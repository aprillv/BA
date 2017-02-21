//
//  cl_vendor.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-21.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cl_vendor : NSCoder
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(BOOL)addToVendor:(NSMutableArray *)result1;
-(NSMutableArray *)getVendorList:(NSString *)str;
-(void)deletaAll:(NSString *)idmaster;
-(void)deletaAllCias;
//-(void)updProject:(wcfProjectItem *)pi andId:(NSString *)idproject;


@end
