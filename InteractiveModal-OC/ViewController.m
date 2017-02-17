//
//  ViewController.m
//  InteractiveModal-OC
//
//  Created by 王顺 on 2017/2/14.
//  Copyright © 2017年 shun. All rights reserved.
//

#import "ViewController.h"
#import "DismissAnimator.h"
#import "ModalViewController.h"

@interface ViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) Interactor *interactor;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"sdfsdf");
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[ModalViewController class]]) {
        ModalViewController *mVC = segue.destinationViewController;
        mVC.transitioningDelegate = self;
        mVC.interactor = self.interactor;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[DismissAnimator alloc] init];
}
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactor.hasStarted ? self.interactor : nil;
}

#pragma mark -
- (Interactor *)interactor {
    if (_interactor == nil) {
        _interactor = [[Interactor alloc] init];
    }
    return _interactor;
}
@end
