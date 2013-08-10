//
//  RPDFToolbarButton.h
//  RMag
//
//  Created by Robin Qu on 13-8-10.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPDFToolbarButton : UIButton

+ (id)backButton;
+ (id)tocButton;
+ (id)hintButton;

- (void)setPosition:(CGPoint)position;

@end
