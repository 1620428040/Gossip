//
//  GDBackgroundView.m
//  Gossip
//
//  Created by 国栋 on 15/12/31.
//  Copyright (c) 2015年 GD. All rights reserved.
//
#define sw ([UIScreen mainScreen].bounds.size.width)
#define sh ([UIScreen mainScreen].bounds.size.height)
#define vw (self.frame.size.width)
#define vh (self.frame.size.height)

#import "GDBackgroundView.h"

@interface GDBackgroundView ()

@property UIButton *button;
@property UIViewController<GDBackgroundViewDelegate> *delegate;

@end

@implementation GDBackgroundView
@synthesize button,delegate,backgroundImage;

+(GDBackgroundView*)createWithDelegate:(UIViewController<GDBackgroundViewDelegate> *)theDelegate
{
    GDBackgroundView *new=[[self alloc]init];
    new.delegate=theDelegate;
    
    float barHeight=20;
    if (new.delegate.navigationController!=nil) {
        barHeight+=new.delegate.navigationController.navigationBar.frame.size.height;
    }
    new.contentSize=CGSizeMake(sw, sh-barHeight);
    new.button.frame=CGRectMake(0, 0, new.contentSize.width, new.contentSize.height);
    
    [new resize:nil];
    return new;
}
-(instancetype)init
{
    if (self=[super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resize:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resize:) name:UIKeyboardDidHideNotification object:nil];
        
        button=[UIButton new];
        [button addTarget:delegate action:@selector(subviewResignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}
-(void)resize:(NSNotification*)info
{
    float end=sh;
    if (info!=nil) {
        NSValue *value=[info.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        end=[value CGRectValue].origin.y;
    }
    self.frame=CGRectMake(0, 0, sw, end);
}

//设置背景图片
-(void)setBackgroundImage:(UIImage *)image
{
    [button setImage:image forState:UIControlStateNormal];
    backgroundImage=image;
}
-(UIImage *)backgroundImage
{
    return backgroundImage;
}
@end
