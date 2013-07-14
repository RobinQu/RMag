//
//  RIssuesDataSource.m
//  RMag
//
//  Created by Robin Qu on 13-7-13.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RIssuesDataSource.h"
#import <AFNetworking/AFJSONRequestOperation.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "RIssueManifest.h"
#import "RIssue.h"
#import "RAsset.h"

#define MANIFEST_REVOKED_ISSUES_KEY @"revoked"
#define MANIFEST_NEW_ISSUES_KEY @"new"
#define MANIFEST_UPDATED_ISSUES_KEY @"updated"


//Sample manifest.json

@interface RIssuesDataSource ()

@end

@implementation RIssuesDataSource

+ (void)initialize
{
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/plain", nil]];
}

- (id)initWithPublisherURL:(NSURL *)url
{
    self = [self init];
    if (self) {
        self.publiserURL = url;
    }
    return self;
}

- (void)updateWithCallback:(void (^)(NSError *))callback
{
    static AFJSONRequestOperation *operation = nil;
    if (operation) {
        [operation cancel];
    }
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[self.publiserURL URLByAppendingPathComponent:@"manifest.json"]];
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self processManifest:JSON];
            dispatch_async( dispatch_get_main_queue(), ^{
                if (callback) {
                    callback(nil);
                }
            });
        });
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (callback) {
            callback(error);
        }
    }];
}

- (void)processManifest:(NSDictionary *)JSON
{
    RIssueManifest *manifest = [RIssueManifest sharedManifest];
    if ([RIssueManifest hasDefaultManifest]) {//update local manifest
        //revoke issues
        NSArray *revokedIssuesData = JSON[MANIFEST_REVOKED_ISSUES_KEY];
        if (revokedIssuesData && revokedIssuesData.count) {
            [revokedIssuesData setValue:@(RIssueStateRevoked) forKey:@"state"];
            for (NSString *uuid in revokedIssuesData) {
                [self revokeIssueByUUID:uuid];
            }
        }
        //update issues
        NSArray *updatedIssuesData = JSON[MANIFEST_UPDATED_ISSUES_KEY];
        if (updatedIssuesData && updatedIssuesData.count) {
            [updatedIssuesData setValue:@(RIssueStateUpdateAvailable) forKey:@"state"];
            for (NSDictionary *obj in updatedIssuesData) {
                [self updateIssueWithObject:obj];
            }
            
        }
        //new issues
        NSArray *newIssuesData = JSON[MANIFEST_NEW_ISSUES_KEY];
        if (newIssuesData && newIssuesData.count) {
            [newIssuesData setValue:@(RIssueStateNew) forKey:@"state"];
            for (NSDictionary *obj in newIssuesData) {
                [self newIssueWithObject:obj];
            }
        }
        manifest.utime = [NSDate dateWithTimeIntervalSince1970:[JSON[@"utime"] integerValue]];
    } else {
        [JSON setValue:@(RIssueStateNew) forKeyPath:@"new.state"];
        [manifest setupWithObject:@{
                                    @"utime": JSON[@"utime"],
                                    @"issues": JSON[@"issues"]
                                    }];
    }
    [manifest synchronize];
}


- (void)revokeIssueByUUID:(NSString *)uuid
{
    NSAssert(uuid, @"shuld have uuid for issue");
    RIssueManifest *manifest = [RIssueManifest sharedManifest];
    RIssue *issue = [self issueWithUUID:uuid];
    if (issue) {
        issue.state = RIssueStateRevoked;
        [manifest.issues removeObject:issue];
    }
}

- (void)updateIssueWithObject:(NSDictionary *)object
{
    NSAssert(object[@"uuid"], @"shuld have uuid in issue data");
    RIssue *issue = [self issueWithUUID:object[@"uuid"]];
    [issue setupWithObject:object];
    issue.state = RIssueStateUpdateAvailable;
}

- (void)newIssueWithObject:(NSDictionary *)object
{
    NSAssert(object[@"uuid"], @"shuld have uuid in issue data");
    RIssue *issue = [[RIssue alloc] initWithObject:object];
    [issue setupWithObject:object];
    issue.state = RIssueStateNew;
    [[[RIssueManifest sharedManifest] issues] addObject:issue];
}

- (RIssue *)issueWithUUID:(NSString *)uuid
{
    RIssueManifest *manifest = [RIssueManifest sharedManifest];
    NSSet *issues = manifest.issues;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid = %@", uuid];
    NSSet* wanted = [issues filteredSetUsingPredicate:predicate];
    if (wanted.count) {
        return wanted.anyObject;
    }
    return nil;
}

- (void)downloadIssue:(RIssue *)issue
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:issue.asset.remoteURL];
        RAsset *asset = [RAsset assetForIssue:issue];
        asset.state = RAssetStateDownloading;
        NSString *mainFileName = [NSString stringWithFormat:@"%f", [issue.utime timeIntervalSince1970]];
        NSOutputStream *output = [NSOutputStream outputStreamWithURL:[asset.localURL URLByAppendingPathComponent:mainFileName] append:NO];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        operation.outputStream = output;
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                asset.state = RAssetStateNormal;
                [self.delegate dataSource:self downloadDidCompleteForIssue:issue];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                asset.state = RAssetStateCorrupted;
                [self.delegate dataSource:self downloadDidFailForIssue:issue withError:error];
            });
        }];
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            [self.delegate dataSource:self issue:issue downloadProgressDidChange:totalBytesRead :totalBytesExpectedToRead ? totalBytesExpectedToRead + totalBytesRead : 0];
        }];
        [operation start];
    });
}


@end
