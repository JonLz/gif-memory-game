//
//  BackgroundView.m
//  gif-memory-game
//
//  Created by Jon on 2/5/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import "BackgroundView.h"

static inline double radians (double degrees)
{
    return degrees * M_PI/180;
}

void MyDrawColoredPattern (void *info, CGContextRef context)
{
    UIColor * dotColor = [UIColor colorWithHue:0 saturation:0 brightness:0.07 alpha:1.0];
    UIColor * shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    
    CGContextSetFillColorWithColor(context, dotColor.CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1, shadowColor.CGColor);
    
    CGContextAddArc(context, 3, 3, 4, 0, radians(360), 0);
    CGContextFillPath(context);
    
    CGContextAddArc(context, 16, 16, 4, 0, radians(360), 0);
    CGContextFillPath(context);
}

@implementation BackgroundView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor * bgColor = [UIColor colorWithHue:0 saturation:0 brightness:0.15 alpha:1.0];
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillRect(context, rect);
    
    static const CGPatternCallbacks callbacks = { 0, &MyDrawColoredPattern, NULL };
    
    CGContextSaveGState(context);
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    
    CGPatternRef pattern = CGPatternCreate(NULL,
                                           rect,
                                           CGAffineTransformIdentity,
                                           24,
                                           24,
                                           kCGPatternTilingConstantSpacing,
                                           true,
                                           &callbacks);
    CGFloat alpha = 1.0;
    CGContextSetFillPattern(context, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(context, self.bounds);
    CGContextRestoreGState(context);
}

@end
