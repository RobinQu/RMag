//
//  RIssue.h
//  RMag
//
//  Created by Robin Qu on 13-7-13.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RAsset;

typedef NS_OPTIONS(NSInteger, RIssueState) {
    RIssueStateUnkown = 0,
    RIssueStateNormal = 1 << 0,
    RIssueStateNew = 1 << 1,
    RIssueStateUpdateAvailable = 1 << 2,
    RIssueStateRevoked = 1 << 3
};

@interface RIssue : NSObject

@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) NSString *name;;
@property (nonatomic, retain) NSURL *coverImageURL;
@property (nonatomic, retain) NSURL *assetURL;
@property (nonatomic, retain) RAsset *asset;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSDate *utime;
@property (nonatomic, assign) RIssueState state;

- (id)initWithObject:(id)object;
- (void)setupWithObject:(id)object;
- (NSDictionary *)dictionary;

@end