//
//  cl_pin.m
//  BuildersAccessPo
//
//  Created by amy zhao on 13-3-9.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "cl_pin.h"

@implementation cl_pin
@synthesize managedObjectContext;

-(BOOL)addToXpin:(NSString *)email andpincode:(NSString *)xpincode{
    NSManagedObject *steve;
    NSError *error = nil;
   
    steve = [NSEntityDescription insertNewObjectForEntityForName:@"Xpin" inManagedObjectContext:[self managedObjectContext]];
  
    [steve setValue:email forKey:@"email"];
    [steve setValue:xpincode forKey:@"pincode"];
    
    BOOL isSaveSuccess=[self.managedObjectContext save:&error];
    
    if (!isSaveSuccess) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"BuildersAccess"
                              message:[NSString stringWithFormat:@"Error: %@,%@",error,[error userInfo]]
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        return NO;
    }

    return  YES;
}

- (BOOL) deletePin{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Xpin"inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    for (NSManagedObject *entry1 in mutableFetchResult) {
        [self.managedObjectContext deleteObject:entry1];
        
    }
    
    if (![self.managedObjectContext save:&error]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"BuildersAccess"
                              message:[NSString stringWithFormat:@"Error: %@,%@",error,[error userInfo]]
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        return NO;
    }
    return  YES;
}

- (int)IsUser:(NSString*)xemail
{
    //Provide the ABLockScreen with a code to verify against
    //    return 1234;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Xpin"inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pincode"ascending:NO];
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if ([mutableFetchResult count]==0) {
        return 0;
    }else{
        NSManagedObject *entry1 = [mutableFetchResult objectAtIndex:0];
        if ([xemail isEqualToString:[entry1 valueForKey:@"email"]]) {
            return 1;
        }
        return -1;
    }
    
}


@end
