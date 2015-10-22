//
//  cl_cia.m
//  BuildersAccessPo
//
//  Created by amy zhao on 13-3-8.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "cl_cia.h"
#import "wcfKeyValueItem.h"

@implementation cl_cia
@synthesize managedObjectContext;

-(BOOL)addToCia:(NSMutableArray *)result1{
    NSManagedObject *steve;
    NSError *error = nil;
    for(wcfKeyValueItem *kv in result1){
        steve = [NSEntityDescription insertNewObjectForEntityForName:@"DatCias" inManagedObjectContext:[self managedObjectContext]];
        [steve setValue:kv.Value forKey:@"cianame"];
        [steve setValue:kv.Key forKey:@"ciaid"];
        
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

-(NSMutableArray *)getCiaList{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatCias"inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    return [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
}

-(NSMutableArray *)getCiaListWithStr:(NSString *)str{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatCias"inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    [request setPredicate:predicate];
    NSError *error = nil;
    return [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
}


-(void)deletaAll{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DatCias"inManagedObjectContext:self.managedObjectContext];
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
