//
//  codisapprove.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-2.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CustomKeyboard.h"
//#import "MBProgressHUD.h"

@interface codisapprove : fathercontroller<UITextViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate, CustomKeyboardDelegate>{
    UITextView *txtNote;
    CustomKeyboard *keyboard;
    
//MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;


@property(nonatomic, retain)  UIButton *dd1;
@property(nonatomic, retain)  NSString *xemail;
@property(nonatomic, retain)  NSString *xmsg;
@property (retain, nonatomic) NSArray * pickerArray;

@property(copy, nonatomic) NSString *idnumber;
@property(copy, nonatomic) NSString *calendardata;
@property BOOL disapprove;
@end
