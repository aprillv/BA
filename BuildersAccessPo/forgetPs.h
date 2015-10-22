//
//  forgetPs.h
//  BuildersAccess
//
//  Created by Bin Bob on 7/18/11.
//  Copyright 2011 lovetthomes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fViewController.h"
#import "CustomKeyboard.h"

@interface forgetPs : fViewController<CustomKeyboardDelegate, UITextFieldDelegate> {
	UITextField *txtEmail;
    CustomKeyboard *keyboard;
}

@property (nonatomic, retain) IBOutlet UITextField *txtEmail;

- (IBAction)doCancel:(id)sender;
- (IBAction)doSend:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
@end