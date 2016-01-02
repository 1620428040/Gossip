//
//  AddViewController.m
//  Gossip
//
//  Created by 国栋 on 15/12/31.
//  Copyright (c) 2015年 GD. All rights reserved.
//
#define sw ([UIScreen mainScreen].bounds.size.width)
#define sh ([UIScreen mainScreen].bounds.size.height)
#define vw (self.frame.size.width)
#define vh (self.frame.size.height)

#import "AddViewController.h"
#import "CustomUserManager.h"
#import "GDBackgroundView.h"
#import "NewsManager.h"

@interface AddViewController ()<GDBackgroundViewDelegate,UITextViewDelegate>

@property CustomUser *user;
@property GDBackgroundView *main;//背景
@property UITextField *titleTextField;
@property UITextView *describeTextView;
@property UITextView *contentTextView;


@end

@implementation AddViewController
@synthesize user,main,titleTextField,describeTextView,contentTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submit)];
    
    main=[GDBackgroundView createWithDelegate:self];
    main.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:main];
    
    CustomUserManager *cum=[CustomUserManager share];
    user=cum.currentUser;
    
    //self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 30)];
    titleLabel.text=@"标题：";
    [main addSubview:titleLabel];
    
    titleTextField=[[UITextField alloc]initWithFrame:CGRectMake(70, 10, sw-80, 30)];
    titleTextField.placeholder=@"在这里输入标题";
    titleTextField.backgroundColor=[UIColor lightTextColor];
    titleTextField.layer.borderWidth=1;
    titleTextField.layer.cornerRadius=10;
    titleTextField.layer.borderColor=[UIColor grayColor].CGColor;
    [main addSubview:titleTextField];
    
    UILabel *describeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, 60, 30)];
    describeLabel.text=@"简介：";
    [main addSubview:describeLabel];
    
    describeTextView=[[UITextView alloc]initWithFrame:CGRectMake(70, 50, sw-80, 100)];
    describeTextView.backgroundColor=[UIColor lightTextColor];
    describeTextView.layer.borderWidth=1;
    describeTextView.layer.cornerRadius=10;
    describeTextView.layer.borderColor=[UIColor grayColor].CGColor;
    [main addSubview:describeTextView];
    
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 160, sw-20, 30)];
    contentLabel.text=@"详情（允许输入HTML）";
    [main addSubview:contentLabel];
    
    contentTextView=[[UITextView alloc]initWithFrame:CGRectMake(10, 200, sw-20, main.contentSize.height-210)];
    contentTextView.backgroundColor=[UIColor lightTextColor];
    contentTextView.layer.borderWidth=1;
    contentTextView.layer.cornerRadius=10;
    contentTextView.layer.borderColor=[UIColor grayColor].CGColor;
    contentTextView.delegate=self;
    [main addSubview:contentTextView];
    // Do any additional setup after loading the view.
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    main.contentOffset=CGPointMake(0, 100);
    return YES;
}
-(void)subviewResignFirstResponder
{
    [titleTextField resignFirstResponder];
    [describeTextView resignFirstResponder];
    [contentTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)submit
{
    NewsManager *newsManager=[NewsManager share];
    
    News *aNews=[[News alloc]init];
    aNews.title=titleTextField.text;
    aNews.author=user.account;
    aNews.date=[NSDate date];
    aNews.describe=describeTextView.text;
    aNews.content=contentTextView.text;
    [newsManager addObject:aNews];
    NSDictionary *dict=[newsManager dictionaryWithObject:aNews];
    
    //假装发到服务器上
#warning 需要服务器支持的步骤
    NSLog(@"%@",dict);
    //假装发到服务器上了
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
