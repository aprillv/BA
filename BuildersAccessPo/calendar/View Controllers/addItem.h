//
//  addItem.h
//  BuildersAccess
//
//  Created by amy zhao on 13-7-9.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"

@interface addItem : fathercontroller
@property(copy, nonatomic) NSString *idnumber;
@property(copy, nonatomic) NSString *isshow;
@property(copy, nonatomic) NSString *category;
@property int fromtype;
@end
