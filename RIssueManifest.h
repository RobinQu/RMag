//
//  RIssueManifest.h
//  RMag
//
//  Created by Robin Qu on 13-7-13.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RIssueManifest : NSObject

@property (nonatomic, retain) NSDate *utime;
@property (nonatomic, retain) NSSet *issues;
@property (nonatomic, retain) NSNumber *sdkVersion;

@property (nonatomic,retain) NSURL *localURL;

+ (id)sharedManifest;
+ (BOOL)hasDefaultManifest;
+ (NSString *)pathForDefaultManifest;
- (id)initWithURL:(NSURL *)url;
- (void)setupWithObject:(id)object;
- (void)synchronize;

@end
