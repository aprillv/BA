//
//  ciaList.h
//  BuildersAccess
//
//  Created by amy zhao on 12-12-8.
//  Copyright (c) 2012年 april. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fathercontroller.h"
#import "CustomKeyboard.h"

@interface ciaList : fathercontroller<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UISearchBarDelegate, CustomKeyboardDelegate>{
    CustomKeyboard *keyboard;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchtxt;
@property (nonatomic, retain) NSMutableArray  *ciaListresult;
@property (weak, nonatomic) IBOutlet UITableView *ciatbview;

@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property  int islocked;
@end
