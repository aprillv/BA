//
//  codisapprove.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-2.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "codisapprove.h"
#import "Mysql.h"
#import "userInfo.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "calendarforapprove.h"
#import "Reachability.h"
#import "MBProgressHUD.h"

#import "forapprove.h"

@interface codisapprove ()<MBProgressHUDDelegate, UITabBarDelegate>{

    NSTimer *myTimer;
    MBProgressHUD *HUD;
}

@end

@implementation codisapprove

@synthesize uv, ntabbar, dd1, pickerArray, xemail, xmsg, disapprove, idnumber, calendardata;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    
    int x=0;
    int y=10;
    if (self.view.frame.size.height>480) {
        y=y+5;
        x=10;
        uv.contentSize=CGSizeMake(self.view.frame.size.width,460.0);
    }else{
        x=5;
        uv.contentSize=CGSizeMake(self.view.frame.size.width,370.0);
    }
    
    self.title=@"Disapprove";
    uv.backgroundColor = [Mysql groupTableViewBackgroundColor];
    
    UILabel *lbl;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"To";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    UITextField * text1=[[UITextField alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 30)];
    
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    
    dd1=[UIButton buttonWithType: UIButtonTypeCustom];
    [dd1 setFrame:CGRectMake(15, y+4, self.view.frame.size.width-30, 21)];
    [dd1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
    [dd1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [dd1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [dd1 setTitle:xemail forState:UIControlStateNormal];
    [dd1.titleLabel setFont:[UIFont systemFontOfSize:17]];
    
    
    y=y+30+x;
    [uv addSubview:dd1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Message";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 105)];
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(12, y+3, self.view.frame.size.width-24, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    txtNote.delegate=self;
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithDone]];
    [txtNote setText:xmsg];
    [uv addSubview:txtNote];
    y=y+110+x;
    
    if (disapprove) {
        UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 36)];
        
        
        [loginButton setTitle:@"Submit Disapprove" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(dodisapprove:) forControlEvents:UIControlEventTouchUpInside];
        
        [uv addSubview:loginButton];
    }
    
    ntabbar.userInteractionEnabled = YES;
    
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"For Approve" ];
    ntabbar.delegate = self;
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1)  ];
    [[ntabbar.items objectAtIndex:1]setImage:nil ];
    [[ntabbar.items objectAtIndex:1]setTitle:nil ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO  ];
    [[ntabbar.items objectAtIndex:2]setImage:nil ];
    [[ntabbar.items objectAtIndex:2]setTitle:nil ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO  ];
    [[ntabbar.items objectAtIndex:3]setImage:nil ];
    [[ntabbar.items objectAtIndex:3]setTitle:nil ];
    [[ntabbar.items objectAtIndex:3]setEnabled:NO  ];
//    [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"refresh3.png"] ];
//    [[ntabbar.items objectAtIndex:3]setTitle:@"Refresh" ];
//    [[ntabbar.items objectAtIndex:3]setAction:@selector(doRefresh)  ];
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"For Approve"]) {
        [self goBack1];
    }
}
//-(void)doRefresh{
//    [self getInfofromService];
//}

-(void)goBack1{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ( [temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
- (void)doneClicked{
    [uv setContentOffset:CGPointMake(0,0) animated:YES];
    [txtNote resignFirstResponder];
}
-(IBAction)dodisapprove:(id)sender{
    UIAlertView *alert = nil;
    alert = [[UIAlertView alloc]
             initWithTitle:@"BuildersAccess"
             message:@"Are you sure you want to disapprove?"
             delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"Ok", nil];
    alert.tag = 1;
    [alert show];
    
}
- (void) xisupdate_iphoneHandler: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            self.view.userInteractionEnabled=YES;
            [HUD hide];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
            [alert show];
        }else{
            HUD.progress=0.5;
            wcfService *service = [wcfService service];
            
            calendardata =[calendardata stringByAppendingFormat:@",'ToMessage':'%@'}", txtNote.text];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
            [service xUpdateCalendarDisApprove1:self action:@selector(xUpdateCalendarApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] calendarData:calendardata xidnumber:self.idnumber EquipmentType:@"3"];
        }
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 1 && buttonIndex==1){
        
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
            [alert show];
        }else{
            
//            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//            [self.navigationController.view addSubview:HUD];
//            HUD.labelText=@"   Updating...   ";
//            HUD.dimBackground = YES;
//            HUD.delegate = self;
//            [HUD show:YES];
            self.view.userInteractionEnabled=NO;
//            alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//            
//            [alertViewWithProgressbar show];
//            alertViewWithProgressbar.progress=30;
            
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
            [self.navigationController.view addSubview:HUD];
            HUD.labelText=@"Sending Email to Queue...";
            
            HUD.progress=0.3;
            [HUD layoutSubviews];
            HUD.dimBackground = YES;
            HUD.delegate = self;
            [HUD show:YES];
            
            wcfService* service = [wcfService service];
            NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler:) version:version];
        }
        
        
    }else{
        [ntabbar setSelectedItem:nil];
    }
}


- (void) xUpdateCalendarApproveHandler: (id) value {
  
    NSString *str =(NSString *)value;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    if([str isEqualToString:@"0"]){
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        
        UIAlertView *alert = nil;
        alert=[self getErrorAlert:@"Update fail."];
        [alert show];
    }else if([str isEqualToString:@"-1"]){
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        
        UIAlertView *alert = nil;
        alert=[self getErrorAlert:@"Send email fail."];
        [alert show];
        
    }else{
        HUD.progress=1;
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                   target:self
                                                 selector:@selector(targetMethod)
                                                 userInfo:nil
                                                  repeats:YES];
        
        
    }
	
    
}

-(void)targetMethod{
    [myTimer invalidate];
    self.view.userInteractionEnabled=YES;
    [HUD hide];
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[calendarforapprove class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.view.frame.size.height>500) {
//        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-170) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-84) animated:YES];    }
	return YES;
    
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
