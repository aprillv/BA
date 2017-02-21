//
//  calendarqa.h
//  BuildersAccess
//
//  Created by amy zhao on 13-7-1.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "MBProgressHUD.h"
#import "CKCalendarDelegate.h"
#import "CKCalendarDataSource.h"

@interface calendarqa : fathercontroller<MBProgressHUDDelegate>{
   MBProgressHUD *HUD;
}
@property (strong, nonatomic) IBOutlet UITabBar *ntabbar;

@property (nonatomic, assign) id<CKCalendarViewDataSource> dataSource;
@property (nonatomic, assign) id<CKCalendarViewDelegate> delegate;

- (CKCalendarView *)calendarView;
@end
