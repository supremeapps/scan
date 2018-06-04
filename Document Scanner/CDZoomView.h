#import <UIKit/UIKit.h>

@interface CDZoomView : UIView{
    
    CGPoint _currentCenter;
    CGPoint _cornerCenter;
}

-(void)setZoomScale:(CGFloat)scale;

-(void)setZoomCenter:(CGPoint)point;
-(void)zoomViewHide:(BOOL)hide;

-(void)setDragingEnabled:(BOOL)enabled;

@end
