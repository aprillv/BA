//
//  cl_assembly.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-20.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cl_assembly : NSCoder
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(BOOL)addToAssembly:(NSMutableArray *)result1;
-(NSMutableArray *)getAssemblyList:(NSString *)str;
-(void)deletaAll:(int)xtype;
-(void)deletaAllCias;
//-(void)updProject:(wcfProjectItem *)pi andId:(NSString *)idproject;

@end
