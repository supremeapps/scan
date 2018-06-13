//
//  PaidSubscription.m
//  colorbynumbers
//
//  Created by Andrew Medvedev on 11/02/2018.
//  Copyright © 2018 Cube Software Solutions. All rights reserved.
//

#import "PaidSubscription.h"

@implementation PaidSubscription

//------------------------------------------------------------------------------
- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super init];
    if (self != nil) {
        self.productId = json[@"product_id"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss VV";
        self.purchaseDate = [formatter dateFromString:json[@"purchase_date"]];
        self.expiresDate = [formatter dateFromString:json[@"expires_date"]];
    }
    
    return self;
}

//------------------------------------------------------------------------------
- (BOOL)isActive {
    return [self.purchaseDate compare:[NSDate date]] == NSOrderedAscending && [self.expiresDate compare:[NSDate date]] == NSOrderedDescending;
}

@end
