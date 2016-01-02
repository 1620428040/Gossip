//
//  CommentViewController.m
//  Gossip
//
//  Created by 国栋 on 15/12/31.
//  Copyright (c) 2015年 GD. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentView.h"

@interface CommentViewController ()

@end

@implementation CommentViewController
@synthesize theTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    CommentView *tableView=[[CommentView alloc]initWithFrame:[UIScreen mainScreen].bounds title:theTitle];
    self.title=theTitle;
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
