//
//  RTOCCell.m
//  RMag
//
//  Created by Robin Qu on 13-8-11.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RTOCCell.h"

@implementation RTOCCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UIView *selectedBG = [[UIView alloc] initWithFrame:self.frame];
        selectedBG.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
        self.selectedBackgroundView = selectedBG;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setEntry:(RPDFOutlineEntry *)entry
{
    if (entry != _entry) {
        [self willChangeValueForKey:@"entry"];
        _entry = entry;
        self.textLabel.text = entry.title;
        [self didChangeValueForKey:@"entry"];
    }
}

@end
