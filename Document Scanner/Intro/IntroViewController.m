//
//  IntroViewController.m
//  Simple Scan
//
//  Created by Andrew Medvedev on 12/06/2018.
//  Copyright © 2018 kazuh1ko. All rights reserved.
//

#import "IntroViewController.h"
#import "SubscriptionViewController.h"
#import "PictureSelectorViewController.h"
#import "CustomNavigationController.h"

@interface IntroViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;

@property (strong, nonatomic) NSMutableArray<UIView *> *views;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.views = [NSMutableArray array];
    [self initViews];
    [self updateButton];
}

- (void)initViews {
    NSArray<UIView *> *views = [NSBundle.mainBundle loadNibNamed:@"IntroControllers" owner:nil options:nil];
    for (UIView *view in views) {
        [self.scrollView addSubview:view];
        [self.views addObject:view];
    }
    self.pageControll.numberOfPages = self.views.count;
    self.pageControll.currentPage = 0;
    self.scrollView.pagingEnabled = true;
}

//------------------------------------------------------------------------------
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat postion = 0;
    for (UIView *view in self.views) {
        view.frame = (CGRect){self.scrollView.bounds.size.width * postion, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height};
        postion += 1;
    }
    self.scrollView.contentSize = (CGSize){self.scrollView.bounds.size.width * self.pageControll.numberOfPages, self.scrollView.bounds.size.height};
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.bounds.size.width;
    NSInteger newPage = (NSInteger)floor((self.scrollView.contentOffset.x - (pageWidth / 2.0)) / pageWidth) + 1;
    if (self.pageControll.currentPage != newPage) {
        self.pageControll.currentPage = newPage;
        [self updateButton];
    }
}


#pragma mark - Action

//------------------------------------------------------------------------------
- (IBAction)actionButton:(UIButton *)sender {
    if (self.pageControll.currentPage < self.views.count - 1) {
        CGRect scrollRect = (CGRect){ceil(self.scrollView.bounds.size.width * (self.pageControll.currentPage + 1)), 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height};
        [self.scrollView scrollRectToVisible:scrollRect animated:true];
    } else {
        SubscriptionViewController *destVc =  [[UIStoryboard storyboardWithName:@"Subcription" bundle:nil] instantiateViewControllerWithIdentifier:@"SubscriptionViewController"];
        destVc.subscriptionCompletion = ^{
            UIWindow *window = UIApplication.sharedApplication.keyWindow;
            PictureSelectorViewController* picVC = [[PictureSelectorViewController alloc] initWithNibName:nil bundle:nil];
            CustomNavigationController* navController = [[CustomNavigationController alloc] initWithRootViewController:picVC];
            
            window.rootViewController = navController;
            [window makeKeyAndVisible];
        };
        [self presentViewController:destVc animated:true completion:nil];
    }
}


#pragma mark - Common

- (void)updateButton {
    if (self.pageControll.currentPage == 0) {
        [self.button setTitle:@"YES" forState:UIControlStateNormal];
    } else if (self.pageControll.currentPage == 1) {
        [self.button setTitle:@"NEXT" forState:UIControlStateNormal];
    }
}


@end
