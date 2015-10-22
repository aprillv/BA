//
//  Login.m
//  BuildersAccessPo
//
//  Created by amy zhao on 13-3-1.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//
#import "Mysql.h"
#import "Login.h"
#import "wcfService.h"
#import "forgetPs.h"
#import "SignUp.h"
#import "cl_cia.h"
#import "cl_project.h"
#import "cl_pin.h"
#import "mainmenu.h"
#import "Reachability.h"
#import "cl_sync.h"
#import "cl_favorite.h"
#import "cl_phone.h"
#import "cl_vendor.h"
#import "cl_reason.h"
#import "mainmenu.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "baControl.h"

#define NAVBAR_HEIGHT   44
#define PROMPT_HEIGHT   70
#define DIGIT_SPACING   10
#define DIGIT_WIDTH     61
#define DIGIT_HEIGHT    40
#define MARKER_WIDTH    16
#define MARKER_HEIGHT   16
#define MARKER_X        22
#define MARKER_Y        18
#define MESSAGE_HEIGHT  74
#define FAILED_LCAP     19
#define FAILED_RCAP     19
#define FAILED_HEIGHT   26
#define FAILED_MARGIN   10
#define TEXTFIELD_MARGIN 8
#define SLIDE_DURATION  0.3

@interface Login (){
    
}
@end

NSString     *name;
BOOL transiting;
BOOL isenter;

NSString* xget;

@implementation Login{
    UISwitch *switchView;
}
@synthesize usernameField;
@synthesize passwordField;
//@synthesize checkButton;
@synthesize ischecked;
@synthesize pwd, pickerArray;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.title=@"BuildersAccess";
    
    [self doInitPage];
	self.ischecked = NO;
    
	NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        //NSData *reader = [NSData dataWithContentsOfFile:filePath];
		NSArray *arr = [[NSArray alloc] initWithContentsOfFile:filePath];
		self.usernameField.text = [arr objectAtIndex:0];
		self.pwd=[arr objectAtIndex:1];
        name=self.usernameField.text;
        
		self.passwordField.text = @"******";
		self.ischecked=YES;
		switchView.on=YES;
    }
    
    
  
  
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, NAVBAR_HEIGHT)];
//    navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    navigationBar.items = @[self.navigationItem];
//    [self.navigationController.navigationBar addSubview:navigationBar];
//     UIColor * cg1 =[UIColor whiteColor] ;
//
//    UIImage *tabBackground = [[UIImage imageNamed:@"grayButton.jpg"]
//                              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    // Set background for all UITabBars
//    [[UITabBar appearance] setBackgroundImage:tabBackground];
    // Set background for only this UITabBar
   
    
    UIColor * cg = [UIColor lightGrayColor];
    [[UITabBar appearance] setTintColor:cg];
//
//    [[UITabBarItem appearance] setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:
//      cg1, UITextAttributeTextColor,
//      [UIFont boldSystemFontOfSize:9.0], UITextAttributeFont,
//      [UIColor darkGrayColor], UITextAttributeTextShadowColor,
//      nil] forState:UIControlStateNormal];
    
  
    [[UIToolbar appearance] setTintColor:cg];
//    [[UIBarItem appearance] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    [[UITabBarItem appearance]setTitleShadowColor:<#(UIColor *)#> forState:<#(UIControlState)#>: [UIColor whiteColor] forState:UIControlStateNormal];
    
    
    self.navigationController.navigationBar.tintColor = cg;
//      [[UISearchBar appearance] setTintColor:[UIColor redColor]];
    
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleBlackTranslucent;
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [usernameField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :TRUE]];
    [passwordField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:TRUE :NO]];
    
    isenter=YES;
}

-(void)viewDidAppear:(BOOL)animated{
    if (![[self unlockPasscode] isEqualToString:@"0"] && isenter) {
        [self enterPasscode:nil];
        
    }
    isenter=NO;
}

-(void)viewWillAppear:(BOOL)animated{
    if (!switchView.on) {
        passwordField.text=@"";
    }
    transiting=NO;
}


// custom keyboard
- (void)nextClicked{
    [passwordField becomeFirstResponder];
}

- (void)previousClicked{
    [usernameField becomeFirstResponder];
}

- (void)doneClicked{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

-(void)doInitPage{
    
    UIScrollView *sv = (UIScrollView *)[self.view viewWithTag:1];
    int x=0;
    int y=10;
    if (self.view.frame.size.height>480) {
        sv.contentSize=CGSizeMake(320.0,425.0+80);
        y=y+20;
        x=10;
    }else{
        sv.contentSize=CGSizeMake(320.0,425.0);
        x=5;
    }
    
    UILabel *lbl;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Email";
    [sv addSubview:lbl];
    y=y+21+x;
    
    usernameField=[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 30)];
    [usernameField setBorderStyle:UITextBorderStyleRoundedRect];
    [usernameField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    usernameField.returnKeyType=UIReturnKeyDone;
    [sv addSubview: usernameField];
    y=y+30+x+5;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Password";
    [sv addSubview:lbl];
    y=y+21+x;
    
    passwordField=[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 30)];
    [passwordField setBorderStyle:UITextBorderStyleRoundedRect];
    [passwordField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [passwordField setSecureTextEntry:YES];
    [sv addSubview: passwordField];
    y=y+30+x+15;
    
//    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
//    lbl.text=@"Access";
//    [sv addSubview:lbl];
//    y=y+21+x+11;
//    
//    UITextField * text1=[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 30)];
//    
//    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
//    text1.enabled=NO;
//    text1.text=@"";
//    [sv addSubview: text1];
//    
//    
//    dd1=[UIButton buttonWithType: UIButtonTypeCustom];
//    [dd1 setFrame:CGRectMake(25, y+4, 270, 21)];
//    [dd1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
//    [dd1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [dd1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
//    [dd1.titleLabel setFont:[UIFont systemFontOfSize:17]];
//    [dd1 setTitle:@"Builder" forState:UIControlStateNormal];
//    y=y+41+x+11;
//    [sv addSubview:dd1];
    
    
    
    UIView *lbl1 =[[UIView alloc]initWithFrame:CGRectMake(20, y, self.view.frame.size.width - 40, 36)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.layer.borderWidth=1.0f;
    lbl1.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [sv addSubview:lbl1];
    
   
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(35, y+8, 120, 21)];
    lbl.text=@"Remember Me";
    [sv addSubview:lbl];
    
    switchView= [[UISwitch alloc] initWithFrame:CGRectMake(235.0f, y+4, 100.0f, 28.0f)];
    switchView.on = NO;
    switchView.transform=CGAffineTransformMakeScale(0.85, 0.85);
//    switchView.onTintColor=[UIColor blueColor];
//    switchView.tintColor = [UIColor blueColor];
    [sv addSubview:switchView];
    [switchView addTarget:self action:@selector(CheckboxClicked:) forControlEvents:UIControlEventValueChanged];
     y=y+70+x;
    
    UIButton *btn1 = [baControl getGrayButton];
    [btn1 setFrame:CGRectMake(20, y, 280, 44)];
    [btn1 setTitle:@"Login" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchDown];
    [sv addSubview:btn1];
    
//    NSLog(@"%@", btn1.titleLabel.textColor);
    
    //    btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [btn1 setFrame:CGRectMake(200, y, 100, 36)];
    //    [btn1 setTitle:@"Sign Up" forState:UIControlStateNormal];
    //    [btn1 addTarget:self action:@selector(SingUpOnclick:) forControlEvents:UIControlEventTouchDown];
    //    [sv addSubview:btn1];
    
    y=y+50+x;
    
//    checkButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    [checkButton setFrame:CGRectMake(20, y, 280, 44)];
//    [checkButton addTarget:self action:@selector(CheckboxClicked:) forControlEvents:UIControlEventTouchDown];
//    [checkButton setImageEdgeInsets:UIEdgeInsetsMake(2.0, -150.0, 5.0, 5.0)];
//    [checkButton setImage: [UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
//    [checkButton setTitleEdgeInsets:UIEdgeInsetsMake(2.0, -140.0, 5.0, 5.0)];
//    [checkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////     [checkButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
//    [checkButton setTitle:@"Remember Me" forState:UIControlStateNormal];
//    [sv addSubview:checkButton];
    
    y=y+30+x;
    
    btn1 =[baControl getGrayButton];
    [btn1 setFrame:CGRectMake(20, y, 280, 44)];
    [btn1 setTitle:@"Forgot Your Password" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(ForgotPasOnclick:) forControlEvents:UIControlEventTouchDown];
    [sv addSubview:btn1];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}




-(IBAction)popupscreen2:(id)sender{
    
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    pickerArray = [NSArray arrayWithObjects:@"Builder", nil];
    
    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle: nil
                                                       delegate: self
                                              cancelButtonTitle: nil
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    
   [alert addButtonWithTitle:@"Builder"];
    
    [alert addButtonWithTitle:@"Cancel"];
    [alert showInView:self.view];
    
}

//-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
//     NSString *str = [actionSheet1 buttonTitleAtIndex:buttonIndex];
//    if (![str isEqualToString:@"Cancel"]) {
//        [dd1 setTitle:str forState:UIControlStateNormal];
//    }
//    
//    
//}

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"save"];
}

- (void)creatFiles: (NSString *)pwd1 {
    
    NSString *user_name = [Mysql TrimText:self.usernameField.text];
    NSString *filePath = [self dataFilePath];
	//NSFileManager *fileManager =[NSFileManager defaultManager];
	if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
		NSError* error;
		[[NSFileManager defaultManager]removeItemAtPath:filePath error:&error];
	}
	//NSData *data = (NSData *)[self TrimText:self.usernameField.text];
	//[fileManager createFileAtPath:filePath contents:data attributes:nil];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:user_name];
	[array addObject:pwd1];
    [array writeToFile:filePath atomically:YES];
    
}

- (IBAction) ForgotPasOnclick: (id) sender{
    if (transiting) {
        return;
    }else{
        transiting=YES;
        forgetPs *fp = [forgetPs alloc];
        fp.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:fp animated:YES];
    }
}

- (IBAction) SingUpOnclick: (id) sender{
    if (transiting) {
        return;
    }else{
        transiting=YES;
        SignUp *mysignup = [SignUp alloc];
        mysignup.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:mysignup animated:YES];
    }
}

- (IBAction) CheckboxClicked : (id) sender{
    if (ischecked == NO) {
		self.ischecked=YES;
//		[self.checkButton setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
	}else {
		self.ischecked=NO;
//		[self.checkButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        
        NSString *filePath = [self dataFilePath];
        if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
            NSError* error;
            [[NSFileManager defaultManager]removeItemAtPath:filePath error:&error];
        }
        
        passwordField.text=@"";
        
        [self deletealldata];
	}
}

-(void)deletealldata{
    cl_pin *mf =[[cl_pin alloc]init];
    mf.managedObjectContext=self.managedObjectContext;
    [mf deletePin];
    
    cl_project *mp =[[cl_project alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    [mp deletaAllCias];
    
    cl_cia *mcia =[[cl_cia alloc]init];
    mcia.managedObjectContext=self.managedObjectContext;
    [mcia deletaAll];
    
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    [ms deleteall];
    
    cl_favorite *mt =[[cl_favorite alloc]init];
    mt.managedObjectContext=self.managedObjectContext;
    [mt deletaAllCias];
    
    cl_phone *mpt =[[cl_phone alloc]init];
    mpt.managedObjectContext=self.managedObjectContext;
    [mpt deletaAllCias];
    
    cl_vendor *mpv =[[cl_vendor alloc]init];
    mpv.managedObjectContext=self.managedObjectContext;
    [mpv deletaAllCias];
    
    cl_reason *mpr =[[cl_reason alloc]init];
    mpr.managedObjectContext=self.managedObjectContext;
    [mpr deletaAllCias];
    
}
- (IBAction) login: (UIButton *) sender{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText=@"   Login...   ";
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    
    [self autoUpd];
}

-(void)autoUpd{

    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
       [HUD hide:YES];
        for (UIWindow* window in [UIApplication sharedApplication].windows) {
            NSArray* subviews = window.subviews;
            if ([subviews count] > 0){
                for (UIAlertView* cc in subviews) {
                    if ([cc isKindOfClass:[UIAlertView class]]) {
                        [cc dismissWithClickedButtonIndex:0 animated:YES];
                        
                    }
                }
            }
            
        }

        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        
        transiting=NO;
    }else{
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
           [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler:) version:version];
            
    }
}
- (void) xisupdate_iphoneHandler: (id) value {
   
        
    
    
// Handle errors
if([value isKindOfClass:[NSError class]]) {
    NSError *error = value;
    NSLog(@"%@", [error localizedDescription]);
    [HUD hide:YES];
    
    
    UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
    [alert show];
    
    transiting=NO;
    return;
}

// Handle faults
if([value isKindOfClass:[SoapFault class]]) {
    SoapFault *sf =value;
    NSLog(@"%@", [sf description]);
    [HUD hide:YES];
    UIAlertView *alert = [self getErrorAlert: value];
    [alert show];
    transiting=NO;
    return;
}

    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {
        [HUD hide:YES];
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
    }else{
        [self doLogin];
    }


}
- (void) doLogin{
    if (transiting) {
        return;
    }else{
        transiting=YES;
    }
    
	NSString *user_name = [Mysql TrimText:self.usernameField.text];
    NSString *pass_word = [Mysql TrimText:self.passwordField.text];
	if (user_name.length==0){
        [HUD hide:YES];
		UIAlertView *alert = [self getErrorAlert: @"Please Input All Fields"];
        [alert show];
        [usernameField becomeFirstResponder];
        transiting=NO;
	}else if(pass_word.length==0){
        [HUD hide:YES];
        UIAlertView *alert = [self getErrorAlert: @"Please Input All Fields"];
        [alert show];
		
        [passwordField becomeFirstResponder];
        transiting=NO;
    }else if ([Mysql IsEmail:user_name]==NO) {
        [HUD hide:YES];
        UIAlertView *alert = [self getErrorAlert: @"Please Input invalid email"];
        [alert show];
        [usernameField becomeFirstResponder];
        transiting=NO;
	} else{
        
        NSString *myMD5Pas;
		if (self.pwd != nil && [pass_word isEqualToString:@"******"]==YES) {
			myMD5Pas = pwd;
		} else {
			myMD5Pas = [Mysql md5:pass_word];
		}
//        NSLog(@"%@", myMD5Pas);
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            [HUD hide:YES];
            UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
            [alert show];
            transiting=NO;
        }else{
            wcfService* service = [wcfService service];
            
//            if([self.dd1.titleLabel.text isEqualToString:@"Builder"]){
//                
//              
//                
//            }
//            NSLog(@"%@", myMD5Pas);
            [service xCheckLogin:self action:@selector(xCheckLoginHandler:) xemail: user_name xpassword: myMD5Pas EquipmentType:@"3"];
        }
	}
}

- (void) xCheckLoginHandler: (id) value {
    [HUD hide:YES];
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        
        
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        transiting=NO;
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        transiting=NO;
        return;
    }
    
    wcfKeyValueItem* result = (wcfKeyValueItem*)value;
    
    if (![result.Key isEqualToString:@"0"] ){
        xget=result.Key;
        NSString *user_name = [Mysql TrimText:self.usernameField.text];
        cl_pin *mp =[[cl_pin alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        int rtn =[mp IsUser:user_name];
        if (rtn==-1){
            [self deletealldata];
            [mp addToXpin:user_name andpincode:@"0"];
        }else if(rtn==0){
            [self deletealldata];
            [mp addToXpin:user_name andpincode:@"0"];
        }
        
        
        NSString *pass_word = [Mysql TrimText:self.passwordField.text];
        NSString *myMD5Pas;
        if (self.pwd != nil && [pass_word isEqualToString:@"******"]==YES) {
            myMD5Pas = pwd;
        } else {
            myMD5Pas = [Mysql md5:pass_word];
        }
        
        if (self.ischecked == YES) {
            
            if (self.pwd == nil) {
                [self creatFiles:myMD5Pas];
            } else if ([pass_word isEqualToString:@"******"]==NO || ![name isEqualToString:user_name]) {
                [self creatFiles:myMD5Pas];
            }
            
            [userInfo setUserName:user_name andPwd:myMD5Pas];
            [userInfo inituserNameServer:result.Value];
            
            [self CancletPin];
            
            
        }else {
            [userInfo setUserName:user_name andPwd:myMD5Pas];
            
            NSString *filePath = [self dataFilePath];
            if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
                NSError* error;
                [[NSFileManager defaultManager]removeItemAtPath:filePath error:&error];
            }
            
            [self CancletPin];
        }
        
    }else{
        UIAlertView *alert = [self getErrorAlert: @"Email and Password not found"];
        [alert show];
        [usernameField becomeFirstResponder];
        transiting=NO;
        return;
    }
    
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    
//    UIAlertView *alert = [self getErrorAlert: event];
//    [alert show];
//}
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"%@", event);
//}
-(void)CancletPin{
    cl_sync *ms = [[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    if ([ms isFirttimeToSync:@"0" :@"0"]) {
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]initWithTitle:@"BuildersAccess"
                                          message:@"This is the first time, we will sync all companies with your device, this will take some time, Are you sure you want to continue?"
                                         delegate:self
                                cancelButtonTitle:@"Cancel"
                                otherButtonTitles:@"Continue", nil];
        alert.tag = 0;
        [alert show];
        
    }else{
        [self gotomainmenu];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 0) {
        switch (buttonIndex) {
			case 0:
                transiting=NO;
				break;
			default:
                [self getciaList];
                break;
		}
		return;
	}
}

-(void)getciaList {
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"internet"];
        [alert show];
    }else{
        
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Company..." delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Synchronizing Company...";
        
        HUD.progress=0;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [service xGetCiaList:self action:@selector(vGetCiaListHandler:) xemail: [userInfo getUserName] xpassword: [[userInfo getUserPwd] copy] EquipmentType:@"3"];
    }
}


- (void) vGetCiaListHandler: (id) value {
    // Handle errors
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
    
	// Do something with the NSMutableArray* result
    NSMutableArray *result1 = (NSMutableArray*)value;
    
    if([result1 isKindOfClass:[wcfArrayOfKeyValueItem class]]){
        
        cl_cia *mcia = [[cl_cia alloc]init];
        mcia.managedObjectContext=self.managedObjectContext;
        [mcia addToCia:result1];
        
        cl_sync *ms =[[cl_sync alloc]init];
        ms.managedObjectContext=self.managedObjectContext;
        [ms addToSync:@"0" :@"0" :[[NSDate alloc] init]];
    }
    
    HUD.progress= 1;
    [HUD hide];
    
    [self gotomainmenu];
    
}
-(void)gotomainmenu{
    mainmenu *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"mainmenu"];
    LoginS.managedObjectContext=self.managedObjectContext;
    LoginS.xget=xget;
    [self.navigationController pushViewController:LoginS animated:YES];
    
//    ViewController *vc =[[ViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

@end
