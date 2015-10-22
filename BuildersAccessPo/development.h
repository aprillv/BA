//
//  development.h
//  BuildersAccess
//
//  Created by amy zhao on 13-3-11.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"


@interface development : fathercontroller<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource,UIDocumentInteractionControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIDocumentInteractionController *docController;
    NSString *xemail;
}

@property (nonatomic, strong) UIDocumentInteractionController *docController;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property(retain, nonatomic) NSString *idproject;
@end
