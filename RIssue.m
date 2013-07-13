//
//  RIssue.m
//  RMag
//
//  Created by Robin Qu on 13-7-13.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RIssue.h"

@implementation RIssue

- (id)initWithObject:(id)object
{
    self = [self init];
    if (self) {
        [self setupWithObject:object];
    }
    return self;
}

- (void)setupWithObject:(id)object
{
    self.uuid = object[@"uuid"];
    self.name = object[@"name"];
    self.coverImage = [NSURL URLWithString:object[@"cover"]];
    self.assetURL = [NSURL URLWithString:object[@"asset"]];
    self.summary = object[@"summary"];
    self.utime = [NSDate dateWithTimeIntervalSince1970:[object[@"utime"] longLongValue]];
    self.state = NSIssueStateInfoReady;
}

- (NSDictionary *)dictionary
{
    return @{
             @"uuid": self.uuid,
             @"name": self.name,
             @"cover": self.coverImage.absoluteString,
             @"asset": self.assetURL.absoluteString,
             @"summary": self.summary,
             @"utime": @([self.utime timeIntervalSince1970])
             };
}

@end
