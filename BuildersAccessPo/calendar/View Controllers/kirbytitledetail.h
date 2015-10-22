//
//  kirbytitledetail.h
//  BuildersAccess
//
//  Created by amy zhao on 13-6-3.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "wcfCalendarEntryItem.h"

@interface kirbytitledetail : fathercontroller<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>{
    UITabBar *ntabbar;
    UITextField *txtSubject;
    UITextField *txtLocation;
    UITextField *txtContractNm;
    UITextField *txtPhone;
    UITableView *Mobile;
    UITableView *Email;
    UIButton *txtDate;
    UIButton *txtStart;
    UIButton *txtEnd;
    UITextView *txtNote;
    UITextField *txtcharge;
    
    UIActionSheet* actionSheet;
    NSArray * pickerArrayStart;
    NSArray * pickerArrayEnd;
    
    
    UIPickerView *pstart;
    UIPickerView *pend;
    wcfCalendarEntryItem* result;
    
    UIScrollView *uv;
    UITableView *phone;
    
}
@property(copy, nonatomic) NSString *idnumber;


@end
