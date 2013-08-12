//
//  RTOCViewController.m
//  RMag
//
//  Created by Robin Qu on 13-8-11.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RTOCViewController.h"
#import "RPDFPageViewController.h"
#import "RPDFDocumentOutline.h"
#import "RTOCCell.h"


static const CGFloat kTableHeaderHeight = 40.0f;

@interface RTOCViewController ()

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *backButton;

@property (nonatomic, retain) NSArray *outlines;

@end

@implementation RTOCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view addSubview:self.titleLabel];
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.backButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateWithOutlines:(NSArray *)outlines
{
    self.outlines = outlines;
    [self.tableView reloadData];
//    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

#pragma mark - Components
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTableHeaderHeight, self.view.bounds.size.width, self.view.bounds.size.height - kTableHeaderHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_tableView registerClass:[RTOCCell class] forCellReuseIdentifier:RTOCCellIdentifier];
    }
    return _tableView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, kTableHeaderHeight)];
        _titleLabel.center = CGPointMake(self.view.center.x, kTableHeaderHeight/2);
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = NSLocalizedString(@"Table of Contents", nil);
    }
    return _titleLabel;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 60, 0, 60, kTableHeaderHeight)];
        [_backButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (void)goBack
{
    //hide toc
    [self.toolbarViewController hideTOC];
    //directly exit toolbar VC
    [self.toolbarViewController dismiss];
}

#pragma mark - UITableViewDataSource methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RTOCCell *cell = nil;
    if ([self.tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:RTOCCellIdentifier forIndexPath:indexPath];
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:RTOCCellIdentifier];
    }
    cell.entry = [self.outlines objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.outlines.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPDFOutlineEntry *entry = [self.outlines objectAtIndex:indexPath.row];
    return entry.level;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPDFOutlineEntry *entry = [self.outlines objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kEntryRequestNotification object:nil userInfo:@{@"entry":entry}];
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    });
    [self.toolbarViewController hideTOC];
    [self.toolbarViewController dismiss];
}

@end