//
//  GDBackgroundView.h
//  Gossip
//
//  Created by 国栋 on 15/12/31.
//  Copyright (c) 2015年 GD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GDBackgroundViewDelegate <NSObject>

-(void)subviewResignFirstResponder;
@optional

@end

@interface GDBackgroundView : UIScrollView

@property UIImage *backgroundImage;//背景图片

+(GDBackgroundView*)createWithDelegate:(UIViewController<GDBackgroundViewDelegate>*)theDelegate;

@end
