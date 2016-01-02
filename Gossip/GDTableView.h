//
//  GDTableView.h
//  Gossip
//
//  Created by 国栋 on 15/12/30.
//  Copyright (c) 2015年 GD. All rights reserved.
//


//这是一个动态的高度的表视图类的 例子
#import <UIKit/UIKit.h>
#import "NewsManager.h"

@protocol GDTableViewDelegate <NSObject>
-(void)detailView:(News*)news;//详情页
@end


@interface GDTableView : UIView<UITableViewDataSource,UITableViewDelegate>

@property id<GDTableViewDelegate> delegate;
@property UITableView *theTableView;
@property NSMutableArray *data;//要展示的数据
@property float height;//默认的cell的高度
@property UIRefreshControl *refresh;

-(instancetype)initWithFrame:(CGRect)frame;

@end

@interface GDTableViewCell : UITableViewCell

@property UILabel *title;
@property UILabel *author;
@property UILabel *date;
@property UILabel *skim;
@property UILabel *believable;
@property UILabel *doubt;
@property UILabel *describe;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;

@end