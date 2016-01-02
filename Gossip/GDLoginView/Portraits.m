//
//  Portraits.m
//  GDLoginView
//
//  Created by 国栋 on 15/12/30.
//  Copyright (c) 2015年 GD. All rights reserved.
//

#import "Portraits.h"

@implementation Portraits
@synthesize icon;

- (void)drawRect:(CGRect)rect {
    if (icon==nil) {
        return;
    }
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [icon drawInRect:rect];
}
-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
    icon=image;
    self.backgroundColor=[UIColor clearColor];
    [self setNeedsDisplay];
}

@end
