//
//  RPDFPageViewController.h
//  RMag
//
//  Created by Robin Qu on 13-8-9.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JCTiledScrollView/JCTiledPDFScrollView.h>
#import "RPDFReaderToolbarViewController.h"

@class RPDFPageView, RPDFReaderViewController;

@interface RPDFPageViewController : UIViewController <JCTiledScrollViewDelegate, RPDFReaderToolbarDelegate>

- (id)initWithDocumentRef:(CGPDFDocumentRef)document atPage:(NSUInteger)page;

- (void)showTOC;
- (void)hideTOC;

@property (nonatomic, assign) RPDFReaderViewController *PDFReaderViewController;

@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, retain) RPDFPageView *pageView;

@end