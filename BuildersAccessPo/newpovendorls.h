//
//  newpovendorls.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-20.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"


@interface newpovendorls : fathercontroller

@property(nonatomic, retain) NSString *xidvendor;
@property(nonatomic, retain) NSString *xidproject;
@property (retain, nonatomic)NSString *idmaster;
@property(nonatomic, retain) NSString *xxnvendor;
@property (nonatomic, retain) NSMutableArray *rtnlist;
@property int xtype;
@property (nonatomic, retain) IBOutlet UITextField *searchField;

@end
