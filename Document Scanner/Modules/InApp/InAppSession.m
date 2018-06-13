//
//  InAppSession.m
//  Calculator
//
//  Created by Andrew Medvedev on 11/02/2018.
//  Copyright © 2018 Cube Software Solutions. All rights reserved.
//

#import "InAppSession.h"

@implementation InAppSession

//------------------------------------------------------------------------------
- (instancetype)initWithReceiptData:(NSData *)data parsedReceipt:(NSDictionary *)parsedReceipt {
    self = [super init];
    if (self != nil) {
        self.sessionId = [NSUUID UUID].UUIDString;
        self.receiptData = data;
        self.parsedReceipt = parsedReceipt;
        
        NSMutableArray *subscriptions = [NSMutableArray array];
        for (NSDictionary *purchase in parsedReceipt[@"receipt"][@"in_app"]) {
            PaidSubscription *subscr = [[PaidSubscription alloc] initWithJson:purchase];
            [subscriptions addObject:subscr];
        }
        
        self.paidSubscriptions = subscriptions;
    }
    
    return self;
}

//------------------------------------------------------------------------------
- (PaidSubscription *)currentSubscription {
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"isActive == true && purchaseDate >= %@", [NSDate date]];
    NSArray *activeSubscriptions = [self.paidSubscriptions filteredArrayUsingPredicate:filter];
    NSArray *sortedByMostRecentPurchase = [activeSubscriptions sortedArrayUsingComparator:^NSComparisonResult(PaidSubscription *obj1, PaidSubscription *obj2) {
        return [obj1.purchaseDate compare:obj2.purchaseDate] == NSOrderedDescending;
    }];
    
    return sortedByMostRecentPurchase.firstObject;
}

@end
