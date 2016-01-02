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

#import "GDTableView.h"

@implementation GDTableView
@synthesize delegate,theTableView,height,data,refresh;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
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
        NewsManager *nm=[NewsManager share];
        [nm addWithtitle:@"新闻的标题，哪里又特么炸啦" author:@"guodong" date:[NSDate date] skim:120 believable:11 doubt:5 describe:@"新闻的简介，吧啦吧啦的。。。。。。新闻的简介，吧啦吧啦的。。。。。。新闻的简介，吧啦吧啦的。。。。。。新闻的简介，吧啦吧啦的。。。。。。新闻的简介，吧啦吧啦的。。。。。。新闻的简介，吧啦吧啦的。。。。。。新闻的简介，吧啦吧啦的。。。。。。新闻的简介，吧啦吧啦的。。。。。。新闻的简介，吧啦吧啦的。。。。。。新闻的简介，吧啦吧啦的。。。。。。" content:@"详情啦，什么的。。。。。HTML格式的"];
        [nm addWithtitle:@"哪里又在扫黄啦什么的。。。。" author:@"guodong" date:[NSDate date] skim:120 believable:11 doubt:5 describe:@"各种少儿不宜的内容" content:[NSString stringWithContentsOfFile:@"/Users/guodong/Desktop/首页 - 知乎.html" encoding:NSUTF8StringEncoding error:nil]];
        data=[[NewsManager share]getall];
    }
    return self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (cell==nil) {
        cell=[[GDTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse" frame:CGRectMake(0, 0, vw, 50)];//注意，直接用[cell initWithFrame:]设定大小是无效的，可能是被覆盖了
    }
    
    News *news=[data objectAtIndex:indexPath.row];
    
    //自定义cell
    cell.title.text=news.title;
    cell.author.text=news.author;
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy年MM月dd日 hh:mm:ss"];
    cell.date.text=[df stringFromDate:news.date];
    cell.skim.text=[NSString stringWithFormat:@"浏览：%d",(int)news.skim];
    cell.believable.text=[NSString stringWithFormat:@"相信：%d",(int)news.believable];
    cell.doubt.text=[NSString stringWithFormat:@"怀疑：%d",(int)news.doubt];
    cell.describe.text=news.describe;
    
    //调整子控件的大小,且使宽度保持不变，否则复用的时候会出错
    float width=cell.describe.frame.size.width;
    [cell.describe sizeToFit];
    cell.describe.frame=CGRectMake(cell.describe.frame.origin.x, cell.describe.frame.origin.y, width, cell.describe.frame.size.height);
    
    //计算cell的大小
    cell.frame=CGRectMake(0, 0, vw, cell.describe.frame.size.height+100);
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
    [delegate detailView:[data objectAtIndex:indexPath.row]];
}

//对表视图的移动删除等操作
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [data removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {}
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    id move=[data objectAtIndex:fromIndexPath.row];
    [data removeObject:move];
    [data insertObject:move atIndex:toIndexPath.row];
    [tableView reloadData];
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

@implementation GDTableViewCell

@synthesize title,author,date,skim,believable,doubt,describe;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.frame=frame;
        
        //自定义cell
        title=[[UILabel alloc]initWithFrame:CGRectMake(vw*0.05, 5, vw*0.9, 30)];
        title.font=[UIFont fontWithName:nil size:20];
        //title.backgroundColor=[UIColor cyanColor];
        [self addSubview:title];
        
        author=[[UILabel alloc]initWithFrame:CGRectMake(vw*0.05, 40, vw*0.3, 20)];
        //author.backgroundColor=[UIColor blueColor];
        [self addSubview:author];
        
        date=[[UILabel alloc]initWithFrame:CGRectMake(vw*0.35, 40, vw*0.6, 20)];
        //date.backgroundColor=[UIColor grayColor];
        [self addSubview:date];
        
        skim=[[UILabel alloc]initWithFrame:CGRectMake(vw*0.05, 65, vw*0.4, 20)];
        //skim.backgroundColor=[UIColor redColor];
        [self addSubview:skim];
        
        believable=[[UILabel alloc]initWithFrame:CGRectMake(vw*0.45, 65, vw*0.25, 20)];
        //believable.backgroundColor=[UIColor orangeColor];
        [self addSubview:believable];
        
        doubt=[[UILabel alloc]initWithFrame:CGRectMake(vw*0.70, 65, vw*0.25, 20)];
        //doubt.backgroundColor=[UIColor purpleColor];
        [self addSubview:doubt];
        
        describe=[[UILabel alloc]initWithFrame:CGRectMake(vw*0.05, 95, vw*0.9, 50)];
        describe.numberOfLines=0;
        //describe.backgroundColor=[UIColor greenColor];
        [self addSubview:describe];
    }
    return self;
}

@end
