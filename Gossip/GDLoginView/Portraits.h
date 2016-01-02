//
//  Portraits.h
//  GDLoginView
//
//  Created by 国栋 on 15/12/30.
//  Copyright (c) 2015年 GD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Portraits : UIButton

@property (strong,nonatomic)UIImage *icon;

-(void)setImage:(UIImage *)image forState:(UIControlState)state;

@end
