//
//  TransitionAnimator.h
//  gif-memory-game
//
//  Created by Jon on 2/6/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TransitionDirection) {
    Down,
    Right
};

@interface TransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL presenting;
@property (nonatomic, assign) TransitionDirection direction;
- (instancetype)initWithDirection:(TransitionDirection)direction;

@end
