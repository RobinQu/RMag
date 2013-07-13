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

#define ISSUE_REVOKED_KEY @"revoked"
#define ISSUE_DEFAULT_MAIN_FILENAME @"main"


//Sample manifest.json



@interface RIssuesDataSource ()

@property (nonatomic, retain) NSURL *assetDir;

- (void)loadLocalIssuesData;

@end

@implementation RIssuesDataSource

+ (void)initialize
{
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/plain", nil]];
}

- (id)init
{
    if ([super init]) {
        NSFileManager *fm = [NSFileManager defaultManager];
        self.assetDir = [[fm URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:Nil create:YES error:nil] URLByAppendingPathComponent:@"assets"];
        if (![fm createDirectoryAtURL:self.assetDir withIntermediateDirectories:YES attributes:nil error:nil]) {
            //TODO handle this fatal IO error
            abort();
        }
        [self loadLocalIssuesData];
        
    }
    return self;
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

- (void)loadLocalIssuesData
{
    RIssueManifest *manifest = [RIssueManifest sharedManifest];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (manifest) {//we have previously downloaded manifest, and possibly issue assets
        NSURL *url = nil;
        for (RIssue *issue in manifest.issues) {
            url = [self.assetDir URLByAppendingPathComponent:issue.uuid isDirectory:YES];
            if ([fm fileExistsAtPath:url.absoluteString]) {
                issue.state = issue.state & NSIssueDownloaded;
            }
        }
    }
}

- (void)processManifest:(NSDictionary *)JSON
{
    if ([RIssueManifest hasDefaultManifest]) {//update local manifest
        NSArray *issuesData = JSON[@"issues"];
        RIssueManifest *manifest = [RIssueManifest sharedManifest];
        for (id issueData in issuesData) {
            //revoke issues
            BOOL revoked = NO;
            if (issueData[ISSUE_REVOKED_KEY]) {
                revoked = [issueData[ISSUE_REVOKED_KEY] boolValue];
            }
            if (revoked) {
                NSURL *issueURL = [self.assetDir URLByAppendingPathComponent:issueData[@"uuid"] isDirectory:YES];
                [[NSFileManager defaultManager] removeItemAtURL:issueURL error:nil];
            }
            //update manifest
        }
        [manifest setupWithObject:JSON];
        [manifest synchronize];
    } else {
        [JSON writeToFile:[RIssueManifest pathForDefaultManifest] atomically:YES];
    }
}

//- (RIssue *)issueWithName:(NSString *)name
//{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
//    [[[RIssueManifest sharedManifest] issues] filteredSetUsingPredicate:predicate];
//}

- (void)downloadIssue:(RIssue *)issue
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:issue.assetURL];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSURL *issueDir = [self.assetDir URLByAppendingPathComponent: issue.uuid isDirectory:YES];
        if (![fm createDirectoryAtURL:issueDir withIntermediateDirectories:YES attributes:nil error:nil]) {
            abort();
        }
        
        NSString *mainFileName = [NSString stringWithFormat:@"%f", [issue.utime timeIntervalSince1970]];
        NSOutputStream *output = [NSOutputStream outputStreamWithURL:[issueDir URLByAppendingPathComponent:mainFileName] append:NO];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        operation.outputStream = output;
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate dataSource:self downloadDidCompleteForIssue:issue];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
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
