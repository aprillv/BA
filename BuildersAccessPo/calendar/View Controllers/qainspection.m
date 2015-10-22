//
//  qainspection.m
//  BuildersAccess
//
//  Created by amy zhao on 13-7-2.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "qainspection.h"
#import "Mysql.h"
#import "userInfo.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "calendarqa.h"
#import "Reachability.h"
#import "qainspectionb.h"
#import "project.h"
#import "MBProgressHUD.h"

@interface qainspection ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;


@end

@implementation qainspection

@synthesize idnumber, fromtype, uv, ntabbar;

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
        [self goBack:item];
    }else if(item.tag == 2){
        [self dorefresh];
    }
}
- (void)doneClicked{
    [uv setContentOffset:CGPointMake(0,0) animated:YES];
    [txtNote resignFirstResponder];
}

-(IBAction)goBack1:(id)sender{

    for (UIViewController *temp in self.navigationController.viewControllers) {

        if ([temp isKindOfClass:[calendarqa class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }else if ([temp isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
        
    }
}

-(void)dorefresh{
[self getdetail];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    self.title=@"Inspection";
	
    UITabBarItem *firstItem0 ;
    if (fromtype==1) {
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Calendar" image:[UIImage imageNamed:@"home.png"] tag:1];
    }else{
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
    }
    
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    //
    [ntabbar setItems:itemsArray animated:YES];
    //    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1:) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    //    [[ntabbar.items objectAtIndex:3] setAction:@selector(dorefresh)];
    self.view.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    [self getdetail];
}

-(void)getdetail{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service=[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetQAInspection:self action:@selector(doGet:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnumber EquipmentType:@"3"];
    }
    
}
- (void) doGet: (id) value {
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
    
    
    wcfInspectionqa *result = (wcfInspectionqa*)value;
    
    UILabel *lbl;
    float rowheight=32.0;
    int y=10;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Project";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+25;
    
    UIView *lbl1;
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview: lbl1];
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, 300, rowheight-8)];
    lbl.text=result.Nproejct;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+10;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Inspection";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+25;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview: lbl1];
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, 300, rowheight-8)];
    lbl.text=result.Inspection;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+10;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Assign To";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+25;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview: lbl1];
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, 300, rowheight-8)];
    lbl.text=result.AssignTo;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+10;

    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Remark (max 512 chars)";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+25;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, 300, 105)];
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(12, y+3, 296, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    txtNote.delegate=self;
    txtNote.text=[result.Notes stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    [uv addSubview:txtNote];
    
    y=y+120;
    UIButton* loginButton;
    if ([result.Ready isEqualToString:@"1"]) {
        loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(10, y, 300, 44)];
        [loginButton setTitle:@"Ready" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(doReady) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:loginButton];
        
        y=y+50;
    }
    
    if ([result.NotReady isEqualToString:@"1"]) {
        loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(10, y, 300, 44)];
        [loginButton setTitle:@"Not Ready" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(donotReady) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:loginButton];
    }
        
    if (self.view.frame.size.height>480) {
        uv.contentSize=CGSizeMake(320.0,435.0+80);
    }else{
        uv.contentSize=CGSizeMake(320.0,465.0);
    }
    
    [ntabbar setSelectedItem:nil];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.view.frame.size.height>500) {
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-142) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-54) animated:YES];    }
	return YES;
}

-(void)doReady{
    UIAlertView *alert = nil;
    alert = [[UIAlertView alloc]
             initWithTitle:@"BuildersAccess"
             message:@"Are you sure is ready?"
             delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"OK", nil];
    alert.tag = 2;
    [alert show];
}

-(void)donotReady{
    UIAlertView *alert = nil;
    alert = [[UIAlertView alloc]
             initWithTitle:@"BuildersAccess"
             message:@"Are you sure is not ready?"
             delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"OK", nil];
    alert.tag = 0;
    [alert show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 0) {
        switch (buttonIndex) {
			case 0:
				break;
			default:
            {
                UIAlertView *alert = nil;
                alert = [[UIAlertView alloc]
                         initWithTitle:@"BuildersAccess"
                         message:@"Minus 10 points will be assigned, Are you sure is not ready?"
                         delegate:self
                         cancelButtonTitle:@"Cancel"
                         otherButtonTitles:@"OK", nil];
                alert.tag = 1;
                [alert show];
            }
                break;
		} 
		return;
	}else if (alertView.tag == 1) {
        switch (buttonIndex) {
			case 0:
				break;
			default:
            {
                Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
                NetworkStatus netStatus = [curReach currentReachabilityStatus];
                if (netStatus ==NotReachable) {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
                    [alert show];
                }else{
                    wcfService *service=[wcfService service];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//                    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//                    [self.navigationController.view addSubview:HUD];
//                    HUD.labelText=@"Updating...";
//                    HUD.dimBackground = YES;
//                    HUD.delegate = self;
//                    [HUD show:YES];
                    
                    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                    HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
                    [self.navigationController.view addSubview:HUD];
                    HUD.labelText=@"Sending Email to Queue...";
                    
                    HUD.progress=0.3;
                    [HUD layoutSubviews];
                    HUD.dimBackground = YES;
                    HUD.delegate = self;
                    [HUD show:YES];
                    
//                    alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//
//                    [alertViewWithProgressbar show];
//                    alertViewWithProgressbar.progress=30;
                    
                    [service xUpdQANotReady:self action:@selector(donotReady1:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnumber xnotes:txtNote.text EquipmentType:@"3"];
                }

            }
                break;
		}
    }else if (alertView.tag == 2) {
        switch (buttonIndex) {
			case 0:
				break;
			default:
            {
                Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
                NetworkStatus netStatus = [curReach currentReachabilityStatus];
                if (netStatus ==NotReachable) {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
                    [alert show];
                }else{
                    wcfService *service=[wcfService service];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//                    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//                    [self.navigationController.view addSubview:HUD];
//                    HUD.labelText=@"Updating...";
//                    HUD.dimBackground = YES;
//                    HUD.delegate = self;
//                    [HUD show:YES];
                    
//                    alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//                    
//                    [alertViewWithProgressbar show];
//                    alertViewWithProgressbar.progress=30;
                    
                    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                    HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
                    [self.navigationController.view addSubview:HUD];
                    HUD.labelText=@"Sending Email to Queue...";
                    
                    HUD.progress=0.3;
                    [HUD layoutSubviews];
                    HUD.dimBackground = YES;
                    HUD.delegate = self;
                    [HUD show:YES];
                    
                    [service xUpdQAReady:self action:@selector(doReady1:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnumber xnotes:txtNote.text EquipmentType:@"3"];
                }
                
            }
                break;
		}
    }
}
-(void)doReady1:(id)value{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    [HUD hide:YES];
//    [HUD removeFromSuperview];
    self.view.userInteractionEnabled=YES;
    [HUD hide];
    
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
    
    NSString *rtn = (NSString *)value;
    if ([rtn isEqualToString:@"0"]) {
        UIAlertView *alert = [self getErrorAlert: @"Update fail. Please try again later."];
        [alert show];
    }else{
        qainspectionb *qt =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"qainspectionb"];
        qt.managedObjectContext=self.managedObjectContext;
        qt.idnumber=self.idnumber;
        qt.fromtype=fromtype;
        [self.navigationController pushViewController:qt animated:YES];
    }
}

-(void)donotReady1:(id)value{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.view.userInteractionEnabled=YES;
    [HUD hide];
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
    
    NSString *rtn = (NSString *)value;
    if ([rtn isEqualToString:@"0"]) {
        UIAlertView *alert = [self getErrorAlert: @"Update fail. Please try again later."];
        [alert show];
    }else{
        [self goBack1:nil];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
