//
//  forgetPs.h
//  BuildersAccess
//
//  Created by Bin Bob on 7/18/11.
//  Copyright 2011 lovetthomes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fViewController.h"

@interface forgetPs : fViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;

- (IBAction)doCancel:(id)sender;
- (IBAction)doSend:(id)sender;
@end