//
//  LoginViewController.h
//  GDFW
//
//  Created by 国栋 on 15/12/11.
//  Copyright (c) 2015年 GD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUserManager.h"
#import "Portraits.h"

@protocol GDLoginViewDelegate <NSObject>

@required
-(CustomUser*)checkingAccount:(CustomUser*)user;//校验账户
-(void)nextView;//由代理对象打开下一步的界面
-(void)registerView;//由代理对象打开注册界面
-(void)findBackPassword;//找回密码
/*//范例
-(CustomUser*)checkingAccount:(CustomUser*)user
{
    //校验账户
    //user.icon把账户对应的头像等信息加入
    return user;
}//校验账户
-(void)nextView
{
    NSLog(@"打开下一个界面");
}//由代理对象打开下一步的界面
-(void)registerView
{
    NSLog(@"打开注册界面");
}//由代理对象打开注册界面
-(void)findBackPassword
{
    NSLog(@"打开找回密码界面");
}//找回密码
 */
@end


@interface GDLoginView : UIView

@property id<GDLoginViewDelegate> delegate;//委托对象
@property UIImageView *background;//背景图
@property UITextField *accountInputField;//账号输入框
@property UITextField *passwordInputField;//密码输入框
@property Portraits *portraits;//头像,这个控件是UIButton的子类
@property UIButton *loginButton;//登录按钮
@property UIButton *registerButton;//注册按钮
@property UIButton *savePassword;//保存密码
@property UIButton *forgetPassword;//忘记密码
@property UIImage *imageForYes;//选项是选定状态时显示的图片
@property UIImage *imageForNo;//选项是否定状态时显示的图片
@property UIButton *autoLogin;//自动登录

+(id)createWithDelegate:(id<GDLoginViewDelegate>)delegate frame:(CGRect)rect;

@end