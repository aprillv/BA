//
//  selectionCalendar.h
//  BuildersAccess
//
//  Created by roberto ramirez on 12/17/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CKCalendarDataSource.h"
#import "CKCalendarDelegate.h"

@interface selectionCalendar : fathercontroller
@property (nonatomic, assign) id<CKCalendarViewDataSource> dataSource;
@property (nonatomic, assign) id<CKCalendarViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITabBar *ntabbar;

- (CKCalendarView *)calendarView;
@end
