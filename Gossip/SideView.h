//
//  SideView.h
//  Gossip
//
//  Created by 国栋 on 15/12/30.
//  Copyright (c) 2015年 GD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SideViewDelegate <NSObject>

-(UIView*)leftView;//需要返回侧边栏的内容
/*委托对象中的示例
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
*/
@end

@interface SideView : UIView

@property (strong,nonatomic)id<SideViewDelegate>delegate;
@property (assign,nonatomic)BOOL isOpen;
@property (strong,nonatomic)UIButton *grayView;
@property (strong,nonatomic)UIView *leftSideView;

-(instancetype)initWithDelegate:(id<SideViewDelegate>)theDelegate frame:(CGRect)frame;//注意不要被覆盖在其它视图下面
-(void)touchButton;//从外部打开／关闭侧边栏的方法

@end
