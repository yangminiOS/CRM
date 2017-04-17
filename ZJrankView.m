//
//  ZJrankView.m
//  CRM
//
//  Created by mini on 16/11/10.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJrankView.h"
#import "ZJSelectTableViewCell.h"
#import "ZJCustomerItemsTableInfo.h"



@interface ZJrankView ()<UITableViewDelegate,UITableViewDataSource>

//**<#注释#>**//
@property(nonatomic,weak) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataAray;


//**选中的row**//
@property(nonatomic,assign)NSInteger selectRow;

@end


static NSString *identifier = @"selectCell";

@implementation ZJrankView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = ZJRGBColor(220, 220, 220, 0.5);

        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    self.dataAray = [NSMutableArray array];
    
    NSArray *array = @[@"按客户录入时间排序",@"按客户名称排序",@"按放贷金额排序"];
    
    for (NSInteger i = 0; i<array.count; i++) {
        
        ZJCustomerItemsTableInfo *model = [[ZJCustomerItemsTableInfo alloc]init];
        
        model.itemString = array[i];
        
        [self.dataAray addObject:model];
    }
    
    CGFloat Cellheight = PX2PT(128);
    
    CGRect frame = CGRectMake(0, 0, zjScreenWidth,3*Cellheight);
    
    UITableView *table = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    
    self.tableView = table;
    
    table.delegate = self;
    table.dataSource = self;
    [self addSubview:table];
    
    [table registerClass:[ZJSelectTableViewCell class] forCellReuseIdentifier:identifier];
    table.rowHeight = Cellheight;
    
    [table selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];


}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    ZJCustomerItemsTableInfo *items = self.dataAray[indexPath.row];
    
    cell.model = items;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate ZJrankView:self clickRow:indexPath.row];
   
    
}

-(void)setSelectCell:(NSInteger)selectCell{
    
       [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectCell inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];

}


@end
