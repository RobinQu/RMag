//
//  RPDFToolbarButton.m
//  RMag
//
//  Created by Robin Qu on 13-8-10.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RPDFToolbarButton.h"

@implementation RPDFToolbarButton

+ (id)buttonWithImageNamed:(NSString *)name
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[name stringByAppendingString:@"-active"]] forState:UIControlStateHighlighted];
    return button;
}

+ (id)backButton
{
    UIButton *button = [self buttonWithImageNamed:@"reader-back-icon"];
    return button;
}

+ (id)tocButton
{
    UIButton *button = [self buttonWithImageNamed:@"reader-menu-icon"];
    return button;
}

+ (id)hintButton
{
    UIButton *button = [self buttonWithImageNamed:@"reader-bubble-icon"];
    return button;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPosition:(CGPoint)position
{
    self.frame = CGRectMake(position.x, position.y, 60, 60);
}


@end
