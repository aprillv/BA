//
//  projectpo.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-6.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"

@interface projectpo : fathercontroller
@property (nonatomic, retain) NSString *idproject;
@property (nonatomic, retain) NSString *idvendor;
@property (nonatomic, retain) NSString *idmaster;
@property int xtype;
@property int isfromdevelopment;
@property (strong, nonatomic) IBOutlet UITabBar *ntabbar;
@property (strong, nonatomic) IBOutlet UITableView *ciatbview;
@property (nonatomic, retain) NSMutableArray* result;
@end
