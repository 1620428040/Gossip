//
//  GDTableView.h
//  Gossip
//
//  Created by 国栋 on 15/12/30.
//  Copyright (c) 2015年 GD. All rights reserved.
//


//这是一个动态的高度的表视图类的 例子
#import <UIKit/UIKit.h>
#import "CommentManager.h"

@protocol CommentViewDelegate <NSObject>

@end


@interface CommentView : UIView<UITableViewDataSource,UITableViewDelegate>

@property id<CommentViewDelegate> delegate;
@property UITableView *theTableView;
@property NSString *title;//当前新闻的标题
@property NSArray *data;//要展示的数据
@property float height;//默认的cell的高度
@property UIRefreshControl *refresh;

-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)theTitle;

@end

@interface CommentViewCell : UITableViewCell

@property UILabel *title;//所属的新闻的标题
@property UILabel *author;
@property UILabel *date;
@property UILabel *content;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;

@end