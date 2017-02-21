//
//  project.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-11.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"

@interface project : fathercontroller<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource,UIDocumentInteractionControllerDelegate, UIActionSheetDelegate>{
    UIDocumentInteractionController *docController;
     NSString *xemail;
    UITableView *tbview;
    NSMutableArray *qllist;
}

@property (nonatomic, strong) UIDocumentInteractionController *docController;

@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property(retain, nonatomic) NSString *idproject;
@end
