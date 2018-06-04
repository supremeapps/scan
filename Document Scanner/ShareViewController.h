#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface ShareViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>{
    
    UIView* _headerView;
    UITableView* _shareListView;
    UIImageView* _thumbnailImageView;
    
    NSArray* _contentArray;
}
@property(nonatomic, strong) UIImage* savedImage;

@end
