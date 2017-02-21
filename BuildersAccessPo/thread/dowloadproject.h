//
//  dowloadproject.h
//  BuildersAccess
//
//  Created by roberto ramirez on 3/22/14.
//  Copyright (c) 2014 eloveit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol dowloadprojectDelegate

//@optional
-(void)finishone:(NSArray *)pc andPageNo:(int)pagen;
-(void)doexception;
//-(void)finishall;
@end

@interface dowloadproject : NSOperation

@property (nonatomic, strong) id<dowloadprojectDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
-(id)initDownloadWithPageNo:(int)pageno andxtype:(int)xtype;

@end
