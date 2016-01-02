//
//  FloatView.m
//  Gossip
//
//  Created by 国栋 on 16/1/1.
//  Copyright (c) 2016年 GD. All rights reserved.
//
#define sw ([UIScreen mainScreen].bounds.size.width)
#define sh ([UIScreen mainScreen].bounds.size.height)
#define vw (self.frame.size.width)
#define vh (self.frame.size.height)

#import "FloatView.h"

@implementation FloatView

+(FloatView *)createWithDelegate:(id)theDelegate frame:(CGRect)frame
{
    FloatView *new=[[self alloc]initWithFrame:frame];
    return new;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        self.alpha=0.8;
    }
    return self;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float oldValue=0;
    if (scrollView.contentOffset.y<=oldValue) {
        if (self.alpha<0.8) {
            self.alpha+=0.1;
        }
    }
    else
    {
        if (self.alpha>0) {
            self.alpha-=0.1;
        }
    }
    oldValue=scrollView.contentOffset.y;
}
@end
