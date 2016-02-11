//
//  suggestforapprove.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-15.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CustomKeyboard.h"

@interface suggestforapprove : fathercontroller<UITableViewDataSource, UITableViewDelegate, CustomKeyboardDelegate, UISearchBarDelegate >{
    CustomKeyboard *keyboard;
}

@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchtxt;
@property (retain, nonatomic) NSMutableArray *rtnlist;
@property (retain, nonatomic) NSMutableArray *rtnlist1;
@property(copy, nonatomic) NSString *masterciaid;

@property (strong, nonatomic) IBOutlet UITableView *tbview;

@end
