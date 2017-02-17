//
//  DismissAnimator.m
//  InteractiveModal-OC
//
//  Created by 王顺 on 2017/2/14.
//  Copyright © 2017年 shun. All rights reserved.
//

#import "DismissAnimator.h"

@implementation DismissAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (fromViewController == nil && toViewController == nil) {
        return;
    }
    
    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGPoint bottomLeftCorner = CGPointMake(0, screenBounds.size.height);
    CGRect finalFrame = CGRectMake(bottomLeftCorner.x, bottomLeftCorner.y, screenBounds.size.width, screenBounds.size.height);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.frame = finalFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
@end

@implementation Interactor

@end
