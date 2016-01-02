//
//  DetailViewController.m
//  Gossip
//
//  Created by 国栋 on 15/12/31.
//  Copyright (c) 2015年 GD. All rights reserved.
//
#define sw ([UIScreen mainScreen].bounds.size.width)
#define sh ([UIScreen mainScreen].bounds.size.height)
#define vw (self.frame.size.width)
#define vh (self.frame.size.height)

#import "DetailViewController.h"
#import "CommentViewController.h"
#import "FloatView.h"

@interface DetailViewController ()

@property UIWebView *webView;
@property FloatView *floatView;
@property News *currentNews;
@property UIButton *believable;
@property UIButton *doubt;

@end

@implementation DetailViewController
@synthesize webView,floatView,currentNews,believable,doubt;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)detailView:(News*)news
{
    currentNews=news;
    self.navigationItem.title=news.title;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"评论" style:UIBarButtonItemStyleDone target:self action:@selector(comment)];
    
    floatView=[FloatView createWithDelegate:self frame:CGRectMake(0, 64, sw, 30)];
    
    UIButton *author=[[UIButton alloc]initWithFrame:CGRectMake(sw*0.1, 0, sw*0.4, 30)];
    [author setTitle:news.author forState:UIControlStateNormal];
    [author setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [author addTarget:self action:@selector(authorHandler) forControlEvents:UIControlEventTouchDown];
    [floatView addSubview:author];
    
    believable=[[UIButton alloc]initWithFrame:CGRectMake(sw*0.5, 0, sw*0.2, 30)];
    [believable setTitle:[NSString stringWithFormat:@"相信 %d",(int)news.believable] forState:UIControlStateNormal];
    [believable setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [believable addTarget:self action:@selector(believableHandler) forControlEvents:UIControlEventTouchDown];
    [floatView addSubview:believable];
    
    doubt=[[UIButton alloc]initWithFrame:CGRectMake(sw*0.7, 0, sw*0.2, 30)];
    [doubt setTitle:[NSString stringWithFormat:@"怀疑 %d",(int)news.doubt] forState:UIControlStateNormal];
    [doubt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [doubt addTarget:self action:@selector(doubtHandler) forControlEvents:UIControlEventTouchDown];
    [floatView addSubview:doubt];
    
    webView=[[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    webView.scrollView.delegate=floatView;
    [webView loadHTMLString:news.content baseURL:nil];
    [self.view addSubview:webView];
    
    [self.view addSubview:floatView];
}
-(void)comment
{
    CommentViewController *comment=[CommentViewController new];
    comment.theTitle=currentNews.title;
    [self.navigationController pushViewController:comment animated:YES];
}
-(void)authorHandler
{
    NSLog(@"弹出用户介绍的界面");
}
-(void)believableHandler
{
    currentNews.believable++;
    [[NewsManager share]changeObject:currentNews];
    [believable setTitle:[NSString stringWithFormat:@"相信 %d",(int)currentNews.believable] forState:UIControlStateNormal];
}
-(void)doubtHandler
{
    currentNews.doubt++;
    [[NewsManager share]changeObject:currentNews];
    [doubt setTitle:[NSString stringWithFormat:@"怀疑 %d",(int)currentNews.doubt] forState:UIControlStateNormal];
}
@end
