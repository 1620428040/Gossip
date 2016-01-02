//
//  GDTableView.m
//  Gossip
//
//  Created by 国栋 on 15/12/30.
//  Copyright (c) 2015年 GD. All rights reserved.
//

#define sw ([UIScreen mainScreen].bounds.size.width)
#define sh ([UIScreen mainScreen].bounds.size.height)
#define vw (self.frame.size.width)
#define vh (self.frame.size.height)

#import "CommentView.h"

@implementation CommentView
@synthesize delegate,theTableView,height,data,refresh,title;

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)theTitle
{
    if (self=[super initWithFrame:frame]) {
        
        title=theTitle;
        
        //创建tableview
        theTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, vw, vh)];
        [self addSubview:theTableView];
        theTableView.delegate=self;
        theTableView.dataSource=self;
        height=44;
        data=[NSMutableArray array];
        
        //创建刷新控制器
        refresh=[[UIRefreshControl alloc]init];
        
        [refresh addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
        refresh.attributedTitle=[[NSAttributedString alloc]initWithString:@"下拉刷新"];
        [theTableView addSubview:refresh];
        
        
        //测试数据
        CommentManager *cm=[CommentManager share];
        [cm addWithtitle:@"新闻的标题，哪里又特么炸啦" author:@"wuak" date:[NSDate date] content:@"hahahahah"];
        [cm addWithtitle:@"新闻的标题，哪里又特么炸啦" author:@"wuak" date:[NSDate date] content:@"默哀"];
        [cm addWithtitle:@"哪里又在扫黄啦什么的。。。。" author:@"ds" date:[NSDate date] content:@"dongguan?"];
        data=[cm findbyPredicate:[NSPredicate predicateWithFormat:@"title=%@",title]];
    }
    return self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (cell==nil) {
        cell=[[CommentViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse" frame:CGRectMake(0, 0, vw, 50)];//注意，直接用[cell initWithFrame:]设定大小是无效的，可能是被覆盖了
    }
    
    Comment *news=[data objectAtIndex:indexPath.row];
    
    //自定义cell
    cell.title.text=news.title;
    cell.author.text=news.author;
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy年MM月dd日 hh:mm:ss"];
    cell.date.text=[df stringFromDate:news.date];
    cell.content.text=news.content;
    
    //调整子控件的大小,且使宽度保持不变，否则复用的时候会出错
    float width=cell.content.frame.size.width;
    [cell.content sizeToFit];
    cell.content.frame=CGRectMake(cell.content.frame.origin.x, cell.content.frame.origin.y, width, cell.content.frame.size.height);
    
    //计算cell的大小
    cell.frame=CGRectMake(0, 0, vw, cell.content.frame.size.height+40);
    height=cell.frame.size.height;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}

//选择cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[delegate detailView:[data objectAtIndex:indexPath.row]];
}

//下拉刷新的操作
-(void)refreshTableView
{
    if (refresh.refreshing)//检测是否在刷新中
    {
        refresh.attributedTitle=[[NSAttributedString alloc]initWithString:@"加载中..."];
    }
    [theTableView reloadData];
    //[self setNeedsDisplay];
    //数据更新后
    [refresh endRefreshing];//结束刷新的状态
    refresh.attributedTitle=[[NSAttributedString alloc]initWithString:@"下拉刷新"];//复原提示的文本
}
@end

@implementation CommentViewCell

@synthesize title,author,date,content;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.frame=frame;
        
        //自定义cell
        author=[[UILabel alloc]initWithFrame:CGRectMake(vw*0.05, 10, vw*0.3, 20)];
        //author.backgroundColor=[UIColor blueColor];
        [self addSubview:author];
        
        date=[[UILabel alloc]initWithFrame:CGRectMake(vw*0.35, 10, vw*0.6, 20)];
        //date.backgroundColor=[UIColor grayColor];
        [self addSubview:date];
        
        content=[[UILabel alloc]initWithFrame:CGRectMake(vw*0.05, 40, vw*0.9, 50)];
        content.numberOfLines=0;
        //describe.backgroundColor=[UIColor greenColor];
        [self addSubview:content];
    }
    return self;
}

@end
