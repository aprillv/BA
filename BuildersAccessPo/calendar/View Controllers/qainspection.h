//
//  qainspection.h
//  BuildersAccess
//
//  Created by amy zhao on 13-7-2.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CustomKeyboard.h"
//#import "MBProgressHUD.h"

@interface qainspection : fathercontroller<CustomKeyboardDelegate, UITextViewDelegate, UIAlertViewDelegate>{
    UITextView *txtNote;
    CustomKeyboard *keyboard;
//    MBProgressHUD *HUD;
}

@property(copy, nonatomic) NSString *idnumber;
@property int fromtype;
@end
