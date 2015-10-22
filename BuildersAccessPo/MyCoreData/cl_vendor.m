//
//  cl_vendor.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-21.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "cl_vendor.h"
#import "userInfo.h"
#import "wcfArrayOfVendor.h"
#import "wcfVendor.h"

@implementation cl_vendor

@synthesize managedObjectContext;

-(BOOL)addToVendor:(NSMutableArray *)result1{
    NSManagedObject *steve;
    NSError *error = nil;
    for(wcfVendor *kv in result1){
        
        steve = [NSEntityDescription insertNewObjectForEntityForName:@"DatVendor" inManagedObjectContext:[self managedObjectContext]];
        [steve setValue:kv.Contact forKey:@"idcia"];
        [steve setValue:kv.Idnumber forKey:@"idNumber"];
        [steve setValue:kv.Name forKey:@"name"];
        
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

-(NSMutableArray *)getVendorList:(NSString *)str{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatVendor" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    if (str==nil) {
        str=[NSString stringWithFormat:@"idcia ='%d'", [userInfo getCiaId]];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    NSError *error = nil;
    NSMutableArray *rtnlist= [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    //    [rtnlist sortUsingComparator:^NSComparisonResult(NSEntityDescription * obj1, NSEntityDescription * obj2) {
    //        if ([obj1 valueForKey:@"planname"]==nil || [[obj1 valueForKey:@"planname"] isEqualToString:@""]) {
    //            return NSOrderedDescending;
    //        }else{
    //            return  NSOrderedAscending;
    //        }
    //
    //    }];
    
    //    for (entity in rtnlist) {
    //        NSLog(@"%@", [entity valueForKey:@"idnumber"]);
    //    }
    
    //    NSLog(@"%@", [entity valueForKey:@"idnumber"]);
    return rtnlist;
    
}

-(void)deletaAll:(NSString *)idmaster{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatVendor"inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSString *str;
     str=[NSString stringWithFormat:@"idcia ='%@'", idmaster];
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

//-(void)updProject:(wcfProjectItem *)pi andId:(NSString *)idproject{
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatProject"inManagedObjectContext:self.managedObjectContext];
//    [request setEntity:entity];
//
//    NSString *str;
//    str=[NSString stringWithFormat:@"idcia ='%d' and idnumber='%@'", [userInfo getCiaId], idproject];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
//    [request setPredicate:predicate];
//
//    NSError *error = nil;
//    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
//    if (mutableFetchResult == nil) {
//        NSLog(@"Error: %@,%@",error,[error userInfo]);
//    }
//    for (NSManagedObject *steve in mutableFetchResult) {
//
//        [steve setValue:pi.Name forKey:@"name"];
//        [steve setValue:pi.PlanName forKey:@"planname"];
//        [steve setValue:pi.Status forKey:@"status"];
//
//
//        BOOL isSaveSuccess=[self.managedObjectContext save:&error];
//
//        if (!isSaveSuccess) {
//            UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle:@"BuildersAccess"
//                                  message:[NSString stringWithFormat:@"Error: %@,%@",error,[error userInfo]]
//                                  delegate:self
//                                  cancelButtonTitle:nil
//                                  otherButtonTitles:@"OK", nil];
//            [alert show];
//        }
//    }
//}

-(void)deletaAllCias{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatVendor"inManagedObjectContext:self.managedObjectContext];
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
