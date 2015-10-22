//
//  forapprove.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-27.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "fathercontroller.h"

@interface forapprove : fathercontroller<UITableViewDelegate, UITableViewDataSource>{
    int xtype;
    NSString *potitle;
    UITableView *tbview;
}
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property (retain, nonatomic) NSMutableArray *rtnlist;

@property(copy, nonatomic) NSString *mastercia;

@end
