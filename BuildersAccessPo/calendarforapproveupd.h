//
//  calendarforapproveupd.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-29.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CustomKeyboard.h"
#import "wcfCalendarEntryItem.h"
//#import "MBProgressHUD.h"

@interface calendarforapproveupd : fathercontroller<UITextViewDelegate, UITextFieldDelegate, CustomKeyboardDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>{
    UITextField *txtSubject;
    UITextField *txtLocation;
    UITextField *txtContractNm;
    UITextField *txtPhone;
    UITextField *txtMobile;
    UITextField *txtemail;
    UIButton *txtDate;
    UIButton *txtStart;
    UIButton *txtEnd;
    UITextView *txtNote;
    CustomKeyboard *keyboard;
    UITextField *txtcharge;
    
    UIActionSheet* actionSheet;
     NSArray * pickerArrayStart;
     NSArray * pickerArrayEnd;
    
    UIDatePicker *pdate;
    UIPickerView *pstart;
    UIPickerView *pend;
    wcfCalendarEntryItem* result;
//    MBProgressHUD *HUD;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property(copy, nonatomic) NSString *idnumber;
@property int xmtype;

@end
