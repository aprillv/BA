//
//  viewImage.h
//  BuildersAccess
//
//  Created by amy zhao on 13-7-10.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRZoomScrollView.h"
#import "fathercontroller.h"

@interface viewImage : fathercontroller<UIScrollViewDelegate>{
    NSMutableData *_data;
    UIScrollView *_scrollView;
}
@property (nonatomic, retain) MRZoomScrollView  *zoomScrollView;
@property (nonatomic, retain) UIImage *img;
@end
