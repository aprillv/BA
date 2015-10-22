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

    UIActivityIndicatorView *_spinner;
    NSMutableData *_data;
}

@property (nonatomic, retain) UIScrollView      *scrollView;

@property (nonatomic, retain) MRZoomScrollView  *zoomScrollView;
@property(copy, nonatomic) NSString *xurl;
@end
