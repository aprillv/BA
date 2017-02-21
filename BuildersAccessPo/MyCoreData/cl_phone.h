//
//  cl_phone.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-14.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "wcfPhoneListItem.h"

@interface cl_phone : NSCoder
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(BOOL)IsFirstTimeToSyncPhone;
-(BOOL)addToPhone:(NSMutableArray *)result1;
-(NSMutableArray *)getPhoneList:(NSString *)str;
-(void)deleteByCurrentCia;
-(void)deletaAllCias;
-(void)updPhone:(wcfPhoneListItem *)pi;
-(void)updPhonefrommyprofile:(wcfPhoneListItem *)kv;

-(BOOL)addToPhone:(NSMutableArray *)result1 andidcia:(NSString *)xidcia;
@end
