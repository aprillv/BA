//
//  cl_sync.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-13.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "cl_sync.h"
#import "Mysql.h"

@implementation cl_sync
@synthesize managedObjectContext;


-(BOOL)addToSync:(NSString *)idcia :(NSString *)xtype :(NSDate *)xtime{
    NSManagedObject *steve;
    NSError *error = nil;
    
    steve = [NSEntityDescription insertNewObjectForEntityForName:@"DatSync" inManagedObjectContext:[self managedObjectContext]];
    [steve setValue: idcia forKey:@"ciaid"];
    [steve setValue:xtype forKey:@"mtype"];
    [steve setValue:xtime  forKey:@"lastsync"];
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
    }else{
        return  YES;
    }
}
-(void)updSync:(NSString *)idcia :(NSString *)xtype :(NSDate *)xtime{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatSync" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSString *str;
    str=[NSString stringWithFormat:@"ciaid ='%@' and mtype='%@'", idcia, xtype];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    if ([mutableFetchResult count]==0) {
        [self addToSync:idcia :xtype :xtime];
    }else{
        NSManagedObject *steve=[mutableFetchResult objectAtIndex:0];
        [steve setValue:xtime forKey:@"lastsync"];
        
        
        BOOL isSaveSuccess=[self.managedObjectContext save:&error];
        
        if (!isSaveSuccess) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"BuildersAccess"
                                  message:[NSString stringWithFormat:@"Error: %@,%@",error,[error userInfo]]
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }

    }

}

-(BOOL)isFirttimeToSync:(NSString *)idcia :(NSString *)xtype {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatSync" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSString *str;
    str=[NSString stringWithFormat:@"ciaid ='%@' and mtype='%@'", idcia, xtype];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if ([mutableFetchResult count] == 0) {
        
        return YES;
    }else{
        return NO;
    }
    
}


-(NSString *)getLastSync:(NSString *)idcia :(NSString *)xtype{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatSync" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSString *str;
    str=[NSString stringWithFormat:@"ciaid ='%@' and mtype='%@'", idcia, xtype];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    for (NSManagedObject *steve in mutableFetchResult) {
        return [Mysql stringFromDate:[steve valueForKey:@"lastsync"]];
    }
    return @"";
}

-(void)deleteall{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatSync"inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    for (NSManagedObject *entity1 in mutableFetchResult) {
        [self.managedObjectContext deleteObject:entity1];
    }
}
@end
