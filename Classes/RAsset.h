//
//  RAsset.h
//  RMag
//
//  Created by Robin Qu on 13-7-14.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

@class RIssue;

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, RAssetState) {
    RAssetStateUnknown = 0,
    RAssetStateNormal = 1 << 0,
    RAssetStateDownloading = 1 << 1,
    RAssetStatePartialDownloaded = 1 << 2,
    RAssetStateDeleted = 1 << 3,
    RAssetStateCorrupted = 1 << 4
};


@interface RAsset : NSObject

@property (nonatomic, assign) RAssetState state;
@property (nonatomic, retain) NSURL *localURL;
@property (nonatomic, retain) NSURL *remoteURL;


+ (id)assetForIssue:(RIssue *)issue;
+ (NSURL *)assetDirectory;


@end
