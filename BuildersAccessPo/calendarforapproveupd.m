//
//  calendarforapproveupd.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-29.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "calendarforapproveupd.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "wcfService.h"
#import "userInfo.h"
#import "codisapprove.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "forapprove.h"

@interface calendarforapproveupd ()<MBProgressHUDDelegate, UITabBarDelegate>{
    MBProgressHUD *HUD;
    NSDateFormatter *formatter;
     UIButton* loginButton;
     UIButton* loginButton1;
    
    UIAlertController *sheet;
}

@end

@implementation calendarforapproveupd

@synthesize uv, ntabbar, xmtype, idnumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [ntabbar setSelectedItem:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self drawScreen];
    
   
    [self getInfofromService];
    
	// Do any additional setup after loading the view.
}

-(void)getInfofromService{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetCalendarEntry:self action:@selector(xGetCalendarEntryHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnumber: idnumber EquipmentType: @"3"];
        
    }
}

-(void)drawScreen{
    
    int x=0;
    int y=10;
    if (self.view.frame.size.height>480) {
        y=y+5;
        x=10;
    }else{
        x=5;
    }
    
    self.title=@"Calendar Event";
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    uv.backgroundColor = [Mysql groupTableViewBackgroundColor];
    
    UILabel *lbl;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Subject";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    txtSubject=[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 30)];
    [txtSubject setBorderStyle:UITextBorderStyleRoundedRect];
    
    txtSubject .delegate=self;
    txtSubject.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: txtSubject];
    y=y+30+x+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Location";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    txtLocation=[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 30)];
    [txtLocation setBorderStyle:UITextBorderStyleRoundedRect];
    txtLocation.delegate=self;
    txtLocation.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: txtLocation];
    y=y+30+x+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Date";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    UITextField * text1;
    
    text1 =[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    txtDate=[UIButton buttonWithType: UIButtonTypeCustom];
    [txtDate setFrame:CGRectMake(25, y+4, 270, 21)];
    [txtDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [txtDate addTarget:self action:@selector(popupscreen:) forControlEvents:UIControlEventTouchDown];
    [txtDate setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [txtDate setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [txtDate.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [uv addSubview: txtDate];
    y=y+30+x+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Start Time";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    
    text1 =[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    txtStart=[UIButton buttonWithType: UIButtonTypeCustom];
    [txtStart setFrame:CGRectMake(25, y+4, 270, 21)];
    [txtStart setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [txtStart addTarget:self action:@selector(popupscreen1:) forControlEvents:UIControlEventTouchDown];
    [txtStart setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [txtStart setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [txtStart.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [uv addSubview: txtStart];
    y=y+30+x+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"End Time";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    
    text1=[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    txtEnd=[UIButton buttonWithType: UIButtonTypeCustom];
    [txtEnd setFrame:CGRectMake(25, y+4, 270, 21)];
    [txtEnd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [txtEnd addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
    [txtEnd setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [txtEnd setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [txtEnd.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [uv addSubview: txtEnd];
    y=y+30+x+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Contact Name";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    txtContractNm=[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 30)];
    [txtContractNm setBorderStyle:UITextBorderStyleRoundedRect];
    txtContractNm.delegate=self;
    txtContractNm.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: txtContractNm];
    y=y+30+x+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Phone";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    txtPhone=[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 30)];
    [txtPhone setBorderStyle:UITextBorderStyleRoundedRect];
    txtPhone.delegate=self;
    txtPhone.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: txtPhone];
    y=y+30+x+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Mobile";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    txtMobile=[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 30)];
    [txtMobile setBorderStyle:UITextBorderStyleRoundedRect];
    txtMobile.delegate=self;
    txtMobile.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: txtMobile];
    y=y+30+x+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Email";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    txtemail=[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 30)];
    [txtemail setBorderStyle:UITextBorderStyleRoundedRect];
    txtemail.delegate=self;
    txtemail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: txtemail];
    y=y+30+x+5;
    
    
    if (xmtype ==2) {
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
        lbl.text=@"Daily Charge";
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.backgroundColor=[UIColor clearColor];
        [uv addSubview:lbl];
        y=y+21+x;
        
        txtcharge=[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 30)];
        [txtcharge setBorderStyle:UITextBorderStyleRoundedRect];
        txtcharge.delegate=self;
        txtcharge.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [uv addSubview: txtcharge];
        y=y+30+x+5;
    }
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Notes";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 75)];
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(22, y+3, 276, 68) ];
    txtNote.layer.cornerRadius=10;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    txtNote.delegate=self;
    [uv addSubview:txtNote];
    y=y+80+x;
   
    if (xmtype==3) {
//         [[ntabbar.items objectAtIndex:0]setTitle:nil ];
//        [[ntabbar.items objectAtIndex:1]setTitle:nil ];
//       // [ntabbar removeFromSuperview];
        
       
        
        
            loginButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton1 setFrame:CGRectMake(20, y, 280, 44)];
            [loginButton1 setTitle:@"Save" forState:UIControlStateNormal];
            [loginButton1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton1 setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton1 addTarget:self action:@selector(dosave:) forControlEvents:UIControlEventTouchUpInside];
           
            y=y+54;
        
        loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(20, y, 280, 44)];
        [loginButton setTitle:@"Delete" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(dodelte:) forControlEvents:UIControlEventTouchUpInside];
       
        y=y+54;
        
        
        
//        ntabbar.userInteractionEnabled = YES;
//        
//        [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"save.png"] ];
//        [[ntabbar.items objectAtIndex:0]setTitle:@"Save" ];
////        [[ntabbar.items objectAtIndex:0]setAction:@selector(dosave:)  ];
//        [[ntabbar.items objectAtIndex:1]setImage:[UIImage imageNamed:@"disapprove.png"] ];
//        [[ntabbar.items objectAtIndex:1]setTitle:@"Delete" ];
//        [[ntabbar.items objectAtIndex:1]setAction:@selector(dodelte:)  ];
    }else{
        
        
       
        
        
        loginButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton1 setFrame:CGRectMake(20, y, 280, 44)];
        [loginButton1 setTitle:@"Approve" forState:UIControlStateNormal];
        [loginButton1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton1 setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton1 addTarget:self action:@selector(doapprove:) forControlEvents:UIControlEventTouchUpInside];
        y=y+54;
        
        loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(20, y, 280, 44)];
        [loginButton setTitle:@"DisApprove" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(dodisapprove:) forControlEvents:UIControlEventTouchUpInside];
        y=y+54;
        
        

    }
     uv.contentSize=CGSizeMake(320.0,y+1);
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
    [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:3]setTitle:@"Refresh" ];
//    [[ntabbar.items objectAtIndex:3]setAction:@selector(doRefresh)  ];
    
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtSubject setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :YES]];
    [txtLocation setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
    [txtContractNm setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
    [txtPhone setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
    [txtMobile setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
    [txtemail setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
    [txtcharge setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
    [txtNote setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :NO]];
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"For Approve"]) {
        [self goBack1];
    }else if ([item.title isEqualToString:@"Refresh"]) {
        [self doRefresh];
    }
}

-(void)doRefresh{
    [self getInfofromService];
}

-(void)goBack1{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ( [temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
-(void)dodelte:(id)sender{
    UIAlertView *alert = nil;
    alert = [[UIAlertView alloc]
             initWithTitle:@"BuildersAccess"
             message:@"Are you sure you want to delete?"
             delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"Ok", nil];
    alert.tag = 2;
    [alert show];
}

-(IBAction)doapprove:(id)sender{
    UIAlertView *alert = nil;
    alert = [[UIAlertView alloc]
             initWithTitle:@"BuildersAccess"
             message:@"Are you sure you want to save and approve?"
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
        [HUD hide:YES];
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        [HUD hide:YES];
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        return;
    }
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"1"]) {
        [HUD hide:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
    }else{
        NSString *para;
      if (xmtype==2) {
            para = [NSString stringWithFormat:@"{'Subject':'%@','Location':'%@','ContactName':'%@','Phone':'%@','Mobile':'%@','Notes':'%@','TDate':'%@','StartTime':'%@','EndTime':'%@', 'Email':'%@', 'DailyCharge':'%@','MEvent':'%@'}", txtSubject.text, txtLocation.text, txtContractNm.text, txtPhone.text, txtMobile.text, txtNote.text, txtDate.titleLabel.text, txtStart.titleLabel.text, txtEnd.titleLabel.text, txtemail.text, txtcharge.text,result.MEvent ];
        }else{
            para = [NSString stringWithFormat:@"{'Subject':'%@','Location':'%@','ContactName':'%@','Phone':'%@','Mobile':'%@','Notes':'%@','TDate':'%@','StartTime':'%@','EndTime':'%@', 'Email':'%@', 'MEvent':'%@', 'DailyCharge':'%@'}", txtSubject.text, txtLocation.text, txtContractNm.text, txtPhone.text, txtMobile.text, txtNote.text, txtDate.titleLabel.text, txtStart.titleLabel.text, txtEnd.titleLabel.text, txtemail.text ,result.MEvent, result.DailyCharge];
        }
            //            NSLog(@"%@ %@ %d", para, idnumber, [userInfo getCiaId]);
            wcfService *service = [wcfService service];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
            [service xUpdateCalendarApprove1:self action:@selector(xUpdateCalendarApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] calendarData:para xidnumber:idnumber EquipmentType:@"3"];
        
        
        

    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if ((alertView.tag == 1 || alertView.tag==2) && buttonIndex==1){
        
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
            [alert show];
        }else{
            
            Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
            NetworkStatus netStatus = [curReach currentReachabilityStatus];
            if (netStatus ==NotReachable) {
                UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
                [alert show];
            }else{
                
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.labelText=@"   Updating...   ";
                HUD.dimBackground = YES;
                HUD.delegate = self;
                [HUD show:YES];
                
                wcfService* service = [wcfService service];
                NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler:) version:version];
            }
        }
    }else{
        [ntabbar setSelectedItem:nil];
    }
    
    
}
-(void)xdelteKirbyTitleHandler:(id)value3{
    [HUD hide:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    wcfKeyValueItem* result1 = (wcfKeyValueItem*)value3;
    if ([result1.Key isEqualToString:@"-1"]) {
        UIAlertView *alert = nil;
        alert=[self getErrorAlert:result1.Value];
        [alert show];
    }else {
        [self goBack:nil];
    }

}
- (void) xUpdateCalendarApproveHandler: (id) value3 {
    [HUD hide:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    NSString* result1 = (NSString*)value3;
    if ([result1 isEqualToString:@"2"]) {
        UIAlertView *alert = nil;
        alert=[self getErrorAlert:[NSString stringWithFormat:@"Date time is already taken: %@ by %@", result.Subject, result.CreateBy]];
        [alert show];
    }else if([result1 isEqualToString:@"0"]){
        UIAlertView *alert = nil;
        alert=[self getErrorAlert:@"Update fail."];
        [alert show];
    }else{
        [self goBack:nil];
    }
}

-(IBAction)dodisapprove:(id)sender{
    
    codisapprove *pd =[self.storyboard instantiateViewControllerWithIdentifier:@"codisapprove"];
    pd.managedObjectContext=self.managedObjectContext;
    
    pd.xemail =result.ToEmail;
    pd.xmsg = result.ToMessage;
    pd.disapprove=result.DisApprove;
    pd.idnumber=self.idnumber;
    
    
    NSString *para;
    if (xmtype==2) {
        para = [NSString stringWithFormat:@"{'Subject':'%@','Location':'%@','ContactName':'%@','Phone':'%@','Mobile':'%@','Notes':'%@','TDate':'%@','StartTime':'%@','EndTime':'%@', 'Email':'%@', 'DailyCharge':'%@','MEvent':'%@', 'ToEmail':'%@', 'ToSubject':'%@'", txtSubject.text, txtLocation.text, txtContractNm.text, txtPhone.text, txtMobile.text, txtNote.text, txtDate.titleLabel.text, txtStart.titleLabel.text, txtEnd.titleLabel.text, txtemail.text, txtcharge.text,result.MEvent, result.ToEmail, result.ToSubject ];
    }else{
        para = [NSString stringWithFormat:@"{'Subject':'%@','Location':'%@','ContactName':'%@','Phone':'%@','Mobile':'%@','Notes':'%@','TDate':'%@','StartTime':'%@','EndTime':'%@', 'Email':'%@', 'MEvent':'%@', 'DailyCharge':'%@', 'ToEmail':'%@', 'ToSubject':'%@'", txtSubject.text, txtLocation.text, txtContractNm.text, txtPhone.text, txtMobile.text, txtNote.text, txtDate.titleLabel.text, txtStart.titleLabel.text, txtEnd.titleLabel.text, txtemail.text ,result.MEvent, result.DailyCharge, result.ToEmail, result.ToSubject];
    }
    
    pd.calendardata=para;
    [self.navigationController pushViewController:pd animated:YES];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView==pend) {
        return [pickerArrayEnd count];
    }else{
        return [pickerArrayStart count];}
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView==pend) {
        return [pickerArrayEnd objectAtIndex:row];
    }else{
        return [pickerArrayStart objectAtIndex:row];
    }
}

-(IBAction)popupscreen:(id)sender{
    
    [txtSubject resignFirstResponder];
    [txtLocation resignFirstResponder];
    [txtContractNm resignFirstResponder];
    [txtPhone resignFirstResponder];
    [txtMobile resignFirstResponder];
    [txtemail resignFirstResponder];
    [txtNote resignFirstResponder];
    
    if (self.view.frame.size.height>500) {
        [uv setContentOffset:CGPointMake(0,txtDate.frame.origin.y-180) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0,txtDate.frame.origin.y-90) animated:YES];
    }
   
    if (!sheet) {
        sheet = [UIAlertController alertControllerWithTitle:@"Select Date" message:@"\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        
        CGFloat aWidth =320;
        CGFloat CONTENT_HEIGHT = 400;
        //
        [sheet.view setBounds:CGRectMake(0, 0, aWidth, CONTENT_HEIGHT)];
        
        UIToolbar *toolbar = [[UIToolbar alloc]
                              initWithFrame:CGRectMake(10, 44, 280, 44)];
        [toolbar setItems:@[
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerSheetCancel)],
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerSheetDone)]
                            ]];
        
        
        if (pdate ==nil) {
            pdate=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 88, 320, 170)];
            pdate.datePickerMode=UIDatePickerModeDate;
            Mysql *msql=[[Mysql alloc]init];
            if (txtDate.titleLabel.text) {
                [pdate setDate:[msql dateFromString:txtDate.titleLabel.text]];
            }else{
                [pdate setDate:[[NSDate alloc]init]];
            }
        }
        [sheet.view addSubview:toolbar];
        [sheet.view addSubview:pdate];
    }
    
    [self.parentViewController presentViewController:sheet animated:YES completion:nil];
}

-(void)pickerSheetCancel{
    [sheet dismissViewControllerAnimated:YES completion:nil];
}

-(void)pickerSheetDone{
    [sheet dismissViewControllerAnimated:YES completion:nil];
    if (!formatter) {
        formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM/dd/YYYY"];
    }
    
    [txtDate setTitle:[formatter stringFromDate:[pdate date]] forState:UIControlStateNormal];
}


-(IBAction)popupscreen1:(id)sender{
    
    [txtSubject resignFirstResponder];
    [txtLocation resignFirstResponder];
    [txtContractNm resignFirstResponder];
    [txtPhone resignFirstResponder];
    [txtMobile resignFirstResponder];
    [txtemail resignFirstResponder];
    [txtNote resignFirstResponder];
    
    if (self.view.frame.size.height>500) {
        [uv setContentOffset:CGPointMake(0,txtStart.frame.origin.y-230) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0,txtStart.frame.origin.y-90) animated:YES];
    }
    
    actionSheet=nil;
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self
                                     cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Select",@"Cancel", nil];
    [actionSheet setTag:2];
    
    if (pstart ==nil) {
        pstart = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        pstart.showsSelectionIndicator = YES;
        
        pstart.delegate = self;
        pstart.dataSource = self;
        if (pickerArrayStart ==nil) {
            pickerArrayStart = [NSArray arrayWithObjects: @"06:00 AM", @"06:30 AM", @"07:00 AM", @"07:30 AM", @"08:00 AM", @"08:30 AM", @"09:00 AM", @"09:30 AM", @"10:00 AM", @"10:30 AM", @"11:00 AM", @"11:30 AM", @"12:00 PM", @"12:30 PM", @"01:00 PM", @"01:30 PM", @"02:00 PM", @"02:30 PM", @"03:00 PM", @"03:30 PM", @"04:00 PM", @"04:30 PM", @"05:00 PM", @"05:30 PM", @"06:00 PM", @"06:30 PM", @"07:00 PM", @"07:30 PM", @"08:00 PM", @"08:30 PM", @"09:00 PM", nil];
            int j =0;
            for (int i=0; i<[pickerArrayStart count]; i++) {
                
                if ([result.StartTime isEqualToString:[pickerArrayStart objectAtIndex:i]]) {
                    j=i;
                    [pstart selectRow:i inComponent:0 animated:YES];
                    break;
                }
            }
            
            NSMutableArray *t = [[NSMutableArray alloc]init];
            for (int i=j; i<[pickerArrayStart count]; i++) {
                [t addObject:[pickerArrayStart objectAtIndex:i]];
            }
            pickerArrayEnd=t;
        }
        
        
    }
    [actionSheet addSubview:pstart];
    
//    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//    [actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
    int y=0;
    if (self.view.frame.size.height>480) {
        y=80;
    }
    
    [actionSheet setFrame:CGRectMake(0, 177+y, 320, 383)];
//    [[[actionSheet subviews]objectAtIndex:0] setFrame:CGRectMake(20,180, 120, 46)];
//    [[[actionSheet subviews]objectAtIndex:1] setFrame:CGRectMake(180,180, 120, 46)];
 [actionSheet showInView:self.view];
}

-(IBAction)popupscreen2:(id)sender{
    
    [txtSubject resignFirstResponder];
    [txtLocation resignFirstResponder];
    [txtContractNm resignFirstResponder];
    [txtPhone resignFirstResponder];
    [txtMobile resignFirstResponder];
    [txtemail resignFirstResponder];
    [txtNote resignFirstResponder];
    
    if (self.view.frame.size.height>500) {
        [uv setContentOffset:CGPointMake(0,txtEnd.frame.origin.y-230) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0,txtEnd.frame.origin.y-90) animated:YES];
    }
    
    
    actionSheet=nil;
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self
                                     cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Select",@"Cancel", nil];
    [actionSheet setTag:3];
    
    if (pend ==nil) {
        pend = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        pend.showsSelectionIndicator = YES;
        
        
        if (pickerArrayStart ==nil) {
            pickerArrayStart = [NSArray arrayWithObjects: @"06:00 AM", @"06:30 AM", @"07:00 AM", @"07:30 AM", @"08:00 AM", @"08:30 AM", @"09:00 AM", @"09:30 AM", @"10:00 AM", @"10:30 AM", @"11:00 AM", @"11:30 AM", @"12:00 PM", @"12:30 PM", @"01:00 PM", @"01:30 PM", @"02:00 PM", @"02:30 PM", @"03:00 PM", @"03:30 PM", @"04:00 PM", @"04:30 PM", @"05:00 PM", @"05:30 PM", @"06:00 PM", @"06:30 PM", @"07:00 PM", @"07:30 PM", @"08:00 PM", @"08:30 PM", @"09:00 PM", nil];
            int j =0;
            for (int i=0; i<[pickerArrayStart count]; i++) {
                
                if ([result.StartTime isEqualToString:[pickerArrayStart objectAtIndex:i]]) {
                    j=i;
                    [pstart selectRow:i inComponent:0 animated:YES];
                    break;
                }
            }
            
            NSMutableArray *t = [[NSMutableArray alloc]init];
            for (int i=j; i<[pickerArrayStart count]; i++) {
                [t addObject:[pickerArrayStart objectAtIndex:i]];
            }
            pickerArrayEnd=t;
            
        }
        
        pend.delegate = self;
        pend.dataSource = self;
        
        
    }

        
for (int i=0; i<[pickerArrayStart count]; i++) {
    if ([result.EndTime isEqualToString:[pickerArrayStart objectAtIndex:i]]) {
        [pend selectRow:i inComponent:0 animated:YES];
    }
}

    


    [actionSheet addSubview:pend];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//    [actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)

    int y=0;
    if (self.view.frame.size.height>480) {
        y=80;
    }
    
    [actionSheet setFrame:CGRectMake(0, 177+y, 320, 383)];
 [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        switch (actionSheet1.tag) {
            
            case 2:{
                [txtStart setTitle:[pickerArrayStart objectAtIndex: [pstart selectedRowInComponent:0]] forState:UIControlStateNormal];
                NSMutableArray *t = [[NSMutableArray alloc]init];
                for (int j=[pstart selectedRowInComponent:0]; j<[pickerArrayStart count]; j++) {
                    [t addObject:[pickerArrayStart objectAtIndex:j]];
                }
                pickerArrayEnd=nil;
                pickerArrayEnd=t;
                [pend reloadAllComponents];
                if (![pickerArrayEnd containsObject:txtEnd.currentTitle]) {
                    [txtEnd setTitle:[pickerArrayEnd objectAtIndex: 0] forState:UIControlStateNormal];
                }
                break;
            }
            default:
                [txtEnd setTitle:[pickerArrayEnd objectAtIndex: [pend selectedRowInComponent:0]] forState:UIControlStateNormal];
                break;
        }
        
        
    }
    
}



- (void)doneClicked {
    [txtSubject resignFirstResponder];
    [txtLocation resignFirstResponder];
    [txtContractNm resignFirstResponder];
    [txtPhone resignFirstResponder];
    [txtMobile resignFirstResponder];
    [txtemail resignFirstResponder];
    [txtNote resignFirstResponder];
    [txtcharge resignFirstResponder];
    [uv setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)previousClicked{
    if([txtLocation isFirstResponder]){
        [txtSubject becomeFirstResponder];
        //    }else if([txtDate isFirstResponder]){
        //        [txtLocation becomeFirstResponder];
        //    }else if([txtStart isFirstResponder]){
        //        [txtDate becomeFirstResponder];
        //    }else if([txtEnd isFirstResponder]){
        //        [txtStart becomeFirstResponder];
    }else if([txtContractNm isFirstResponder]){
        [txtLocation becomeFirstResponder];
    }else if([txtPhone isFirstResponder]){
        [txtContractNm becomeFirstResponder];
    }else if([txtMobile isFirstResponder]){
        [txtPhone becomeFirstResponder];
    }else if([txtemail isFirstResponder]){
        [txtMobile becomeFirstResponder];
    }else if ([txtNote isFirstResponder]){
        if (xmtype==2) {
            [txtcharge becomeFirstResponder];
        }else{
            [txtemail becomeFirstResponder];
        }
    }else{
        [txtemail becomeFirstResponder];
    }
}
-(void)nextClicked{
    if([txtSubject isFirstResponder]){
        [txtLocation becomeFirstResponder];
    }else if([txtLocation isFirstResponder]){
        [txtContractNm becomeFirstResponder];
        //    }else if([txtDate isFirstResponder]){
        //        [txtStart becomeFirstResponder];
        //    }else if([txtStart isFirstResponder]){
        //        [txtEnd becomeFirstResponder];
        //    }else if([txtEnd isFirstResponder]){
        //        [txtContractNm becomeFirstResponder];
    }else if([txtContractNm isFirstResponder]){
        [txtPhone becomeFirstResponder];
    }else if([txtPhone isFirstResponder]){
        [txtMobile becomeFirstResponder];
    }else if([txtMobile isFirstResponder]){
        [txtemail becomeFirstResponder];
    }else if([txtemail isFirstResponder]){
        if (xmtype==2) {
            [txtcharge becomeFirstResponder];
        }else{
            [txtNote becomeFirstResponder];
        }
        
    }else{
        [txtNote becomeFirstResponder];
    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(id)sender
{
	[sender resignFirstResponder];
    if (self.view.frame.size.height>500) {
        [uv setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }
	return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)sender
{
    if (self.view.frame.size.height>500) {
        if (sender != txtSubject && sender!=txtLocation ) {
            [uv setContentOffset:CGPointMake(0,sender.frame.origin.y-212) animated:YES];
        }else {
            [uv setContentOffset:CGPointMake(0,0) animated:YES];
        }
    }else{
        if (sender != txtSubject && sender!=txtLocation) {
            [uv setContentOffset:CGPointMake(0,sender.frame.origin.y-124) animated:YES];
        }else{
            [uv setContentOffset:CGPointMake(0,0) animated:YES];
            
        }
        
        
    }
	return YES;
}


- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.view.frame.size.height>500) {
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-170) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-84) animated:YES];    }
	return YES;
    
}


- (void) xGetCalendarEntryHandler: (id) value {
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
    
    result = (wcfCalendarEntryItem*)value;
    txtSubject.text=result.Subject;
    if (result.Location ==nil) {
        result.Location=@"";
    }
    if (result.DailyCharge==nil) {
        result.DailyCharge=@"";
    }
    txtLocation.text=result.Location;
   
    if (![result.TDate isEqualToString:@"01/01/1980"]) {
        [txtDate setTitle:result.TDate forState:UIControlStateNormal];
    }
    
    result.StartTime=  [result.StartTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    result.EndTime=  [result.EndTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [txtStart setTitle:result.StartTime forState:UIControlStateNormal];
    
    [txtEnd setTitle:result.EndTime forState:UIControlStateNormal];
    
    [txtContractNm setText: result.ContactName];
    if (![result.Phone isEqualToString:@"(null)"]) {
         [txtPhone setText:result.Phone];
    }
   
    txtMobile.text= result.Mobile;
    txtemail.text=result.Email;
    txtNote.text=result.Notes;
    if (xmtype==2) {
        txtcharge.text=result.Notes;
    }
    
    if (result.MApprove) {
        [uv addSubview:loginButton1];
        [uv addSubview:loginButton];
    }else{
     uv.contentSize=CGSizeMake(320.0,uv.contentSize.height-108);
    }
    [ntabbar setSelectedItem:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
