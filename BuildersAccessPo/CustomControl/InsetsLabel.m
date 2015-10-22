//
//  InsetsLabel.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-11.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "InsetsLabel.h"

@implementation InsetsLabel

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    return self;
}
-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, 10, 0, 0))];
}
@end
