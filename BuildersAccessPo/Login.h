//
//  Login.h
//  BuildersAccessPo
//
//  Created by amy zhao on 13-3-1.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fViewController.h"
#import "CustomKeyboard.h"
#import "userInfo.h"
#import "MBProgressHUD.h"

@interface Login : fViewController<UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate, CustomKeyboardDelegate, MBProgressHUDDelegate> {
    CustomKeyboard *keyboard;
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UISwitch *switchView;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

//@property (nonatomic, retain)  UITextField         *usernameField;
//@property (nonatomic, retain)  UITextField         *passwordField;
@property (nonatomic, retain) NSString                     *pwd;
//@property(nonatomic, retain)  UIButton *dd1;
@property (retain, nonatomic) NSArray * pickerArray;

@end
