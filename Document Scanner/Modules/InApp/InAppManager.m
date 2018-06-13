//
//  InAppManager.m
//  Calculator
//
//  Created by Andrew Medvedev on 11/02/2018.
//  Copyright © 2018 Cube Software Solutions. All rights reserved.
//

#import "InAppManager.h"
#import "InAppSession.h"
#import "PaidSubscription.h"

#import <StoreKit/StoreKit.h>

extern NSString * const kInAppManagerDidUpdateSubscriptionStatus = @"InAppManagerDidUpdateSubscriptionStatus";
static NSString * const kInAppIdentifier = @"259669466a4742e49e86ae49efdf2c03";

@interface InAppManager() <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (copy, nonatomic) NSMutableDictionary *sessions;
@property (strong, nonatomic) PaidSubscription *paidSubscription;
@property (strong, nonatomic) SKProductsRequest *productRequest;

@end

@implementation InAppManager

+ (instancetype)shared {
    static InAppManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [InAppManager new];
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDate* expireDate = [NSUserDefaults.standardUserDefaults objectForKey:@"kLastExpireDate"];
        if ([expireDate compare:[NSDate date]] == NSOrderedAscending) {
            [NSUserDefaults.standardUserDefaults removeObjectForKey:@"kLastExpireDate"];
        }
    }
    return self;
}


#pragma mark - Base store information

//------------------------------------------------------------------------------
- (void)loadStore:(NSSet<NSString *> *)productIdentifiers {
    [UIApplication.sharedApplication setNetworkActivityIndicatorVisible:YES];
    [SKPaymentQueue.defaultQueue addTransactionObserver:self];
    
    self.productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    self.productRequest.delegate = self;
    [self.productRequest start];
}

//------------------------------------------------------------------------------
- (void)purchaseProduct:(SKProduct *)product {
    if ([SKPaymentQueue canMakePayments]) {
        [UIApplication.sharedApplication setNetworkActivityIndicatorVisible:YES];
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [SKPaymentQueue.defaultQueue addPayment:payment];
    }
}

//------------------------------------------------------------------------------
- (void)restore {
//    [UIApplication.sharedApplication setNetworkActivityIndicatorVisible:YES];
    [SKPaymentQueue.defaultQueue addTransactionObserver:self];
    [SKPaymentQueue.defaultQueue restoreCompletedTransactions];
}

//------------------------------------------------------------------------------
- (void)cancelTransaction {
    
}


#pragma mark - Receipt

//------------------------------------------------------------------------------
- (void)validateReceipt:(NSData *)data completion:(void(^)(BOOL success, PaidSubscription *result)) completion {
    NSDictionary *body = @{@"receipt-data" : [data base64EncodedStringWithOptions:0],
                           @"password" : kInAppIdentifier
                           };
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = bodyData;
    
    void(^sharedCompletion)(NSData *data) = ^(NSData *data){
        if (data != nil) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            InAppSession *session = [[InAppSession alloc] initWithReceiptData:data parsedReceipt:result];
            self.sessions[session.sessionId] = session;
            PaidSubscription *lastSubs = session.paidSubscriptions.firstObject;
            for (PaidSubscription *s in session.paidSubscriptions) {
                NSLog(@"%@", s.expiresDate);
                if ([s.expiresDate compare:lastSubs.expiresDate] == NSOrderedDescending) {
                    lastSubs = s;
                }
            }
            self.paidSubscription = lastSubs;
            completion(true, self.paidSubscription);
        } else {
            completion(false, nil);
        }
    };
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            completion(false, nil);
        } else {
            __block NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSInteger status = [result[@"status"] integerValue];
            if (status == 21007) {
                NSMutableURLRequest *sandboxRequst = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"]];
                sandboxRequst.HTTPMethod = @"POST";
                sandboxRequst.HTTPBody = bodyData;
                
                [[[NSURLSession sharedSession] dataTaskWithRequest:sandboxRequst completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    sharedCompletion(data);
                }] resume];
            } else {
                sharedCompletion(data);
            }
        }
    }] resume];
}

+ (BOOL)userHasPurchasedItem {
    NSDate* expireDate = [NSUserDefaults.standardUserDefaults objectForKey:@"kLastExpireDate"];
    if ([expireDate compare:[NSDate date]] == NSOrderedDescending) {
        return true;
    }
    
    BOOL result = false;
    PaidSubscription *subcrs = [InAppManager shared].paidSubscription;
    if (subcrs) {
        result = subcrs.isActive;
    }
    
    return result;
}

+ (void)userHasPurchasedItems:(BOOL)useCache completion:(void(^)(BOOL result)) completion {
    
    void(^commonCompletion)(BOOL result) = ^(BOOL result) {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(result);
            });
        }
    };
    
    if (useCache) {
        NSDate* expireDate = [NSUserDefaults.standardUserDefaults objectForKey:@"kLastExpireDate"];
        if ([expireDate compare:[NSDate date]] == NSOrderedDescending) {
            commonCompletion(true);
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *receiptUrl = NSBundle.mainBundle.appStoreReceiptURL;
        if ([NSFileManager.defaultManager fileExistsAtPath:receiptUrl.path]) {
            NSData *data = [NSData dataWithContentsOfURL:receiptUrl];
            [InAppManager.shared validateReceipt:data completion:^(BOOL success, PaidSubscription *result) {
                InAppManager.shared.paidSubscription = result;
                BOOL hasPurchase = result.isActive;
                if (hasPurchase) {
                    [NSUserDefaults.standardUserDefaults setObject:result.expiresDate forKey:@"kLastExpireDate"];
                } else {
                    [NSUserDefaults.standardUserDefaults removeObjectForKey:@"kLastExpireDate"];
                }
                commonCompletion(hasPurchase);
                [NSNotificationCenter.defaultCenter postNotificationName:kInAppManagerDidUpdateSubscriptionStatus object:nil];
            }];
        } else {
            commonCompletion(NO);
        }
    });
}


- (void)forceReload {
    self.paidSubscription = nil;
}


#pragma mark - SKProductRequestDelegate

//------------------------------------------------------------------------------
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    if (self.productsLoadingCallback != nil) {
        self.productsLoadingCallback(response.products);
        [UIApplication.sharedApplication setNetworkActivityIndicatorVisible:NO];
    }
}


#pragma mark - SKPaymentDelegate

//------------------------------------------------------------------------------

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    if (self.paymentRequestResult != nil) {
        self.paymentRequestResult(queue, transactions);
        [UIApplication.sharedApplication setNetworkActivityIndicatorVisible:NO];
    }
}

//------------------------------------------------------------------------------
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    if (self.restoreCompletion) {
        self.restoreCompletion();
    }
}

//------------------------------------------------------------------------------
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    if (self.restoreCompletion) {
        self.restoreCompletion();
    }
}

@end
