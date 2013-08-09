//
//  RDatasourceTest.m
//  RMag
//
//  Created by Robin Qu on 13-7-19.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//


#import "RTestCase.h"
#import "RIssuesDataSource.h"

@interface RDatasourceTest : RTestCase

@end

@implementation RDatasourceTest

- (void)testNewManifest
{
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/manifest.json"];
    RIssuesDataSource *ds = [[RIssuesDataSource alloc] initWithPublisherURL:url];
    __block BOOL done = NO;
    [ds updateWithCallback:^(NSError *error) {
        done = YES;
        XCTAssertNil(error, @"should have no error");
    }];
    [self waitWithTimeout:2.0 forSuccessInBlock:^BOOL{
        return done;
    }];
    
}

@end
