//
//  RTOCViewController.h
//  RMag
//
//  Created by Robin Qu on 13-8-11.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPDFReaderToolbarViewController.h"
#import "RToolbarHelperViewController.h"

@class RPDFPageViewController, RPDFReaderToolbarViewController;

@interface RTOCViewController : RToolbarHelperViewController <UITableViewDataSource, UITableViewDelegate, RPDFTOCVC>

@end
