//
//  coforapproveupd1.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-3.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CustomKeyboard.h"
#import "wcfUserCOEmail.h"
//#import "MBProgressHUD.h"

@interface coforapproveupd1 : fathercontroller<UITextViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate, CustomKeyboardDelegate, UITableViewDelegate, UITableViewDataSource>{
    UITextView *txtNote;
    CustomKeyboard *keyboard;
    wcfUserCOEmail* result;
    UILabel *lbl0;
    UITableView *lbl1;
    int ctag;
//    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property bool isfromapprove;
@property(nonatomic, retain)  UIButton *dd1;
@property (retain, nonatomic) NSArray * pickerArray;

@property(copy, nonatomic) NSString *idcia;

@property(copy, nonatomic) NSString *idco1;

@property int xtype;

@end
