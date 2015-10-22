//
//  cl_project.h
//  BuildersAccessPo
//
//  Created by amy zhao on 13-3-8.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "wcfProjectItem.h"

@interface cl_project : NSCoder

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(BOOL)addToProject:(NSMutableArray *)result1 andscheleyn: (NSString *)scheduleyn;
-(NSMutableArray *)getProjectList:(NSString *)str;
-(void)deletaAll:(int)xtype;
-(void)deletaAllCias;
-(void)updProject:(wcfProjectItem *)pi andId:(NSString *)idproject;
@end
