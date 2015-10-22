//
//  cl_favorite.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-11.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "wcfProjectItem.h"

@interface cl_favorite : NSCoder

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(BOOL )isInFavorite:(NSString *)idproject;
-(BOOL)addToFavorite:(NSString *)idproject;
-(BOOL)removeFromFavorite:(NSString *)idproject;
-(void)updProject:(wcfProjectItem *)pi andId:(NSString *)idproject;
-(NSMutableArray *)getProject:(NSString *)str;

-(void)deletaAllCias;
@end
