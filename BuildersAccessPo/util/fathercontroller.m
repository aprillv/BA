//
//  fathercontroller.m
//  BuildersAccess
//
//  Created by amy zhao on 12-12-12.
//  Copyright (c) 2012年 lovetthomes. All rights reserved.
//

#import "fathercontroller.h"
#import "userInfo.h"
#import "Reachability.h"
#import "wcfService.h"
#import "NSString+Color.h"
#import "mainmenu.h"

@interface fathercontroller ()

@end

@implementation fathercontroller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

-(IBAction)goBack:(id)sender
{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler11:) version:version];
    }
}
- (void) xisupdate_iphoneHandler11: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
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
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if ([self isKindOfClass:[mainmenu class]]) {
//        UIButton *lbla =[UIButton buttonWithType:UIButtonTypeCustom];
//        lbla .frame=CGRectMake(230, 5, 100, 30);
//        [lbla addTarget:self action:@selector(doLogout1:) forControlEvents:UIControlEventTouchUpInside];    [lbla setTitle:@"Logout" forState:UIControlStateNormal];
//        UIColor * cg1 = [@"#007aff" toColor];
//        [lbla setTitleColor:cg1 forState:UIControlStateNormal];
//        [self.navigationController.navigationBar addSubview:lbla];
//    }else{
//        for (UIView *tv in self.navigationController.navigationBar.subviews) {
//            if ([tv isKindOfClass:[UIButton class]]) {
//                [tv removeFromSuperview];
//            }
//        }
//        UIButton *lbla =[UIButton buttonWithType:UIButtonTypeCustom];
//        lbla.frame=CGRectMake(230, 5, 100, 30);
//        [lbla addTarget:self action:@selector(doLogout1:) forControlEvents:UIControlEventTouchUpInside];    [lbla setTitle:@"Logout" forState:UIControlStateNormal];
//        UIColor * cg1 = [@"#007aff" toColor];
//        [lbla setTitleColor:cg1 forState:UIControlStateNormal];
//        [self.navigationController.navigationBar addSubview:lbla];
    
    
    
	// Do any additional setup after loading the view.
}

-(IBAction)gohome:(id)sender{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler12:) version:version];
    }
}
- (void) xisupdate_iphoneHandler12: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess. Please try again later. Thanks for your patience."];
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
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    
    
}

//-(IBAction)logout:(id)sender{
//    [userInfo setUserName:Nil andPwd:Nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
-(UIBarButtonItem *)getbackButton{
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNext.frame = CGRectMake(0, 40, 40, 40);
    [btnNext addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btnNextImageNormal = [UIImage imageNamed:@"back.png"];
    [btnNext setImage:btnNextImageNormal forState:UIControlStateNormal];
    [btnNext setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    return  [[UIBarButtonItem alloc] initWithCustomView:btnNext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
