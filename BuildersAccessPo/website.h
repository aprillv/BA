//
//  website.h
//  BuildersAccess
//
//  Created by amy zhao on 13-5-5.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"

@interface website : fathercontroller<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview1;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property (nonatomic, retain) NSString *Url;
@end
