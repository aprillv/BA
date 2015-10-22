//
//  coforapprovecials.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-1.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CustomKeyboard.h"

@interface coforapprovecials : fathercontroller<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CustomKeyboardDelegate>{
    CustomKeyboard *keyboard;
    UIScrollView *uv;
    NSMutableArray* result1;
    UITableView *ciatbview;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property(copy, nonatomic) NSString *mastercia;
@property  (retain, nonatomic) NSMutableArray* result;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property (weak, nonatomic) IBOutlet UITableView *tbview;

@end
