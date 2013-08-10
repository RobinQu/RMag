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
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.9];
    [self.view addSubview:self.backgroundView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnBackgroundView)];
//    [self.view addGestureRecognizer:tap];
    
    self.backButton = [RPDFToolbarButton backButton];
    [self.backButton setPosition:CGPointMake(36, 185)];
    [self.backButton addTarget:self action:@selector(informDelegateOfTapOnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    self.tocButton = [RPDFToolbarButton tocButton];
    [self.tocButton setPosition:CGPointMake(130, 185)];
    [self.view addSubview:self.tocButton];
    [self.tocButton addTarget:self action:@selector(informDelegateOfTapOnButton:) forControlEvents:UIControlEventTouchUpInside];
    self.hintButton = [RPDFToolbarButton hintButton];
    [self.hintButton setPosition:CGPointMake(225, 185)];
    [self.view addSubview:self.hintButton];
    [self.hintButton addTarget:self action:@selector(informDelegateOfTapOnButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view insertSubview:self.backgroundView atIndex:0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnBackgroundView)];
    [self.view addGestureRecognizer:tap];
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
    }
    return _backgroundView;
}

@end
