//
//  RPDFReaderToolbarViewController.h
//  RMag
//
//  Created by Robin Qu on 13-8-9.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

@class RPDFPageViewController;

#import <UIKit/UIKit.h>


@interface RPDFReaderToolbarViewController : UIViewController

+ (void)showForPageViewController:(RPDFPageViewController *)pageViewController;
+ (void)dismiss;


@end