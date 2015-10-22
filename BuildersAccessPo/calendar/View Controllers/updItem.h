//
//  updItem.h
//  BuildersAccess
//
//  Created by amy zhao on 13-7-10.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"

@interface updItem : fathercontroller
@property(copy, nonatomic) NSString *idnumber;
@property(copy, nonatomic) NSString *isshow;
@property(copy, nonatomic) NSString *category;
@property(copy, nonatomic) NSString *itemId;
@property (nonatomic) BOOL xstatus;
@property int fromtype;
@end
