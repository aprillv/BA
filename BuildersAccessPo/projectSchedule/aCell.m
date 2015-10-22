//
//  aCell.m
//  BuildersAccess
//
//  Created by roberto ramirez on 9/15/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "aCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation aCell

@synthesize ismore;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)willTransitionToState:(UITableViewCellStateMask)state{
    [super willTransitionToState:state];
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
        for (UIView *subview in self.subviews) {
//            NSLog(@"%@", NSStringFromClass([subview class]));
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]||[NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl_Legacy"]) {
               
                UIButton * _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
                if (ismore) {
                    _deleteButton.frame = CGRectMake(6, 14, 100, 35);
                }else{
                _deleteButton.frame = CGRectMake(6, 8, 100, 35);
                }
                 [_deleteButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
                [_deleteButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_deleteButton setTitle:@"Reschedule" forState:UIControlStateNormal];
                [_deleteButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];

                _deleteButton.layer.cornerRadius = 5.0;
                _deleteButton.layer.borderWidth = 1.0;
                _deleteButton.layer.borderColor=[UIColor darkGrayColor].CGColor;
                _deleteButton.clipsToBounds = YES;
                [subview addSubview:_deleteButton];

            }
        }
    }
}





@end
