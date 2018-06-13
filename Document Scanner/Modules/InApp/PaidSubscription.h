//
//  PaidSubscription.h
//  Calculator
//
//  Created by Andrew Medvedev on 11/02/2018.
//  Copyright © 2018 Cube Software Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaidSubscription : NSObject

@property (copy, nonatomic) NSString *productId;
@property (strong, nonatomic) NSDate *purchaseDate;
@property (strong, nonatomic) NSDate *expiresDate;

- (instancetype)initWithJson:(NSDictionary *)json;
- (BOOL)isActive;

@end
