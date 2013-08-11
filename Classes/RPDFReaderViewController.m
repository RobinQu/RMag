//
//  RPDFReaderViewController.m
//  RMag
//
//  Created by Robin Qu on 13-8-9.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RPDFReaderViewController.h"
//override CG functions
#import <JCTiledScrollView/CGPDFDocument.h>
#import "RPDFPageViewController.h"
#import "RPDFReaderToolbarViewController.h"
#import "RPDFDocumentOutline.h"

@interface RPDFReaderViewController ()
{
    CGPDFDocumentRef _PDFDocRef;
}

@property (nonatomic, retain) NSURL *documentURL;

@end

@implementation RPDFReaderViewController

- (void)dealloc
{
    CGPDFDocumentRelease(_PDFDocRef);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDocumentURL:(NSURL *)url
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.documentURL = url;
        //second argument is empty, as we don't support PDF with password for now
        _PDFDocRef =  CGPDFDocumentCreateX((__bridge CFURLRef)url, @"");
        self.numberOfPages = CGPDFDocumentGetNumberOfPages(_PDFDocRef);
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    NSRange theRange = { .location = 1, .length = 1 };
    if (self.pageViewController.spineLocation == UIPageViewControllerSpineLocationMid)
    {
        theRange = (NSRange){ .location = 0, .length = 2 };
        self.pageViewController.doubleSided = YES;
    }
    NSArray *theViewControllers = [self pageViewControllersForRange:theRange];
    [self.pageViewController setViewControllers:theViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEntryRequestNotification:) name:kEntryRequestNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleEntryRequestNotification:(NSNotification *)notification
{
    RPDFOutlineEntry *entry = [notification.userInfo valueForKey:@"entry"];
    if ([entry.target isKindOfClass:[NSURL class]]) {
        //TODO handle URL target
    } else {
        NSInteger pageNo = [entry.target integerValue];
        [self turnToPage:pageNo];
    }
}

- (void)turnToPage:(NSInteger)page
{
    RPDFPageViewController *pageVC = [self pageViewControllerAtPage:page];
    
    NSArray *pageNumbers = [self.pageViewController.viewControllers valueForKey:@"pageNumber"];
    NSInteger maxPageNo = [[pageNumbers valueForKeyPath:@"@max.intValue"] integerValue];
    [self.pageViewController setViewControllers:@[pageVC] direction: page > maxPageNo ?   UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

- (NSArray *)pageViewControllersForRange:(NSRange)inRange
{
    NSMutableArray *thePages = [NSMutableArray array];
    for (NSUInteger N = inRange.location; N != inRange.location + inRange.length; ++N)
    {
        [thePages addObject:[self pageViewControllerAtPage:N]];
    }
    return(thePages);
}
- (RPDFPageViewController *)pageViewControllerAtPage:(NSUInteger)page
{
    RPDFPageViewController *pageVC = [[RPDFPageViewController alloc] initWithDocumentRef:_PDFDocRef atPage:page];
    pageVC.PDFReaderViewController = self;
    return pageVC;
}

#pragma mark - UIPageViewController delegate methods
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    RPDFPageViewController *theViewController = (RPDFPageViewController *)viewController;
    NSUInteger previousPageNumber  = theViewController.pageNumber - 1;
    if (previousPageNumber > self.numberOfPages) {
        return NULL;
    }
    if (previousPageNumber == 0 && UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
    {
        return NULL;
    }
    return [self pageViewControllerAtPage:previousPageNumber];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    RPDFPageViewController *theViewController = (RPDFPageViewController *)viewController;
    NSUInteger nextPageNumber =  theViewController.pageNumber + 1;
    if (nextPageNumber > self.numberOfPages) {
        return NULL;
    }
    return [self pageViewControllerAtPage:nextPageNumber];
    
}


@end
