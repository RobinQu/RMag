//
//  RTOCViewController.h
//  RMag
//
//  Created by Robin Qu on 13-8-11.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <UIKit/UIKit.h>



@class RPDFPageViewController, RPDFReaderToolbarViewController;

@interface RTOCViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) RPDFReaderToolbarViewController *toolbarViewController;

+ (id)sharedTOCForDocument:(CGPDFDocumentRef)document;
+ (id)sharedInstance;



@end
