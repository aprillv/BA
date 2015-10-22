//
//  requestedvpols.h
//  BuildersAccess
//
//  Created by amy zhao on 13-7-13.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CustomKeyboard.h"

@interface requestedvpols : fathercontroller<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CustomKeyboardDelegate, UIAlertViewDelegate>{
    CustomKeyboard *keyboard;
    UITableView *ciatbview;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchtxt;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@property  (retain, nonatomic) NSMutableArray* result;
@property  (retain, nonatomic) NSMutableArray* result1;
@property  int xtype;
@property  (retain, nonatomic) NSString* idproject;
@end
