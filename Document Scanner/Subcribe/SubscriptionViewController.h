//
//  SubscriptionViewController.h
//  Simple Scan
//
//  Created by Andrew Medvedev on 13/06/2018.
//  Copyright © 2018 kazuh1ko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscriptionViewController : UIViewController

@property (copy, nonatomic) void(^subscriptionCompletion)(void);

@end
