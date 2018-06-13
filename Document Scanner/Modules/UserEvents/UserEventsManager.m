//
//  UserEventsManager.m
//  Calculator
//
//  Created by Andrew Medvedev on 21/05/2018.
//  Copyright © 2018 Andrew Medvedev. All rights reserved.
//

#import "UserEventsManager.h"
#import "InAppManager.h"

@interface UserEventsManager()

@property (assign, nonatomic) NSInteger eventsCount;

@end

@implementation UserEventsManager

+ (instancetype)manager {
    static UserEventsManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [UserEventsManager new];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _maxEventsCount = 2;
        _eventsCount = 0;
    }
    return self;
}

- (BOOL)logEvent {
    if ([InAppManager userHasPurchasedItem]) {
        return true;
    }
    
    BOOL canContinue = true;
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    NSDate *lastDate = [defaults objectForKey:@"LastScanDate"];
    _eventsCount = [defaults integerForKey:@"ScansCount"];
    
    if (_eventsCount < _maxEventsCount) {
        _eventsCount++;
        [defaults setObject:@(_eventsCount) forKey:@"ScansCount"];
        [defaults setObject:[NSDate date] forKey:@"LastScanDate"];
    } else {
        if (lastDate.timeIntervalSince1970 + 24 * 60 * 60 < NSDate.date.timeIntervalSince1970) {
            _eventsCount = 0;
            [defaults setObject:@(_eventsCount) forKey:@"ScansCount"];
        } else {
            if (self.event) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.event();
                });
            }
            canContinue = false;
        }
    }
    return canContinue;
}



@end
