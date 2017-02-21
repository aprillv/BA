//
//  coforapproveupd.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-3.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "wcfCODetail.h"

@interface coforapproveupd : fathercontroller<UITableViewDelegate, UITableViewDataSource>{
    wcfCODetail* result;
int xtype;
}
@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@property(copy, nonatomic) NSString *idnumber;
@property(copy, nonatomic) NSString *idcia;
@property bool isfromapprove;
@end
