//
//  myprofile.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-13.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CustomKeyboard.h"

@interface myprofile : fathercontroller<UITextFieldDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, CustomKeyboardDelegate>{
    CustomKeyboard *keyboard;
}
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@property (retain, nonatomic)UITextField *uname;
@property (retain, nonatomic)UITableView *ciatbview;
@property (retain, nonatomic)UITextField *utitle;
@property (retain, nonatomic)UITextField *phone;
@property (retain, nonatomic)UITextField *fax;
@property (retain, nonatomic)UITextField *mobile;
@property (retain, nonatomic) UIImage *myphoto;
@end
