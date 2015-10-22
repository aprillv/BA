//
//  cl_pin.h
//  BuildersAccessPo
//
//  Created by amy zhao on 13-3-9.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cl_pin : NSCoder

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
-(BOOL)addToXpin:(NSString *)email andpincode:(NSString *)xpincode;
- (BOOL) deletePin;

- (int)IsUser:(NSString*)xemail;
@end
