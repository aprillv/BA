//
//  poassembly.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-20.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"

@interface poassembly : fathercontroller

@property (retain, nonatomic) NSMutableArray *rtnlist;
@property (weak, nonatomic) IBOutlet UISearchBar *searchtxt;

@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@property (retain, nonatomic)UITableView *tbview;

@property (retain, nonatomic)NSString *idproject;
@property (retain, nonatomic)NSString *idmaster;
@property int xtype;
@property  int islocked;
@end
