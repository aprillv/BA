//
//  emailVendor.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-7.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "emailVendor.h"
#import "Mysql.h"
#import "userInfo.h"
#import "Reachability.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "InsetsLabel.h"
#import "projectpols.h"
#import "MBProgressHUD.h"
#import "CustomKeyboard.h"
#import "wcfPODetail.h"
#import "project.h"
#import "development.h"
#import "forapprove.h"

@interface emailVendor ()<UITextViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate, CustomKeyboardDelegate, MBProgressHUDDelegate, UITabBarDelegate>{
    CustomKeyboard *keyboard;
    NSMutableArray * pickerArray;
    UIButton *dd1;
    UITextView *txtNote;

    MBProgressHUD *HUD;
    NSTimer *myTimer;
}
@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@end

@implementation emailVendor

@synthesize xidvendor, pd, poid, fromforapprove, ntabbar, uv;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goToMain];
    }
}
-(void)goToMain{
    if (fromforapprove==4) {
        [self gohome:nil];
    }else{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        
        if ([temp isKindOfClass:[development class]] || [temp isKindOfClass:[project class]] ||[temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
        
        
    }}

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITabBarItem *firstItem0;
    if (fromforapprove==1) {
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"For Approve" image:[UIImage imageNamed:@"home.png"] tag:1];
    }else if (fromforapprove==2){
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Development" image:[UIImage imageNamed:@"home.png"] tag:1];
    }else if (fromforapprove==3){
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
    }else{
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:1];
    }
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]init];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    
    [ntabbar setItems:itemsArray animated:YES];
    ntabbar.delegate = self;
    //    [[ntabbar.items objectAtIndex:0]setAction:@selector(goToMain) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    [self getEmail];
	// Do any additional setup after loading the view.
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.view.frame.size.height>500) {
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-170) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-84) animated:YES];    }
	return YES;
}


-(void)getEmail{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetEmailList:self action:@selector(xGetEmailListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] idvendor:[[NSNumber numberWithLong:pd.Idvendor] stringValue]];
    }
}

- (void) xGetEmailListHandler: (id) value {
    
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	// Handle errors
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
    
    
    pickerArray =(NSMutableArray*)value;
    [self drawpage];
    
}

-(void)drawpage{
    UILabel *lbl;
    int y=10;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=[NSString stringWithFormat:@"%@ # %@", pd.Doc, pd.IdDoc];
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UIView *ta = [[UIView alloc]initWithFrame:CGRectMake(10, y, 300, 30)];
    ta.backgroundColor = [UIColor whiteColor];
    ta.layer.cornerRadius = 10.0;
    [uv addSubview:ta];
    
    lbl=[[InsetsLabel alloc]initWithFrame:CGRectMake(10, y, 300, 30)];
    lbl.layer.cornerRadius =10.0;
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.text=[NSString stringWithFormat:@"Total: %@", pd.Total];
    [uv addSubview:lbl];
    
    y = y+30+10;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"To";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField * text1;
    text1=[[UITextField alloc]initWithFrame:CGRectMake(10, y, 300, 30)];
    
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    dd1=[UIButton buttonWithType: UIButtonTypeCustom];
    [dd1 setFrame:CGRectMake(20, y+4, 270, 21)];
    [dd1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [dd1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [dd1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [dd1.titleLabel setFont:[UIFont systemFontOfSize:17]];
    if ([pickerArray count]==0) {
        [dd1 setTitle:@"Email not found" forState:UIControlStateNormal];
    }else{
        [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
        [dd1 setTitle:[pickerArray objectAtIndex:0] forState:UIControlStateNormal];
    }
    y=y+30+10;
    [uv addSubview:dd1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Message";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, 300, 105)];
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(12, y+3, 296, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    txtNote.delegate=self;
    txtNote.text=[pd.Shipto stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    [uv addSubview:txtNote];
    
    y=y+120;
    
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, y, 300, 44)];
    [loginButton setTitle:@"Send" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
    [uv addSubview:loginButton];
    
    y = y>uv.frame.size.height+1? y:uv.frame.size.height+1;
    uv.contentSize=CGSizeMake(320.0,y);
}

-(IBAction)sendEmail:(id)sender{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
//        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//        [self.navigationController.view addSubview:HUD];
//        HUD.labelText=@"Sending email...";
//        HUD.dimBackground = YES;
//        HUD.delegate = self;
//        [HUD show:YES];
        self.view.userInteractionEnabled=NO;
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Sending Email to Queue...";
        
        HUD.progress=0.01;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];

        
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
//        alertViewWithProgressbar.progress=1;
        
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler:) version:version];
    }
}

- (void) xisupdate_iphoneHandler: (id) value {
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
//        [HUD hide:YES];
        [HUD hide];
        self.view.userInteractionEnabled=YES;
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
//        [HUD hide:YES];
         [HUD hide];
        self.view.userInteractionEnabled=YES;
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        return;
    }
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"1"]) {
//        [HUD hide:YES];
         [HUD hide];
        self.view.userInteractionEnabled=YES;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
    }else{
        HUD.progress=0.5;
        [txtNote resignFirstResponder];
        wcfService *service=[wcfService service];
        [service xSendEmail:self action:@selector(xSendEmailHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid: poid xto: dd1.titleLabel.text oldvendoremail: @"" xmsg: txtNote.text EquipmentType: @"3" xtype:  @""];
        
//        [service xSendEmail:self action:@selector(xSendEmailHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid: poid xto: @"xiujun_85@163.com" oldvendoremail: @"" xmsg: txtNote.text EquipmentType: @"3" xtype:  @""];
        

    }
}

- (void) xSendEmailHandler: (BOOL) value {
//    [HUD hide:YES];
    
	if (!value) {
        [HUD hide];
        self.view.userInteractionEnabled=YES;
        UIAlertView *alert=[self getErrorAlert:@"Send email unsuccessfully, please try it again later."];
        [alert show];
    }else{
        HUD.progress=1.0;
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                   target:self
                                                 selector:@selector(targetMethod)
                                                 userInfo:nil
                                                  repeats:YES];
    }
}

-(void)targetMethod{
    [myTimer invalidate];
    [HUD hide];
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[projectpols class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
- (void)doneClicked{
    [uv setContentOffset:CGPointMake(0,0) animated:YES];
    [txtNote resignFirstResponder];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
