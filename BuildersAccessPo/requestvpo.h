//
//  requestvpo.h
//  BuildersAccess
//
//  Created by amy zhao on 13-7-15.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"
#import "wcfRequestedPODetail.h"

@interface requestvpo : fathercontroller<UIAlertViewDelegate>{
    
    int xtype;
    wcfRequestedPODetail *pd;
    NSString *kv;
}


@property(copy, nonatomic) NSString *idnum;
@property(copy, nonatomic) NSString *xcode;
//1 from for approve
//2 from development
//3 from project
@property int fromforapprove;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property (weak, nonatomic) IBOutlet UIScrollView *uv;

@end
