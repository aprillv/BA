//
//  reschedule.h
//  BuildersAccess
//
//  Created by roberto ramirez on 9/15/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "fathercontroller.h"
@class wcfArrayOfKeyValueItem;
@class wcfProjectSchedule;

@interface reschedule : fathercontroller

@property(copy, nonatomic) NSString *xidproject;

@property(retain, nonatomic) wcfProjectSchedule *ws;
//@property(copy, nonatomic) NSString *xrefid;
//@property(copy, nonatomic) NSString *xname;
@property(copy, nonatomic) NSDate *xstartd;
@property int idmainstep;
@property(copy, nonatomic) wcfArrayOfKeyValueItem *result;

@property BOOL iscriticalpath;

@end
