//
//  forgetPs.m
//  BuildersAccess
//
//  Created by Bin Bob on 7/18/11.
//  Copyright 2011 lovetthomes. All rights reserved.
//

#import "forgetPs.h"
#import "Mysql.h"
#import "wcfService.h"
#import "Reachability.h"

@implementation forgetPs
@synthesize txtEmail;

- (IBAction)doCancel:(id)sender {
	#pragma unused(sender)
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doSend:(id)sender {
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self doSend:nil];
    return YES;
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
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [self sendeamil];
    }
    
    
}


- (void)sendeamil {
    NSString *stremail = [Mysql TrimText: self.txtEmail.text];
	
	if (stremail.length == 0){
		UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Please Input Email Address."
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
		[alert show];
        [txtEmail becomeFirstResponder];
	} else if ([Mysql IsEmail:stremail]==NO) {
		UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Please Input invalid email"
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
		[alert show];
        [txtEmail becomeFirstResponder];
	}else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        wcfService* service = [wcfService service];
        
        [service xSendGetPasswordMail:self action:@selector(xSendGetPasswordMailHandler:) xemail: stremail EquipmentType:@"3"];
        
	}
    
}

- (void) xSendGetPasswordMailHandler: (id) value {
    
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

    
    
	// Do something with the NSString* result
    NSString* categoryid = (NSString*)value;
	
    if ([categoryid isEqualToString:@"-1"]) {
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Email not found."
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
        [alert show];
    }else if ([categoryid isEqualToString:@"1"]) {
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Email can not be send. Please try again."
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
        [alert show];
    }else if ([categoryid isEqualToString:@"0"]) {
        
        UIAlertView *alert = [self getSuccessAlert:@"We have send a link to reset your password to your email address.\nIf you are having problems receiving this link, please contact Customer Service."];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }else{
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Error happened. Please exit and open again."
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    
}

-(UIAlertView *)getErrorAlert:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error"
                          message:str
                          delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil];
    return alert;
}

-(UIAlertView *)getSuccessAlert:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Success"
                          message:str
                          delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil];
    return alert;
}


-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    
    [self.navigationItem setHidesBackButton:YES];
    self.sendBtn.layer.cornerRadius = 5.0;
//    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnNext.frame = CGRectMake(0, 40, 40, 40);
//    [btnNext addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
//    UIImage *btnNextImageNormal = [UIImage imageNamed:@"back.png"];
//    [btnNext setImage:btnNextImageNormal forState:UIControlStateNormal];
//    [btnNext setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btnNext]];

}






- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
    [self doSend:nil];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	txtEmail = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
