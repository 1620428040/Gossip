//
//  MainViewController.m
//  Gossip
//
//  Created by 国栋 on 15/12/31.
//  Copyright (c) 2015年 GD. All rights reserved.
//
#define sw ([UIScreen mainScreen].bounds.size.width)
#define sh ([UIScreen mainScreen].bounds.size.height)
#define vw (self.frame.size.width)
#define vh (self.frame.size.height)

#import "MainViewController.h"
#import "GDTableView.h"
#import "SideView.h"
#import "GDTableView.h"
#import "DetailViewController.h"
#import "AddViewController.h"

@interface MainViewController ()<GDTableViewDelegate,SideViewDelegate>

@property GDTableView *tableview;
@property SideView *sideView;

@end

@implementation MainViewController
@synthesize tableview,sideView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    tableview=[[GDTableView alloc]initWithFrame:CGRectMake(0, 0, sw, sh)];
    tableview.delegate=self;
    [self.view addSubview:tableview];
    
    sideView=[[SideView alloc]initWithDelegate:self frame:CGRectMake(0, 60, sw, sh-40)];
    [self.view addSubview:sideView];
    
    self.navigationItem.title=@"新闻";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:sideView action:@selector(touchButton)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addViewController)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 新建界面
-(void)addViewController
{
    AddViewController *addView=[AddViewController new];
    [self.navigationController pushViewController:addView animated:YES];
}
#pragma mark 侧边栏
-(UIView *)leftView
{
    UIView *side=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, sh-40)];
    side.backgroundColor=[UIColor whiteColor];
    
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    lab1.text=@"全部";
    [side addSubview:lab1];
    
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(0, 30, 200, 30)];
    lab2.text=@"新闻";
    [side addSubview:lab2];
    
    UILabel *lab3=[[UILabel alloc]initWithFrame:CGRectMake(0, 60, 200, 30)];
    lab3.text=@"设置";
    [side addSubview:lab3];
    
    UILabel *lab4=[[UILabel alloc]initWithFrame:CGRectMake(0, 90, 200, 30)];
    lab4.text=@"其它";
    [side addSubview:lab4];
    
    return side;
}

#pragma mark 表视图
-(void)detailView:(News*)news
{
    DetailViewController *detail=[DetailViewController new];
    [detail detailView:news];
    news.skim++;
    [[NewsManager share]changeObject:news];
#warning 需要发送到服务器
    [self.navigationController pushViewController:detail animated:YES];
}
@end
