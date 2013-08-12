//
//  RPDFPageViewController.m
//  RMag
//
//  Created by Robin Qu on 13-8-9.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RPDFPageViewController.h"
#import <objc/runtime.h>
#import "RPDFReaderViewController.h"

@interface RPDFPageViewController ()
{
    CGPDFDocumentRef _PDFDocRef;
}
@end

@implementation RPDFPageViewController

static char RPDFReaderViewControllerKey;

- (RPDFReaderViewController *)PDFReaderViewController
{
    id controller = objc_getAssociatedObject(self,
                                             &RPDFReaderViewControllerKey);
    return controller;
}

- (void)setPDFReaderViewController:(RPDFReaderViewController *)PDFReaderViewController
{
    [self willChangeValueForKey:@"PDFReaderViewController"];
    objc_setAssociatedObject( self,
                             &RPDFReaderViewControllerKey,
                             PDFReaderViewController,
                             OBJC_ASSOCIATION_ASSIGN );
    [self didChangeValueForKey:@"PDFReaderViewController"];
}

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
        CGRect rect = {CGPointZero, self.view.bounds.size};
        CGPDFPageRef page = CGPDFDocumentGetPage(_PDFDocRef, self.pageNumber);
        self.pageView = [[RPDFPageView alloc] initWithFrame:rect document:_PDFDocRef page:page];
        [self.view addSubview:self.pageView];
        self.pageView.centerSingleTap = NO;
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




@end