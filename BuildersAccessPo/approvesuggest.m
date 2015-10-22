//
//  approvesuggest.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-15.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "approvesuggest.h"
#import "Mysql.h"
#import "userInfo.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "forapprove.h"
#import "disapprovesuggest.h"
#import "MBProgressHUD.h"
#import "ViewController.h"

@interface approvesuggest ()<UITextViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate, CustomKeyboardDelegate, MBProgressHUDDelegate, UITextFieldDelegate>{
    CustomKeyboard *keyboard;
    NSMutableArray * pickerArray;
    UIButton *dd1;
    UITextView *txtNote;
    //    MBProgressHUD* HUD;
    UITextField *usernameField;
     UITextField *pronameField;
     UITextField *sendtoField;
    UITextField *tsqft;
    wcfSuggestedPriceItem *rsp;
    UITextField *a;
    NSTimer *myTimer;
    MBProgressHUD *HUD;
     int y;
}
@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@end

#define MRScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)

@implementation approvesuggest

@synthesize xidcia, xidproject, idnumber, xnproject, uv, ntabbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(BOOL) isNumeric:(NSString *)s
{
    NSScanner *sc = [NSScanner scannerWithString: s];
    if ( [sc scanFloat:NULL] )
    {
        return [sc isAtEnd];
    }
    return NO;
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1:
            switch (buttonIndex) {
                case 0:
                    [ntabbar setSelectedItem:nil];
                    break;
                default:{
                    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
                    NetworkStatus netStatus = [curReach currentReachabilityStatus];
                    if (netStatus ==NotReachable) {
                        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
                        [alert show];
                    }else{
//                        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//                        [self.navigationController.view addSubview:HUD];
//                        HUD.labelText=@"Approve suggested price...";
//                        HUD.dimBackground = YES;
//                        HUD.delegate = self;
//                        [HUD show:YES];
                        
                        self.view.userInteractionEnabled=NO;
//                        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//                        
//                        [alertViewWithProgressbar show];
//                        alertViewWithProgressbar.progress=1;
                        
                        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
                        [self.navigationController.view addSubview:HUD];
                        HUD.labelText=@"Sending Email to Queue...";
                        
                        HUD.progress=0.01;
                        [HUD layoutSubviews];
                        HUD.dimBackground = YES;
                        HUD.delegate = self;
                        [HUD show:YES];
                        
                        
                        
                        wcfService* service = [wcfService service];
                        NSString *xs =[usernameField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
                        NSString *xt =[tsqft.text stringByReplacingOccurrencesOfString:@"," withString:@""];
                        [service xApproveSuggest:self action:@selector(xApproveSuggestHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:xidcia xidnumber:idnumber xidproject:xidproject xsqft:xt xsuggestprice:xs EquipmentType:@"3"];
                    }
                }
                    break;
                    
            }
            break;
    }
}

-(void)xApproveSuggestHandler: (id) value {
    // Handle errors
    
   
    if([value isKindOfClass:[NSError class]]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        return;
    }
    
    NSString *t =(NSString *)value;
    if ([t isEqualToString:@"1"]) {
        HUD.progress=1;
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                   target:self
                                                 selector:@selector(targetMethod)
                                                 userInfo:nil
                                                  repeats:YES];
        
        
          
    }else if([t isEqualToString:@"0"]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        
        UIAlertView *alert = [self getErrorAlert: @"Send Email Unsuccessfully."];
        [alert show];
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[forapprove class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }else {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        
        UIAlertView *alert = [self getErrorAlert: @"Update Unsuccessfully."];
        [alert show];
    }
}

-(void)targetMethod{
    [myTimer invalidate];
    self.view.userInteractionEnabled=YES;
    [HUD hide];
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

- (void) xisupdate_iphoneHandler: (id) value {
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        return;
    }
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"1"]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
    }else{
        HUD.progress=0.5f;
        [txtNote resignFirstResponder];
        wcfService *service=[wcfService service];
        [service xCheckApproveSuggest:self action:@selector(xCheckApproveSuggestHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:xidcia xidproject:xidproject xsqft:tsqft.text xsuggestprice:usernameField.text];
        
    }
}

- (void) xCheckApproveSuggestHandler: (id) value {
   
	if([value isKindOfClass:[NSError class]]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        return;
    }
    
    
    
	// Do something with the wcfKeyValueItem* result
    
    wcfKeyValueItem* result = (wcfKeyValueItem*)value;
    if ([result.Key isEqualToString:@"0"]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        
        UIAlertView *alert=[self getErrorAlert:result.Value];
        [alert show];
    }else{
        HUD.progress=1;
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"BuildersAccess"
                 message:result.Value
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 otherButtonTitles:@"Ok", nil];
        alert.tag = 1;
        [alert show];
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.view.frame.size.height>500) {
        [uv setContentOffset:CGPointMake(0,textField.frame.origin.y-215) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0,textField.frame.origin.y-124) animated:YES];
    }
}

//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//
//    if (self.view.frame.size.height>500) {
//        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-170) animated:YES];
//    }else{
//        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-54) animated:YES];    }
//	return YES;
//}

- (void)nextClicked{
    [usernameField becomeFirstResponder];
}

- (void)previousClicked{
     [tsqft becomeFirstResponder];
}

- (void)doneClicked{
    [uv setContentOffset:CGPointMake(0,0) animated:YES];
    [usernameField resignFirstResponder];
    [tsqft resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Suggest Price";
    
    
//    view.backgroundColor=[UIColor whiteColor];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    
    UILabel*  lbl;
    CGFloat screenWidth = self.view.frame.size.width;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, screenWidth-20, 21)];
    lbl.text=[NSString stringWithFormat:@"Project # %@", xidproject];
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    pronameField=[[UITextField alloc]initWithFrame:CGRectMake(10, y, screenWidth-20, 30)];
    [pronameField setBorderStyle:UITextBorderStyleRoundedRect];
    //    [pronameField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    pronameField.enabled=NO;
    pronameField.text=xnproject;
    pronameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: pronameField];
    y=y+30+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, screenWidth-20, 21)];
    lbl.text=@"Send To";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    sendtoField=[[UITextField alloc]initWithFrame:CGRectMake(10, y, screenWidth-20, 30)];
    [sendtoField setBorderStyle:UITextBorderStyleRoundedRect];
    //    [sendtoField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    sendtoField.enabled=NO;
    sendtoField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: sendtoField];
    y=y+30+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, screenWidth-20, 21)];
    lbl.text=@"Comment";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, screenWidth-20, 105)];
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(12, y+3, screenWidth-24, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    [txtNote setEditable:NO];
    [uv addSubview:txtNote];
    y=y+110;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, screenWidth-20, 21)];
    lbl.text=@"SQ.FT.";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    tsqft=[[UITextField alloc]initWithFrame:CGRectMake(10, y, screenWidth-20, 30)];
    [tsqft setBorderStyle:UITextBorderStyleRoundedRect];
    [tsqft addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    tsqft.delegate=self;
    tsqft.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: tsqft];
    y=y+30+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, screenWidth-20, 21)];
    lbl.text=@"Suggested Price";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    usernameField=[[UITextField alloc]initWithFrame:CGRectMake(10, y, screenWidth-20, 30)];
    [usernameField setBorderStyle:UITextBorderStyleRoundedRect];
    usernameField.delegate=self;
    [usernameField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: usernameField];
    y=y+30+5;
    
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, screenWidth-20, 21)];
    lbl.text=@"Formula Price";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    a=[[UITextField alloc]initWithFrame:CGRectMake(10, y, screenWidth-20, 30)];
    [a setBorderStyle:UITextBorderStyleRoundedRect];
    a.autocapitalizationType = UITextAutocapitalizationTypeNone;
    a.enabled=NO;
    [uv addSubview: a];
    y=y+30+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, screenWidth-20, 21)];
    lbl.text=@"Sitemap";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    
    
    
    
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    
    [usernameField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :NO]];
    [tsqft setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :YES]];
    [usernameField setKeyboardType:UIKeyboardTypeDecimalPad];
    [tsqft setKeyboardType:UIKeyboardTypeDecimalPad];
    if (y<MRScreenHeight) {
        uv.contentSize=CGSizeMake(screenWidth,MRScreenHeight+1);
    }else{
        uv.contentSize=CGSizeMake(screenWidth,y+1);
    }
    
    [self getDetailInfo];
    
    
    
	// Do any additional setup after loading the view.
}

-(void)getDetailInfo{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetSuggestedPriceForApprove:self action:@selector(xGetSuggestedPriceForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:xidcia xidnumber:idnumber];
        
       
    }
    
}

- (void) xGetSuggestedPriceForApproveHandler: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	if([value isKindOfClass:[NSError class]]) {
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        return;
    }
    rsp=(wcfSuggestedPriceItem *)value;
    
    UIImage *img ;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ws.buildersaccess.com/sitemapthumb.aspx?email=%@&password=%@&idcia=%@&projectid=%@&projectid2=%@", [userInfo getUserName], [userInfo getUserPwd], xidcia, rsp.IDSub,xidproject]];
//    NSLog(@"%@", rsp);
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data!=nil) {
        img =[UIImage imageWithData:data];
        if (img!=nil) {
            float f = 300/img.size.width;
            
            UIImageView *ui =[[UIImageView alloc]initWithFrame:CGRectMake(10, y, 300, img.size.height*f)];
            ui.image=img;
            
            ui.userInteractionEnabled = YES;
            ui.layer.cornerRadius=10;
            ui.layer.masksToBounds = YES;
            UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction)];
            tapped.numberOfTapsRequired = 1;
            [ui addGestureRecognizer:tapped];
            y=y+img.size.height*f+20;
            [uv addSubview:ui];
            data=nil;
        }
    }
    
    [usernameField setText:rsp.Suggested];
    [tsqft setText:rsp.SQFT];
    [a setText:rsp.FormulaPrice];
    [txtNote setText:rsp.Comment];
    sendtoField.text=rsp.Email;
    
//    if (self.view.frame.size.height>480) {
//        uv.contentSize=CGSizeMake(320.0,370+87);
//    }else{
//        uv.contentSize=CGSizeMake(320.0,y+1);
//    }
    
    
    
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, y, 300, 44)];
    [loginButton setTitle:@"Approve" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(doApprove:) forControlEvents:UIControlEventTouchUpInside];
    [uv addSubview:loginButton];
    y=y+59;
    
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, y, 300, 44)];
    [loginButton setTitle:@"Disapprove" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(doDisApprove:) forControlEvents:UIControlEventTouchUpInside];
    [uv addSubview:loginButton];
    
    y=y+94;
    
//    UITabBarItem *firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Approve" image:[UIImage imageNamed:@"approve.png"] tag:1];
//    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Disapprove" image:[UIImage imageNamed:@"disapprove.png"] tag:2];
//    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0,  firstItem2, nil];
//    
//    [ntabbar setItems:itemsArray animated:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(doApprove:) ];
//    [[ntabbar.items objectAtIndex:1]setAction:@selector(doDisApprove:) ];
    
//    
//	// Do something with the wcfSuggestedPriceItem* result
//    wcfSuggestedPriceItem* result = (wcfSuggestedPriceItem*)value;
//    pickerArray =[[result.Email componentsSeparatedByString:@";"]mutableCopy] ;
//    
//    if ([pickerArray count]>0) {
//        [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
//        [dd1 setTitle:[pickerArray objectAtIndex:0] forState:UIControlStateNormal];
//    }else{
//        [dd1 setTitle:@"Email not found" forState:UIControlStateNormal];
//    }
    
    UITabBarItem *firstItem0 ;
    firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
    UITabBarItem *fi;
    fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    
    [ntabbar setItems:itemsArray animated:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    ntabbar.delegate =self;
//    [[ntabbar.items objectAtIndex:3]setAction:@selector(dorefresh)];
    [ntabbar setSelectedItem:nil];
    
    if (y<MRScreenHeight) {
        y=MRScreenHeight;
    }
    
    uv.contentSize=CGSizeMake(320, y+1);
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack1];
    }else if (item.tag == 2) {
        [self dorefresh];
    }
    
}


-(void)myFunction{
    // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ws.buildersaccess.com/sitemap.aspx?email=%@&password=%@&idcia=%@&projectid=%@", [userInfo getUserName], [userInfo getUserPwd], result.IDCia, result.IDSub]]];
    //
//    for (UIView *uw in uv.subviews) {
//        if ([uw isKindOfClass:[UIImageView class]]) {
//            ((UIImageView *)uw).image=nil;
//        }
//    }
    ViewController *si = [ViewController alloc];
    si.xurl=[NSString stringWithFormat:@"http://ws.buildersaccess.com/contractsitemap.aspx?email=%@&password=%@&idcia=%@&projectid=%@&projectid2=%@", [userInfo getUserName], [userInfo getUserPwd], xidcia, rsp.IDSub, xidproject ];
    si.managedObjectContext=self.managedObjectContext;
    
    [self presentViewController:si animated:YES completion:nil];
    
}

-(void)goBack1{
    for (UIViewController *temp in self.navigationController.viewControllers) {
       if ([temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

-(void)dorefresh{
     [self getDetailInfo];
}


-(IBAction)doApprove:(id)sender{
    
        if ([usernameField.text isEqualToString:@""]) {
            UIAlertView *alert = [self getErrorAlert: @"Please Input Suggested Price"];
            [alert show];
            [usernameField becomeFirstResponder];
            return;
        }
    NSString *xs =[usernameField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        if(![self isNumeric:xs]){
            UIAlertView *alert = [self getErrorAlert: @"Suggested Price must be a Number."];
            [alert show];
            [usernameField becomeFirstResponder];
            return;
            
        }
        
        if ([tsqft.text isEqualToString:@""]) {
            UIAlertView *alert = [self getErrorAlert: @"Please Input SQ.FT."];
            [alert show];
            [tsqft becomeFirstResponder];
            return;
        }
     NSString *xt =[tsqft.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        if(![self isNumeric:xt]){
            UIAlertView *alert = [self getErrorAlert: @"SQ.FT. must be a Number."];
            [alert show];
            [tsqft becomeFirstResponder];
            return;
            
        }
        
        
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        self.view.userInteractionEnabled=NO;
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Checking..." delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
//        alertViewWithProgressbar.progress=1;
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Checking...";
        
        HUD.progress=0.01;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];

        
        
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler:) version:version];
    }
    
    
    }



-(IBAction)doDisApprove:(id)sender{
    if ([usernameField.text isEqualToString:@""]) {
        UIAlertView *alert = [self getErrorAlert: @"Please Input Suggested Price"];
        [alert show];
        [usernameField becomeFirstResponder];
        return;
    }
    NSString *xs =[usernameField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    if(![self isNumeric:xs]){
        UIAlertView *alert = [self getErrorAlert: @"Suggested Price must be a Number."];
        [alert show];
        [usernameField becomeFirstResponder];
        return;
        
    }
    
    if ([tsqft.text isEqualToString:@""]) {
        UIAlertView *alert = [self getErrorAlert: @"Please Input SQ.FT."];
        [alert show];
        [tsqft becomeFirstResponder];
        return;
    }
    NSString *xt =[tsqft.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    if(![self isNumeric:xt]){
        UIAlertView *alert = [self getErrorAlert: @"SQ.FT. must be a Number."];
        [alert show];
        [tsqft becomeFirstResponder];
        return;
        
    }
    
    disapprovesuggest * s =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"disapprovesuggest"];
    s.managedObjectContext=self.managedObjectContext;
    s.idnumber=self.idnumber;
    s.xidproject=self.xidproject;
    s.xsqft1=xt;
    s.xidcia=self.xidcia;
    s.xsuggestprice1=xs;
    s.xemail=rsp.Email;
    [self.navigationController pushViewController:s animated:YES];

}

-(IBAction)popupscreen2:(id)sender{
    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle: nil
                                                       delegate: self
                                              cancelButtonTitle: nil
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    
    [alert addButtonWithTitle:@"Cancel"];
    for( NSString *title in pickerArray)  {
        [alert addButtonWithTitle:title];
    }
    
    
    
    [alert showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *str = [actionSheet1 buttonTitleAtIndex:buttonIndex];
    if (![str isEqualToString:@"Cancel"]) {
        [dd1 setTitle:str forState:UIControlStateNormal];
    }
    
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
