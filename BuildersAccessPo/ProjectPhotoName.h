//
//  ProjectPhotoName.h
//  BuildersAccess
//
//  Created by roberto ramirez on 11/1/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "fathercontroller.h"

@class wcfKeyValueItem;

@interface ProjectPhotoName : fathercontroller
@property(retain, nonatomic) NSString *idproject;
@property(retain, nonatomic) UIImage *imgsss;
@property(retain, nonatomic) wcfKeyValueItem *ki;
@property bool isDevelopment;
@property bool isPhoto;
@end
