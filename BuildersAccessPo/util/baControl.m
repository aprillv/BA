//
//  baControl.m
//  BuildersAccess
//
//  Created by roberto ramirez on 9/24/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "baControl.h"
#import "Mysql.h"
#import "NSString+Color.h"
#import <QuartzCore/QuartzCore.h>

@implementation baControl

+ (UIButton *) getGrayButton{
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btn1 setTitleColor:[Mysql getBlueTextColor] forState:UIControlStateNormal];
//    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    Mysql *msql =[[Mysql alloc]init];
//    UIImage * u =[msql createImageWithColor:[UIColor lightGrayColor] ];
//    
//    [btn1 setBackgroundImage:u forState:UIControlStateNormal];
//    [btn1 setBackgroundImage:[msql createImageWithColor:[@"007add" toColor] ] forState:UIControlStateHighlighted];
//    btn1.contentMode=UIViewContentModeScaleAspectFill;
//    btn1.clipsToBounds=YES;
//    btn1.layer.cornerRadius = 5.0;
//    btn1.layer.borderColor=[UIColor darkGrayColor].CGColor;
//    btn1.layer.borderWidth=1.0f;
//    
//    
//    
////    btn1.titleLabel.font=[UIFont systemFontOfSize:15.0];
//    return btn1;
    
   UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [loginButton setFrame:CGRectMake(10, y, 300, 44)];
//    [loginButton setTitle:btntitle forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
     [loginButton setBackgroundImage:[[UIImage imageNamed:@"grayButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 5.0;
//    loginButton.layer.borderWidth=1.0f;
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return loginButton;
    
}

@end
