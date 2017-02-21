//
//  disapprovesuggest.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-15.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "disapprovesuggest.h"
#import "Mysql.h"
#import "userInfo.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "forapprove.h"
#import "CustomKeyboard.h"
#import "MBProgressHUD.h"
#import "wcfSuggestedPriceItem.h"


@interface disapprovesuggest ()<UITextViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate, CustomKeyboardDelegate, MBProgressHUDDelegate, UITabBarDelegate>{
    
    CustomKeyboard *keyboard;
    NSMutableArray * pickerArray;
    UIButton *dd1;
    UITextView *txtNote;
    //    MBProgressHUD* HUD;
    UITextField *usernameField;
    wcfSuggestedPriceItem *rsp;
    MBProgressHUD *HUD;
    NSTimer *myTimer;
}
@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@end

@implementation disapprovesuggest
@synthesize xidcia, xidproject, idnumber, xemail, xsqft1, xsuggestprice1, ntabbar, uv;

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
        [self goback1:item];
    }
}


-(IBAction)goback1:(id)sender{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
        
    }

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
//                        HUD.labelText=@"Dispprove suggested price...";
//                        HUD.dimBackground = YES;
//                        HUD.delegate = self;
//                        [HUD show:YES];
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
//                        
//                        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//                        
//                        [alertViewWithProgressbar show];
//                        alertViewWithProgressbar.progress=1;
                        
                        NSString *a=usernameField.text;
                        if ([usernameField.text isEqualToString:@""]) {
                            a=@"0";
                        }
                        wcfService* service = [wcfService service];
                        [service xDisApproveSuggest:self action:@selector(xApproveSuggestHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:xidcia xidnumber:idnumber xidproject:xidproject xsqft:xsqft1 xsuggestprice:xsuggestprice1 xcounterprice:a xtext:txtNote.text EquipmentType:@"3"];
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
        [txtNote resignFirstResponder];
        wcfService *service=[wcfService service];
        HUD.progress=0.5;
        [service xCheckDisApproveSuggest:self action:@selector(xCheckApproveSuggestHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:xidcia xidproject:xidproject xsqft:xsqft1 xsuggestprice:xsuggestprice1];
        
    }
}

- (void) xCheckApproveSuggestHandler: (id) value {
    self.view.userInteractionEnabled=YES;
    [HUD hide];
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
    
    
    
	// Do something with the wcfKeyValueItem* result
    
    wcfKeyValueItem* result = (wcfKeyValueItem*)value;
    if ([result.Key isEqualToString:@"0"]) {
        UIAlertView *alert=[self getErrorAlert:result.Value];
        [alert show];
    }else{
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

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.view.frame.size.height>500) {
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-170) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-84) animated:YES];    }
	return YES;
}

- (void)nextClicked{
    [txtNote becomeFirstResponder];
    
}

- (void)previousClicked{
    [usernameField becomeFirstResponder];
}

- (void)doneClicked{
    [uv setContentOffset:CGPointMake(0,0) animated:YES];
    [txtNote resignFirstResponder];
    [usernameField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Disapprove Suggested Price";
    
    UITabBarItem *firstItem0 ;
    
    firstItem0 = [[UITabBarItem alloc]initWithTitle:@"For Approve" image:[UIImage imageNamed:@"home.png"] tag:1];
    
    
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
    
    int y=10;
    UILabel*  lbl;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Send To";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField * text1;
    text1=[[UITextField alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 30)];
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
    pickerArray = [[NSMutableArray alloc]init];
    [pickerArray addObject:xemail];
    [dd1 setTitle:xemail forState:UIControlStateNormal];
    [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
    y=y+30+10;
    [uv addSubview:dd1];
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Counter Price";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    usernameField=[[UITextField alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 30)];
    [usernameField setBorderStyle:UITextBorderStyleRoundedRect];
    [usernameField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [uv addSubview: usernameField];
    y=y+30+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Disapprove Reason";
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
    txtNote.delegate=self;
    [uv addSubview:txtNote];
    y=y+120;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn1 setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 36)];
    [btn1 setTitle:@"Disapprove" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(doApprove:) forControlEvents:UIControlEventTouchDown];
    [uv addSubview:btn1];
    
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    
    [usernameField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :TRUE]];
    [txtNote setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:TRUE :NO]];
    
    y = y>uv.frame.size.height+1? y:uv.frame.size.height+1;
    uv.contentSize=CGSizeMake(self.view.frame.size.width,y);
    
	// Do any additional setup after loading the view.
}



-(IBAction)doApprove:(id)sender{
    
 
    NSString *xs =[usernameField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    if ([xs isEqualToString:@""]) {
        xs=@"0";
    }
    if(![self isNumeric:xs]){
        UIAlertView *alert = [self getErrorAlert: @"Counter Price must be a Number."];
        [alert show];
        [usernameField becomeFirstResponder];
        return;
        
    }
    
    if ([txtNote.text isEqualToString:@""]) {
        UIAlertView *alert = [self getErrorAlert: @"Please Input Disapprove Reason."];
        [alert show];
        [txtNote becomeFirstResponder];
        return;
    }
//
//    if ([tsqft.text isEqualToString:@""]) {
//        UIAlertView *alert = [self getErrorAlert: @"Please Input SQ.FT."];
//        [alert show];
//        [tsqft becomeFirstResponder];
//        return;
//    }
//    NSString *xt =[tsqft.text stringByReplacingOccurrencesOfString:@"," withString:@""];
//    if(![self isNumeric:xt]){
//        UIAlertView *alert = [self getErrorAlert: @"SQ.FT. must be a Number."];
//        [alert show];
//        [tsqft becomeFirstResponder];
//        return;
//        
//    }
    
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        self.view.userInteractionEnabled=NO;
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Checking...";
        
        HUD.progress=0.01;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
//        
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Checking..." delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
//        alertViewWithProgressbar.progress=1;
        
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler:) version:version];
    }
    
    
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
