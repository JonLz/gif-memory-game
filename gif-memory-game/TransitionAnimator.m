//
//  TransitionAnimator.m
//  gif-memory-game
//
//  Created by Jon on 2/6/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import "TransitionAnimator.h"
@implementation TransitionAnimator

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    _direction = Down;
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
   
    CGRect mainBounds = [[UIScreen mainScreen] bounds];
    CGRect offscreenTop = CGRectMake(0, -mainBounds.size.height, mainBounds.size.width, mainBounds.size.height);
    CGRect onScreen = mainBounds;
    CGRect offscreenBottom = CGRectMake(0, mainBounds.size.height, mainBounds.size.width, mainBounds.size.height);
    
    if (self.direction == Down) {
        
        if (self.presenting) {
            fromViewController.view.userInteractionEnabled = NO;
            
            [transitionContext.containerView addSubview:fromViewController.view];
            [transitionContext.containerView addSubview:toViewController.view];
            
            toViewController.view.frame = offscreenBottom;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                fromViewController.view.frame = offscreenTop;
                toViewController.view.frame = onScreen;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }
        
        else {
            toViewController.view.userInteractionEnabled = YES;
            
            [transitionContext.containerView addSubview:toViewController.view];
            [transitionContext.containerView addSubview:fromViewController.view];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                fromViewController.view.frame = offscreenBottom;
                toViewController.view.frame = onScreen;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }
    }
}


@end
