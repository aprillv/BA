//
//  contractforapproveupd.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-4.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "wcfContractEntryItem.h"

@interface contractforapproveupd : fathercontroller<UITableViewDelegate, UITableViewDataSource>{
    wcfContractEntryItem* result;
    int xtype;
    UITableView *ciatbview;
}
@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;


@property(copy, nonatomic) NSString *oidcia;
@property int xfromtype;

@property(copy, nonatomic) NSString *ocontractid;

@property (nonatomic,retain)IBOutlet UIView *subview;

@end
