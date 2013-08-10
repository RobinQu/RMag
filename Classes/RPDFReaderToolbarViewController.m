//
//  RPDFReaderToolbarViewController.m
//  RMag
//
//  Created by Robin Qu on 13-8-9.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RPDFReaderToolbarViewController.h"
#import "RPDFPageViewController.h"
#import <StackBluriOS/UIImage+StackBlur.h>

static const CGFloat kTransitionInterval = .3f;
static const CGFloat kImageBlurRadius = 30.0f;

@interface RPDFReaderToolbarViewController ()

+ (id)sharedInstance;

@property (nonatomic, retain) UIImageView *backgroundView;

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
    instance.view.frame = pageViewController.view.bounds;
    [UIView animateWithDuration:kTransitionInterval animations:^{
        instance.view.alpha = 1;
        [instance didMoveToParentViewController:pageViewController];
    }];
}

+ (void)dismiss
{
    RPDFReaderToolbarViewController *instance = [self sharedInstance];
    [UIView animateWithDuration:kTransitionInterval animations:^{
        instance.view.alpha = 0;
    } completion:^(BOOL finished) {
        [instance.view removeFromSuperview];
        [instance removeFromParentViewController];
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
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnBackgroundView)];
    [self.view addGestureRecognizer:tap];
    

}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnBackgroundView)];
//    [self.backgroundView addGestureRecognizer:tap];
//}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    for (UIGestureRecognizer *gesture in self.backgroundView.gestureRecognizers) {
//        [self.backgroundView removeGestureRecognizer:gesture];
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapOnBackgroundView
{
    [[self class] dismiss];
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
        _backgroundView.hidden = YES;
        [self.view addSubview:_backgroundView];
    }
    return _backgroundView;
}

@end
