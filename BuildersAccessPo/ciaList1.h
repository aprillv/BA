//
//  ciaList.h
//  BuildersAccess
//
//  Created by amy zhao on 12-12-8.
//  Copyright (c) 2012年 april. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fathercontroller.h"

@interface ciaList : fathercontroller<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchtxt;
@property (nonatomic, retain) NSMutableArray  *ciaListresult;

@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property  int islocked;
@end
