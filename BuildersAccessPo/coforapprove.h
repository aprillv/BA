//
//  coforapprove.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-27.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CustomKeyboard.h"

@interface coforapprove : fathercontroller<UITableViewDelegate, UITableViewDataSource,CustomKeyboardDelegate, UISearchBarDelegate >{
    CustomKeyboard *keyboard;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchtxt;

@property (retain, nonatomic) NSMutableArray *rtnlist;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@property (retain, nonatomic)UITableView *tbview;
@property (retain, nonatomic) NSMutableArray *rtnlist1;

@end
