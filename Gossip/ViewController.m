//
//  ViewController.m
//  Gossip
//
//  Created by 国栋 on 15/12/31.
//  Copyright (c) 2015年 GD. All rights reserved.
//
#import "ViewController.h"
#import "MainViewController.h"
#import "GDLoginView.h"

#define sw ([UIScreen mainScreen].bounds.size.width)
#define sh ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()<GDLoginViewDelegate>

@property GDLoginView *loginView;
@end

@implementation ViewController
@synthesize loginView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginView=[GDLoginView createWithDelegate:self frame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.loginView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mainView
{
    
    UINavigationController *mainView=[[UINavigationController alloc]initWithRootViewController:[MainViewController new]];
    [self presentViewController:mainView animated:NO completion:^{}];
}

#pragma mark 登录界面
-(CustomUser*)checkingAccount:(CustomUser*)user
{
    //校验账户
    //假装发到服务器上
#warning 需要服务器支持的步骤
    //假装发到服务器上了
    if (1){//[user.account isEqualToString:@"aq"]&&[user.password isEqualToString:@"213"]) {
        
        //user.icon把账户对应的头像等信息加入
        user.icon=[UIImage imageNamed:@"/Users/guodong/Desktop/Coding/Gossip/Gossip/未选中.png"];
        CustomUserManager *cum=[CustomUserManager share];
        cum.currentUser=user;
        return user;
    }
    return nil;//如果账号不对，返回nil
}//校验账户
-(void)nextView
{
    [self.loginView removeFromSuperview];
    self.loginView=nil;
    [self mainView];
}//由代理对象打开下一步的界面
-(void)registerView
{
    NSLog(@"打开注册界面");
}//由代理对象打开注册界面
-(void)findBackPassword
{
    NSLog(@"打开找回密码界面");
}//找回密码

@end
