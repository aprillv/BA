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
}
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property (retain, nonatomic) NSMutableArray *rtnlist;
@property (strong, nonatomic) IBOutlet UITableView *tbview;
@property(copy, nonatomic) NSString *mastercia;

@end
