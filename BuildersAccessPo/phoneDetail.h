//
//  phoneDetail.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-14.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"

@interface phoneDetail : fathercontroller<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@property(copy, nonatomic) NSString *email;
@property(copy, nonatomic) NSString *ename;
@property(copy, nonatomic) NSString *idmaster;
@property (retain, nonatomic)UITableView *infoview;
@property (retain, nonatomic)UITableView *phone;
@property (retain, nonatomic)UITableView *fax;
@property (retain, nonatomic)UITableView *mobile;
@property (retain, nonatomic)UITableView *uemail;

@end
