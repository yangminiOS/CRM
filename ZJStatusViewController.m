//
//  ZJStatusViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/10.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJStatusViewController.h"
#import "ZJFMdb.h"
#import <FMDB.h>
#import "ZJcustomerTableInfo.h"
#import "ZJCustomerItemsTableInfo.h"

//颜色分类
#import "UIColor+K.h"
//第三方日期
#import "LTPickerView/LTPickerView.h"
@interface ZJStatusViewController ()
{
    //年份按钮
    UIButton *_LastButton;
    
}
@property (nonatomic,assign)NSInteger difference;
//底部视图
@property (nonatomic,weak)UIView *upview;
//客户数据数组
@property (nonatomic,strong)NSMutableArray *TitleArray;
//中间对比年份label
@property (nonatomic,weak)UILabel *YearLabel;
//第三方日期类
@property (nonatomic,weak)LTPickerView *pickerView;
//底部按钮数组
@property (nonatomic,strong)NSMutableArray *buttons;


@property (nonatomic,assign)NSInteger month;

@property (nonatomic,assign)NSInteger day;
//滚动显示数据
@property (nonatomic,weak)UIScrollView *scrollView;

@property (nonatomic,strong)NSMutableArray *SumArray;

@property (nonatomic,strong)NSMutableArray *PkArray;

@property (nonatomic,strong)NSMutableArray *SubArray;
//记录本周月份数组
@property (nonatomic,strong)NSMutableArray *MonthArray;
//记录本周天数数组
@property (nonatomic,strong)NSMutableArray *DayArray;
//记录本周年份
@property (nonatomic,strong)NSMutableArray *YearArray;

//记录上周年份数组
@property (nonatomic,strong)NSMutableArray *lastYearArray;
//记录上周月份数组
@property (nonatomic,strong)NSMutableArray *lastMonthArray;
//记录上周天分数组
@property (nonatomic,strong)NSMutableArray *lastDayArray;


@property (nonatomic,assign)NSInteger year;

@property (nonatomic,assign)NSInteger TodayYear;

@property (nonatomic,assign)NSInteger PKYear;

@end

@implementation ZJStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户状态分析";
    self.view.backgroundColor = ZJBackGroundColor;
    NSDate *date = [NSDate new];
    NSInteger year = [date zj_getRealTimeForRequire:NSCalendarUnitYear];
    self.TodayYear = self.year = year;

    NSInteger month = [date zj_getRealTimeForRequire:NSCalendarUnitMonth];
    self.month = month;
    
    NSInteger day = [date zj_getRealTimeForRequire:NSCalendarUnitDay];
    self.day = day;
    
    //添加底部按钮
    [self addUpview];
    [self selectYear:year andMonth:month];
    //创建对比视图
    [self comparison];
    
    //客户录入时间统计
    UILabel *Thecustomertime = [[UILabel alloc]init];
    Thecustomertime.textAlignment = NSTextAlignmentLeft;
    [Thecustomertime zj_labelText:@"依据客户录入时间统计" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    Thecustomertime.x = PX2PT(60);
    Thecustomertime.y = zjScreenHeight - PX2PT(146 + 270);
    [Thecustomertime zj_adjustWithMin];
    [self.view addSubview:Thecustomertime];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.pickerView close];
    
}
#pragma mark---------添加视图
-(void)addUpview{
    CGFloat heigt = PX2PT(146);
    UIView *upview = [[UIView alloc]initWithFrame:CGRectMake(0, zjScreenHeight - 64 - heigt, zjScreenWidth, heigt)];
    
    upview.backgroundColor = ZJColorFFFFFF;
    self.upview = upview;
    //虚线
    [self setSeparatorViewWithFrame:CGRectMake((zjScreenWidth-4)/5, 0, 1, heigt)];
    
    [self setSeparatorViewWithFrame:CGRectMake(2*(zjScreenWidth-4)/5+1, 0, 1, heigt)];
    
    [self setSeparatorViewWithFrame:CGRectMake(3*(zjScreenWidth-4)/5+2, 0, 1, heigt)];
    [self setSeparatorViewWithFrame:CGRectMake(4*(zjScreenWidth-4)/5+3, 0, 1, heigt)];
    [self setSeparatorViewWithFrame:CGRectMake(0, 0, zjScreenWidth, 1)];
    
    self.buttons = [[NSMutableArray alloc]init];
    NSString *year = [NSString stringWithFormat:@"%zd",self.year];
    NSArray *titleArray = @[@"今天",@"本周",@"本月",@"本季度", year];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(zjScreenWidth / titleArray.count * i, 0,(zjScreenWidth - 1 * titleArray.count - 1) / titleArray.count  , heigt - 1)];
        
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
        [button setTitleColor:ZJColor505050 forState:UIControlStateNormal];
        [button setTitleColor:ZJColor00D3A3 forState:UIControlStateSelected];
        [button addTarget:self action:@selector(timeselection:) forControlEvents:UIControlEventTouchUpInside];
        if (i==4) {
            _LastButton = button;
            button.selected = YES;
            [button setTitle:titleArray[4] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"D-A_arrows"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"D-A_arrows-green"] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
            [button setTitleColor:ZJColor505050 forState:UIControlStateNormal];
            [button setTitleColor:ZJColor00D3A3 forState:UIControlStateSelected];
            [button zj_changeImageAndTitel];
            
        }
        button.tag = i;
        [self.buttons addObject:button];
        [upview addSubview:button];
        
    }
    [self.view addSubview:upview];
}
//设置底部按钮的属性
-(void)setButton:(UIButton *)button title:(NSString *)title{
    [self.upview addSubview:button];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    
    [button setTitleColor:ZJColor00D3A3 forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"D-A_arrows"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"D-A_arrows-green"] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [button zj_changeImageAndTitel];
    
}

#pragma mark---------选择颜色高亮
-(void)timeselection:(UIButton*)sender
{
    for(UIButton* btn in self.buttons) {
        btn.selected = NO;
    }
    sender.selected  =   YES ;
    switch (sender.tag) {
        case 0:
        {
            
            NSDate *date = [NSDate new];
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSTimeInterval time = 24 * 60 * 60 ;
            NSDate * lastYear = [date dateByAddingTimeInterval:-time];
            NSString * startDate = [dateFormatter stringFromDate:lastYear];
        
            //截取月份
            NSRange range = NSMakeRange(5, 2);
            NSString *str1 = [startDate substringWithRange:range];
            NSInteger month = [str1 integerValue];
            //截取天数
            NSRange rangeDay = NSMakeRange(8,2);
            NSString *DayStr = [startDate substringWithRange:rangeDay];
            NSInteger day = [DayStr integerValue];
            
            [self.SumArray removeAllObjects];
            [self.SubArray removeAllObjects];
            [self.PkArray removeAllObjects];
            
            NSMutableArray *dataModel = [NSMutableArray array];
            NSMutableArray *pesrsonsArray = [NSMutableArray array];
            NSMutableArray *contrastArray = [NSMutableArray array];
            ZJCustomerItemsTableInfo *model = [ZJCustomerItemsTableInfo new];
            NSString *selct = @"SELECT * FROM crm_CustomerItems WHERE type='customerState';";
            [ZJFMdb sqlSelecteData:model selecteString:selct success:^(NSMutableArray *successMsg) {
                [dataModel addObjectsFromArray:successMsg];
            }];
            for (ZJCustomerItemsTableInfo *zj in dataModel) {
                [pesrsonsArray addObject:@(zj.iAutoID)];
            }
            for (int i = 0; i < self.TitleArray.count; i++) {
                NSInteger ID = [pesrsonsArray[i] integerValue];
                NSString *str = [NSString stringWithFormat:@"select *,(A.NUM1-B.NUM2) AS SUB FROM(SELECT count(iAutoID) AS NUM1,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID=%zd) AS NAME FROM crm_CustomerInfo AS b WHERE (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%%zd;')AND (cCreateYear='%zd' AND cCreateMonth='%02zd' AND cCreateDay='%02zd')) AS A,(SELECT count(iAutoID) AS NUM2 FROM crm_CustomerInfo AS b WHERE (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%%zd;')AND (cCreateYear='%zd' AND cCreateMonth='%02zd' AND cCreateDay='%02zd')) AS B",ID,ID,ID,ID,self.year,self.month,self.day,ID,ID,ID,self.year,month,day];
                contrastArray = [ZJFMdb text:str];
                for (int i = 0; i < contrastArray.count; i++) {
                    NSDictionary *dic = contrastArray[i];
                    NSString *num = dic[@"num"];
                    [self.SumArray addObject:num];
                    NSString *pk = dic[@"pk"];
                    [self.PkArray addObject:pk];
                    NSString *sum = dic[@"contrast"];
                    [self.SubArray addObject:sum];
                    
                }

            }
            
            //显示数据
            [self comparison];
            
        }
            break;
        case 1:
        {
            [self.SumArray removeAllObjects];
            [self.SubArray removeAllObjects];
            [self.PkArray removeAllObjects];
            //本周的数据
            [self selectWeekYear:self.year andMonth:self.month andDay:self.day];
            //上周的数据
            [self LastweekYear:self.year andMonth:self.month andDay:self.day];
            NSMutableArray *dataModel = [NSMutableArray array];
            NSMutableArray *pesrsonsArray = [NSMutableArray array];
            NSMutableArray *contrastArray = [NSMutableArray array];
            ZJCustomerItemsTableInfo *model = [ZJCustomerItemsTableInfo new];
            NSString *selct = @"SELECT * FROM crm_CustomerItems WHERE type='customerState';";
            [ZJFMdb sqlSelecteData:model selecteString:selct success:^(NSMutableArray *successMsg) {
                [dataModel addObjectsFromArray:successMsg];
            }];
            for (ZJCustomerItemsTableInfo *zj in dataModel) {
                [pesrsonsArray addObject:@(zj.iAutoID)];
            }
            for (int i = 0; i < pesrsonsArray.count; i++) {
                NSMutableString *sql = [[NSMutableString alloc]initWithString:@"select *,(A.NUM1-B.NUM2) AS SUB FROM            ("];
            NSInteger ID = [pesrsonsArray[i] integerValue];
            NSString * SQLtemp1 = [NSString stringWithFormat:@" SELECT count(iAutoID) AS NUM1,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID= %zd ) AS NAME FROM crm_CustomerInfo AS b WHERE (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%%zd;')  AND ( ", ID,ID,ID,ID];
                [sql appendString:SQLtemp1];
                
                NSMutableString * SQLtemp2 = [[NSMutableString alloc] init];
                for ( int n = 0 ; n < 7 ; n++) {
                    if(n <6){
                 SQLtemp2 = [NSMutableString stringWithFormat: @"   (cCreateYear= '%zd' AND cCreateMonth='%02zd' AND cCreateDay = '%02zd') OR ", [self.YearArray[n] integerValue], [self.MonthArray[n] integerValue], [self.DayArray[n] integerValue]];
                    }else
                    {
                    SQLtemp2 = [NSMutableString stringWithFormat: @"   (cCreateYear= '%zd' AND cCreateMonth='%02zd' AND cCreateDay='%02zd') ", [self.YearArray[n] integerValue], [self.MonthArray[n] integerValue], [self.DayArray[n] integerValue]];
                    }
                    [sql appendString: SQLtemp2];
                }
                [sql appendString: @")) AS A, ("];
                
                
                [sql appendFormat:@"SELECT count(iAutoID) AS NUM2 FROM crm_CustomerInfo AS b WHERE (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%%zd;') AND ( ",ID,ID,ID];
                for (int  j = 0;j < 7; j++) {
                    SQLtemp2 = [NSMutableString stringWithFormat:@"(cCreateYear='%zd' AND cCreateMonth='%02zd' AND cCreateDay='%02zd') OR",[self.lastYearArray[j] integerValue],[self.lastMonthArray[j] integerValue],[self.lastDayArray[j] integerValue]];
                    if (j == 6) {
                        SQLtemp2 = [NSMutableString stringWithFormat:@"(cCreateYear='%zd' AND cCreateMonth='%02zd' AND cCreateDay='%02zd') )",[self.lastYearArray[j] integerValue],[self.lastMonthArray[j] integerValue],[self.lastDayArray[j] integerValue]];
                    }
                    [sql appendString:SQLtemp2];
                }
                [sql appendString:@") AS B"];
              
                contrastArray = [ZJFMdb text:sql];
                for (int i = 0; i < contrastArray.count; i++) {
                    NSDictionary *dic = contrastArray[i];
                    NSString *num = dic[@"num"];
                
                    [self.SumArray addObject:num];
                    
                    NSString *pk = dic[@"pk"];
                    [self.PkArray addObject:pk];
                    
                    NSString *sum = dic[@"contrast"];
                    [self.SubArray addObject:sum];
                    
                }
                
            }
            
            //显示数据
            [self comparison];
        }
         break;
        case 2:
        {
            [self.SumArray removeAllObjects];
            [self.SubArray removeAllObjects];
            [self.PkArray removeAllObjects];
            NSInteger temp = 0;
            NSInteger tempYear = self.year;
            if (self.month - 1 == 0) {
                temp = 12;
                tempYear = tempYear - 1;
            }else {
                temp = self.month - 1;
            }
            //本月的数据
            NSMutableArray *contrastArray = [NSMutableArray array];
            NSMutableArray *dataModel = [NSMutableArray array];
            NSMutableArray *pesrsonsArray = [NSMutableArray array];
            ZJCustomerItemsTableInfo *model = [ZJCustomerItemsTableInfo new];
            NSString *selct = @"SELECT * FROM crm_CustomerItems WHERE type='customerState';";
            [ZJFMdb sqlSelecteData:model selecteString:selct success:^(NSMutableArray *successMsg) {
                [dataModel addObjectsFromArray:successMsg];
            }];
            for (ZJCustomerItemsTableInfo *zj in dataModel) {
                [pesrsonsArray addObject:@(zj.iAutoID)];
            }
            for (int i = 0; i < pesrsonsArray.count; i++) {
                NSInteger ID = [pesrsonsArray[i] integerValue];
                
                NSString *pesron = [NSString stringWithFormat:@"select *,(A.NUM1-B.NUM2) AS SUB FROM(SELECT count(iAutoID) AS NUM1,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID=%zd) AS NAME FROM crm_CustomerInfo AS b WHERE (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%%zd;')AND (cCreateYear='%zd' AND cCreateMonth='%02zd')) AS A,(SELECT count(iAutoID) AS NUM2 FROM crm_CustomerInfo AS b WHERE (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%%zd;')AND (cCreateYear='%zd' AND cCreateMonth='%02zd')) AS B",ID,ID,ID,ID,self.year,self.month,ID,ID,ID,tempYear,temp];
                
                 contrastArray = [ZJFMdb text:pesron];
                for (int i = 0; i < contrastArray.count; i++) {
                    NSDictionary *dic = contrastArray[i];
                    NSString *num = dic[@"num"];
                    [self.SumArray addObject:num];
                   
                    NSString *pk = dic[@"pk"];
                    [self.PkArray addObject:pk];
                   
                    NSString *sum = dic[@"contrast"];
                    [self.SubArray addObject:sum];
                 
                }
            }
            //显示数据
            [self comparison];

        }
            break;
        case 3:
        {
            
            [self.SumArray removeAllObjects];
            [self.SubArray removeAllObjects];
            [self.PkArray removeAllObjects];
            
            //本季度的数据
            NSDate *dete = [NSDate new];
            //记录当前季度的月份
            NSInteger onemoth = 0;
            NSInteger twomonth = 0;
            NSInteger  threemoth = 0;
            NSInteger moth =  [dete zj_getSeadonFromDate];
            NSInteger lastYear = self.year;
            switch (moth) {
                case 1:
                {
                    onemoth = 1;
                    twomonth = 2;
                    threemoth = 3;
                    lastYear = self.year - 1;
                    
                }
                    break;
                case 2:
                {
                    onemoth = 4;
                    twomonth = 5;
                    threemoth = 6;
                }
                    break;
                case 3:
                {
                    onemoth = 7;
                    twomonth = 8;
                    threemoth = 9;
                }
                default:
                {
                    onemoth = 10;
                    twomonth = 11;
                    threemoth = 12;
                }
                    break;
            }
            NSInteger LastOneMonth = 0;
            NSInteger LastTwoMonth = 0;
            NSInteger LastThreeMonth = 0;
            switch (moth) {
                case 1:
                {
                    LastOneMonth = 10;
                    LastTwoMonth = 11;
                    LastThreeMonth = 12;
                }
                    break;
                case 2:
                {
                    LastOneMonth = 7;
                    LastTwoMonth = 8;
                    LastThreeMonth = 9;
                }
                    break;
                case 3:
                {
                    LastOneMonth = 10;
                    LastTwoMonth = 11;
                    LastThreeMonth = 12;
                }
                    break;
                case 4:
                {
                    LastOneMonth = 1;
                    LastTwoMonth = 2;
                    LastThreeMonth = 3;
                }
                    break;
                default:
                    break;
            }

            
            NSMutableArray *contrastArray = [NSMutableArray array];
            NSMutableArray *dataModel = [NSMutableArray array];
            NSMutableArray *pesrsonsArray = [NSMutableArray array];
            ZJCustomerItemsTableInfo *model = [ZJCustomerItemsTableInfo new];
            NSString *selct = @"SELECT * FROM crm_CustomerItems WHERE type='customerState';";
            [ZJFMdb sqlSelecteData:model selecteString:selct success:^(NSMutableArray *successMsg) {
                [dataModel addObjectsFromArray:successMsg];
            }];
            for (ZJCustomerItemsTableInfo *zj in dataModel) {
                [pesrsonsArray addObject:@(zj.iAutoID)];
            }
            for (int i = 0; i < pesrsonsArray.count; i++) {
                NSInteger ID = [pesrsonsArray[i] integerValue];
                NSString *pesron = [NSString stringWithFormat:@"select *,(A.NUM1-B.NUM2) AS SUB FROM(SELECT count(iAutoID) AS NUM1,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID=%zd) AS NAME FROM crm_CustomerInfo AS b WHERE (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%%zd;') AND (cCreateMonth='%02zd' OR cCreateMonth='%02zd' OR cCreateMonth='%02zd') AND cCreateYear='%zd') AS A,(SELECT count(iAutoID) AS NUM2 FROM crm_CustomerInfo AS b WHERE (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%%zd;')AND (cCreateMonth='%02zd' OR cCreateMonth='%02zd' OR cCreateMonth='%02zd') AND cCreateYear='%zd') AS B",ID,ID,ID,ID,onemoth,twomonth,threemoth,self.year,ID,ID,ID,LastOneMonth,LastTwoMonth,LastThreeMonth,lastYear];
                
                contrastArray = [ZJFMdb text:pesron];
                for (int i = 0; i < contrastArray.count; i++) {
                    NSDictionary *dic = contrastArray[i];
                    NSString *num = dic[@"num"];
                    [self.SumArray addObject:num];
                    
                    NSString *pk = dic[@"pk"];
                    [self.PkArray addObject:pk];
                   
                    NSString *sum = dic[@"contrast"];
                    [self.SubArray addObject:sum];
                  
                }
            }

            //显示数据
            [self comparison];
        }
            break;
        case 4:
        {
            LTPickerView* pickerView = [[LTPickerView alloc]init];
            self.pickerView = pickerView;
            pickerView.dataSource = @[@"2000",@"2001",@"2002",@"2003",@"2004",@"2005",@"2006",@"2007",@"2008",@"2009",@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030",@"2031",@"2032",@"2033",@"2034",@"2035",@"2036",@"2037",@"2038",@"2039",@"2040",@"2041",@"2042",@"2043",@"2044",@"2045",@"2046",@"2047",@"2048",@"2049",@"2050",@"2051",@"2052",@"2053",@"2054",@"2055",@"2056",@"2057",@"2058",@"2059",@"2060"];//设置要显示的数据
            [pickerView show];//显示
             __weak __typeof(self) weakself=self;
            pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
                self.PKYear = [str integerValue];
                [_LastButton setTitle:str forState:UIControlStateNormal];
                [_LastButton zj_changeImageAndTitel];
                NSString *yearLable = [NSString stringWithFormat:@"%@年",str];
                [weakself.YearLabel zj_labelText:yearLable
                                   textColor:ZJColor505050
                                    textSize:ZJTextSize55PX];
                [weakself.SumArray removeAllObjects];
                [weakself.PkArray removeAllObjects];
                [weakself.SubArray removeAllObjects];
                [weakself selectYear:[str integerValue] andMonth:weakself.month];
                [weakself comparison];
            };
        }
            break;
        default:
            break;
    }
}


//创建虚线
-(void)setSeparatorViewWithFrame:(CGRect)frame{
    
    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = ZJColorDCDCDC;
    
    [self.upview addSubview:view];
    
    view.frame = frame;
    
}



#pragma mark 创建对比视图

-(void)comparison{
    //创建背景视图
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,1, zjScreenWidth, PX2PT(128))];
    view.backgroundColor = ZJColorFFFFFF;
    
    //创建虚线
    UIView *lineview = [[UIView alloc]init];
    lineview.backgroundColor = ZJColorDCDCDC;
    lineview.frame =CGRectMake(0, 0, zjScreenWidth, 1);
    [view addSubview:lineview];
    UIView *otherlineview = [[UIView alloc]init];
    otherlineview.backgroundColor = ZJColorDCDCDC;
    otherlineview.frame =CGRectMake(0,view.height-1, zjScreenWidth, 1);
    [view addSubview:otherlineview];
    
    //创建文本
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentLeft;
    
    for (UIButton *sender in self.buttons) {
        if (sender.selected == YES) {
            if (sender.tag == 4) {
                
                [label zj_labelText:[NSString stringWithFormat:@"今年"]
                          textColor:ZJColor505050
                           textSize:ZJTextSize55PX];
                
                [label zj_adjustWithMin];
                label.x = PX2PT(437);
                label.centerY = view.height/2;
                [view addSubview:label];
            }else {
            [label zj_labelText:[NSString stringWithFormat:@"%@",sender.titleLabel.text]
                      textColor:ZJColor505050
                       textSize:ZJTextSize55PX];
            
            [label zj_adjustWithMin];
            label.x = PX2PT(437);
            label.centerY = view.height/2;
            [view addSubview:label];
            }
        }
    }
    
    CGFloat imgX = CGRectGetMaxX(label.frame)+PX2PT(80);
    
    //创建pk图片
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, 5, PX2PT(100), PX2PT(100))];
    imageview.image = [UIImage imageNamed:@"PK"];
    [view addSubview:imageview];
    
    //创建年
    CGFloat labeX = CGRectGetMaxX(imageview.frame)+ PX2PT(60);
    UILabel *labelyear = [[UILabel alloc]init];
    self.YearLabel = labelyear;
    label.textAlignment = NSTextAlignmentLeft;
    for (UIButton *sender in self.buttons) {
        if (sender.selected == YES) {
            switch (sender.tag) {
                case 0:
                {
                    [labelyear zj_labelText:@"昨天"
                                  textColor:ZJColor505050
                                   textSize:ZJTextSize55PX];
                }
                    break;
                case 1:
                {
                    [labelyear zj_labelText:@"上周"
                                  textColor:ZJColor505050
                                   textSize:ZJTextSize55PX];
                }
                    break;
                case 2:
                {
                    [labelyear zj_labelText:@"上个月"
                                  textColor:ZJColor505050
                                   textSize:ZJTextSize55PX];
                }
                    break;
                case 3:
                {
                    [labelyear zj_labelText:@"上季度"
                                  textColor:ZJColor505050
                                   textSize:ZJTextSize55PX];
                }
                    break;
                default:
                {
                    
                    
                    if ( self.PKYear == 0) {
                        [labelyear zj_labelText:[NSString stringWithFormat:@"%zd年",self.year]
                                      textColor:ZJColor505050
                                       textSize:ZJTextSize55PX];
                        break;
                    }
                    [labelyear zj_labelText:[NSString stringWithFormat:@"%zd年",self.PKYear]
                                  textColor:ZJColor505050
                                   textSize:ZJTextSize55PX];
                }
                    break;
            }
        }
    }
    [labelyear zj_adjustWithMin];
    labelyear.x = labeX;
    [labelyear zj_adjustWithMin];
    labelyear.centerY = view.height/2;
    [view addSubview:labelyear];
    
    [self.view addSubview:view];
    
    //创建滚动视图

    NSArray* colorArray = @[@"#295aa5",@"#52bdbd",@"#ffad6b",@"#f784a5",@"#ceb55a",@"#31b5d6",@"#ff7e3e",@"#ffe608",@"#16b6d3",@"#737bb5",@"#de6b73",@"#3aa55a",@"#e5f6c4",@"#738cc5",@"#8c407d",@"#ff7100",@"#ef1063",@"#e63a8c",@"#a5738c",@"#bd2119"];
    //创建滚动视图
    
    UIScrollView *otherscorllView = [UIScrollView new];
    otherscorllView.frame = CGRectMake(0,view.height, zjScreenWidth, zjScreenHeight - PX2PT(80)  - 64 - 50 - view.height);
    [otherlineview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.scrollView = otherscorllView;
    otherscorllView.backgroundColor = ZJColorFFFFFF;
    otherscorllView.contentSize = CGSizeMake(zjScreenWidth, PX2PT(64+40)*self.TitleArray.count);
    otherscorllView.showsHorizontalScrollIndicator = NO;
    otherscorllView.bounces = NO;
    
    
    //对比人数
    
    [self Calculatedifference:view andCGUP:PX2PT(30) andCGWidth:PX2PT(34) andHeigth:PX2PT(64)];
    
    for (int i = 0; i < self.TitleArray.count; i++) {
        //添加视图到滚动视图中
        [otherscorllView addSubview:[self otheraddUpmiviewWithimageName:colorArray[i]  andTxet:self.TitleArray[i] andY:i andSum:self.SumArray[i] andPk:self.PkArray[i] andSub:self.SubArray[i]]];
    }
    [self.view addSubview:otherscorllView];
    [self.view addSubview:view];
}
#pragma mark---------创建点击按钮事件后的小分类视图
-(UIView *)otheraddUpmiviewWithimageName:(NSString*)name andTxet:(NSString*)text andY:(int)y  andSum:(NSString *)Sum andPk:(NSString *)pk andSub:(NSString *)sub{
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = ZJColorFFFFFF;
    
    view.frame = CGRectMake(0, PX2PT(64+40)*y, zjScreenWidth,PX2PT(64+40));
    //小方块
    UIView* imageview  = [[UIView alloc]initWithFrame:CGRectMake(20,(PX2PT(64+40)-PX2PT(64))/2, 64/3, PX2PT(64))];
    imageview.backgroundColor = [UIColor colorWithHexString:name];
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius = imageview.bounds.size.width/6;
    [view addSubview:imageview];
    
    UILabel* label = [[UILabel alloc]initWithFrame:
                      CGRectMake((40+40+64)/2.5,(PX2PT(64+40)-PX2PT(45))/2, 100,  ZJTextSize45PX)];
    
    label.textAlignment = NSTextAlignmentLeft;
    [label zj_labelText:text textColor:ZJColor505050
               textSize:ZJTextSize45PX];
    
    //人数label
    UILabel *pesons = [UILabel new];
    pesons.textAlignment = NSTextAlignmentRight;
    [pesons zj_labelText:[NSString stringWithFormat:@"%@人",Sum]
               textColor:ZJColor848484
                textSize:ZJTextSize45PX];
    pesons.x = PX2PT(437);
    [pesons zj_adjustWithMin];
    pesons.centerY = view.height/2;
    [view addSubview:pesons];
    
    [view addSubview:label];
    
    //对比人数
    UILabel *pkLabel = [UILabel new];
    pkLabel.textAlignment = NSTextAlignmentRight;
    [pkLabel zj_labelText:[NSString stringWithFormat:@"%@人",pk]
               textColor:ZJColor848484
                textSize:ZJTextSize45PX];
    pkLabel.x = PX2PT(437 + 400);
    [pkLabel zj_adjustWithMin];
    pkLabel.centerY = view.height/2;
    [view addSubview:pkLabel];
    
    
    //上升还是下降人数
    UILabel *uplabel = [UILabel new];
    uplabel.textAlignment = NSTextAlignmentRight;
    [uplabel zj_labelText:[NSString stringWithFormat:@"%@人",sub]
                textColor:ZJColor848484
                 textSize:ZJTextSize45PX];
    //上升还是下降图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(view.width - uplabel.width - PX2PT(190), PX2PT(40), PX2PT(17), PX2PT(32))];
    
    NSInteger temp = [Sum integerValue];
    NSInteger temp1 = [pk integerValue];
    
    if (temp - temp1 > 0) {
        
        imageView.image = [UIImage imageNamed:@"D-A_go-up-small"];
        
    }else if (temp - temp1 < 0){
        
        imageView.image = [UIImage imageNamed:@"D-A_decline-small"];
        
    }else if (temp - temp1 == 0 && temp == 0){

            [uplabel zj_labelText:@"0人"
                        textColor:ZJColor848484
                         textSize:ZJTextSize45PX];
        
    }else {
         
            [uplabel zj_labelText:@"相同"
                        textColor:ZJColor848484
                         textSize:ZJTextSize45PX];
         
    }
    
    uplabel.x =  view.width - 40;
    [uplabel zj_adjustWithMin];
    uplabel.centerY = view.height/2;
    [view addSubview:uplabel];
    
  
    [view addSubview:imageView];
    return view;

}



//查询数据
- (void)selectYear:(NSInteger) year andMonth:(NSInteger) month {
    self.TitleArray = [NSMutableArray array];
    self.SumArray = [NSMutableArray array];
    self.PkArray = [NSMutableArray array];
    self.SubArray = [NSMutableArray array];
   
    NSMutableArray *dataModel = [NSMutableArray array];
    NSMutableArray *pesrsonsArray = [NSMutableArray array];
    NSMutableArray *contrastArray = [NSMutableArray array];
    ZJCustomerItemsTableInfo *model = [ZJCustomerItemsTableInfo new];
    NSString *selct = @"SELECT * FROM crm_CustomerItems WHERE type='customerState';";
    [ZJFMdb sqlSelecteData:model selecteString:selct success:^(NSMutableArray *successMsg) {
        [dataModel addObjectsFromArray:successMsg];
    }];
    for (ZJCustomerItemsTableInfo *zj in dataModel) {
        [self.TitleArray addObject:zj.itemString];
        [pesrsonsArray addObject:@(zj.iAutoID)];
    }
    for (int i = 0; i < self.TitleArray.count; i++) {
        NSInteger ID = [pesrsonsArray[i] integerValue];
        NSString *str = [NSString stringWithFormat:@"select *,(A.NUM1-B.NUM2) AS SUB FROM(SELECT count(iAutoID) AS NUM1,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID=%zd) AS NAME FROM crm_CustomerInfo AS b WHERE (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%%zd;') AND (cCreateYear='%zd')) AS A,(SELECT count(iAutoID) AS NUM2 FROM crm_CustomerInfo AS b WHERE (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%%zd;') AND (cCreateYear='%zd')) AS B",ID,ID,ID,ID,self.TodayYear,ID,ID,ID,year];
        
        contrastArray = [ZJFMdb text:str];
        for (int i = 0; i < contrastArray.count; i++) {
            NSDictionary *dic = contrastArray[i];
            NSString *num = dic[@"num"];
            [self.SumArray addObject:num];
            NSString *pk = dic[@"pk"];
           
            [self.PkArray addObject:pk];
            NSString *sum = dic[@"contrast"];

            [self.SubArray addObject:sum];
            
        }
    }
    
}

//计算差值

- (void)Calculatedifference :(UIView *) head andCGUP:(CGFloat )y andCGWidth:(CGFloat)with andHeigth:(CGFloat ) heigth{
    //人数label
    NSInteger temp = 0;
    for (NSString * str in self.SumArray) {
        NSInteger person = [str integerValue];
        temp = temp + person;
    }
    
    //对比人数
    NSInteger temp1 = 0;
    for (NSString * str in self.PkArray) {
        NSInteger person = [str integerValue];
        temp1 = temp1 + person;
    }
    //差值
    NSInteger difference = 0;
    
    UILabel *uplabel = [UILabel new];
    uplabel.textAlignment = NSTextAlignmentRight;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(head.width - uplabel.width - PX2PT(200), y, with, heigth)];
    if (temp > temp1) {
        difference = temp - temp1;
        self.difference = difference;
        //上升人数
        [uplabel zj_labelText:[NSString stringWithFormat:@"%zd人",difference]
                    textColor:ZJColor848484
                     textSize:ZJTextSize45PX];
        imageView.image = [UIImage imageNamed:@"D-A_go-up-small"];
        
    }else if(temp < temp1) {
        difference = temp1 - temp;
        self.difference = difference;
        //下降升人数
        [uplabel zj_labelText:[NSString stringWithFormat:@"-%zd人",difference]
                    textColor:ZJColor848484
                     textSize:ZJTextSize45PX];
        
        imageView.image = [UIImage imageNamed:@"D-A_decline-small"];
        
    }else {
        difference = temp;
        self.difference = difference;
    
        //人数相同
        if (difference == 0) {
            [uplabel zj_labelText:@"0人"
                        textColor:ZJColor848484
                         textSize:ZJTextSize45PX];
        }else {
            [uplabel zj_labelText:@"相同"
                        textColor:ZJColor848484
                         textSize:ZJTextSize45PX];
            
        }
    }
    uplabel.x =  head.width - 40;
    [uplabel zj_adjustWithMin];
    uplabel.centerY = head.height/2;
    [head addSubview:uplabel];
    [head addSubview:imageView];
}


//查询本周信息
- (void)selectWeekYear:(NSInteger) year andMonth:(NSInteger) Month andDay:(NSInteger) Day{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *String = [NSString stringWithFormat:@"%zd-%02zd-%02zd",year,Month,Day];
    
    NSDate *date = [dateFormatter dateFromString:String];
    
    
    
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:Day];
    [_comps setMonth:Month];
    [_comps setYear:year];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger weekday = [weekdayComponents weekday];
    switch (weekday - 1) {
        case 1:
        {
            NSMutableArray *Year = [NSMutableArray array];
            [self.YearArray removeAllObjects];
            self.YearArray = Year;
            NSMutableArray *moth = [NSMutableArray array];
            [self.MonthArray removeAllObjects];
            self.MonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
            [self.DayArray removeAllObjects];
            self.DayArray = day;
            [Year addObject:@(year)];
            [moth addObject:@(Month)];
            [day addObject:@(Day)];
            for (int i = 1; i <= 6; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                [day addObject:DayStr];
            }
        }
            break;
        case 2:
        {
            NSMutableArray *Year = [NSMutableArray array];
            [self.YearArray removeAllObjects];
            self.YearArray = Year;
            NSMutableArray *moth = [NSMutableArray array];
            [self.MonthArray removeAllObjects];
            self.MonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
            [self.DayArray removeAllObjects];
            self.DayArray = day;
            [Year addObject:@(year)];
            [moth addObject:@(Month)];
            [day addObject:@(Day)];
            for (int i = 1; i <= 1; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:-time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                [day addObject:DayStr];
            }
            for (int i = 1; i <= 5; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                [day addObject:DayStr];
            }
        }
            break;
        case 3:
        {
            NSMutableArray *Year = [NSMutableArray array];
            [self.YearArray removeAllObjects];
            self.YearArray = Year;
            NSMutableArray *moth = [NSMutableArray array];
            [self.MonthArray removeAllObjects];
            self.MonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
            [self.DayArray removeAllObjects];
            self.DayArray = day;
            [Year addObject:@(year)];
            [moth addObject:@(Month)];
            [day addObject:@(Day)];
            for (int i = 1; i <= 2; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:-time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                [day addObject:DayStr];
            }
            for (int i = 1; i <= 4; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                NSInteger d = [DayStr integerValue];
                [day addObject:@(d)];
            }
        }
            break;
        case 4:
        {
            NSMutableArray *Year = [NSMutableArray array];
            [self.YearArray removeAllObjects];
            self.YearArray = Year;
            NSMutableArray *moth = [NSMutableArray array];
            [self.MonthArray removeAllObjects];
            self.MonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
            [self.DayArray removeAllObjects];
            self.DayArray = day;
            [Year addObject:@(year)];
            [moth addObject:@(Month)];
            [day addObject:@(Day)];
            for (int i = 1; i <= 3; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:-time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                [day addObject:DayStr];
            }
            for (int i = 1; i <= 3; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                [day addObject:DayStr];
            }
        }
            break;
        case 5:
        {
            NSMutableArray *Year = [NSMutableArray array];
            [self.YearArray removeAllObjects];
            self.YearArray = Year;
            NSMutableArray *moth = [NSMutableArray array];
            [self.MonthArray removeAllObjects];
            self.MonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
            [self.DayArray removeAllObjects];
            self.DayArray = day;
            [Year addObject:@(year)];
            [moth addObject:@(Month)];
            [day addObject:@(Day)];
            for (int i = 1; i <= 4; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:-time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份;
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                [day addObject:DayStr];
            }
            for (int i = 1; i <= 2; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                [day addObject:DayStr];
            }
        }
            break;
        case 6:
        {
            NSMutableArray *Year = [NSMutableArray array];
            [self.YearArray removeAllObjects];
            self.YearArray = Year;
            NSMutableArray *moth = [NSMutableArray array];
            self.MonthArray = moth;
            [self.MonthArray removeAllObjects];
            NSMutableArray *day = [NSMutableArray array];
            self.DayArray = day;
            [self.DayArray removeAllObjects];
            [Year addObject:@(year)];
            [moth addObject:@(Month)];
            [day addObject:@(Day)];
            for (int i = 1; i <= 5; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:-time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                [day addObject:DayStr];
            }
            for (int i = 1; i < 2; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                [day addObject:DayStr];
            }
        }
            break;
        case 0:
        {
            NSMutableArray *Year = [NSMutableArray array];
            [self.YearArray removeAllObjects];
            self.YearArray = Year;
            NSMutableArray *moth = [NSMutableArray array];
            [self.MonthArray removeAllObjects];
            self.MonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
            [self.DayArray removeAllObjects];
            self.DayArray = day;
            for (int i = 1; i <= 7; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:-time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                [day addObject:DayStr];
            }
        }
            break;
        default:
            break;
    }
    
}

//查询上周信息
- (void)LastweekYear:(NSInteger) year andMonth:(NSInteger) Month andDay:(NSInteger) day {
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *String = [NSString stringWithFormat:@"%zd-%02zd-%02zd",year,Month,day];
    
    NSDate *date = [dateFormatter dateFromString:String];
    
    
    
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:day];
    [_comps setMonth:Month];
    [_comps setYear:year];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger weekday = [weekdayComponents weekday];

    switch (weekday - 1) {
        case 1:
        {
            NSMutableArray *Year = [NSMutableArray array];
            [self.lastYearArray removeAllObjects];
            self.lastYearArray = Year;
            NSMutableArray *moth = [NSMutableArray array];
            [self.lastMonthArray removeAllObjects];
            self.lastMonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
            [self.lastDayArray removeAllObjects];
            self.lastDayArray = day;
            for (int i = 1; i <= 7; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:-time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                [day addObject:DayStr];
            }
        }
            
            break;
        case 2:
        {
            NSMutableArray *Year = [NSMutableArray array];
            [self.lastYearArray removeAllObjects];
            self.lastYearArray = Year;
            NSMutableArray *moth = [NSMutableArray array];
            [self.lastMonthArray removeAllObjects];
            self.lastMonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
            [self.lastDayArray removeAllObjects];
            self.lastDayArray = day;
            for (int i = 2; i <= 8; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:-time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                [day addObject:DayStr];
            }
        }
            break;
        case 3:
        {
            NSMutableArray *Year = [NSMutableArray array];
            [self.lastYearArray removeAllObjects];
            self.lastYearArray = Year;
            NSMutableArray *moth = [NSMutableArray array];
            [self.lastMonthArray removeAllObjects];
            self.lastMonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
            [self.lastDayArray removeAllObjects];

            self.lastDayArray = day;
            for (int i = 3; i <= 9; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:-time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                
                [day addObject:DayStr];
            }
        }
            break;
        case 4:
        {
            NSMutableArray *Year = [NSMutableArray array];
            [self.lastYearArray removeAllObjects];
            self.lastYearArray = Year;
            NSMutableArray *moth = [NSMutableArray array];
            [self.lastMonthArray removeAllObjects];
            self.lastMonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
            [self.lastDayArray removeAllObjects];

            self.lastDayArray = day;
            for (int i = 4; i <= 10; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:-time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                [day addObject:DayStr];
            }
        }
            break;
        case 5:
        {
            NSMutableArray *Year = [NSMutableArray array];
            [self.lastYearArray removeAllObjects];
            self.lastYearArray = Year;
            NSMutableArray *moth = [NSMutableArray array];
            [self.lastMonthArray removeAllObjects];
            self.lastMonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
            [self.lastDayArray removeAllObjects];

            self.lastDayArray = day;
            for (int i = 5; i <= 11; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:-time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                [day addObject:DayStr];
            }
        }
            break;
        case 6:
        {
            NSMutableArray *Year = [NSMutableArray array];
            [self.lastYearArray removeAllObjects];
            self.lastYearArray = Year;
            NSMutableArray *moth = [NSMutableArray array];
            [self.lastMonthArray removeAllObjects];
            self.lastMonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
            [self.lastDayArray removeAllObjects];
            self.lastDayArray = day;
            for (int i = 6; i <= 12; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:-time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                [day addObject:DayStr];
            }
        }
            break;
        case 0:
        {
            
            NSMutableArray *Year = [NSMutableArray array];
            [self.lastYearArray removeAllObjects];
            self.lastYearArray = Year;

            NSMutableArray *moth = [NSMutableArray array];
            [self.lastMonthArray removeAllObjects];
            self.lastMonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
            [self.lastDayArray removeAllObjects];
            self.lastDayArray = day;
            for (int i = 7; i <= 13; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:-time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                [day addObject:DayStr];
            }
        }
            break;
        default:
            break;
    }
    
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
