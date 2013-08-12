//
//  RToolbarHelperViewController.h
//  RMag
//
//  Created by Robin Qu on 13-8-12.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPDFReaderToolbarViewController.h"

static const CGFloat kTransitionInterval = .3f;

@interface RToolbarHelperViewController : UIViewController

@property (nonatomic, assign) RPDFReaderToolbarViewController *toolbarViewController;

+ (id)sharedInstance;
- (void)showForToolbarViewController:(RPDFReaderToolbarViewController *)toolbarVC;
- (void)dismiss;

@end
