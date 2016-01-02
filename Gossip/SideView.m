//
//  SideView.m
//  Gossip
//
//  Created by 国栋 on 15/12/30.
//  Copyright (c) 2015年 GD. All rights reserved.
//

#import "SideView.h"

@implementation SideView
@synthesize delegate,isOpen,leftSideView,grayView;

-(instancetype)initWithDelegate:(id<SideViewDelegate>)theDelegate frame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        delegate=theDelegate;
        
        grayView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        grayView.backgroundColor=[UIColor colorWithWhite:0.1 alpha:0.1];
        [grayView addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        grayView.alpha=0;
        self.alpha=0;
        [self addSubview:grayView];
        
        leftSideView=[delegate leftView];
        leftSideView.frame=CGRectMake(-leftSideView.frame.size.width, 0, leftSideView.frame.size.width, self.frame.size.height);
        [self addSubview:leftSideView];
    }
    return self;
}
-(void)touchButton
{
    if (isOpen==YES) {
        [self close];
    }
    else [self open];
}
-(void)open
{
    isOpen=YES;
    self.alpha=1;
    [UIView animateWithDuration:0.3 animations:^{
        leftSideView.center=CGPointMake(leftSideView.frame.size.width/2, leftSideView.frame.size.height/2);
        grayView.alpha=1;
    } completion:^(BOOL finished) {}];
}
-(void)close
{
    [UIView animateWithDuration:0.3 animations:^{
        leftSideView.center=CGPointMake(-leftSideView.frame.size.width/2, leftSideView.frame.size.height/2);
        grayView.alpha=0;
    } completion:^(BOOL finished) {
        self.alpha=0;
        isOpen=NO;
    }];
}
@end
