//
//  PWCircleView.m
//
//  Created on 5/5/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import "PWCircleView.h"

@implementation PWCircleView


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self internalInitialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self internalInitialize];
    }
    return self;
}

- (void)internalInitialize
{
    _lineWidth = 2;
    _circleColor = [UIColor blackColor];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGRect bounds = [self bounds];
    CGRect circleBounds = CGRectInset(bounds, self.lineWidth / 2, self.lineWidth / 2);
    CGFloat radius = MIN(CGRectGetWidth(circleBounds), CGRectGetHeight(circleBounds)) / 2;
    
    [self.circleColor set];
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = self.lineWidth;
    CGPoint center = CGPointMake(CGRectGetMidX(circleBounds), CGRectGetMidY(circleBounds));
    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    
    [path stroke];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}


-(void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    [self setNeedsDisplay];
}

@end
