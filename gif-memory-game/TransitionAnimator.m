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

- (instancetype)initWithDirection:(TransitionDirection)direction
{
    self = [self init];
    _direction = direction;
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
    CGRect offscreenRight = CGRectMake(mainBounds.size.width, 0, mainBounds.size.width, mainBounds.size.height);
    CGRect offscreenLeft = CGRectMake(-mainBounds.size.width, 0, mainBounds.size.width, mainBounds.size.height);
    
    if (self.presenting) {
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
       
        if (self.direction == Down) {
            toViewController.view.frame = offscreenBottom;
        } else if (self.direction == Right) {
            toViewController.view.frame = offscreenRight;
        }
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
            if (self.direction == Down) {
                fromViewController.view.frame = offscreenTop;
                toViewController.view.frame = onScreen;
            } else if (self.direction == Right) {
                fromViewController.view.frame = offscreenLeft;
                toViewController.view.frame = onScreen;
            }
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    
    else {
        toViewController.view.userInteractionEnabled = YES;
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            if (self.direction == Down) {
                fromViewController.view.frame = offscreenBottom;
                toViewController.view.frame = onScreen;
            } else if (self.direction == Right) {
                fromViewController.view.frame = offscreenRight;
                toViewController.view.frame = onScreen;
            }
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}


@end
