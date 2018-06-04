#import "ShareViewController.h"
#import "CropperConstantValues.h"
#import "ShareObject.h"


@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initializeContents];
    
    [self initializeHeaderView];
    [self initializeMainView];
    // Do any additional setup after loading the view.
}

-(void)initializeContents{
    
    ShareObject* cameraRoll = [[ShareObject alloc] initWithName:@"Save to gallery" imageName:@"share_camera" type:ShareTypeCameraRoll];
    ShareObject* fb = [[ShareObject alloc] initWithName:@"Share to Facebook" imageName:@"share_fb" type:ShareTypeFacebook];
    ShareObject* twitter = [[ShareObject alloc] initWithName:@"Share to Twitter" imageName:@"share_twitter" type:ShareTypeTwitter];
    ShareObject* email = [[ShareObject alloc] initWithName:@"Send E-mail" imageName:@"share_email" type:ShareTypeEmail];
    ShareObject* message = [[ShareObject alloc] initWithName:@"Send Message" imageName:@"share_message" type:ShareTypeMessage];
    ShareObject* more = [[ShareObject alloc] initWithName:@"More" imageName:@"share_more" type:ShareTypeOthers];
    
    _contentArray =  [NSArray arrayWithObjects:cameraRoll, fb, twitter, email, message, more, nil];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        ShareObject* object = [_contentArray objectAtIndex:indexPath.row];
        [self shareWithType:object.shareType];
        
    }else{
        
        [self backButtonClicked];
    }
}

-(void)shareWithType:(ShareType)type{

    switch (type) {
        case ShareTypeCameraRoll:

            UIImageWriteToSavedPhotosAlbum(self.savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);

            break;
            

        case ShareTypeFacebook:
            
            [self shareWithFacebook];

            break;
            
        case ShareTypeTwitter:
            [self shareWithTwitter];

            break;
            
        case ShareTypeEmail:
            
            [self shareWithEmail];
            break;
            
        case ShareTypeMessage:
            
            [self shareWithMessage];
            break;
            
        default:{
            //others
            [self shareWithOthers];
        }
            break;
    }
    
}


//camera roll

- (void)               image:(UIImage *)image
    didFinishSavingWithError:(NSError *)error
                 contextInfo:(void *)contextInfo;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Document scanner"
                                                    message:@"Document save!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)shareWithFacebook{
    
    NSLog(@"fb");
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *fbSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbSheet setInitialText:@"Document from Docement scanner"];
        [fbSheet addImage:self.savedImage];
        [self presentViewController:fbSheet animated:YES completion:nil];
    }
}

-(void)shareWithTwitter{
    NSLog(@"twitter");
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Document from Docement scanner"];
        [tweetSheet addImage:self.savedImage];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    
}
-(void)shareWithEmail{

    if ([MFMailComposeViewController canSendMail])
    {
     
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Document from Docement scanner"];
        
        NSData *imageData = UIImagePNGRepresentation(self.savedImage);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"Unitiled"];
        
        [self presentViewController:mailer animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"This device does not support Email!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];

    }
}

-(void)shareWithMessage{

    if([MFMessageComposeViewController canSendText]) {
        
        NSString *message = @"Document from Docement scanner";
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController setBody:message];
        [self presentViewController:messageController animated:YES completion:nil];

    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"This device does not support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];

    }
}

-(void)shareWithOthers{
    
    NSArray *activityItems = @[self.savedImage];

    NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage];

    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityController.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityController animated:YES completion:nil];
}


-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
  
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark uitableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    if (section == 0) {
         return _contentArray.count;
    }else{
        return 1;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 42.0;
    }else{
        
        return 52.0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"DraftCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UILabel* doneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 15.0, self.view.frame.size.width, 22.0)];
        doneLabel.tag = 123;
        doneLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0f alpha:1.0];
        doneLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:doneLabel];
        
    }

    UILabel* doneLabel = (UILabel *)[cell viewWithTag:123];
    
    if (indexPath.section == 0) {
    
        doneLabel.hidden = YES;
        ShareObject* object = [_contentArray objectAtIndex:indexPath.row];
        
        cell.imageView.image = [UIImage imageNamed:object.thumbnail];
        cell.textLabel.text = object.connectionName;
        
    }else{
        
        doneLabel.text = @"Done";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)initializeMainView{
    
    _shareListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _shareListView.translatesAutoresizingMaskIntoConstraints = NO;
    _shareListView.delegate = self;
    _shareListView.dataSource = self;
    [self.view addSubview:_shareListView];
    
    CGSize screenSize = self.view.frame.size;
    CGFloat imgViewHeight = screenSize.height*0.4;
    
    _thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenSize.width, imgViewHeight)];
    _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
    _thumbnailImageView.backgroundColor = [UIColor colorWithWhite:33.0/255.0 alpha:1.0];
    _thumbnailImageView.image = self.savedImage;

    
    _shareListView.tableHeaderView = _thumbnailImageView;
    
    NSLayoutConstraint* listTop = [NSLayoutConstraint constraintWithItem:_shareListView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_headerView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0 constant:0.0];
    NSLayoutConstraint* listBtm = [NSLayoutConstraint constraintWithItem:_shareListView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0 constant:0.0];
    NSLayoutConstraint* listLeft = [NSLayoutConstraint constraintWithItem:_shareListView
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0 constant:0.0];
    NSLayoutConstraint* listRight = [NSLayoutConstraint constraintWithItem:_shareListView
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0 constant:0.0];
    
    NSArray* listConstraints = [NSArray arrayWithObjects:listBtm, listLeft, listRight, listTop, nil];
    
    [self.view addConstraints:listConstraints];

}
-(void)initializeHeaderView{
    
    _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [_headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_headerView setBackgroundColor:[CropperConstantValues standartBackgroundColor]];
    [self.view addSubview:_headerView];
    
    UILabel* screenTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150.0)/2.0, 33.0, 150.0, 18)];
    screenTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [screenTitleLabel setText:@"Save document"];
    [screenTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [screenTitleLabel setFont:[UIFont systemFontOfSize:16]];
    [screenTitleLabel setTextColor:[UIColor whiteColor]];
    [_headerView addSubview:screenTitleLabel];
    
    
    UIButton* backBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_btn_normal"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_btn_selected"] forState:UIControlStateSelected];
    [backBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:backBtn];

    
    NSLayoutConstraint* headerTop = [NSLayoutConstraint constraintWithItem:_headerView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0 constant:0.0];
    NSLayoutConstraint* headerHeight = [NSLayoutConstraint constraintWithItem:_headerView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0 constant:[CropperConstantValues pictureSelectorHeaderViewHeight]];
    NSLayoutConstraint* headerLeft = [NSLayoutConstraint constraintWithItem:_headerView
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0 constant:0.0];
    NSLayoutConstraint* headerRight = [NSLayoutConstraint constraintWithItem:_headerView
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0 constant:0.0];
    
    NSArray* headerViewConstraints = [NSArray arrayWithObjects:headerTop, headerHeight, headerLeft, headerRight, nil];
    
    [self.view addConstraints:headerViewConstraints];
    
    
    //
    
    NSLayoutConstraint* titleTop = [NSLayoutConstraint constraintWithItem:screenTitleLabel
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_headerView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0 constant:33.0];
    
    NSLayoutConstraint* titleCenter = [NSLayoutConstraint constraintWithItem:screenTitleLabel
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_headerView
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0 constant:0.0];
    
    NSArray* titleConstraints = [NSArray arrayWithObjects:titleTop, titleCenter, nil];
    
    [_headerView addConstraints:titleConstraints];
    

    NSLayoutConstraint* backTop = [NSLayoutConstraint constraintWithItem:backBtn
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_headerView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0 constant:20.0];
    
    NSLayoutConstraint* backLeft = [NSLayoutConstraint constraintWithItem:backBtn
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_headerView
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0 constant:0.0];
    
    
    NSArray* backConstraints = [NSArray arrayWithObjects:backTop, backLeft, nil];
    
    [_headerView addConstraints:backConstraints];
    

    
}


-(void)backButtonClicked{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(BOOL)shouldAutorotate{
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
