//
//  RPDFReaderToolbarViewController.h
//  RMag
//
//  Created by Robin Qu on 13-8-9.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

@class RPDFPageViewController, RPDFToolbarButton, RPDFReaderToolbarViewController;

#import <UIKit/UIKit.h>


@protocol RPDFReaderToolbarDelegate <NSObject>

- (void)toolbarViewController:(RPDFReaderToolbarViewController *)toobarViewController didTapOnButton:(RPDFToolbarButton *)button;

@end

@interface RPDFReaderToolbarViewController : UIViewController


@property (nonatomic, assign) id<RPDFReaderToolbarDelegate> delegate;

+ (void)showForPageViewController:(RPDFPageViewController *)pageViewController;
+ (void)configureDelegate:(id<RPDFReaderToolbarDelegate>)delegate;
+ (void)dismiss;
- (void)dismiss;


@end