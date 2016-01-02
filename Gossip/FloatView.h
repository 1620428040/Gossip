//
//  FloatView.h
//  Gossip
//
//  Created by 国栋 on 16/1/1.
//  Copyright (c) 2016年 GD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloatView : UIView<UIScrollViewDelegate>

+(FloatView*)createWithDelegate:(id)theDelegate frame:(CGRect)frame;

@end
