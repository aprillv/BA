//
//  mainmenu.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-9.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"

@interface mainmenu : fathercontroller<UITableViewDataSource, UITableViewDelegate>{
UITableView *ciatbview;
}
@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property(retain, nonatomic) NSString * xget;
@end
