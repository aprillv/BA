//
//  assignVendor.h
//  BuildersAccess
//
//  Created by amy zhao on 12-12-20.
//  Copyright (c) 2012年 lovetthomes. All rights reserved.
//

#import "fathercontroller.h"


@interface assignVendor : fathercontroller
@property(nonatomic, retain) NSString *xpoid;
@property(nonatomic, retain) NSString *xpocode;
@property int fromforapprove;
@property(nonatomic, retain) NSString *xidcostcode;
@property(nonatomic, retain) NSString *xidproject;
@property(nonatomic, retain) NSString *xshipto;
@property(nonatomic, retain) NSString *xdelivery;

@property (nonatomic, retain) NSMutableArray *rtnlist;

@property (nonatomic, retain) IBOutlet UITextField *searchField;

@end
