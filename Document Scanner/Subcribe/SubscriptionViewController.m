//
//  SubscriptionViewController.m
//  Simple Scan
//
//  Created by Andrew Medvedev on 13/06/2018.
//  Copyright © 2018 kazuh1ko. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "InAppManager.h"
#import "TermsViewController.h"
#import <StoreKit/StoreKit.h>
#import <SVProgressHUD.h>

@interface SubscriptionViewController ()

@property (strong) SKProduct *premiumProduct;

@end

@implementation SubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadInApp];
}


#pragma mark - InApp

//------------------------------------------------------------------------------
- (void)loadInApp {
    NSString *premium = @"com.supreme.scanner.app.subscriptions.premium";
    NSSet *identifiers = [NSSet setWithArray:@[premium]];
    
    [SVProgressHUD show];
    [InAppManager.shared loadStore:identifiers];
    [InAppManager.shared setProductsLoadingCallback:^(NSArray<SKProduct *> *products) {
        for (SKProduct *product in products) {
            if ([product.productIdentifier isEqualToString:premium]) {
                self.premiumProduct = product;
            }
        }
        [SVProgressHUD dismiss];
    }];
    [InAppManager.shared setPaymentRequestResult:^(SKPaymentQueue *queue, NSArray<SKPaymentTransaction *> *transactions) {
        BOOL success = NO;
        for (SKPaymentTransaction *transaction in transactions) {
            switch (transaction.transactionState) {
                case SKPaymentTransactionStatePurchasing:
                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                    [SVProgressHUD show];
                    break;
                case SKPaymentTransactionStatePurchased: {
                    [queue finishTransaction:transaction];
                    success = YES;
                    break;
                }
                case SKPaymentTransactionStateFailed: {
                    [queue finishTransaction:transaction];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"An error occured" message:transaction.error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [SVProgressHUD dismiss];
                    break;
                }
                case SKPaymentTransactionStateRestored: {
                    [queue finishTransaction:transaction];
                    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                    [SVProgressHUD showWithStatus:@"Checking subscription"];
                    [InAppManager userHasPurchasedItems:NO completion:^(BOOL result) {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"An error occured" message:result ? @"Subscription is restored" : @"You have no active subscriptions" preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                        [self presentViewController:alertController animated:YES completion:nil];
                        [SVProgressHUD dismiss];
                        if (result) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                        dispatch_semaphore_signal(sema);
                    }];
                    dispatch_semaphore_wait(sema, DISPATCH_TIME_NOW + 15);
                    break;
                }
                case SKPaymentTransactionStateDeferred:
                    [SVProgressHUD dismiss];
                    break;
            }
        }
        
        if (success) {
            [SVProgressHUD showWithStatus:@"Checking subscription"];
            [InAppManager userHasPurchasedItems:NO completion:^(BOOL result) {
                [SVProgressHUD dismiss];
                if (self.subscriptionCompletion) {
                    self.subscriptionCompletion();
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }];
}


#pragma mark - Actions

- (IBAction)actionBuy:(UIButton *)sender {
    [SVProgressHUD show];
    [InAppManager.shared purchaseProduct:self.premiumProduct];
}
- (IBAction)actionContinueUsage:(UIButton *)sender {
    [SVProgressHUD dismiss];
    if (self.subscriptionCompletion != nil) {
        self.subscriptionCompletion();
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)actionRestore:(UIButton *)sender {
    [SVProgressHUD show];
    [InAppManager.shared restore];
}

- (IBAction)actionTermsOfUse:(UIButton *)sender {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[TermsViewController alloc] init]];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)actionPrivicy:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://supremeapps.000webhostapp.com/Policy/"] options:@[] completionHandler:nil];
}

@end
