//
//  po1.h
//  BuildersAccess
//
//  Created by amy zhao on 13-4-23.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "wcfPODetail.h"
#import "MBProgressHUD.h"

@interface po1 : fathercontroller<UIAlertViewDelegate, MBProgressHUDDelegate>{
   
    int xtype;
    wcfPODetail *pd;
    NSString *kv;
    MBProgressHUD* HUD;
}


@property(copy, nonatomic) NSString *idpo1;
@property(copy, nonatomic) NSString *xcode;
//1 from for approve
//2 from development
//3 from project
//4 from multi search
@property int fromforapprove;

@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property (weak, nonatomic) IBOutlet UIScrollView *uv;

@end

