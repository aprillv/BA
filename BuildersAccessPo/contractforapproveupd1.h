//
//  contractforapproveupd1.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-5.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CustomKeyboard.h"
#import "wcfKeyValueItem.h"
//#import "MBProgressHUD.h"

@interface contractforapproveupd1 : fathercontroller<UITextViewDelegate, UIAlertViewDelegate, CustomKeyboardDelegate, UITableViewDelegate, UITableViewDataSource>{
    UITextView *txtNote;
    CustomKeyboard *keyboard;
    wcfKeyValueItem* result;
    UILabel *lbl0;
    UITableView *lbl1;
    UIButton *dd1;
    NSArray * pickerArray;
    int ctag;
//    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property int xfromtype;
@property(copy, nonatomic) NSString *idcia;
@property(copy, nonatomic) NSString *idcontract1;
@property(copy, nonatomic) NSString *idproject;
@property(copy, nonatomic) NSString *projectname;

@property int xtype;

@end
