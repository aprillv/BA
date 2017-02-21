//
//  checkbutton.m
//  BuildersAccess
//
//  Created by amy zhao on 13-1-25.
//  Copyright (c) 2013年 lovetthomes. All rights reserved.
//

#import "checkbutton.h"

@implementation checkbutton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupButton:(NSString *)title image:(UIImage *)image description:(NSString *) description {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 50)];
    [self addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked.png"]];
                              [self addSubview:imageView];
                              
                              UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 200, 100)];
                              [self addSubview:descriptionLabel];
                              }
                              
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
