#import <UIKit/UIKit.h>

@interface FlashButton : UIButton{
    
    UIImageView* _flashIconView;
    UILabel* _flashTypeLabel;
    
    BOOL _flashIsON;
}

-(void)changeFlashType:(BOOL)isOn;

-(BOOL)flashTypeIsON;

@end
