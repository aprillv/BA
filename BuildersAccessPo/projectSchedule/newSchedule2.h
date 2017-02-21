//
//  newSchedule2.h
//  BuildersAccess
//
//  Created by roberto ramirez on 8/21/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "fathercontroller.h"

@interface newSchedule2 : fathercontroller
@property (weak, nonatomic) IBOutlet UIDatePicker *pdate;
@property(copy, nonatomic) NSString *xidproject;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property (weak, nonatomic) IBOutlet UITableView *tbview;
@property(copy, nonatomic) NSString *xidstep;
@end
