//
//  RIssuesDataSource.h
//  RMag
//
//  Created by Robin Qu on 13-7-13.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RIssue, RIssueManifest, RIssuesDataSource, RAsset;


@protocol RIssueDataSourceDelegate <NSObject>


- (void)dataSource:(RIssuesDataSource *)dataSource downloadDidCompleteForIssue:(RIssue *)issue;
- (void)dataSource:(RIssuesDataSource *)dataSource downloadDidFailForIssue:(RIssue *)issue withError:(NSError *)error;
- (void)dataSource:(RIssuesDataSource *)dataSource issue:(RIssue *)issue downloadProgressDidChange:(long long)bytesRead :(long long)bytesExpectedToBeRead;

@end

@interface RIssuesDataSource : NSObject

@property (nonatomic, retain) NSURL *publiserURL;
@property (nonatomic, assign) id<RIssueDataSourceDelegate> delegate;

//update
- (id)initWithPublisherURL:(NSURL *)url;
- (void)updateWithCallback:(void(^)(NSError *error))callback;

//Issues API
- (RIssue *)issueWithUUID:(NSString *)uuid;
- (void)downloadIssue:(RIssue *)issue;


@end
