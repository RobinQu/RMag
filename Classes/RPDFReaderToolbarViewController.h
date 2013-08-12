//
//  RPDFReaderToolbarViewController.h
//  RMag
//
//  Created by Robin Qu on 13-8-9.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

@class RPDFPageViewController, RPDFToolbarButton, RPDFReaderToolbarViewController;

#import <UIKit/UIKit.h>

@protocol RPDFHelperVC <NSObject>

- (void)showForToolbarViewController:(RPDFReaderToolbarViewController *)toolbarVC;
- (void)dismiss;

@end


@protocol RPDFTOCVC <RPDFHelperVC>

- (void)updateWithOutlines:(NSArray *)outlines;

@end

@protocol RPDFHintVC <RPDFHelperVC>

@end

static NSString *const kEntryRequestNotification = @"entry-request";

@protocol RPDFReaderToolbarDelegate <NSObject>

- (void)toolbarViewController:(RPDFReaderToolbarViewController *)toobarViewController didTapOnButton:(RPDFToolbarButton *)button;

@optional
- (UIViewController<RPDFTOCVC> *)TOCViewControllerForToolbarViewController:(RPDFReaderToolbarViewController *)toolbarVC;
- (UIViewController<RPDFHintVC> *)HintViewControllerForToolbarViewController:(RPDFReaderToolbarViewController *)toolbarVC;

@end


@interface RPDFReaderToolbarViewController : UIViewController

@property (nonatomic, assign) id<RPDFReaderToolbarDelegate> delegate;
@property (nonatomic, retain) UIView *buttonContainer;
@property (nonatomic, assign) UIViewController<RPDFHintVC> *hintViewController;
@property (nonatomic, assign) UIViewController<RPDFTOCVC> *TOCViewController;

+ (void)show;
+ (void)configureDelegate:(id<RPDFReaderToolbarDelegate>)delegate;
+ (void)dismiss;
- (void)dismiss;
- (void)showTOCForDocument:(CGPDFDocumentRef)document;
- (void)hideTOC;
- (void)showHint;
- (void)hideHint;

@end