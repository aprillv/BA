//
//  cl_reason.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-20.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cl_reason : NSCoder
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(BOOL)addToReason:(NSMutableArray *)result1 :(NSString *)xidcia;
-(NSMutableArray *)getReasonList:(NSString *)str;
-(void)deletaAll:(NSString *)idmaster;
-(void)deletaAllCias;
@end
