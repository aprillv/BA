//
//  AppDelegate.m
//  BuildersAccessPo
//
//  Created by amy zhao on 13-3-1.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "AppDelegate.h"

#import "Login.h"
#import "ciaList.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    Login *controller = (Login *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    
    [[UITableView appearance] setLayoutMargins: UIEdgeInsetsZero];
    [[UITableView appearance] setSeparatorInset:UIEdgeInsetsZero];
    [[UITableView appearance] setPreservesSuperviewLayoutMargins:NO];
    [[UITableViewCell appearance] setLayoutMargins:UIEdgeInsetsZero];
    [[UITableViewCell appearance] setSeparatorInset:UIEdgeInsetsZero];
    [[UITableViewCell appearance] setPreservesSuperviewLayoutMargins: NO];
//    [[UITableView appearance] setCellLayoutMarginsFollowReadableWidth:NO];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
   
//    UINavigationController *nav =(UINavigationController *)self.window.rootViewController;
//    if ([[[nav childViewControllers]lastObject] isKindOfClass:[Login class]]) {
//        [self saveContext];
//        
//        [[NSThread mainThread] a];
//       
//    }
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    UINavigationController *nav =(UINavigationController *)self.window.rootViewController;
    [self showPinScreen:nav];
    
    
}

-(void)showPinScreen:(UINavigationController *)nav{
   fViewController *T=[[nav childViewControllers]lastObject];
    if (![[T unlockPasscode] isEqualToString:@"0"] && ![[T unlockPasscode] isEqualToString:@"1"]) {
        if ([T isKindOfClass:[ciaList class]]) {
            
            ciaList *cl = (ciaList *)T;
            if (cl.islocked==1 || cl.islocked==2) {
                cl.islocked=2;
            }else {
                [T enterPasscode:nil];
            }
        }else{
            
            if (T.navigationItem.rightBarButtonItem !=nil) {
                
                T.navigationItem.rightBarButtonItem.enabled=YES;
            }
            
            [T enterPasscode:nil];
            
        }
    
    }    
}
UIBackgroundTaskIdentifier backgroundTask;
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    backgroundTask = [application beginBackgroundTaskWithExpirationHandler: ^{
        // 如果超时这个block将被调用
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (backgroundTask != UIBackgroundTaskInvalid)
            {
                // do whatever needs to be done
                [application endBackgroundTask:backgroundTask];
                backgroundTask = UIBackgroundTaskInvalid;
                
            }
        });
    }];
    
    
    // Start the long-running task
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Do the work!
        [NSThread sleepForTimeInterval:5];
        //    NSLog(@"Time remaining: %f",[application backgroundTimeRemaining]);
        [NSThread sleepForTimeInterval:5];
        //    NSLog(@"Time remaining: %f",[application backgroundTimeRemaining]);
        [NSThread sleepForTimeInterval:5];
        //    NSLog(@"Time remaining: %f",[application backgroundTimeRemaining]);
        
        while(1)
        {
            [NSThread sleepForTimeInterval:5];
//            NSLog(@"Time remaining: %f",[application backgroundTimeRemaining]);
        }
        // done!
        
        // call endBackgroundTask - should be executed back on
        // main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (backgroundTask != UIBackgroundTaskInvalid)
            {
                // if you don't call endBackgroundTask, the OS will exit your app.
                [application endBackgroundTask:backgroundTask];
                backgroundTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
//    NSLog(@"Reached the end of ApplicationDidEnterBackground - I'm done!");
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BuildersAccessPo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
        
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BuildersAccessPo.sqlite"];
    
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Handle error
        NSLog(@"Problem with PersistentStoreCoordinator: %@",error);
    }

    
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
