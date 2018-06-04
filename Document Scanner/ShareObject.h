#import <Foundation/Foundation.h>

typedef enum {
    
    ShareTypeCameraRoll,
    ShareTypeFacebook,
    ShareTypeTwitter,
    ShareTypeEmail,
    ShareTypeMessage,
    ShareTypeOthers
    
} ShareType;



@interface ShareObject : NSObject

@property(nonatomic, strong) NSString* connectionName;
@property(nonatomic, strong) NSString* thumbnail;
@property(nonatomic) ShareType shareType;

-(id)initWithName:(NSString *)name imageName:(NSString *)imgName type:(ShareType)type;
@end
