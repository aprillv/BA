//
//  cl_sync.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-13.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cl_sync : NSCoder


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(BOOL)addToSync:(NSString *)idcia :(NSString *)mtype :(NSDate *)xtime;
-(void)updSync:(NSString *)idcia :(NSString *)xtype :(NSDate *)xtime;
-(NSString *)getLastSync:(NSString *)idcia :(NSString *)xtype;

-(void)deleteall;

-(BOOL)isFirttimeToSync:(NSString *)idcia :(NSString *)xtype ;
@end
