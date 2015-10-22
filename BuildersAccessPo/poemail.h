//
//  poemail.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-24.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "wcfPODetail.h"
#import "CustomKeyboard.h"
#import "MBProgressHUD.h"

@interface poemail : fathercontroller<UIPickerViewDataSource, UIPickerViewDelegate,UITextViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate, CustomKeyboardDelegate, MBProgressHUDDelegate>{
    CustomKeyboard *keyboard;
    UIDatePicker *pdate;
    UIButton *txtDate;
    bool isreleased;
    bool isDraftorForapprove;
    NSString *oldemail;
    NSString *oldStatus;
    wcfPODetail *pd;
    MBProgressHUD* HUD;
}

@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property (weak, nonatomic) IBOutlet UIScrollView *uv;

@property(copy, nonatomic) NSString *idpo1;
@property(copy, nonatomic) NSString *xmcode;
@property(nonatomic, retain)  UIButton *dd1;
@property(copy, nonatomic) NSString *idvendor;
@property (retain, nonatomic) NSMutableArray * pickerArray;
@property(nonatomic, retain) UIPickerView *ddpicker;
@property int xtype;
@property bool isfromassign;
@property(nonatomic, retain)  UITextView *txtNote;
@property int fromforapprove;
@end
