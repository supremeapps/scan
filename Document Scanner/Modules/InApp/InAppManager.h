//
//  InAppManager.h
//  Calculator
//
//  Created by Andrew Medvedev on 11/02/2018.
//  Copyright © 2018 Cube Software Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

extern NSString * const kInAppManagerDidUpdateSubscriptionStatus;

@interface InAppManager : NSObject

+ (instancetype)shared;

- (void)loadStore:(NSSet<NSString *> *)productIdentifiers;
+ (BOOL)userHasPurchasedItem;
+ (void)userHasPurchasedItems:(BOOL)useCache completion:(void(^)(BOOL result)) completion;
- (void)purchaseProduct:(SKProduct *)product;
- (void)restore;

- (void)forceReload;

@property (copy, nonatomic) void(^productsLoadingCallback)(NSArray<SKProduct *> *products);
@property (copy, nonatomic) void(^paymentRequestResult)(SKPaymentQueue *queue, NSArray<SKPaymentTransaction *> *transactions);
@property (copy, nonatomic) void(^restoreCompletion)(void);

@end
