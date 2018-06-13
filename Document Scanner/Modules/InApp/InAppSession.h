//
//  InAppSession.h
//  Calculator
//
//  Created by Andrew Medvedev on 11/02/2018.
//  Copyright © 2018 Cube Software Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaidSubscription.h"

@interface InAppSession : NSObject

- (instancetype)initWithReceiptData:(NSData *)data parsedReceipt:(NSDictionary *)parsedReceipt;

@property (copy, nonatomic) NSString *sessionId;
@property (copy, nonatomic) NSArray<PaidSubscription *> *paidSubscriptions;
@property (strong, nonatomic) NSData *receiptData;
@property (copy, nonatomic) NSDictionary *parsedReceipt;

@property (strong, nonatomic) PaidSubscription *currentSubscription;

@end
