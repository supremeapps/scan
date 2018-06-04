#import <UIKit/UIKit.h>
@class SelectableRoundView;

@protocol SelectabeRoundDelegate <NSObject>

-(void)cornerPointDidChangingAt:(CGPoint)point corner:(SelectableRoundView *)cornerView;
-(void)cornerPointDidChanged;

-(BOOL)canSwipeCornerView:(SelectableRoundView *)cornerView point:(CGPoint)point;

@end
@interface SelectableRoundView : UIView{
    
    UIImageView* _pointerView;
}


@property(nonatomic, weak) id<SelectabeRoundDelegate> delegate;

@end
