//
//  emailVendor.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-7.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
@class wcfPODetail;

//#import "MBProgressHUD.h"

@interface emailVendor : fathercontroller

@property(retain, nonatomic) wcfPODetail *pd;
@property (nonatomic, retain) NSString *xidvendor;
@property(copy, nonatomic) NSString *poid;
@property int xtype;
@property int fromforapprove;
@end
