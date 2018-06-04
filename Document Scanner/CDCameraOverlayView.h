#import <UIKit/UIKit.h>

@interface CDCameraOverlayView : UIView{
    
    CGPoint _topLeftPoint;
    CGPoint _topRightPoint;
    CGPoint _bottomLeftPoint;
    CGPoint _bottomRightPoint;
    
}

- (void)drawHighLightOverlayWithImage:(CIImage *)image topLeft:(CGPoint)topLeft topRight:(CGPoint)topRight bottomLeft:(CGPoint)bottomLeft bottomRight:(CGPoint)bottomRight;

-(void)hideHightLightOverlay;

@end
