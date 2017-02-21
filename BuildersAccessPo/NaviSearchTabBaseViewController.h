//
//  NaviSearchTabBaseViewController.h
//  BuildersAccess
//
//  Created by April on 10/31/15.
//  Copyright © 2015 eloveit. All rights reserved.
//

#import "fathercontroller.h"

@interface NaviSearchTabBaseViewController : fathercontroller
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tbview;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@end
