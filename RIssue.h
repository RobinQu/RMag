//
//  RIssue.h
//  RMag
//
//  Created by Robin Qu on 13-7-13.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, RIssueState) {
    NSIssueStateNone = 0,
    NSIssueStateInfoReady = 1 << 0,
    NSIssueDownloading = 1 << 1,
    NSIssueDownloaded = 1 << 2,
    NSIssueUpdateAvailable = 1 << 3,
    NSIssueRevoked = 1 << 4,
    NSIssueValidating = 1 << 5
};

@interface RIssue : NSObject

@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) NSString *name;;
@property (nonatomic, retain) NSURL *coverImage;
@property (nonatomic, retain) NSURL *assetURL;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSDate *utime;
@property (nonatomic, assign) RIssueState state;

- (id)initWithObject:(id)object;
- (void)setupWithObject:(id)object;
- (NSDictionary *)dictionary;

@end