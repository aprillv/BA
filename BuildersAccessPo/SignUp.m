    //
//  SignUp2.m
//  BuildersAccess
//
//  Created by Bin Bob on 7/16/11.
//  Copyright 2011 lovetthomes. All rights reserved.
//

#import "SignUp.h"
#import "Mysql.h"
#import "website.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/CADisplayLink.h>
#import "wcfService.h"


@implementation SignUp
int i;

@synthesize txtEmail;
@synthesize txtFName;
@synthesize txtLName;
@synthesize txtPs;
@synthesize txtPs1;
@synthesize ischecked;
@synthesize checkButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}



- (void)viewDidLoad {

	self.ischecked = NO;
	self.title = @"Become a member";
    UIScrollView *sv =(UIScrollView *)[self.view viewWithTag:1];
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNext.frame = CGRectMake(0, 40, 40, 40);
    [btnNext addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btnNextImageNormal = [UIImage imageNamed:@"back.png"];
    [btnNext setImage:btnNextImageNormal forState:UIControlStateNormal];
    [btnNext setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
     [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btnNext]]; 
    
    checkButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton setFrame:CGRectMake(10, 300, 34, 44)];
    [checkButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(CheckboxClicked:) forControlEvents:UIControlEventTouchDown];
    [sv addSubview:checkButton];
    
	[super viewDidLoad];
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtEmail setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :TRUE]];
    [txtPs setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:TRUE :TRUE]];
     [txtPs1 setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:TRUE :TRUE]];
    [txtFName setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:TRUE :TRUE]];
     [txtLName setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:TRUE :NO]];  
}

- (void)nextClicked{
    if ([txtEmail isFirstResponder]) {
        [txtPs becomeFirstResponder];
    }else if([txtPs isFirstResponder]){
        [txtPs1 becomeFirstResponder];
    }else if([txtPs1 isFirstResponder]){
        [txtFName becomeFirstResponder];
    }else if([txtFName isFirstResponder]){
        [txtLName becomeFirstResponder];
    }
}
- (void)previousClicked{
    if([txtPs isFirstResponder]){
        [txtEmail becomeFirstResponder];
    }else if([txtPs1 isFirstResponder]){
        [txtPs becomeFirstResponder];
    }else if([txtFName isFirstResponder]){
        [txtPs1 becomeFirstResponder];
    }else{
        [txtFName becomeFirstResponder];
    }
}

- (void)doneClicked{
    
    [txtEmail resignFirstResponder];
    [txtPs resignFirstResponder];
    [txtPs1 resignFirstResponder];
    [txtLName resignFirstResponder];
    [txtFName resignFirstResponder];
    int  y2;
    if (self.view.frame.size.height>500) {
        y2=252;
    }else{
        y2=208;
    }
	self.view.center = CGPointMake(self.view.center.x, y2);
}


-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(id)sender
{
    int  y2;
    if (self.view.frame.size.height>500) {
        y2=252;
    }else{
        y2=208;
    }
	self.view.center = CGPointMake(self.view.center.x, y2);
	[sender resignFirstResponder];
	return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)sender
{
    int  y2, y3;
    if (self.view.frame.size.height>500) {
        y2=252;
        y3=154;
        
        if (sender == self.txtLName) {
            self.view.center =  CGPointMake(self.view.center.x, y3+40);
        }else if(sender == txtFName){
            self.view.center =  CGPointMake(self.view.center.x, y3+100);
        }else{
            self.view.center = CGPointMake(self.view.center.x, y2);
        }
    }else{
        y2=208;
        y3=110;
        if (sender == self.txtPs1) {
            self.view.center =  CGPointMake(self.view.center.x, y3+70);
        }else if (sender == self.txtLName) {
            self.view.center =  CGPointMake(self.view.center.x, y3-50);
        }else if(sender == txtFName){
            self.view.center =  CGPointMake(self.view.center.x, y3+10);
        }else{
            self.view.center = CGPointMake(self.view.center.x, y2);
        }
    }

	return YES;
}

- (IBAction)doCancel:(id)sender {
    #pragma unused(sender)
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)readuse:(id)sender {
#pragma unused(sender)
	website *ws = [website alloc];
    
	ws.Url = @"http://www.buildersaccess.com/terms.aspx";
    
    [self presentViewController:ws animated:YES completion:NULL];

	
}

- (IBAction)readpolicy:(id)sender {
#pragma unused(sender)
	website *ws = [website alloc];
	ws.Url = @"http://www.buildersaccess.com/policy.aspx";
    [self presentViewController:ws animated:YES completion:NULL];

}

- (IBAction) CheckboxClicked:(id)sender  {
	if (self.ischecked == NO){
		self.ischecked = YES;
		[self.checkButton setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
		
	}else{
		self.ischecked = NO;
		[self.checkButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
		
	}
}

- (IBAction)doSignUp:(id)sender {
	NSString *email = [Mysql TrimText:self.txtEmail.text];
	NSString *ps = [Mysql TrimText:self.txtPs.text];
	NSString *ps1 = [Mysql TrimText:self.txtPs1.text];
	NSString *fname = [Mysql TrimText:self.txtFName.text];
	NSString *lname = [Mysql TrimText:self.txtFName.text];
	
    if (email.length == 0 || ps.length == 0 || ps1.length == 0
		|| fname.length == 0 || lname.length ==0) {
		UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Please Input All Fields"
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
		[alert show];
	}else if (!self.ischecked) {
		UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"You must agree with the terms of use and privacy policy."
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
		[alert show];
	}else if ([Mysql IsEmail:email]==NO) {
		UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Please Input invalid email"
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
		[alert show];
	}else if ([ps isEqualToString:ps1]==NO) {
		UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Password and confirm password should be the same."
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
		[alert show];
	}else{
//		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        wcfService* service = [wcfService service];

//        [service xSignUp:self action:@selector(xSignUpHandler:) xemail:email password:ps firstName:fname lastName:lname EquipmentType:@"3"];
//        
		
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

- (void) xSignUpHandler: (id) value {
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
    NSString* result = (NSString*)value;
    
    if ([result isEqualToString:@"-1"]) {
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Can not add record to database."
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
        [alert show];
    }else if ([result isEqualToString:@"2"]) {
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Email can not be send. Please try again."
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
        [alert show];
    }else if ([result isEqualToString:@"0"]) {
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Email already exist."
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
        UIAlertView *alert = nil;
        NSString *email = [Mysql TrimText:self.txtEmail.text];
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Success"
                 message:[@"Your account is not active yet, we have send you an email to: " stringByAppendingString:email]
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }		
}

- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	self.txtEmail = nil;
	self.txtFName = nil;
	self.txtLName = nil;
	self.txtPs = nil;
	self.txtPs1 = nil;
	self.ischecked = nil;
	self.checkButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
