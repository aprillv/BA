//
//  ViewController.h
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRZoomScrollView.h"
#import "fathercontroller.h"

@interface ViewController : fathercontroller<UIScrollViewDelegate>{
    NSMutableData *_data;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property(copy, nonatomic) NSString *xurl;
@end
