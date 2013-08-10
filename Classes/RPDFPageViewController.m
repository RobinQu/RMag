//
//  RPDFPageViewController.m
//  RMag
//
//  Created by Robin Qu on 13-8-9.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RPDFPageViewController.h"
#import "RPDFPageView.h"
#import "RPDFReaderToolbarViewController.h"



@interface RPDFPageViewController ()
{
    CGPDFDocumentRef _PDFDocRef;
}
@end

@implementation RPDFPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDocumentRef:(CGPDFDocumentRef)document atPage:(NSUInteger)page
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.pageNumber = page;
        _PDFDocRef = document;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGPDFPageRef page = CGPDFDocumentGetPage(_PDFDocRef, self.pageNumber);
    CGRect rect = {CGPointZero, self.view.bounds.size};
    self.pageView = [[RPDFPageView alloc] initWithFrame:rect document:_PDFDocRef page:page];
    self.pageView.tiledScrollViewDelegate = self;
    self.pageView.centerSingleTap = NO;
    [self.view addSubview:self.pageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JCTiledScrollViewDelegate
- (void)tiledScrollView:(JCTiledScrollView *)scrollView didReceiveSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [RPDFReaderToolbarViewController showForPageViewController:self];
}

- (JCAnnotationView *)tiledScrollView:(JCTiledScrollView *)scrollView viewForAnnotation:(id<JCAnnotation>)annotation
{
    return nil;
}

@end