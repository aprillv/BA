//
//  cl_favorite.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-11.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "cl_favorite.h"
#import "userInfo.h"
#import "cl_project.h"

@implementation cl_favorite

@synthesize  managedObjectContext;

-(BOOL)isInFavorite:(NSString *)idproject{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatFavorite" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"idcia=%d and idnumber=%@",[userInfo getCiaId], idproject];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *rtnlist= [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
       
//        for (entity in rtnlist) {
//            NSLog(@"%@ %@", [entity valueForKey:@"idcia"], [entity valueForKey:@"idnumber"]);
//        }
    if ([rtnlist count]>0) {
        return YES;
    }else{
        return  NO;
    }
    
}


-(NSMutableArray *)getProject:(NSString *)str{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatFavorite" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    if (str!=nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
        [request setPredicate:predicate];
    }
   
    
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    NSError *error = nil;
    NSMutableArray *rtnlist= [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        return rtnlist;
    
}

-(void)updProject:(wcfProjectItem *)pi andId:(NSString *)idproject{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatFavorite"inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSString *str;
    str=[NSString stringWithFormat:@"idcia ='%d' and idnumber='%@'", [userInfo getCiaId], idproject];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    for (NSManagedObject *steve in mutableFetchResult) {

        [steve setValue:pi.Name forKey:@"name"];
        [steve setValue:pi.PlanName forKey:@"planname"];
        [steve setValue:pi.Status forKey:@"status"];
        
        
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

-(BOOL)addToFavorite:(NSString *)idproject{
    
    NSManagedObject *steve;
    NSError *error = nil;
    
    cl_project *mp =[[cl_project alloc]init];
    mp.managedObjectContext =self.managedObjectContext;
    NSMutableArray *projectls =[mp getProjectList:[NSString stringWithFormat:@"idcia='%d' and idnumber='%@'", [userInfo getCiaId], idproject]];
    
    if ([projectls count]>0) {
        NSManagedObject *entity1=[projectls objectAtIndex:0];
        steve = [NSEntityDescription insertNewObjectForEntityForName:@"DatFavorite" inManagedObjectContext:[self managedObjectContext]];
        [steve setValue:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] forKey:@"idcia"];
        [steve setValue:idproject forKey:@"idnumber"];
        [steve setValue:[entity1 valueForKey:@"name"] forKey:@"name"];
        [steve setValue:[entity1 valueForKey:@"planname"] forKey:@"planname"];
        [steve setValue:[entity1 valueForKey:@"status"] forKey:@"status"];
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
    }else{
        return NO;
    }
    
}

-(BOOL)removeFromFavorite:(NSString *)idproject{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatFavorite" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSString *str;
    str=[NSString stringWithFormat:@"idcia='%d' and idnumber='%@'", [userInfo getCiaId], idproject];
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
    return YES;
}

-(void)deletaAllCias{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatFavorite"inManagedObjectContext:self.managedObjectContext];
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
