//
//  contractforapproveupd1.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-5.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "contractforapproveupd1.h"
#import "Mysql.h"
#import "userInfo.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "contractforapprove.h"
#import "MBProgressHUD.h"
#import "forapprove.h"
#import "project.h"

@interface contractforapproveupd1 ()<MBProgressHUDDelegate, UITabBarDelegate, UIActionSheetDelegate>{
MBProgressHUD *HUD;
    NSTimer *myTimer;
}

@end

@implementation contractforapproveupd1

@synthesize ntabbar, uv, xtype, idcia, idcontract1, projectname, idproject, xfromtype;

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
    
    uv.backgroundColor = [Mysql groupTableViewBackgroundColor];
    
    UILabel *lbl;
    
    lbl0 =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl0.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl0.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl0];
    y=y+21+x;
    
    lbl1 =[[UITableView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 28)];
    lbl1.layer.cornerRadius = 7;
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    lbl1.rowHeight=28*(font.pointSize/15.0);
    y=y+32+x;
    
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
    
    [uv addSubview:txtNote];
    y=y+110+x;
    
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 36)];
    if (xtype==1) {
        [loginButton setTitle:@"Submit Approve" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(doapprove:) forControlEvents:UIControlEventTouchUpInside];
        
    }else  if (xtype==2) {
        [loginButton setTitle:@"Submit Disapprove" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(dodisapprove:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [loginButton setTitle:@"Acknowledge" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(doAcknowledge:) forControlEvents:UIControlEventTouchUpInside];
    }
    [uv addSubview:loginButton];
    
    ntabbar.delegate = self;
    if (xfromtype==1) {
        
        UITabBarItem *firstItem0 ;
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"For Approve" image:[UIImage imageNamed:@"home.png"] tag:1];
        UITabBarItem *fi;
        fi =[[UITabBarItem alloc]init];
        UITabBarItem *f2 =[[UITabBarItem alloc]init];
        UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
        NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
        
        [ntabbar setItems:itemsArray animated:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1) ];
        [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
        [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
//        [[ntabbar.items objectAtIndex:3]setAction:@selector(dorefresh)];
        
    }else{
        UITabBarItem *firstItem0 ;
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
        UITabBarItem *fi;
        fi =[[UITabBarItem alloc]init];
        UITabBarItem *f2 =[[UITabBarItem alloc]init];
        UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
        NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
        
        [ntabbar setItems:itemsArray animated:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1) ];
        [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
        [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
//        [[ntabbar.items objectAtIndex:3]setAction:@selector(dorefresh)];
    }
    
    
    [self getemailInfo];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"Project"] || [item.title isEqualToString:@"For Approve"]) {
        [self goBack1];
    }else if ([item.title isEqualToString:@"Refresh"]) {
        [self dorefresh];
    }
}


-(void)dorefresh{
[self getemailInfo];
   
}
-(void)goBack1{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[forapprove class]] || [temp isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (BAUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    BAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.text=projectname;
        cell.textLabel.font=[UIFont systemFontOfSize:17.0f];
        cell.userInteractionEnabled = NO;
        
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell .imageView setImage:nil];
        
        
    }
    
    return cell;
}


-(IBAction)doapprove:(id)sender{
    
    [self autoUpd:1];
}



-(IBAction)dodisapprove:(id)sender{
    [self autoUpd:2];
    }

-(IBAction)doAcknowledge:(id)sender{
    [self autoUpd:3];
}


-(void)autoUpd:(int) xt{
    ctag=xt;
    
    if (ctag==2) {
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"BuildersAccess"
                 message:@"Are you sure you want to disapprove?"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 otherButtonTitles:@"Ok", nil];
        alert.tag = 2;
        [alert show];
    } else if (ctag==3) {
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"BuildersAccess"
                 message:@"Are you sure you want to acknowledge?"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 otherButtonTitles:@"Ok", nil];
        alert.tag = 3;
        [alert show];
        
    }else{
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"BuildersAccess"
                 message:@"Are you sure you want to approve?"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 otherButtonTitles:@"Ok", nil];
        alert.tag = 1;
        [alert show];
    }

    
    
    
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
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"1"]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        //        UIAlertView *alert = nil;
        //        alert = [[UIAlertView alloc]
        //                 initWithTitle:@"BuildersAccess"
        //                 message:@"There is a new version?"
        //                 delegate:self
        //                 cancelButtonTitle:@"Cancel"
        //                 otherButtonTitles:@"Ok", nil];
        //        alert.tag = 1;
        //        [alert show];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        if (ctag == 1){
            HUD.progress=0.5;
            Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
            NetworkStatus netStatus = [curReach currentReachabilityStatus];
            if (netStatus ==NotReachable) {
                self.view.userInteractionEnabled=YES;
                [HUD hide];
                UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
                [alert show];
            }else{
                wcfService *service = [wcfService service];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
                
                [service xUpdateContract:self action:@selector(doupdate:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:idcia contractid:idcontract1 xtype:@"5" toemail:dd1.titleLabel.text msg:txtNote.text EquipmentType:@"3"];
                
               
//                 [service xUpdateContract:self action:@selector(doupdate:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:idcia contractid:idcontract1 xtype:@"5" toemail:@"xiujun_85@163.com" msg:txtNote.text EquipmentType:@"3"];
                
//
                 
                
            }
            
            
        }else if (ctag == 2){
            HUD.progress=0.5;
            
            Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
            NetworkStatus netStatus = [curReach currentReachabilityStatus];
            if (netStatus ==NotReachable) {
                self.view.userInteractionEnabled=YES;
                [HUD hide];
                UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
                [alert show];
            }else{
                wcfService *service = [wcfService service];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
                [service xUpdateContract:self action:@selector(doupdate:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:idcia contractid:idcontract1 xtype:@"3" toemail:dd1.titleLabel.text msg:txtNote.text EquipmentType:@"3"];
                
                
            }
            
        }else if (ctag == 3){
            HUD.progress=0.5;
            
            Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
            NetworkStatus netStatus = [curReach currentReachabilityStatus];
            if (netStatus ==NotReachable) {
                self.view.userInteractionEnabled=YES;
                [HUD hide];
                UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
                [alert show];
            }else{
                wcfService *service = [wcfService service];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
                [service xUpdateContract:self action:@selector(doupdate:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:idcia contractid:idcontract1 xtype:@"4" toemail:dd1.titleLabel.text msg:txtNote.text EquipmentType:@"3"];
//                 [service xUpdateContract:self action:@selector(doupdate:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:idcia contractid:idcontract1 xtype:@"4" toemail:@"xiujun_85@163.com" msg:txtNote.text EquipmentType:@"3"];
                
            }
            
 
        }
    }
    
    
}


-(void)getemailInfo{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [service xGetContractApproveEmailTo:self action:@selector(xGetContractApproveEmailToHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia:idcia contractid: idcontract1];
        

    }
    
    
}
- (void) xGetContractApproveEmailToHandler: (id) value {
    
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
    
    
	// Do something with the wcfUserCOEmail* result
    result = (wcfKeyValueItem*)value;
	
    
    // [result.Email componentsSeparatedByString:@";"]
    pickerArray =[NSArray arrayWithObjects:result.Key, nil];
    lbl0.text=[NSString stringWithFormat:@"Project # %@", idproject];
    lbl1.delegate=self;
    lbl1.dataSource=self;
    [uv addSubview:lbl1];
    
    [dd1 setTitle:[pickerArray objectAtIndex:0] forState:UIControlStateNormal];
    if (xtype==1) {
         [txtNote setText:@"I approve the following Contract."];
    }else  if (xtype==2) {
    [txtNote setText:@"I disapprove the following Contract."];
    }else{
    [txtNote setText:@"I acknowledge the following Contract."];
    }
    [ntabbar setSelectedItem:nil];
}


- (void)doneClicked{
    [uv setContentOffset:CGPointMake(0,0) animated:YES];
    [txtNote resignFirstResponder];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        if (buttonIndex==1) {
            Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
            NetworkStatus netStatus = [curReach currentReachabilityStatus];
            if (netStatus ==NotReachable) {
                UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
                [alert show];
            }else{
                
//                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//                [self.navigationController.view addSubview:HUD];
//                HUD.labelText=@"   Updating...   ";
//                HUD.dimBackground = YES;
//                HUD.delegate = self;
//                [HUD show:YES];
                self.view.userInteractionEnabled=NO;
//                alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//                
//                [alertViewWithProgressbar show];
//                alertViewWithProgressbar.progress=1;
                
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
                NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler:) version:version];
            }
            
        }else{
            [ntabbar setSelectedItem:nil];
        }
    
    
    
	
}

- (void) doupdate: (int) value {
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    if(value==0){
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        
        UIAlertView *alert = nil;
        alert=[self getErrorAlert:@"Update fail."];
        [alert show];
    }else if(value==1){
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
        if ([temp isKindOfClass:[contractforapprove class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.view.frame.size.height>500) {
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-170) animated:YES];
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
    //    [dd1 setTitle:[pickerArray objectAtIndex: [ddpicker selectedRowInComponent:0]] forState:UIControlStateNormal];
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
