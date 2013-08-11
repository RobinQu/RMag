//
//  RPDFReaderToolbarViewController.m
//  RMag
//
//  Created by Robin Qu on 13-8-9.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RPDFReaderToolbarViewController.h"
#import "RPDFPageViewController.h"
#import "RPDFToolbarButton.h"
#import "RTOCViewController.h"
#import <StackBluriOS/UIImage+StackBlur.h>


static const CGFloat kTransitionInterval = .3f;
static const CGFloat kImageBlurRadius = 30.0f;

@interface RPDFReaderToolbarViewController ()

+ (id)sharedInstance;

@property (nonatomic, retain) UIImageView *backgroundView;

@property (nonatomic, retain) RPDFToolbarButton *backButton;
@property (nonatomic, retain) RPDFToolbarButton *tocButton;
@property (nonatomic, retain) RPDFToolbarButton *hintButton;

@end

@implementation RPDFReaderToolbarViewController

+ (id)sharedInstance
{
    static RPDFReaderToolbarViewController *toolbarVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toolbarVC = [[RPDFReaderToolbarViewController alloc] initWithNibName:nil bundle:nil];
    });
    return toolbarVC;
}

+ (void)configureDelegate:(id<RPDFReaderToolbarDelegate>)delegate
{
    [[self sharedInstance] setDelegate:delegate];
}

+ (void)showForPageViewController:(RPDFPageViewController *)pageViewController
{
    UIView *backView = pageViewController.view;
    UIGraphicsBeginImageContext(backView.bounds.size);
    [backView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    RPDFReaderToolbarViewController *instance = [self sharedInstance];
    [instance updateBackground:viewImage];
    
    [pageViewController addChildViewController:instance];
    [pageViewController.view addSubview:instance.view];
    instance.view.frame = CGRectMake(0, 0, pageViewController.view.bounds.size.width, pageViewController.view.bounds.size.height);
    [UIView animateWithDuration:kTransitionInterval animations:^{
        instance.view.alpha = 1;
        [instance didMoveToParentViewController:pageViewController];
    }];
}

+ (void)dismiss
{
    RPDFReaderToolbarViewController *instance = [self sharedInstance];
    instance.backgroundView.hidden = YES;
    [instance dismiss];
}

- (void)dismiss
{
    [UIView animateWithDuration:kTransitionInterval animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)didPanOnToolbar
{
//    NSLog(@"do nothing for panning; just prevent page view controller to slide");
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
    self.view.alpha = 0;
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    [self.view addSubview:self.backgroundView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnBackgroundView)];
//    [self.view addGestureRecognizer:tap];
    self.buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 60)];
    self.buttonContainer.center = self.view.center;
    
    self.backButton = [RPDFToolbarButton backButton];
    [self.backButton setPosition:CGPointMake(0, 0)];
    [self.backButton addTarget:self action:@selector(informDelegateOfTapOnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonContainer addSubview:self.backButton];
    self.tocButton = [RPDFToolbarButton tocButton];
    [self.tocButton setPosition:CGPointMake(80, 0)];
    [self.buttonContainer addSubview:self.tocButton];
    [self.tocButton addTarget:self action:@selector(informDelegateOfTapOnButton:) forControlEvents:UIControlEventTouchUpInside];
    self.hintButton = [RPDFToolbarButton hintButton];
    [self.hintButton setPosition:CGPointMake(160, 0)];
    [self.buttonContainer addSubview:self.hintButton];
    [self.hintButton addTarget:self action:@selector(informDelegateOfTapOnButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.buttonContainer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view insertSubview:self.backgroundView atIndex:0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnBackgroundView)];
    [self.backgroundView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanOnToolbar)];
    [self.view addGestureRecognizer:pan];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    for (UIGestureRecognizer *gesture in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gesture];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapOnBackgroundView
{
    [[self class] dismiss];
}

- (void)informDelegateOfTapOnButton:(RPDFToolbarButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolbarViewController:didTapOnButton:)]) {
        [self.delegate toolbarViewController:self didTapOnButton:button];
    }
}

- (void)updateBackground:(UIImage *)image
{
    self.backgroundView.image = [image stackBlur:kImageBlurRadius];
    self.backgroundView.hidden = NO;
}

- (UIImageView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _backgroundView.alpha = 0.8;
        _backgroundView.hidden = YES;
        _backgroundView.userInteractionEnabled = YES;
    }
    return _backgroundView;
}

- (void)showTOCForDocument:(CGPDFDocumentRef)document
{
    RTOCViewController *toc = [RTOCViewController sharedTOCForDocument:document];
    toc.toolbarViewController = self;
    [self addChildViewController:toc];
    toc.view.alpha = 0;
    [self.view addSubview:toc.view];
    [UIView animateWithDuration:kTransitionInterval animations:^{
        toc.view.alpha = 1;
        self.buttonContainer.alpha = 0;
    } completion:^(BOOL finished) {

    }];
}

- (void)hideTOC
{
    RTOCViewController *toc = [RTOCViewController sharedInstance];
    [UIView animateWithDuration:kTransitionInterval animations:^{
        toc.view.alpha = 0;
        self.buttonContainer.alpha = 1;
    } completion:^(BOOL finished) {
        [toc removeFromParentViewController];
        [toc.view removeFromSuperview];
    }];
}

@end
