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

+ (id)sharedInstance;
- (void)updateDocument:(CGPDFDocumentRef)document;

@end

@implementation RTOCViewController
{
    CGPDFDocumentRef _document;
}

+ (id)sharedInstance
{
    static RTOCViewController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RTOCViewController alloc] initWithNibName:nil bundle:nil];
    });
    return instance;
}

+ (id)sharedTOCForDocument:(CGPDFDocumentRef)document
{
    id instance = [self sharedInstance];
    [instance updateDocument:document];
    return instance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.tableView registerClass:[RTOCCell class]  forCellReuseIdentifier:RTOCCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDocument:(CGPDFDocumentRef)document
{
    if (document != _document) {
        CGPDFDocumentRelease(_document);
        _document = document;
        self.outlines = [RPDFDocumentOutline outlineFromDocument:document password:@""];
        [self.tableView reloadData];
        CGPDFDocumentRetain(_document);
    }
}

#pragma mark - Components
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTableHeaderHeight, self.view.bounds.size.width, self.view.bounds.size.height -kTableHeaderHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, kTableHeaderHeight)];
        [_backButton setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (void)goBack
{
    [self.pageViewControler hideTOC];
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

@end