//
//  requestpoemail.h
//  BuildersAccess
//
//  Created by amy zhao on 13-7-24.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "wcfPODetail.h"
#import "CustomKeyboard.h"
//#import "MBProgressHUD.h"

@interface requestpoemail : fathercontroller<UIActionSheetDelegate, UIAlertViewDelegate, CustomKeyboardDelegate>{
    CustomKeyboard *keyboard;
//    MBProgressHUD* HUD;
}


@property(copy, nonatomic) NSString *aemail;
@property(copy, nonatomic) NSString *idnum;
@property (retain, nonatomic) NSMutableArray * pickerArray;
@property int xtype;
//0 acknowledge 1 disapprove 2 void 3 hold
@property bool isfromassign;
@property(nonatomic, retain)  UITextView *txtNote;
@property int fromforapprove;
@property(copy, nonatomic) NSString *xxreason;
@property(copy, nonatomic) NSString *xxtotle;
@property(copy, nonatomic) NSString *xxdate;
@property(copy, nonatomic) NSString *xxstr;
@property(copy, nonatomic) NSString *xxnotes;

@end
