//
//  RAsset.m
//  RMag
//
//  Created by Robin Qu on 13-7-14.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RAsset.h"
#import "RIssue.h"
#import <DTFoundation/DTExtendedFileAttributes.h>

#define ASSET_STATE_FILED_IN_ATTRIBUTES @"asset_state"


@interface RAsset ()


@end

@implementation RAsset

@synthesize state = _state;

+ (id)assetForIssue:(RIssue *)issue
{
    static NSCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [NSCache new];
    });
    if (![cache objectForKey:issue]) {
        RAsset *asset = [RAsset new];
        asset.remoteURL = issue.assetURL;
        asset.localURL = [[self assetDirectory] URLByAppendingPathComponent:issue.uuid];
        if (![[NSFileManager defaultManager] createDirectoryAtURL:asset.localURL withIntermediateDirectories:YES attributes:nil error:nil]) {
            abort();
        }
    }
    
    return [cache objectForKey:issue];
}

+ (NSURL *)assetDirectory
{
    static NSURL *assetDir = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFileManager *fm = [NSFileManager defaultManager];
        assetDir = [[fm URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil] URLByAppendingPathComponent:@"assets"];
    });
    return assetDir;
}

- (RAssetState)state
{
    if (!_state) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.localURL.absoluteString]) {
            DTExtendedFileAttributes *attributes = [[DTExtendedFileAttributes alloc] initWithPath:self.localURL.absoluteString];
            _state = [[attributes valueForAttribute:ASSET_STATE_FILED_IN_ATTRIBUTES] integerValue];
        } else {
            _state = RAssetStateUnknown;
        }
    }
    return _state;
}

- (void)setState:(RAssetState)state
{
    if (state != _state) {
        [self willChangeValueForKey:@"state"];
        _state = state;
        DTExtendedFileAttributes *attributes = [[DTExtendedFileAttributes alloc] initWithPath:self.localURL.absoluteString];
        [attributes setValue:[NSString stringWithFormat:@"%d",state] forAttribute:ASSET_STATE_FILED_IN_ATTRIBUTES];
        [self didChangeValueForKey:@"state"];
    }
}


@end
