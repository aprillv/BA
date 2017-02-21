//
//  SignUp2.h
//  BuildersAccess
//
//  Created by Bin Bob on 7/16/11.
//  Copyright 2011 lovetthomes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomKeyboard.h"
#import "fViewController.h"

@interface SignUp : fViewController <UITextFieldDelegate, CustomKeyboardDelegate> {

	UITextField *txtEmail;
	UITextField *txtFName;
	UITextField *txtLName;
	UITextField *txtPs;
	UITextField *txtPs1;
	UIButton *checkButton;
    CustomKeyboard *keyboard;
	
	bool                       ischecked;
}

@property (nonatomic, retain) IBOutlet UITextField *txtEmail;
@property (nonatomic, retain) IBOutlet UITextField *txtFName;
@property (nonatomic, retain) IBOutlet UITextField *txtLName;
@property (nonatomic, retain) IBOutlet UITextField *txtPs;
@property (nonatomic, retain) IBOutlet UITextField *txtPs1;
@property (nonatomic, retain) IBOutlet UIButton *checkButton;
@property (nonatomic, assign) bool                         ischecked;

- (IBAction)doCancel:(id)sender;
- (IBAction)doSignUp:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction) CheckboxClicked:(id)sender ;
- (IBAction)readuse:(id)sender;
- (IBAction)readpolicy:(id)sender;
@end
