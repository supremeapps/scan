#import "ShareObject.h"

@implementation ShareObject
@synthesize connectionName;
@synthesize thumbnail,shareType;

-(id)initWithName:(NSString *)name imageName:(NSString *)imgName type:(ShareType)type{
    
    self = [super init];
    if (self) {

        self.connectionName = name;
        self.thumbnail = imgName;
        self.shareType = type;
    }
    return self;
}

@end
