//
//  ZJPesonCountsViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/8.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJPesonCountsViewController.h"
#import "Pinyin.h"
//第三方日期
#import "LTPickerView/LTPickerView.h"
#import "UIColor+K.h"
#import "XYPieChart.h"
#import "UIButton+Cagetory.h"
#import "ZJCustomerItemsTableInfo.h"
#import "ZJFMdb.h"
#import "NSDate+Category.h"

@interface ZJPesonCountsViewController ()<XYPieChartDelegate,XYPieChartDataSource>

//第三方日期类
@property (nonatomic,weak)LTPickerView *pickerView;
@property (nonatomic,weak)UIView *upview;
//底部按钮数组
@property (nonatomic,strong)NSMutableArray *buttons;
//三方类
@property (nonatomic,strong)XYPieChart *piechart;
//圆的人数数组
@property (nonatomic,strong)NSMutableArray *arraycounts;
//圆存放颜色数组
@property (nonatomic,strong)NSArray *arraycolor;
//控制视图
@property (nonatomic,weak)UIView *backView;
//滚动视图
@property (nonatomic,strong)UIScrollView *scrollView;
//scrollview的conntentView
@property(nonatomic,weak)UIView *contentView;
//年份背景视图
@property (nonatomic,weak)UIView *conterView;
//年份滚动视图
@property (nonatomic,weak)UIScrollView *otherscrollView;
//年份对比label
@property (nonatomic,weak)UILabel *YearLabel;
//人数的label
@property (nonatomic,weak)UILabel *PersonLabel;
//对比人数上下还是下降UIImageView
@property (nonatomic,weak)UIImageView *ContrastImageView;
//底部最后一个按钮;
@property (nonatomic,weak)UIButton *LastButton;
//
@property (nonatomic,strong)UIView *PKView;
//名称数组
@property (nonatomic,strong)NSMutableArray *titleArray;
//人数数组
@property (nonatomic,strong)NSMutableArray *PersonArray;
//记录当前的年份
@property (nonatomic,assign)NSInteger year;
//记录当前的月份
@property (nonatomic,assign)NSInteger month;
//记录当前天数
@property (nonatomic,assign)NSInteger day;
//记录本周月份数组
@property (nonatomic,strong)NSMutableArray *MonthArray;
//记录本周年份数组
@property (nonatomic,strong)NSMutableArray *YearArray;
//记录本周天数数组
@property (nonatomic,strong)NSMutableArray *DayArray;

@property (nonatomic,weak)UIImageView *backImageView;

@property (nonatomic,copy)NSString *str;

//放有总人数和其它人数数组
@property (nonatomic,strong)NSMutableArray *ALLSumsArray;
@end

@implementation ZJPesonCountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"客户人数统计";
    self.view.backgroundColor = ZJBackGroundColor;
    NSDate *date = [NSDate new];
    NSInteger year = [date zj_getRealTimeForRequire:NSCalendarUnitYear];
    self.year = year;
    NSInteger month = [date zj_getRealTimeForRequire:NSCalendarUnitMonth];
    self.month = month;
    NSInteger day = [date zj_getRealTimeForRequire:NSCalendarUnitDay];
    self.day = day;
    //创建底部视图
    [self addUpview];
    [self selectYear:year andMonth:month];
    //创建圆
    [self addyuan];
    //创建滚动视图的分类视图
    [self addret];
    
    
    [self TempImageView:@"客户数据统计"];
    
    
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
        if (i == 2) {
            button.selected = YES;
        }
        if (i==4) {
            self.LastButton = button;
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
            //今天的数据
            [self.PersonArray removeAllObjects];
            NSDate *date = [NSDate new];
            NSInteger day = [date zj_getRealTimeForRequire:NSCalendarUnitDay];
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
                NSString *pesron = [NSString stringWithFormat:@"SELECT count(iAutoID) AS NUM,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID=%zd) AS NAME FROM crm_CustomerInfo AS b WHERE (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%%zd;') AND (cCreateYear='%zd' AND cCreateMonth='%02zd' AND cCreateDay='%02zd') ",ID,ID,ID,ID,self.year,self.month,day];
                
                NSInteger sum = [ZJFMdb sqlSelecteCountWithString:pesron];
                NSLog(@"%zd",sum);
                
                [self.PersonArray addObject:@(sum)];
            }
            [self addret];
            //创建圆
            [self addyuan];
            [self.piechart reloadData];
            [self TempImageView:@"客户数据统计"];
            
        }
            break;
        case 1:
        {
            //本周的数据
            [self selectWeekYear:self.year andMonth:self.month andDay:self.day];
            [self.PersonArray removeAllObjects];
            NSMutableArray *dataModel = [NSMutableArray array];
            NSMutableArray *pesrsonsArray = [NSMutableArray array];
            NSMutableArray *contrastArray = [NSMutableArray array];
            [contrastArray removeAllObjects];
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
                NSMutableString *SQL = [[NSMutableString alloc]initWithFormat:@"SELECT count(iAutoID) AS NUM,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID=%zd) AS NAME FROM crm_CustomerInfo AS b WHERE (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%%zd;') AND (",ID,ID,ID,ID];
                NSMutableString * SQLtemp2 = [[NSMutableString alloc] init];
                for (int  j = 0;j < 7; j++) {
                    if (j < 6) {
                    SQLtemp2 = [NSMutableString stringWithFormat:@"(cCreateYear='%zd' AND cCreateMonth='%zd' AND cCreateDay='%02zd') OR",[self.YearArray[j] integerValue],[self.MonthArray[j] integerValue],[self.DayArray[j] integerValue]];
                    }else {
                    SQLtemp2 = [NSMutableString stringWithFormat:@"(cCreateYear='%zd' AND cCreateMonth='%zd' AND cCreateDay='%02zd') )",[self.YearArray[j] integerValue],[self.MonthArray[j] integerValue],[self.DayArray[j] integerValue]];
                    }
                    [SQL appendString:SQLtemp2];
                }
                NSLog(@"sql -- %@",SQL);
                contrastArray = [ZJFMdb references:SQL];
                
                for (int i = 0; i < contrastArray.count; i++) {
                    NSDictionary *dic = contrastArray[i];
                    NSString *num = dic[@"num"];
                    NSLog(@" 本年本周 %@",num);
                    [self.PersonArray addObject:num];
                }
    
            }
            [self addret];
            //创建圆
            [self addyuan];
            [self.piechart reloadData];
            [self TempImageView:@"客户数据统计"];
        }
            break;
        case 2:
        {
            //本月的数据
            [self.PersonArray removeAllObjects];
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
                NSString *pesron = [NSString stringWithFormat:@"SELECT count(iAutoID) AS NUM,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID=%zd) AS NAME FROM crm_CustomerInfo AS b WHERE (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%%zd;') AND (cCreateYear='%zd' AND cCreateMonth='%02zd') ",ID,ID,ID,ID,self.year,self.month];
                NSLog(@"pesron -- %@",pesron);
                NSInteger sum = [ZJFMdb sqlSelecteCountWithString:pesron];
                NSLog(@"%zd",sum);
                [self.PersonArray addObject:@(sum)];
            }
            [self addret];
            //创建圆
            [self addyuan];
            [self.piechart reloadData];
            [self TempImageView:@"客户数据统计"];
        }
            break;
        case 3:
        {
            //本季度的数据
            NSDate *dete = [NSDate new];
            //记录当前季度的月份
            NSInteger onemoth = 0;
            NSInteger twomonth = 0;
            NSInteger threemoth = 0;
           NSInteger moth =  [dete zj_getSeadonFromDate];
            switch (moth) {
                case 1:
                {
                    onemoth = 1;
                    twomonth = 2;
                    threemoth = 3;
                    
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
                    break;
                case 4:
                {
                    onemoth = 10;
                    twomonth = 11;
                    threemoth = 12;
                }
                    break;
                default:
                    break;
            }
        
            [self.PersonArray removeAllObjects];
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
                NSString *pesron = [NSString stringWithFormat:@"SELECT count(iAutoID) AS NUM,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID=%zd) AS NAME FROM crm_CustomerInfo AS b WHERE (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%%zd;') AND  cCreateYear='%zd' AND (cCreateMonth='%02zd' OR cCreateMonth='%02zd' OR cCreateMonth='%02zd') ",ID,ID,ID,ID,self.year,onemoth,twomonth,threemoth];
                
                NSInteger sum = [ZJFMdb sqlSelecteCountWithString:pesron];
                NSLog(@"%zd",sum);
                
                [self.PersonArray addObject:@(sum)];
            }
            [self addret];
            //创建圆
            [self addyuan];
            [self.piechart reloadData];
            [self TempImageView:@"客户数据统计"];
           
        }
            break;
        case 4:
        {
           //全年的数据
            LTPickerView* pickerView = [[LTPickerView alloc]init];
            self.pickerView = pickerView;
            pickerView.dataSource = @[@"2000",@"2001",@"2002",@"2003",@"2004",@"2005",@"2006",@"2007",@"2008",@"2009",@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030",@"2031",@"2032",@"2033",@"2034",@"2035",@"2036",@"2037",@"2038",@"2039",@"2040",@"2041",@"2042",@"2043",@"2044",@"2045",@"2046",@"2047",@"2048",@"2049",@"2050",@"2051",@"2052",@"2053",@"2054",@"2055",@"2056",@"2057",@"2058",@"2059",@"2060"];//设置要显示的数据
            [pickerView show];//显示
             __weak __typeof(self) weakself=self;
            pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
                
                [weakself.LastButton setTitle:str forState:UIControlStateNormal];
                [weakself.LastButton zj_changeImageAndTitel];
                NSString *year = [NSString stringWithFormat:@"%@年",str];
                weakself.YearLabel.text = year;
                
                [weakself.PersonArray removeAllObjects];
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
                    NSString *pesron = [NSString stringWithFormat:@"SELECT count(iAutoID) AS NUM,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID=%zd) AS NAME FROM crm_CustomerInfo AS b WHERE (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%%zd;') AND  cCreateYear='%zd'",ID,ID,ID,ID,[str integerValue]];
                    
                    NSInteger sum = [ZJFMdb sqlSelecteCountWithString:pesron];
                    
                    [weakself.PersonArray addObject:@(sum)];
                }
                
               
                [weakself addret];
                //创建圆
                [weakself addyuan];
                [weakself.piechart reloadData];
                [self TempImageView:@"客户数据统计"];
            };
            
        }
            break;
        default:
        
            
            break;
    }
    
}


- (void)TempImageView:(NSString *) imageName{
    NSInteger sum = 0;
    NSInteger K = 0;
    for (int i = 0; i < self.PersonArray.count; i++) {
        NSInteger number = [self.PersonArray[i] integerValue];
        if (sum == number) {
            K++;
        }
    }
    if (K < self.PersonArray.count) {
        [self.backImageView removeFromSuperview];
        return;
    }else {
        UIImageView *ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(zjScreenWidth / 4  , PX2PT(200), PX2PT(638), PX2PT(323))];
        ImageView.image = [UIImage imageNamed:imageName];
        self.backImageView = ImageView;
        [self.view addSubview:ImageView];
        
    }
}


#pragma mark---------创建分类视图

-(void)addret{
   
    NSArray* colorArray = @[@"#295aa5",@"#52bdbd",@"#ffad6b",@"#f784a5",@"#ceb55a",@"#31b5d6",@"#ff7e3e",@"#ffe608",@"#16b6d3",@"#737bb5",@"#de6b73",@"#3aa55a",@"#e5f6c4",@"#738cc5",@"#8c407d",@"#ff7100",@"#ef1063",@"#e63a8c",@"#a5738c",@"#bd2119"];
     [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //创建滚动视图
    UIScrollView *scorView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.piechart.height + 1, zjScreenWidth,zjScreenHeight - 64 - PX2PT(146 + 100) - 200 )];
    
    //zjScreenHeight - PX2PT(146)- 64 - 200
    self.scrollView = scorView;
    //contentview
    scorView.backgroundColor = ZJColorFFFFFF;
    scorView.contentSize = CGSizeMake(zjScreenWidth, PX2PT(64+40)*self.titleArray.count);
    scorView.showsHorizontalScrollIndicator = NO;
    scorView.bounces = NO;
    
  
    for (int i = 0; i < self.titleArray.count; i++) {
        //添加视图到滚动视图中
        [scorView addSubview:[self addUpmiviewWithimageName:colorArray[i] andTxet:self.titleArray[i] andY:i andSum:[self.PersonArray[i] integerValue]]];
    }
    [self.view addSubview:scorView];
    
    
}



#pragma mark---------创建小分类视图
-(UIView*)addUpmiviewWithimageName:(NSString*)name andTxet:(NSString*)text andY:(int)y andSum:(NSInteger) sum
{
    
    NSLog(@"显示人数---  %zd",sum);
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = ZJColorFFFFFF;
    view.frame = CGRectMake(0, PX2PT(64+40)*y, zjScreenWidth,PX2PT(64+40) );
    UIView* imageview  = [[UIView alloc]initWithFrame:
                          CGRectMake(20,(PX2PT(64+40)-PX2PT(64))/2, 64/3, PX2PT(64))];
    imageview.backgroundColor = [UIColor colorWithHexString:name];
    
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius = imageview.bounds.size.width/6;
    [view addSubview:imageview];
    
    UILabel* label = [[UILabel alloc]initWithFrame:
                      CGRectMake((40+40+64)/2.5,(PX2PT(64+40)-PX2PT(45))/2, 100,  ZJTextSize45PX)];
    label.textAlignment = NSTextAlignmentLeft;
    [label zj_labelText:text textColor:ZJColor505050
                              textSize:ZJTextSize45PX];
    
    [view addSubview:label];
    
    
    UILabel* labelnumber = [[UILabel alloc]initWithFrame:CGRectMake(zjScreenWidth - 40/3 - 50,(PX2PT(64+40)-PX2PT(45))/2, 50, ZJTextSize45PX)];
    labelnumber.textAlignment = NSTextAlignmentRight;
    
    [labelnumber zj_labelText:[NSString stringWithFormat:@"%zd人",sum]
                                    textColor:ZJColor848484
                                     textSize:ZJTextSize45PX];
    [view addSubview:labelnumber];
    return view;
    
}

-(void)setSeparatorViewWithFrame:(CGRect)frame{
    
    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = ZJColorDCDCDC;
    
    [self.upview addSubview:view];
    
    view.frame = frame;
    
}
#pragma mark---------创建圆视图

-(void)addyuan{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, zjScreenWidth, 200)];
    view.backgroundColor = [UIColor whiteColor];
    self.backView = view;
    
    //创建圆
    self.piechart = [[XYPieChart alloc]initWithFrame:
                     CGRectMake(0, 0, zjScreenWidth, 200) Center:CGPointMake(zjScreenWidth/2, 200/2) Radius:80];
    [self.piechart setDataSource:self];
    [self.piechart setDelegate:self];
    [self.piechart setShowPercentage:NO];
    
    
   //颜色数组
    self.arraycolor = @[@"#295aa5",@"#52bdbd",@"#ffad6b",@"#f784a5",@"#ceb55a",@"#31b5d6",@"#ff7e3e",@"#ffe608",@"#16b6d3",@"#737bb5",@"#de6b73",@"#3aa55a",@"#e5f6c4",@"#738cc5",@"#8c407d",@"#ff7100",@"#ef1063",@"#e63a8c",@"#a5738c",@"#bd2119"];
    
    [view addSubview:self.piechart];
    
    [self.view addSubview:view];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.piechart reloadData];
}


//第三库的协议
-(NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart{
    return self.PersonArray.count;
}

-(CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index{
    
    return [self.PersonArray[index] integerValue];
}

-(UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index{
    
    return [UIColor colorWithHexString:self.arraycolor[index]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//查询数据
- (void)selectYear:(NSInteger) year andMonth:(NSInteger) month{
    
    self.titleArray = [NSMutableArray array];
    NSMutableArray *dataModel = [NSMutableArray array];
    NSMutableArray *pesrsonsArray = [NSMutableArray array];
    self.PersonArray = [NSMutableArray array];
    ZJCustomerItemsTableInfo *model = [ZJCustomerItemsTableInfo new];
    NSString *selct = @"SELECT * FROM crm_CustomerItems WHERE type='customerState';";
    [ZJFMdb sqlSelecteData:model selecteString:selct success:^(NSMutableArray *successMsg) {
        [dataModel addObjectsFromArray:successMsg];
    }];
    for (ZJCustomerItemsTableInfo *zj in dataModel) {
        [self.titleArray addObject:zj.itemString];
        [pesrsonsArray addObject:@(zj.iAutoID)];
    }
   
    NSLog(@"-----%ld",pesrsonsArray.count);
    for (int i = 0; i < pesrsonsArray.count; i++) {
        NSInteger ID = [pesrsonsArray[i] integerValue];
        NSString *pesron = [NSString stringWithFormat:@"SELECT count(iAutoID) AS NUM,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID=%zd) AS NAME FROM crm_CustomerInfo AS b WHERE (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%%zd;') AND (cCreateYear='%zd' AND cCreateMonth='%02zd' ) ",ID,ID,ID,ID,year,month];
       NSInteger sum =   [ZJFMdb sqlSelecteCountWithString:pesron];
        [self.PersonArray addObject:@(sum)];
    }
 }



//查询本周信息
- (void)selectWeekYear:(NSInteger) year andMonth:(NSInteger) Month andDay:(NSInteger) Day{
  
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *String = [NSString stringWithFormat:@"%zd-%02zd-%02zd",year,Month,Day];
    NSLog(@"时间--%@",String);
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
    NSLog(@"weekday -- %zd",weekday);
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
            self.MonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
            self.DayArray = day;
            [Year addObject:@(year)];
            [moth addObject:@(Month)];
            [day addObject:@(Day)];
            for (int i = 1; i < 2; i++) {
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
            self.MonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
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
                [day addObject:DayStr];
            }
        }
            break;
        case 4:
        {
            NSMutableArray *Year = [NSMutableArray array];
            [self.YearArray removeAllObjects];
            self.YearArray = Year;
            NSMutableArray *moth = [NSMutableArray array];
            self.MonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
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
                NSLog(@"----  年份---%@",year);
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
            self.MonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
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
                NSLog(@"year %@",year);
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
                NSLog(@"---- %@",year);
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
            for (int i = 1; i <= 1; i++) {
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
            self.MonthArray = moth;
            NSMutableArray *day = [NSMutableArray array];
            self.DayArray = day;
            [Year addObject:@(year)];
            [moth addObject:@(Month)];
            [day addObject:@(Day)];
            for (int i = 1; i <= 6; i++) {
                NSTimeInterval time = 24 * 60 * 60 * i;
                NSDate * lastYear = [date dateByAddingTimeInterval:-time];
                NSString * startDate = [dateFormatter stringFromDate:lastYear];
                //截取年份
                NSString *year = [startDate substringToIndex:4];
                NSLog(@"year --- %@",year);
                [Year addObject:year];
                //截取月份
                NSRange range = NSMakeRange(5, 2);
                NSString *str1 = [startDate substringWithRange:range];
                NSLog(@"str1 -- %@",str1);
                [moth addObject:str1];
                //截取天数
                NSRange rangeDay = NSMakeRange(8,2);
                NSString *DayStr = [startDate substringWithRange:rangeDay];
                NSLog(@"day -- %@",DayStr);
                [day addObject:DayStr];
            }
          
        }
            break;
        default:
            break;
    }

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
