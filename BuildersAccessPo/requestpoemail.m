
//
//  poemail.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-24.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "requestpoemail.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "InsetsLabel.h"
#import "Reachability.h"
#import "po1.h"
#import "projectpols.h"
#import "forapprove.h"
#import "project.h"
#import "development.h"
#import "MBProgressHUD.h"


@interface requestpoemail ()<MBProgressHUDDelegate>{
    UIButton *dd1;
     MBProgressHUD *HUD;
    NSTimer *myTimer;
}
@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@end

@implementation requestpoemail

@synthesize txtNote, pickerArray, xtype, aemail, idnum;
@synthesize xxdate, xxreason, xxstr, xxtotle, xxnotes, fromforapprove, ntabbar, uv;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ( item.tag == 1) {
        [self goback1:item];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    switch (xtype) {
        case 0:
             self.title=@"Acknowledge Requested VPO";
            break;
        case 1:
            self.title=@"Disapprove Requested VPO";
            break;
        case 3:
            self.title=@"Hold Requested VPO";
            break;
        default:
            self.title=@"Void Requested VPO";
            break;
    }
    UITabBarItem *firstItem0;
    if (fromforapprove==1) {
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"For Approve" image:[UIImage imageNamed:@"home.png"] tag:1];
    }else{
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
    }
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]init];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    [ntabbar setItems:itemsArray animated:YES];
    ntabbar.delegate = self;
    //    [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:3]setEnabled:NO ];
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    [self drawpageg];
}


-(void)drawpageg{
    UILabel *lbl;
    int y=10;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"To";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField * text1;
    text1=[[UITextField alloc]initWithFrame: CGRectMake(10, y, self.view.frame.size.width-20, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    dd1=[UIButton buttonWithType: UIButtonTypeCustom];
    [dd1 setFrame:CGRectMake(20, y+4, 270, 21)];
    [dd1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
    [dd1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [dd1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [dd1.titleLabel setFont:[UIFont systemFontOfSize:17]];
    
    y=y+25+10;
    [uv addSubview:dd1];
    
       
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Message";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 105)];
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(12, y+3, self.view.frame.size.width-24, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.font=[UIFont systemFontOfSize:17.0];
   
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithDone]];
//    if (![xxnotes isEqualToString:@""]) {
//       xxnotes=xxnotes;
//    }
    txtNote.text=@"";
    [uv addSubview:txtNote];
    
    y=y+120;
    
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
    switch (xtype) {
        case 0:
        {
            [loginButton setTitle:@"Submit Acknowledge" forState:UIControlStateNormal];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [loginButton setTitle:@"Submit Disapprove" forState:UIControlStateNormal];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [loginButton setTitle:@"Submit Hold" forState:UIControlStateNormal];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        }
            break;
        default:
        {
            [loginButton setTitle:@"Submit Void" forState:UIControlStateNormal];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        }
            break;
    }
    
    
   
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
   
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(doapprove:) forControlEvents:UIControlEventTouchUpInside];
    [uv addSubview:loginButton];
    
    if (self.view.frame.size.height>480) {
        uv.contentSize=CGSizeMake(self.view.frame.size.width,uv.frame.size.height+1);
        
    }else{
        uv.contentSize=CGSizeMake(self.view.frame.size.width,y+50);
    }
    
    pickerArray =[[NSMutableArray alloc]init];
    [pickerArray addObject:aemail];
    [dd1 setTitle:aemail forState:UIControlStateNormal];
    
}
//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    if (self.view.frame.size.height>500) {
//        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-170) animated:YES];
//    }else{
//        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-84) animated:YES];    }
//	return YES;
//    
//}

-(IBAction)doapprove:(id)sender{
   
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler:) version:version];
    }
}

- (void) xisupdate_iphoneHandler: (id) value {
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
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        NSString *nstatus;
        switch (xtype) {
            case 0:
                nstatus=@"Acknowledge";
                break;
            case 1:
                nstatus=@"Disapprove";
                break;
                break;
            case 3:
                nstatus=@"Hold";
                break;
            default:
                  nstatus=@"Void";
        }
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:@"BuildersAccess"
                              message:[NSString stringWithFormat:@"Are you sure you want to %@?", nstatus]
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
        alert.tag = 0;
        [alert show];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 0){
	    switch (buttonIndex) {
			case 0:
				break;
			default:
                 [self updatepo];				
				break;
		}
    }else if (alertView.tag == 1){
        switch (buttonIndex) {
			case 0:
				break;
			default:
				[self updatepo];
				break;
		}
    }
}


-(void)updatepo{
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];
//    HUD.labelText=@"Updating...";
//    HUD.dimBackground = YES;
//    HUD.delegate = self;
//    [HUD show:YES];
    
    self.view.userInteractionEnabled=NO;
//    alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//    
//    [alertViewWithProgressbar show];
//    alertViewWithProgressbar.progress=30;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    [self.navigationController.view addSubview:HUD];
    HUD.labelText=@"Sending Email to Queue...";
    
    HUD.progress=0.3;
    [HUD layoutSubviews];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    
    NSString *nmsg=[txtNote.text stringByReplacingOccurrencesOfString:@"\n" withString:@";"];
    wcfService *service=[wcfService service];
    switch (xtype) {
        case 0:
            [service xAprroveRequestedPOWithEmail:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnum reason:xxreason xtotal:xxtotle xdate:xxdate xnotes:xxnotes xstr:xxstr emailbody:nmsg EquipmentType:@"3"];
            break;
          case 1:
            [service xDisAprroveRequestedPOWithEmail:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnum emailbody: nmsg xtotal:xxtotle xdate:xxdate xstr:xxstr xnotes:xxnotes EquipmentType:@"3"];
            break;
        case 3:
            [service xHoldRequestedPOWithEmail:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnum emailbody: nmsg xtotal:xxtotle xdate:xxdate xstr:xxstr xnotes:xxnotes EquipmentType:@"3"];
            break;
        default:
            [service xVoidRequestedPOWithEmail:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnum emailbody:nmsg xtotal:xxtotle xdate:xxdate xstr:xxstr xnotes:xxnotes EquipmentType:@"3"];
            break;
    }
}

- (void) xisupdate_iphoneHandler2: (id) value {
    
//    [HUD hide:YES];
//    [HUD removeFromSuperViewOnHide];
   
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
    
    NSString *rtn =(NSString *)value;
    if ([rtn isEqualToString:@"1"]) {
        HUD.progress=1;
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                   target:self
                                                 selector:@selector(targetMethod)
                                                 userInfo:nil
                                                  repeats:YES];


    }else if ([rtn isEqualToString:@"2"]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        
        UIAlertView *alert=[self getErrorAlert:@"Send email fail."];
        [alert show];
        [self goback1:nil];
    }
    
}

-(void)targetMethod{
    [myTimer invalidate];
    [HUD hide];
    [self goback1:nil];
}


-(IBAction)goback1:(id)sender{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            
        }else if ([temp isKindOfClass:[development class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }else if ([temp isKindOfClass:[project class]]) {
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



