//
//  RTOCCell.h
//  RMag
//
//  Created by Robin Qu on 13-8-11.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPDFDocumentOutline.h"

static NSString *const RTOCCellIdentifier = @"TOC Cell";

@interface RTOCCell : UITableViewCell

@property (nonatomic, retain) RPDFOutlineEntry *entry;

@end
