//
//  calendarforapprove.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-27.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CustomKeyboard.h"

@interface calendarforapprove : fathercontroller<UITableViewDataSource, UITableViewDelegate, CustomKeyboardDelegate, UISearchBarDelegate >{
    CustomKeyboard *keyboard;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchtxt;
@property int mxtype;
@property (retain, nonatomic) NSMutableArray *rtnlist;
@property (strong, nonatomic) IBOutlet UITableView *tbview;

@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property (retain, nonatomic) NSMutableArray *rtnlist1;
@property(copy, nonatomic) NSString *masterciaid;
@end
