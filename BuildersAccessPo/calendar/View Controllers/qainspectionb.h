//
//  qainspectionb.h
//  BuildersAccess
//
//  Created by amy zhao on 13-7-8.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "wcfCalendarQAb.h"
#import "CustomKeyboard.h"

@interface qainspectionb : fathercontroller<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, CustomKeyboardDelegate, UITextViewDelegate>{
    
}
@property(copy, nonatomic) NSString *idnumber;
@property int fromtype;
@end
