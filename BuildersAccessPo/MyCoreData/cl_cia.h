//
//  cl_cia.h
//  BuildersAccessPo
//
//  Created by amy zhao on 13-3-8.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cl_cia : NSCoder

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(BOOL)addToCia:(NSMutableArray *)result1;
-(NSMutableArray *)getCiaList;
-(void)deletaAll;
-(NSMutableArray *)getCiaListWithStr:(NSString *)str;
@end
