#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    
    ImageFilterTypeColorful,
    ImageFilterTypeGrayScale,
    ImageFilterTypeBlackAndWhite
    
} ImageFilterType;

@interface CDImageRectangleDetector : NSObject

+(CDImageRectangleDetector *)sharedDetector;


- (CIDetector *)highAccuracyRectangleDetector;
- (CIRectangleFeature *)biggestRectangleInRectangles:(NSArray *)rectangles;
- (CIImage *)drawHighlightOverlayForPoints:(CIImage *)image topLeft:(CGPoint)topLeft topRight:(CGPoint)topRight bottomLeft:(CGPoint)bottomLeft bottomRight:(CGPoint)bottomRight;

-(UIImage *)imageFilter:(UIImage *) image type:(ImageFilterType)type;

//rotate
- (UIImage *)rotatedImageWithDegree:(double)degree image:(UIImage*)image;



@end
