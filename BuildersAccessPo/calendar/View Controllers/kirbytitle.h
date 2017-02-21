//
//  kirbytitle.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-31.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "CKCalendarDelegate.h"
#import "CKCalendarDataSource.h"
#import "fathercontroller.h"
#import "MBProgressHUD.h"

@interface kirbytitle : fathercontroller<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) IBOutlet UITabBar *ntabbar;

@property (nonatomic, assign) id<CKCalendarViewDataSource> dataSource;
@property (nonatomic, assign) id<CKCalendarViewDelegate> delegate;

- (CKCalendarView *)calendarView;

@end
