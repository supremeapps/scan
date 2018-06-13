//
//  UserEventsManager.h
//  Calculator
//
//  Created by Andrew Medvedev on 21/05/2018.
//  Copyright © 2018 Andrew Medvedev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserEventsManager : NSObject

+ (instancetype)manager;

- (BOOL)logEvent;

@property (assign, nonatomic, readonly) NSInteger eventsCount;
@property (assign, nonatomic) NSInteger maxEventsCount;
@property (copy, nonatomic) void(^event)(void);

@end
