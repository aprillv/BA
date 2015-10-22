//
//  projectls.h
//  BuildersAccess
//
//  Created by amy zhao on 12-12-11.
//  Copyright (c) 2012年 lovetthomes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fathercontroller.h"
#import "CustomKeyboard.h"

@interface projectls : fathercontroller<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate ,UIAlertViewDelegate, CustomKeyboardDelegate>{
    CustomKeyboard *keyboard;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchtxt;

@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@property (weak, nonatomic) IBOutlet UITableView *tbview;
@property  int islocked;
@end
