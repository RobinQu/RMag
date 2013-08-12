//
//  RToolbarHelperViewController.m
//  RMag
//
//  Created by Robin Qu on 13-8-12.
//  Copyright (c) 2013年 Robin Qu. All rights reserved.
//

#import "RToolbarHelperViewController.h"
#import <objc/runtime.h>

const char kToolbarHelperSingletonKey;

@interface RToolbarHelperViewController ()

@end

@implementation RToolbarHelperViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (id)sharedInstance
{
    id instance = objc_getAssociatedObject(self, &kToolbarHelperSingletonKey);
    if (!instance) {
        instance = [[self alloc] initWithNibName:nil bundle:nil];
        objc_setAssociatedObject(self, &kToolbarHelperSingletonKey, instance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return instance;
}

- (void)showForToolbarViewController:(RPDFReaderToolbarViewController *)toolbarVC
{
    self.toolbarViewController = toolbarVC;
    [toolbarVC addChildViewController:self];
    self.view.alpha = 0;
    [toolbarVC.view addSubview:self.view];
    [UIView animateWithDuration:kTransitionInterval animations:^{
        self.view.alpha = 1;
        toolbarVC.buttonContainer.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:kTransitionInterval animations:^{
        self.view.alpha = 0;
        self.toolbarViewController.buttonContainer.alpha = 1;
    } completion:^(BOOL finished) {
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }];
}

@end
