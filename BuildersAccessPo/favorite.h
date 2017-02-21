//
//  favorite.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-11.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CustomKeyboard.h"

@interface favorite : fathercontroller<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,CustomKeyboardDelegate>{
    CustomKeyboard *keyboard;
    UITableView *tbview;
}

@property (retain, nonatomic) NSMutableArray *rtnlist;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchtxt;

@end
