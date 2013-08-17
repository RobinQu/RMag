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
#import "RPDFDocumentOutline.h"
#import <StackBluriOS/UIImage+StackBlur.h>
#import <QuartzCore/QuartzCore.h>

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

+ (void)show
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(window.bounds.size);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    RPDFReaderToolbarViewController *instance = [self sharedInstance];
    [instance updateBackground:viewImage];
    [window addSubview:instance.view];
    
    instance.view.frame = CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height);
    [UIView animateWithDuration:kTransitionInterval animations:^{
        instance.view.alpha = 1;
    }];
}

+ (void)dismiss
{
    RPDFReaderToolbarViewController *instance = [self sharedInstance];
    [instance dismiss];
}

- (void)dismiss
{
    self.backgroundView.hidden = YES;
    [UIView animateWithDuration:kTransitionInterval animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
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
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8];
    [self.view addSubview:self.backgroundView];
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
    
//    UIPanGestureRecognizer *pan =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanOnToolbar)];
//    [self.view addGestureRecognizer:pan];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    for (UIGestureRecognizer *gesture in self.view.gestureRecognizers) {
        [self.backgroundView removeGestureRecognizer:gesture];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)informDelegateOfTapOnButton:(RPDFToolbarButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolbarViewController:didTapOnButton:)]) {
        [self.delegate toolbarViewController:self didTapOnButton:button];
    }
}

#pragma mark - Blurred Background
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

- (void)didTapOnBackgroundView
{
    [self dismiss];
}

#pragma mark - TOC VC
- (UIViewController<RPDFTOCVC> *)TOCViewController
{
    if (!_TOCViewController) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(TOCViewControllerForToolbarViewController:)]) {
            _TOCViewController = [self.delegate TOCViewControllerForToolbarViewController:self];
        } else {
            _TOCViewController = [RTOCViewController sharedInstance];
        }
    }
    return _TOCViewController;
}

- (void)showTOCForDocument:(CGPDFDocumentRef)document
{
    UIViewController<RPDFTOCVC> *toc = self.TOCViewController;
    CGPDFDocumentRetain(document);
    NSArray *outlines = [RPDFDocumentOutline outlineFromDocument:document password:@""];
    [toc updateWithOutlines:outlines];
    CGPDFDocumentRelease(document);
    [toc showForToolbarViewController:self];
}

- (void)hideTOC
{
    [self.TOCViewController dismiss];
}

#pragma mark - Hints VC
- (UIViewController<RPDFHintVC> *)hintViewController
{
    if (!_hintViewController) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(HintViewControllerForToolbarViewController:)]) {
            _hintViewController = [self.delegate HintViewControllerForToolbarViewController:self];
        }
    }
    return _hintViewController;
}

- (void)showHint
{
    [self.hintViewController showForToolbarViewController:self];
}

- (void)hideHint
{
    [self.hintViewController dismiss];
}

@end
