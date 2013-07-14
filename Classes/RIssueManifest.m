//
//  RIssueManifest.m
//  RMag
//
//  Created by Robin Qu on 13-7-13.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RIssueManifest.h"
#import "RIssue.h"

@implementation RIssueManifest

+ (BOOL)hasDefaultManifest
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self pathForDefaultManifest]];
}

+ (NSString *)pathForDefaultManifest
{
    NSString *fp = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"manifest.json"];
    return fp;
}

+ (id)sharedManifest
{
    NSString *fp = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"manifest.json"];
    static RIssueManifest *manifest = nil;
//    if ([[NSFileManager defaultManager] fileExistsAtPath:fp]) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manifest = [[RIssueManifest alloc] initWithURL:[NSURL URLWithString:fp]];
    });
//    }
    return manifest;
}

- (id)initWithURL:(NSURL *)url
{
    self = [self init];
    if (self) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:url.absoluteString]) {
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfURL:url];
            [self setupWithObject:dict];
        }
    }
    return self;
}

- (void)setupWithObject:(id)object
{
    self.utime = object[@"utime"];
    NSArray *issues = object[@"issues"];
    NSMutableSet *set = [NSMutableSet set];
    if (issues && issues.count) {
        for (id obj in issues) {
            [set addObject:[[RIssue alloc] initWithObject:obj]];
        }
    }
    self.issues = set;
}

- (void)synchronize
{
    NSMutableArray *issues = [@[] mutableCopy];
    for (RIssue *issue in self.issues) {
        [issues addObject:[issue dictionary]];
    }
    NSDictionary *data = @{
                           @"utime": @([self.utime timeIntervalSince1970]),
                           @"issues": issues
                           };
    [data writeToURL:self.localURL atomically:YES];
}

@end