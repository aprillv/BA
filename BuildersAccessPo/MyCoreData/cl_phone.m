//
//  cl_phone.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-14.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "cl_phone.h"
#import "userInfo.h"


@implementation cl_phone

@synthesize managedObjectContext;

- (BOOL)IsFirstTimeToSyncPhone{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatPhone"inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSString *str=[NSString stringWithFormat:@"ciaid ='%d'", [userInfo getCiaId]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *na = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if ([na count]==0) {
        return YES;
    }else{
        return NO;
    }
    
}

-(BOOL)addToPhone:(NSMutableArray *)result1{
    return [self addToPhone:result1 andidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue]];
}

-(BOOL)addToPhone:(NSMutableArray *)result1 andidcia:(NSString *)xidcia{
    NSManagedObject *steve;
    NSError *error = nil;
    for(wcfPhoneListItem *kv in result1){
        steve = [NSEntityDescription insertNewObjectForEntityForName:@"DatPhone" inManagedObjectContext:[self managedObjectContext]];
        [steve setValue:xidcia forKey:@"ciaid"];
        [steve setValue:kv.Name forKey:@"name"];
        [steve setValue:kv.Title forKey:@"title"];
        [steve setValue:kv.Office forKey:@"telhome"];
        [steve setValue:kv.Fax forKey:@"tel"];
        [steve setValue:kv.Mobile forKey:@"mobile"];
        [steve setValue:kv.Email forKey:@"email"];
        
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
    }
    return YES;
}


-(NSMutableArray *)getPhoneList:(NSString *)str{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatPhone" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
//    if (str==nil) {
//        str=[NSString stringWithFormat:@"ciaid ='%d'", [userInfo getCiaId]];
//    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    NSError *error = nil;
    NSMutableArray *rtnlist= [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    return rtnlist;
    
}

-(void)deleteByCurrentCia{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatPhone"inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSString *str;
    str=[NSString stringWithFormat:@"ciaid ='%d'", [userInfo getCiaId]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    for (NSManagedObject *entity1 in mutableFetchResult) {
        [self.managedObjectContext deleteObject:entity1];
    }
    
}

-(void)updPhone:(wcfPhoneListItem *)kv{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatPhone"inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSString *str;
    if ([userInfo getCiaId]==0) {
        str=[NSString stringWithFormat:@"email='%@'",  kv.Email];
    }else{
        str=[NSString stringWithFormat:@"ciaid ='%d' and email='%@'", [userInfo getCiaId], kv.Email];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    for (NSManagedObject *steve in mutableFetchResult) {
        
        [steve setValue:kv.Name forKey:@"name"];
        [steve setValue:kv.Title forKey:@"title"];
        [steve setValue:kv.Office forKey:@"telhome"];
        [steve setValue:kv.Fax forKey:@"tel"];
        [steve setValue:kv.Mobile forKey:@"mobile"];
        
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

-(void)updPhonefrommyprofile:(wcfPhoneListItem *)kv{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatPhone"inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSString *str;
     str=[NSString stringWithFormat:@"email='%@'",  kv.Email];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    for (NSManagedObject *steve in mutableFetchResult) {
        
        [steve setValue:kv.Name forKey:@"name"];
        [steve setValue:kv.Title forKey:@"title"];
        [steve setValue:kv.Office forKey:@"telhome"];
        [steve setValue:kv.Fax forKey:@"tel"];
        [steve setValue:kv.Mobile forKey:@"mobile"];
        
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


-(void)deletaAllCias{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatPhone"inManagedObjectContext:self.managedObjectContext];
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
