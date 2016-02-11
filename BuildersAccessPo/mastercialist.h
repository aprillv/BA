//
//  mastercialist.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-2.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "CustomKeyboard.h"

@interface mastercialist : fathercontroller<UISearchBarDelegate, CustomKeyboardDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>{
    CustomKeyboard *keyboard;
   
}

@property (strong, nonatomic) IBOutlet UITableView *tbview;
@property (weak, nonatomic) IBOutlet UISearchBar *searchtxt;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property int type;
@property (retain, nonatomic) NSMutableArray *rtnlist;
@property (retain, nonatomic) NSMutableArray *rtnlist1;
@end
