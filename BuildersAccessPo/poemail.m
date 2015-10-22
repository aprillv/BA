//
//  poemail.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-24.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "poemail.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "InsetsLabel.h"
#import "Reachability.h"
#import "po1.h"
#import "projectpols.h"
#import "project.h"
#import "development.h"
#import "forapprove.h"
@interface poemail ()<UITabBarDelegate>{
    BOOL addEmail;
    NSDateFormatter *formatter;
    UIAlertController *sheet;
}

@end

@implementation poemail

@synthesize uv, ntabbar,dd1, txtNote, pickerArray, ddpicker, xtype, idpo1,xmcode, isfromassign,fromforapprove, idvendor;

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
    addEmail=NO;
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    isreleased=YES;
    isDraftorForapprove=NO;
    oldemail=@"";
    
    //    [self getEmaills];
    
	// Do any additional setup after loading the view.
    [self getPoDetail];
	
    UITabBarItem *firstItem0;
    if (fromforapprove==1) {
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"For Approve" image:[UIImage imageNamed:@"home.png"] tag:1];
    }else if (fromforapprove==2){
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Development" image:[UIImage imageNamed:@"home.png"] tag:1];
    }else if (fromforapprove==4){
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
    }else{
     firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
    }
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:3];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    [ntabbar setItems:itemsArray animated:YES];
    ntabbar.delegate = self;
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goToMain) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
//    [[ntabbar.items objectAtIndex:3]setAction:@selector(getPoDetail) ];
    
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goToMain];
    }else if(item.tag == 3){
        [self getPoDetail];
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
            
            
        }
    }
   
    
}

-(void)getPoDetail{
    wcfService *service=[wcfService service];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (isfromassign) {
        [service xGetPODetailForSubmit:self action:@selector(xGetPODetailForSubmitHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid: idpo1 xvendorid: idvendor xcode: xmcode EquipmentType: @"3"];
    }else{
        [service xGetPODetailForSubmit:self action:@selector(xGetPODetailForSubmitHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid: idpo1 xvendorid: @"" xcode: xmcode EquipmentType: @"3"];
    }
    
}

- (void) xGetPODetailForSubmitHandler: (id) value {
    
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
    
	// Do something with the NSMutableArray* result
    pd = (wcfPODetail*)value;
    
    if([pd.Status isEqualToString:@"Draft"] ||[pd.Status isEqualToString:@"For Approve"]){
        isDraftorForapprove=YES;
    }
    
    if ([pd.Oldvendoremail isEqualToString:@"0"]) {
        oldemail=@"";
    }else{
        oldemail=[pd.Oldvendoremail copy];
    }
    
    if(!isfromassign){
        oldemail=@"";
    }
    
    NSString * btntitle ;
    NSString *btnimg;
    if (xtype==0) {
        addEmail=YES;
    }
    switch (xtype) {
        case 6:
            addEmail=YES;
            self.title=@"Re-Open PO";
            btntitle=@"Submit Re-Open";
            btnimg=@"greenButton.png";
            break;
            
        case 0:
        case 4:
            if(![pd.Release isEqualToString:@"1"]){
                addEmail=YES;
                self.title=@"Submit For Approve PO";
                btntitle=@"Submit";
                btnimg=@"greenButton.png";
            }else{
                self.title=@"Release PO";
                btntitle=@"Submit Release";
                btnimg=@"greenButton.png";
            }
            break;
        case 3:
            self.title=@"Disapprove PO";
            btntitle=@"Submit Disapprove";
            btnimg=@"redButton.png";
            break;
        case 10:
            self.title=@"Hold PO";
            btntitle=@"Submit Hold";
            btnimg=@"redButton.png";
            break;
        case 7:
            self.title=@"Void PO";
            btntitle=@"Submit Void";
            btnimg=@"redButton.png";
            
            break;
            
    }
    [self drawpage:btntitle andImg:btnimg];
    [ntabbar setSelectedItem:nil];
}

-(void)drawpage: (NSString *)btntitle andImg:(NSString *)btnimg{
    UILabel *lbl;
    int y=10;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=[NSString stringWithFormat:@"%@", pd.Doc];
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
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
    
    y=y+25+10;
    [uv addSubview:dd1];
    
    if (xtype!=7) {
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
        lbl.text=@"Delivery Date";
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [uv addSubview:lbl];
        y=y+30;
        
        text1 =[[UITextField alloc]initWithFrame:CGRectMake(10, y, 300, 30)];
        [text1 setBorderStyle:UITextBorderStyleRoundedRect];
        text1.enabled=NO;
        text1.text=@"";
        [uv addSubview: text1];
        
        txtDate=[UIButton buttonWithType: UIButtonTypeCustom];
        [txtDate setFrame:CGRectMake(15, y+4, 270, 21)];
        [txtDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [txtDate addTarget:self action:@selector(popupscreen:) forControlEvents:UIControlEventTouchDown];
        [txtDate setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [txtDate setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
        [txtDate.titleLabel setFont:[UIFont systemFontOfSize:17]];
        if ([pd.Delivery isEqualToString:@"01/01/1980"]) {
            [txtDate setTitle:@"" forState:UIControlStateNormal];
        }else{
            [txtDate setTitle:pd.Delivery forState:UIControlStateNormal];
        }
        
        [uv addSubview: txtDate];
        y=y+30+10;
        
    }
    
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
    if (xtype==7) {
        txtNote.text=[NSString stringWithFormat:@"Please disregard %@. It's no longer effective.", pd.Doc];
    }else if (xtype==10) {
        txtNote.text=[NSString stringWithFormat:@"%@. It's on hold.", pd.Doc];
    }else{
        txtNote.text=[pd.Shipto stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
    }
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    [uv addSubview:txtNote];
    
    y=y+120;
    
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, y, 300, 44)];
    [loginButton setTitle:btntitle forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [loginButton setBackgroundImage:[[UIImage imageNamed:btnimg] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(doapprove:) forControlEvents:UIControlEventTouchUpInside];
    [uv addSubview:loginButton];
    
    if (self.view.frame.size.height>480) {
        uv.contentSize=CGSizeMake(320.0,460.0);
    }else{
        uv.contentSize=CGSizeMake(320.0,y+50);
    }
    
    [self getEmaills];
}

-(void)getEmaills{
    if ((xtype==4 || xtype==0)&& ![pd.Release isEqualToString:@"1"]) {
//        pickerArray =[[NSMutableArray alloc]init];
//        isreleased=NO;
//        [pickerArray addObject:@"Submit For Approve"];
//        [dd1 setTitle:@"Submit For Approve" forState:UIControlStateNormal];
        wcfService *service =[wcfService service];
    
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        if (xtype==0) {
            [service xGetEmailList2:self action:@selector(xGetEmailListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpo1:idpo1 idvendor:idvendor xtype:@"1"];
        }else{
        [service xGetEmailList2:self action:@selector(xGetEmailListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpo1:idpo1 idvendor:idvendor xtype:@"3"];
        }
    
        
    }else{
        
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        
        if (xtype==3) {
            [service xGetEmailListDisapprove:self action:@selector(xGetEmailListDisapproveHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] poid: idpo1];
            
        }else{
            if (xtype==6 || xtype==4 || xtype==0) {
                if (xtype==0) {
                    [service xGetEmailList2:self action:@selector(xGetEmailListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpo1:idpo1 idvendor:idvendor xtype:@"1"];
                }else  if (xtype==4) {
                   
                    [service xGetEmailList2:self action:@selector(xGetEmailListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpo1:idpo1 idvendor:idvendor xtype:@"3"];
                }else{
                    [service xGetEmailList2:self action:@selector(xGetEmailListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpo1:idpo1 idvendor:idvendor xtype:@"2"];}
            }else {
            [service xGetEmailList:self action:@selector(xGetEmailListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] idvendor:[[NSNumber numberWithLong:pd.Idvendor] stringValue]];
            }
        
        }
    }
}


- (void) xGetEmailListDisapproveHandler: (id) value {
    
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
    
    
    pickerArray =[[NSMutableArray alloc]init];
    if (value) {
        [pickerArray addObject:value];
    }
    
    if ([pickerArray count]==0) {
        [dd1 setTitle:@"Email not found" forState:UIControlStateNormal];
    }else{
        [dd1 setTitle:[pickerArray objectAtIndex:0] forState:UIControlStateNormal];
        [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
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
    
//    NSLog(@"%@", pickerArray);
    pickerArray =(NSMutableArray*)value;
    if ([pickerArray count]==0) {
        [dd1 setTitle:@"Email not found" forState:UIControlStateNormal];
    }else{
        [dd1 setTitle:[pickerArray objectAtIndex:0] forState:UIControlStateNormal];
        [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
    }
    
}



-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.view.frame.size.height>500) {
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-170) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-84) animated:YES];    }
	return YES;
    
}

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
            case 7:
                nstatus=@"Void";
                break;
            case 6:
                nstatus=@"Re-Open";
                break;
            case 3:
                nstatus=@"Disapprove";
                break;
            case 10:
                nstatus=@"Hold";
                break;
            default:
                if(!isreleased){
                    nstatus=@"Submit For Approve";
                    xtype=5;
                }else{
                    nstatus=@"Release";
                    xtype=4;
                }
        }
         UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:@"BuildersAccess"
                              message:[NSString stringWithFormat:@"Are you sure you want to %@ this po?", nstatus]
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
                if (xtype==7) {
                    UIAlertView *alert = nil;
					alert = [[UIAlertView alloc]
							 initWithTitle:@"BuildersAccess"
							 message:@"If record is voided you will not be able to recover it.\nAre you sure you want to void?"
							 delegate:self
							 cancelButtonTitle:@"Cancel"
							 otherButtonTitles:@"OK", nil];
					alert.tag = 1;
					[alert show];
                }else{
                    [self updatepo];
                }
				
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

- (void) createPickerView {
    if (!sheet) {
        sheet = [UIAlertController alertControllerWithTitle:@"Delivery Date" message:@"\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        
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
            if ([pd.Delivery rangeOfString:@"1980"].location == NSNotFound) {
                [pdate setDate:[msql dateFromString:pd.Delivery]];
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
    //    if (buttonIndex == 0) {
    if (!formatter) {
        formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM/dd/YYYY"];
    }
    [txtDate setTitle:[formatter stringFromDate:[pdate date]] forState:UIControlStateNormal];
    //    }
//    [uv setContentOffset:CGPointMake(0,0) animated:YES];
    
}

-(IBAction)popupscreen:(id)sender{
    
    [txtNote resignFirstResponder];
    [self createPickerView];
    
}



-(IBAction)popupscreen2:(id)sender{
    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle: nil
                                                       delegate: self
                                              cancelButtonTitle: nil
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    
    alert.tag = 1;
    [alert addButtonWithTitle:@"Cancel"];
    for( NSString *title in pickerArray)  {
        [alert addButtonWithTitle:title];
    }
    
    [alert showInView:self.view];
    
}


-(void)updatepo{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText=@"Updating...";
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    
	NSString *dl = txtDate.titleLabel.text;
	if ([dl isEqualToString:@""]|| dl ==nil) {
		dl = @"01/01/1980";
//        NSLog(@"%@", dl);
	}
    
    wcfService *service=[wcfService service];
        if(isfromassign){
            [service xUpdateUserPurchaseOrder:self action:@selector(xUpdateUserPurchaseOrderHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid: idpo1 xtype: [[NSNumber numberWithInt:xtype]stringValue] update: @"1" vendorid: idvendor delivery: dl xlgsel:@"" xcode: xmcode EquipmentType: @"3"];
        }else{
    
    [service xUpdateUserPurchaseOrder:self action:@selector(xUpdateUserPurchaseOrderHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid:idpo1 xtype: [[NSNumber numberWithInt:xtype]stringValue] update: @"" vendorid: [[NSNumber numberWithInt:pd.Idvendor] stringValue] delivery: dl xlgsel:@"" xcode: xmcode EquipmentType: @"3"];
    
       }
}


- (void) xUpdateUserPurchaseOrderHandler: (id) value {
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
    
    
    if(!value){
         [HUD hide:YES];
        UIAlertView *alert =[self getErrorAlert:@"Update failed, please try it again later"];
        alert.tag=2;
        [alert show];
    }else{

        
        NSString *nmsg=[txtNote.text stringByReplacingOccurrencesOfString:@"\n" withString:@";"];
        wcfService *service=[wcfService service];
        if([dd1.titleLabel.text isEqualToString:@"Email not found"] ||[dd1.titleLabel.text isEqualToString:@"Submit For Approve"]){
            [service xSendMessage:self action:@selector(xSendMessageHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid: idpo1 oldvendoremail: @"" xmsg: nmsg EquipmentType: @"3" xtype: [[NSNumber numberWithInt:xtype] stringValue]];
        }else{
            
                    [HUD hide:YES];
            //        UIAlertView *alert =[self getErrorAlert:@"Updateok"];
            //        alert.tag=2;
            //        [alert show];sdfa
            
            self.view.userInteractionEnabled=NO;
//            alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//            
//            [alertViewWithProgressbar show];
            
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
            [self.navigationController.view addSubview:HUD];
            HUD.labelText=@"Sending Email to Queue...";
            
            HUD.progress=0;
            [HUD layoutSubviews];
            HUD.dimBackground = YES;
            HUD.delegate = self;
            [HUD show:YES];

            
            HUD.progress=0.01;
            [service xSendEmail:self action:@selector(xSendEmailHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid: idpo1 xto: dd1.titleLabel.text oldvendoremail: @"" xmsg: nmsg EquipmentType: @"3" xtype: [[NSNumber numberWithInt:xtype] stringValue]];

//             [service xSendEmail:self action:@selector(xSendEmailHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid: idpo1 xto: @"xiujun_85@163.com" oldvendoremail: @"" xmsg: nmsg EquipmentType: @"3" xtype: [[NSNumber numberWithInt:xtype] stringValue]];
        
        }
    }
}

- (void) xSendMessageHandler: (BOOL) value {
     [HUD hide:YES];
	if (!value) {
        UIAlertView *alert=[self getErrorAlert:@"Send email unsuccessfully, please try it again later."];
        [alert show];
    }else{
        bool isgo =NO;
        
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[projectpols class]]) {
                isgo=YES;
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
        
        if (!isgo) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
        }
        
    }
    
}

- (void) xSendEmailHandler: (BOOL) value {
    
	if (!value) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        
        UIAlertView *alert=[self getErrorAlert:@"Send email unsuccessfully, please try it again later."];
        [alert show];
    }else{
        HUD.progress=1;
        
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        
        bool isgo =NO;
        
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[projectpols class]]) {
                isgo=YES;
                [self.navigationController popToViewController:temp animated:YES];
            }

        }
        
        if (!isgo) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
        }

    }
}



- (void)doneClicked{
    [uv setContentOffset:CGPointMake(0,0) animated:YES];
    [txtNote resignFirstResponder];
}




-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet1.tag==2) {
        if (buttonIndex == 0) {
            if (!formatter) {
                formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"MM/dd/YYYY"];
            }
            [txtDate setTitle:[formatter stringFromDate:[pdate date]] forState:UIControlStateNormal];
        }
        [uv setContentOffset:CGPointMake(0,0) animated:YES];
        
    }else{
        NSString *str = [actionSheet1 buttonTitleAtIndex:buttonIndex];
        if (![str isEqualToString:@"Cancel"]) {
            [dd1 setTitle:str forState:UIControlStateNormal];
        }
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
