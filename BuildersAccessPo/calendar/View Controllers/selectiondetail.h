//
//  selectiondetail.h
//  BuildersAccess
//
//  Created by roberto ramirez on 12/17/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "fathercontroller.h"
@class wcfCalendarEntryItem;
#import "CustomKeyboard.h"


@interface selectiondetail : fathercontroller<UITextViewDelegate, UITextFieldDelegate, CustomKeyboardDelegate, UIActionSheetDelegate,  UIAlertViewDelegate>{
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
    
    UIActionSheet* actionSheet;
    NSArray * pickerArrayStart;
    NSArray * pickerArrayEnd;
    
    UIDatePicker *pdate;
    UIPickerView *pstart;
    UIPickerView *pend;
    wcfCalendarEntryItem* result;
    //    MBProgressHUD *HUD;
    
}
@property(copy, nonatomic) NSString *idnumber;

@end
