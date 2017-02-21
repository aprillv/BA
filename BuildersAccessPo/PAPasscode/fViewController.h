//
//  fViewController.h
//  CoreData
//
//  Created by amy zhao on 13-2-26.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAPasscodeViewController.h"
 

#define Download_InstallLink @"itms-services://?action=download-manifest&url=https://www.buildersaccess.com/iphone/dev.plist"


@interface fViewController : UIViewController<PAPasscodeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *passcodeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *simpleSwitch;

- (IBAction)setPasscode:(id)sender;
- (IBAction)enterPasscode:(id)sender;
- (IBAction)changePasscode:(id)sender;

- (NSString *)unlockPasscode;

-(IBAction)logout:(id)sender;

-(void)changePin;
-(void)CancletPin;
-(UIAlertView *)getErrorAlert:(NSString *)str;
-(UIAlertView *)getSuccessAlert:(NSString *)str;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
