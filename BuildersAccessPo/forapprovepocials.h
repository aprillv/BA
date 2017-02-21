//
//  forapprovepocials.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-19.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CustomKeyboard.h"
#import "wcfArrayOfKeyValueItem.h"

@interface forapprovepocials : fathercontroller<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CustomKeyboardDelegate>{
    CustomKeyboard *keyboard;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchtxt;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property (weak, nonatomic) IBOutlet UITableView *ciatbview;

@property  (retain, nonatomic) NSMutableArray* result;
@property  (retain, nonatomic) NSMutableArray* result1;
@property int mxtype;
@property(copy, nonatomic) NSString *masterciaid;


@end
