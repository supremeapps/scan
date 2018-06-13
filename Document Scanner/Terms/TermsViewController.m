//
//  TermsViewController.m
//  colorbynumbers
//
//  Created by Andrew Medvedev on 15/03/2018.
//  Copyright © 2018 Cube Software Solutions. All rights reserved.
//

#import "TermsViewController.h"

@interface TermsViewController ()

@property (strong, nonatomic) UITextView *textView;

@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    NSMutableAttributedString *termsText = [[NSMutableAttributedString alloc] initWithString:@"By subscribing to Pixel app you get unlimited access to all content.\n\nGood to know:\n\n• The payment will be charged to your iTunes Account at confirmation of purchase\n•  Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period\n•  Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal\n•  Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase\n•  You may turn off the auto-renewal of your subscription via iTunes Account Settings\n•  Any unused portion of a free trial period will be forfeited when the user purchases our subscriptions\n\n What happens when free trial ends?\n\n3 day free trial automatically converts to a paid subscription  unless auto-renew is turned off at least 24-hours before the end of the trial period. From that point onwards, subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period.\n\nHow do I restore subscription on new devices?\n\nTap \"Restore Purchases\" button in the ‘More info’ section.\n\nRestore Purchases\n\nHow do I switch subscription plans?\n\nOpen your device settings and tap iTunes & App Store > Apple ID > View Apple ID > enter the password > Subscriptions > Pixel app > select the subscription plan you are after.\n\nHow do I cancel subscription?\n\nYou can cancel a subscription service at any time during the subscription period via the subscription settings in your iTunes account (open your device settings and tap iTunes & App Store > Apple ID > View Apple ID > enter the password > Subscriptions > Assembly > Cancel Subscription button at the bottom.\n\nTerms of Service and Privacy Policy\n\nPlease, follow the link http://pixel.000webhostapp.com/Policy/ to read more about terms of service and privacy policies.\n"];
    
    NSRange linkRange = [termsText.string rangeOfString:@"http://pixel.000webhostapp.com/Policy/"];
    [termsText addAttribute:NSLinkAttributeName value:@"http://pixel.000webhostapp.com/Policy/" range:linkRange];
    self.textView.attributedText = termsText;
    self.textView.editable = false;
    [self.view addSubview:self.textView];
    
    self.navigationItem.title = @"Terms and conditions";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.textView.frame = self.view.bounds;
    self.textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
