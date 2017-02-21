//
//  selectitem.h
//  BuildersAccess
//
//  Created by amy zhao on 13-7-9.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"

@interface selectitem : fathercontroller<UITableViewDataSource, UITableViewDelegate>

@property(copy, nonatomic) NSString *idnumber;
@property int fromtype;
@end
