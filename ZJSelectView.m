//
//  ZJSelectView.m
//  CRM
//
//  Created by mini on 16/11/10.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJSelectView.h"
#import "ZJSelectTableViewCell.h"
#import "ZJCustomerItemsTableInfo.h"


@interface ZJSelectView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray *dataAray;

//**tableView**//
@property(nonatomic,weak) UITableView *tableView;


@end

static NSString *identifier = @"selectCell";
@implementation ZJSelectView

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame tableViewData:(NSMutableArray *)array{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = ZJRGBColor(220, 220, 220, 0.5);
        self.dataAray = array;
        [self setupUI];
        
    }
    
    return self;
}

#pragma mark   设置UI
-(void)setupUI{
    CGFloat height = PX2PT(128)*self.dataAray.count;
    //判断是否比父视图高
    height = height>self.height?self.height:height;
    
    CGRect frame = CGRectMake(0, 0, zjScreenWidth, height);
    
    UITableView *table = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    self.tableView = table;
    
    table.delegate = self;
    table.dataSource = self;
    [self addSubview:table];
    
    [table registerClass:[ZJSelectTableViewCell class] forCellReuseIdentifier:identifier];
    
    
    table.rowHeight = PX2PT(128);
}

#pragma mark UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataAray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    ZJCustomerItemsTableInfo *items = self.dataAray[indexPath.row];
    
    cell.model = items;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
//    if (indexPath.row == _selectCell)return;
    
    _selectCell = indexPath.row;
    
    ZJCustomerItemsTableInfo *items = self.dataAray[indexPath.row];

    
    [self.delegate ZJSelectView:self didSelectItemID:items.iAutoID clickRow:indexPath.row];
    
}

-(void)setSelectCell:(NSInteger)selectCell{
    _selectCell = selectCell;
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectCell inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];

    
}
@end
