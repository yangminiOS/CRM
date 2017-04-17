//
//  ZJTimeGoalViewController.m
//  CRM
//
//  Created by mini on 16/10/22.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJTimeGoalViewController.h"
#import "ZJAddGoaldViewController.h"
#import "NSDate+Category.h"
#import "ZJGoalTableInfo.h"//数据库模型
#import "ZJFMdb.h"
#import "ZJGoaldTableViewCell.h"


@interface ZJTimeGoalViewController ()<UITableViewDelegate,UITableViewDataSource>
//月度目标
@property(weak,nonatomic) UIButton *monthButton;

//**季度目标**//
@property(nonatomic,weak) UIButton *seasonButton;

//**年度目标**//
@property(nonatomic,weak) UIButton *yearButton;

//**转换Button**//
@property(nonatomic,strong) UIButton *tempButton;
//顶部视图
@property(weak,nonatomic) UIView *topView;
//**tableView**//
@property(nonatomic,weak) UITableView *tableView;
//**传输到下一个界面的目标类型**//
@property(nonatomic,copy)NSString *goaldTypeString;
//**传输到下一个界面的时间数据**//
@property(nonatomic,copy)NSString *dateString;
//**传输到下一个界面的额度数据**//
@property(nonatomic,copy)NSString *countString;

//**存放数据的数组**//
@property(nonatomic,strong) NSMutableArray *remindDateArray;

//**<#注释#>**//
@property(nonatomic,strong) NSMutableArray *borrowMorryArray;
//**时间格式**//
@property(nonatomic,copy)NSString *dateFormatter;
//**当前时间**//
@property(nonatomic,strong) NSDate *nowDate;
//
//**站位图片**//
@property(nonatomic,weak) UIImageView *imgV;

//**目标个数和完成数量的View**//
@property(nonatomic,weak) UIView *goaldANDcompleteView;
//**目标个数和完成数量的Label**//
@property(nonatomic,weak) UILabel *goaldANDcompleteLabel;
//**完成目标的个数**//
@property(nonatomic,assign)NSInteger completeCount;

@end

static NSString *identifier = @"goalCell";

@implementation ZJTimeGoalViewController

-(NSMutableArray *)remindDateArray{
    if (!_remindDateArray) {
        
        _remindDateArray = [NSMutableArray array];
    }
    return _remindDateArray;
}

-(NSMutableArray *)borrowMorryArray{
    if (!_borrowMorryArray) {
        
        _borrowMorryArray = [NSMutableArray array];
    }
    return _borrowMorryArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//    [self addDateFromSql];
    
    [self clickMonthButton:self.monthButton];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    [self setupNavi];
    //表视图
    [self setupTableView];
    //顶部视图
    [self setupTopView];
    //呈现月度目标的数据
    
}

#pragma mark   设置导航
-(void)setupNavi{
    
    self.view.backgroundColor = ZJColorFFFFFF;
    self.navigationItem.title = @"月度目标";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem zj_BarButtonItemWithTitle:@"新增" titleColor:ZJColorFFFFFF target:self action:@selector(clickAdd)];
}
-(void)clickAdd{
    
    ZJAddGoaldViewController *addView = [[ZJAddGoaldViewController alloc]init];
    addView.addGoaldModel = ZJAddGoaldModelWhite;
    addView.goaldTypeString = self.goaldTypeString;
    addView.dateString = self.dateString;
    addView.countString = self.countString;
    [self.navigationController pushViewController:addView animated:YES];
}

#pragma mark   设置顶部视图
-(void)setupTopView{
    //设置当前时间
    self.nowDate = [[NSDate alloc]init];
    
    UIView *top = [[UIView alloc]init];
    [self.view addSubview:top];
    self.topView = top;
    top.frame = CGRectMake(0, 0, self.view.width, PX2PT(132));
    top.backgroundColor = ZJColorFFFFFF;
    
    CGFloat itemW = (self.view.width -2)/3.0;
    
    CGFloat itemH = PX2PT(132);
    
    //月度目标
    UIButton *month = [[UIButton alloc]init];
    [top addSubview:month];
    self.monthButton = month;
    [self setButtonAtts:month buttonTitle:@"月度目标"];
    month.frame = CGRectMake(0, 0, itemW, itemH);
    [month addTarget:self action:@selector(clickMonthButton:) forControlEvents:UIControlEventTouchUpInside];
    //季度目标
    UIButton *season = [[UIButton alloc]init];
    [top addSubview:season];
    self.seasonButton = season;
    [self setButtonAtts:season buttonTitle:@"季度目标"];
    season.frame = CGRectMake(itemW+1, 0, itemW, itemH);
    [season addTarget:self action:@selector(clickSeasonButton:) forControlEvents:UIControlEventTouchUpInside];

    //年度目标
    UIButton *year = [[UIButton alloc]init];
    [top addSubview:year];
    self.yearButton = year;
    [self setButtonAtts:year buttonTitle:@"年度目标"];
    year.frame = CGRectMake(2*(itemW+1), 0, itemW, itemH);
    [year addTarget:self action:@selector(clickYearButton:) forControlEvents:UIControlEventTouchUpInside];

    //分割线
    [self separatorLine:CGRectMake(itemW, 8, 1, itemH -16) supView:top];
    [self separatorLine:CGRectMake(2*itemW+1, 8, 1, itemH-16) supView:top];
    [self separatorLine:CGRectMake(0, itemH-1, top.width, 1) supView:top];
    //目标与完成个数展示
    
    UIView *goaldView = [[UIView alloc]init];
    goaldView.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:goaldView];
    self.goaldANDcompleteView = goaldView;
    goaldView.frame = CGRectMake(0, top.height, zjScreenWidth, 20);
    
    UILabel *goalLabel = [[UILabel alloc]init];
    self.goaldANDcompleteLabel = goalLabel;
    [goaldView addSubview:goalLabel];
    goalLabel.textColor = ZJColor505050;
    goalLabel.textAlignment = NSTextAlignmentCenter;
    goalLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    goalLabel.width = zjScreenWidth;
    goalLabel.height = 16;
    goalLabel.x = 0;
    goalLabel.centerY = goaldView.height/2;
    CGRect frame = CGRectMake(0, goaldView.height-1, zjScreenWidth, 1);
    [self separatorLine:frame supView:goaldView];
}
//items
-(void)setButtonAtts:(UIButton *)button buttonTitle:(NSString *)title{
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    [button setTitleColor:ZJColor00D3A3 forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize55PX];
}
//分割线
-(void)separatorLine:(CGRect)frame supView:(UIView *)sup{
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = ZJColorDCDCDC;
    view.frame = frame;
    [sup addSubview:view];
}

#pragma mark   设置tableView
-(void)setupTableView{
    
    CGRect frame = CGRectMake(0, 0, zjScreenWidth, self.view.height -64);
    UITableView *table = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    [self.view addSubview:table];
    self.tableView = table;
    table.rowHeight = 85;
    table.dataSource = self;
    table.delegate = self;
    table.contentInset = UIEdgeInsetsMake(PX2PT(132)+20, 0, 0, 0);
    [table registerNib:[UINib nibWithNibName:@"ZJGoaldTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark   tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.remindDateArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJGoaldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    ZJGoalTableInfo *model =self.remindDateArray[indexPath.row];
    
    if (self.yearButton.selected) {
        
        NSString *nowYear = [self.nowDate zj_getStringFromDatWithFormatter:@"yyyy年"];
        
        if ([model.tag isEqualToString:nowYear]) {
            model.hidden = NO;
        }else{
            model.hidden = YES;
        }
        
        
    }else if (self.monthButton.selected){
        
        
        NSString *nowMonth = [self.nowDate zj_getStringFromDatWithFormatter:@"yyyy年MM月"];
        if ([model.tag isEqualToString:nowMonth]) {
            
            model.hidden = NO;
        }else{
            model.hidden = YES;
        }
        
        
    }else{
        NSDate *nowDate = [NSDate date];
        NSInteger nowYear = [nowDate zj_getRealTimeForRequire:NSCalendarUnitYear];
        NSInteger seasonIndex = [nowDate zj_getSeadonFromDate];
        
        model.isSeason = YES;
        
        if (model.year.integerValue == nowYear && model.tag.integerValue==seasonIndex){//当前年 当前季度
            model.hidden = NO;
            
            
        }else{
            model.hidden = YES;
            
        }
        
    }
    
    cell.model = model;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJGoalTableInfo *model =self.remindDateArray[indexPath.row];

    if (model.hidden) {
        UITableViewRowAction *delect = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            if (model.completeCount>=model.goalCount) {
                
                self.completeCount--;
            }
            //删除数组中的数据
            [self.remindDateArray removeObject:model];
            [self.borrowMorryArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            //删除数据库中的数据
            [ZJFMdb sqlDelecteData:model tableName:ZJGoalTableName headString:model.iAutoID];
            
            self.goaldANDcompleteLabel.text = [NSString stringWithFormat:@"共计%zd个目标,完成%zd个",self.remindDateArray.count,self.completeCount];

            
        }];
        delect.backgroundColor = ZJRGBColor(253, 1, 0, 1.0);
        return @[delect];

    }
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        ZJAddGoaldViewController *addView = [[ZJAddGoaldViewController alloc]init];
        addView.addGoaldModel = ZJAddGoaldModelEdit;
        addView.editDataModel = model;
        [self.navigationController pushViewController:addView animated:YES];
    }];
    UITableViewRowAction *delect = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //删除数组中的数据
        [self.remindDateArray removeObject:model];
        [self.borrowMorryArray removeObjectAtIndex:indexPath.row];

        //判断是否需要站位图片
        [self noDataAddImage];
        [self.tableView reloadData];
        //删除数据库中的数据
        [ZJFMdb sqlDelecteData:model tableName:ZJGoalTableName headString:model.iAutoID];
        self.goaldANDcompleteLabel.text = [NSString stringWithFormat:@"共计%zd个目标,完成%zd个",self.remindDateArray.count,self.completeCount];

    }];
    
    edit.backgroundColor = ZJColor00D3A3;
    delect.backgroundColor = ZJRGBColor(253, 1, 0, 1.0);
    return @[delect,edit];
}

#pragma mark   点击月度的Button
-(void)clickMonthButton:(UIButton *)button{
//    if (button.selected)return;
    self.goaldTypeString = button.titleLabel.text;
    self.tempButton.selected = NO;
    self.tempButton = button;
    self.tempButton.selected = YES;
    self.dateString =[[[NSDate alloc]init] zj_getStringFromDatWithFormatter:@"yyyy年MM月"];
    self.timeType = @"月度目标";
    self.countString = @"200";
    self.dateFormatter = @"yyyy年MM月";
    self.navigationItem.title = _timeType;
    self.completeCount = 0;

    [self addDateFromSql];

    self.goaldANDcompleteLabel.text = [NSString stringWithFormat:@"共计%zd个目标,完成%zd个",self.remindDateArray.count,self.completeCount];
    
}
#pragma mark   点击季度目标
-(void)clickSeasonButton:(UIButton *)button{
    if (button.selected)return;
    self.goaldTypeString = button.titleLabel.text;
    self.tempButton.selected = NO;
    self.tempButton = button;
    self.tempButton.selected = YES;
    //获取当前季度
    NSDate *date = [NSDate date];
    NSInteger season= [date zj_getSeadonFromDate];
    //查询type
    NSString *year = [date zj_getStringFromDatWithFormatter:@"yyyy年"];

    NSString *seasonString = [NSString stringWithFormat:@"%zd",season];
    
    self.dateString = [year stringByAppendingString:[seasonString zj_getSeasonFromIndex]];

    self.timeType = @"季度目标";
    self.countString = @"600";
    self.navigationItem.title = _timeType;
    self.completeCount = 0;

    [self addDateFromSql];

    self.goaldANDcompleteLabel.text = [NSString stringWithFormat:@"共计%zd个目标,完成%zd个",self.remindDateArray.count,self.completeCount];

}

#pragma mark   点击年度目标
-(void)clickYearButton:(UIButton *)button{
    if (button.selected)return;

    self.goaldTypeString = button.titleLabel.text;
    self.tempButton.selected = NO;
    self.tempButton = button;
    self.tempButton.selected = YES;
    self.dateString = [[[NSDate alloc]init] zj_getStringFromDatWithFormatter:@"yyyy年"];
    //查询type
    self.timeType = @"年度目标";
    self.countString = @"2400";
    self.dateFormatter = @"yyyy年";
    self.navigationItem.title = _timeType;
    self.completeCount = 0;

    [self addDateFromSql];
    self.goaldANDcompleteLabel.text = [NSString stringWithFormat:@"共计%zd个目标,完成%zd个",self.remindDateArray.count,self.completeCount];


}

#pragma mark   数据库
-(void)addDateFromSql{
    
    [self.remindDateArray removeAllObjects];
    ZJGoalTableInfo *model = [[ZJGoalTableInfo alloc]init];
    
//    NSString *year =[NSString stringWithFormat:@"%zd",[[[NSDate alloc]init] zj_getRealTimeForRequire:NSCalendarUnitYear]];//年份
    NSString *select = nil;
    if (self.yearButton.selected) {
        
        select = [NSString stringWithFormat:@"select * from %@ where type='%@'",ZJGoalTableName,self.timeType];

    }else if(self.seasonButton.selected){
        select = [NSString stringWithFormat:@"select * from %@ where type='%@'",ZJGoalTableName,self.timeType];

    }else{
        select = [NSString stringWithFormat:@"select * from %@ where  type='%@'",ZJGoalTableName,self.timeType];

    }
    
    [ZJFMdb sqlSelecteData:model selecteString:select success:^(NSMutableArray *successMsg) {
        
        NSMutableArray *temp = (NSMutableArray*)[successMsg reverseObjectEnumerator];
        [self.remindDateArray addObjectsFromArray:temp];
        
        [self borrowMoney:self.remindDateArray];
        [self.tableView reloadData];

    }];
    
    [self noDataAddImage];

}

-(void)borrowMoney:(NSMutableArray *)array{
    
    ZJGoalTableInfo *goald = [[ZJGoalTableInfo alloc]init];
    
    if (array.count>0) {
        
        goald = array.firstObject;
        
    }else{
        return;
    }
    
    
    NSString *select = nil;
    if (self.monthButton.selected) {
        
        NSString *month = [goald.tag zj_dateStringFormatter:@"yyyy年MM月" toFromatter:@"yyyy-MM"];
        select =[NSString stringWithFormat:@"SELECT sum(fBorrowMoney) AS val from crm_CustomerInfo where cLoanDate like '%@%%'",month];
        for (NSInteger i = 1; i< array.count; i++) {
            
            goald = array[i];
            
            NSString *Emonth = [goald.tag zj_dateStringFormatter:@"yyyy年MM月" toFromatter:@"yyyy-MM"];
            NSString *temp =[NSString stringWithFormat:@" UNION ALL SELECT sum(fBorrowMoney) AS val from crm_CustomerInfo where cLoanDate like '%@%%'",Emonth];
            select = [select stringByAppendingString:temp];

            
        }
        
    }else if (self.yearButton.selected){
        
        NSString *year = [goald.tag zj_dateStringFormatter:@"yyyy年" toFromatter:@"yyyy"];
        select =[NSString stringWithFormat:@"SELECT sum(fBorrowMoney) AS val from crm_CustomerInfo where cLoanDate like '%@%%'",year];

        for (NSInteger i = 1; i< array.count; i++) {
            
            goald = array[i];
            
            NSString *Eyear = [goald.tag zj_dateStringFormatter:@"yyyy年" toFromatter:@"yyyy"];
            NSString *temp =[NSString stringWithFormat:@" UNION ALL SELECT sum(fBorrowMoney) AS val from crm_CustomerInfo where cLoanDate like '%@%%'",Eyear];
            select = [select stringByAppendingString:temp];
            
            
        }

        
    }else if (self.seasonButton.selected){
        
        NSString *seasonMonth = [self appendingMonthFromSeason:goald.tag year:goald.year];
        select = [NSString stringWithFormat:@"SELECT sum(fBorrowMoney) AS val from crm_CustomerInfo where %@",seasonMonth];
        
        for (NSInteger i = 1; i< array.count; i++) {
            
            goald = array[i];
            
            seasonMonth = [self appendingMonthFromSeason:goald.tag year:goald.year];
            
            NSString *temp =[NSString stringWithFormat:@" UNION ALL SELECT sum(fBorrowMoney) AS val from crm_CustomerInfo where %@",seasonMonth];
            select = [select stringByAppendingString:temp];
            
            
        }
        
    }
    
    self.borrowMorryArray = [ZJFMdb sqlMoney:select];
    
    for (NSInteger i = 0; i<self.borrowMorryArray.count; i++) {
        
        NSInteger countMoney = [self.borrowMorryArray[i]integerValue];
        
        ZJGoalTableInfo *goalM = array[i];
        
        goalM.completeCount = countMoney;
        
        if (countMoney>=goalM.goalCount) {
            
            self.completeCount++;
        }
    }
    

}
//SELECT sum(fBorrowMoney) AS val from crm_CustomerInfo where cLoanDate like '(null)%' UNION ALL SELECT sum(fBorrowMoney) AS val from crm_CustomerInfo where cLoanDate like '(null)%' UNION ALL SELECT sum(fBorrowMoney) AS val from crm_CustomerInfo where cLoanDate like '(null)%' UNION ALL SELECT sum(fBorrowMoney) AS val from crm_CustomerInfo where cLoanDate like '(null)%'

#pragma mark   数据的展位图骗
-(void)noDataAddImage{
    
    if (self.remindDateArray.count==0 &&!self.imgV) {
        
        UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"无目标"]];
        self.imgV = imgV;
        
        [self.view addSubview:imgV];
        imgV.center = self.view.center;
        self.goaldANDcompleteView.hidden = YES;
        
    }else if (self.remindDateArray.count>0){
        [self.imgV removeFromSuperview];
        self.imgV = nil;
        self.goaldANDcompleteView.hidden = NO;
        
    }
}

#pragma mark   按照季节返回拼接月份
-(NSString *) appendingMonthFromSeason:(NSString *)season year:(NSString *)year{
    NSString *mounthString = nil;
    if ([season isEqualToString:@"1"]) {
        
        mounthString = [NSString stringWithFormat:@"(cLoanDate like '%@-01%%' OR cLoanDate like '%@-02%%' OR cLoanDate like '%@-03%%')",year,year,year];
    
    }else if ([season isEqualToString:@"2"]){
        mounthString = [NSString stringWithFormat:@"(cLoanDate like '%@-04%%' OR cLoanDate like '%@-05%%' OR cLoanDate like '%@-06%%')",year,year,year];

        
    }else if ([season isEqualToString:@"3"]){
        
        mounthString = [NSString stringWithFormat:@"(cLoanDate like '%@-07%%' OR cLoanDate like '%@-08%%' OR cLoanDate like '%@-09%%')",year,year,year];

        
    }else{
        
        mounthString = [NSString stringWithFormat:@"(cLoanDate like '%@-10%%' OR cLoanDate like '%@-11%%' OR cLoanDate like '%@-12%%')",year,year,year];

        
    }
    
    
    return mounthString;
}
@end
