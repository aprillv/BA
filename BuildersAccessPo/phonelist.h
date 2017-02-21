//
//  phonelist.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-14.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CustomKeyboard.h"

@interface phonelist : fathercontroller<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate ,UIAlertViewDelegate, CustomKeyboardDelegate >{
    CustomKeyboard *keyboard;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchtxt;
@property (retain, nonatomic) NSMutableArray *rtnlist;


@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property (strong, nonatomic) IBOutlet UITableView *tbview;


@end
