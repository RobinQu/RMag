//
//  RPDFPageViewController.h
//  RMag
//
//  Created by Robin Qu on 13-8-9.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPDFPageView.h"

@class RPDFReaderViewController;

@interface RPDFPageViewController : UIViewController

- (id)initWithDocumentRef:(CGPDFDocumentRef)document atPage:(NSUInteger)page;

@property (nonatomic, assign) RPDFReaderViewController *PDFReaderViewController;

@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, retain) RPDFPageView *pageView;

@end