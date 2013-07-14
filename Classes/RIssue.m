//
//  RIssue.m
//  RMag
//
//  Created by Robin Qu on 13-7-13.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RIssue.h"
#import "RAsset.h"

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
    self.coverImageURL = [NSURL URLWithString:object[@"cover"]];
    self.assetURL = [NSURL URLWithString:object[@"asset"]];
    self.summary = object[@"summary"];
    self.utime = [NSDate dateWithTimeIntervalSince1970:[object[@"utime"] longLongValue]];
    if (object[@"state"]) {
        self.state = [object[@"state"] integerValue];
    } else {
        self.state = RIssueStateUnkown;
    }
    RAsset *asset = [RAsset assetForIssue:self];
}

- (NSDictionary *)dictionary
{
    return @{
             @"uuid": self.uuid,
             @"name": self.name,
             @"cover": self.coverImageURL.absoluteString,
             @"asset": self.asset.remoteURL.absoluteString,
             @"summary": self.summary,
             @"utime": @([self.utime timeIntervalSince1970]),
             @"state": @(self.state)
             };
}

@end
