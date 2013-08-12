//
//  RPDFReaderViewController.h
//  RMag
//
//  Created by Robin Qu on 13-8-9.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPDFReaderToolbarViewController.h"
#import <JCTiledScrollView/JCTiledPDFScrollView.h>

@class RPDFReaderViewController;

@interface RPDFReaderViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, JCTiledScrollViewDelegate, RPDFReaderToolbarDelegate>

@property (nonatomic, retain) UIPageViewController *pageViewController;
@property (nonatomic, assign) NSUInteger numberOfPages;

- (id)initWithDocumentURL:(NSURL *)url;

- (void)turnToPage:(NSInteger)page;

@end