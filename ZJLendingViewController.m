//
//  ZJLendingViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/11.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJLendingViewController.h"
//第三方弹框
#import "SGActionSheet.h"
#import "SGAlertView.h"
//第三方日期
#import "LTPickerView/LTPickerView.h"

#import "ZJCustomerItemsTableInfo.h"
#import "ZJFMdb.h"
#import "XYPieChart.h"
@interface ZJLendingViewController ()<XYPieChartDelegate,XYPieChartDataSource,SCChartDataSource,SGActionSheetDelegate, SGAlertViewDelegate>
{
    //创建状型图类
    SCChart *chartView;
}
//顶部选择按钮
@property (nonatomic,strong)NSMutableArray *upbutton;
//顶部按钮背景图片
@property (nonatomic,weak)UIImageView *imageView;
//底部视图
@property (nonatomic,weak)UIView *upview;
//底部按钮数组
@property (nonatomic,strong)NSMutableArray *buttons;
//三方类
@property (nonatomic,strong)XYPieChart *piechart;
//圆的人数数组
@property (nonatomic,strong)NSArray *arraycounts;
//圆存放颜色数组
@property (nonatomic,strong)NSArray *arraycolor;
//控制圆视图
@property (nonatomic,weak)UIView *backView;
//控制滚动视图
@property (nonatomic,weak)UIScrollView *scrollView;
//控制中间label
@property (nonatomic,weak)UILabel *changelabel;
//控制中间视图
@property (nonatomic,weak)UIView *changeView;
//颜色数组
@property (nonatomic,strong)NSArray *colorsArray;
//年度分析类型数组
@property (nonatomic,strong)NSMutableArray *SourceArray;
//月份数组
@property (nonatomic,strong)NSArray *yearsArray;
//月份颜色数组
@property (nonatomic,strong)NSArray *yearsColorsArray;
//放款类型左边底部按钮
@property (nonatomic,weak)UIButton *leftButton;
//放款类型右边底部按钮
@property (nonatomic,weak)UIButton *rightButton;
//右边顶部按钮
@property (nonatomic,weak)UIButton *rightUPButton;
//左边顶部按钮
@property (nonatomic,weak)UIButton *leftUPButton;
//客户信息数据类
@property (nonatomic,strong)NSArray *array;
//年度分析左边按钮
@property (nonatomic,weak)UIButton *otherLeftButton;
//年度分析右边按钮
@property (nonatomic,weak)UIButton *otherRightButton;
//视图中间改变的label
@property (nonatomic,weak)UILabel *SourceLabel;
//第三方日期类
@property (nonatomic,weak)LTPickerView *pickerView;
//名称数组
@property (nonatomic,strong)NSMutableArray *titleArray;
//人数数组
@property (nonatomic,strong)NSMutableArray *personsArray;
//记录年
@property (nonatomic,assign)NSInteger year;
//记录月
@property (nonatomic,assign)NSInteger month;
//来源最多
@property (nonatomic,strong)NSMutableArray *ChannelArray;
//客户数数组
@property (nonatomic,strong)NSMutableArray *NumbersArray;
//匹配点击的关键字数组
@property (nonatomic,strong)NSMutableArray *ThekeywordArray;

@property (nonatomic,strong)NSString *AllName;

@property (nonatomic,weak)UIImageView *backImageView;

@property (nonatomic,assign)NSInteger TodayYear;

@property (nonatomic,weak)SGActionSheet *ActionSheet;
@end

@implementation ZJLendingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"放贷类型统计";
    self.view.backgroundColor = ZJBackGroundColor;
    NSDate *date = [NSDate new];
    NSInteger year = [date zj_getRealTimeForRequire:NSCalendarUnitYear];
    self.year = year;
    self.TodayYear = year;
    NSInteger month = [date zj_getRealTimeForRequire:NSCalendarUnitMonth];
    self.month = month;
    [self selectYear:year andMonth:month];
    //顶部视图
    [self UpButton];
    //底部视图
    [self addUpview];
    //创建圆视图
    [self addyuan];
    //创建分类视图
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
    [self.ActionSheet removeFromSuperview];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //调用第三方开始绘制图形
    [self.piechart reloadData];
}
#pragma mark---------添加底部视图
-(void)addUpview{
    CGFloat heigt = PX2PT(146);
    UIView *upview = [[UIView alloc]initWithFrame:CGRectMake(0, zjScreenHeight - 64 - heigt, zjScreenWidth, heigt)];
    
    upview.backgroundColor = ZJColorFFFFFF;
    self.upview = upview;
    [self setSeparatorViewWithFrame:CGRectMake((zjScreenWidth-2)/2, 0, 1, heigt)];
    
    [self setSeparatorViewWithFrame:CGRectMake(0, 0, zjScreenWidth, 1)];
    
    self.buttons = [[NSMutableArray alloc]init];
    
    NSArray *titleArray = @[@"本月",@"本季度"];
    //左边按钮
    UIButton *leftButton = [[UIButton alloc]init];
    self.leftButton = leftButton;
    self.leftButton.selected = YES;
    leftButton.frame = CGRectMake(0, 0, upview.width/2, upview.height);
    [self setButton:leftButton title:titleArray[0]];
     leftButton.tag = 1;
    [leftButton addTarget:self action:@selector(clicktTimeselection:) forControlEvents:UIControlEventTouchUpInside];
    [upview addSubview:leftButton];
    
    //右边按钮
    UIButton *rightButton = [[UIButton alloc]init];
    self.rightButton = rightButton;
    rightButton.frame = CGRectMake(upview.width/2,0, upview.width/2, heigt);
    [self setButton:rightButton title:titleArray[1]];
    rightButton.tag = 2;
    [rightButton addTarget:self action:@selector(clicktTimeselection:) forControlEvents:UIControlEventTouchUpInside];
   
    [upview addSubview:rightButton];
    
    
    [self.view addSubview:upview];
}
//绘制虚线
-(void)setSeparatorViewWithFrame:(CGRect)frame{
    
    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = ZJColorDCDCDC;
    
    [self.upview addSubview:view];
    
    view.frame = frame;
    
}
//设置底部按钮的属性
-(void)setButton:(UIButton *)button title:(NSString *)title{
    [self.upview addSubview:button];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    
    [button setTitleColor:ZJColor00D3A3 forState:UIControlStateSelected];
    
    button.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [button zj_changeImageAndTitel];
    
}

#pragma mark---------底部按钮点击事件
-(void)clicktTimeselection:(UIButton*)sender
{
    switch (sender.tag) {
        case 1:
        {
            self.leftButton.selected = YES;
            self.rightButton.selected = NO;
            [self.personsArray removeAllObjects];
            [self leftViewArray];
        }
            break;
        case 2:
        {
            self.leftButton.selected = NO;
            self.rightButton.selected = YES;
            //本季度数据
            NSDate *dete = [NSDate new];
            //记录当前季度的月份
            NSInteger onemoth , twomonth , threemoth = 0;
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
            [self.personsArray removeAllObjects];
            NSMutableArray *dataModel = [NSMutableArray array];
            NSMutableArray *pesrsonsArray = [NSMutableArray array];
            ZJCustomerItemsTableInfo *model = [ZJCustomerItemsTableInfo new];
            NSString *selct = @"SELECT * FROM crm_CustomerItems WHERE type='customerType';";
            [ZJFMdb sqlSelecteData:model selecteString:selct success:^(NSMutableArray *successMsg) {
                [dataModel addObjectsFromArray:successMsg];
            }];
            for (ZJCustomerItemsTableInfo *zj in dataModel) {
                [pesrsonsArray addObject:@(zj.iAutoID)];
                
            }
            for (int i = 0; i < pesrsonsArray.count; i++) {
                NSInteger ID = [pesrsonsArray[i] integerValue];
                
                NSString *pesron = [NSString stringWithFormat:@"SELECT count(iAutoID) AS NUM,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID=%zd) AS NAME FROM crm_CustomerInfo AS b WHERE (cLoanType_Tags LIKE '%zd;%%' OR cLoanType_Tags LIKE '%%;%zd;%%' OR cLoanType_Tags LIKE '%zd;') AND  cCreateYear='%zd' AND (cCreateMonth='%02zd' OR cCreateMonth='%02zd' OR cCreateMonth='%02zd')",ID,ID,ID,ID,self.TodayYear,onemoth,twomonth,threemoth];
        
                NSInteger sum = [ZJFMdb sqlSelecteCountWithString:pesron];
               
                [self.personsArray addObject:@(sum)];
            }
            [self addret];
            //创建圆
            [self addyuan];
            [self.piechart reloadData];
            [self TempImageView:@"客户数据统计"];
            break;
        }
        default:
            break;
    }
}

//创建顶部按钮
-(void)UpButton{
    UIImageView *ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX2PT(40), self.view.bounds.origin.y + PX2PT(40), zjScreenWidth - PX2PT(80), 40)];
    ImageView.image = [UIImage imageNamed:@"D-A_acklog"];
    ImageView.userInteractionEnabled = YES;
    self.imageView = ImageView;
    self.upbutton = [NSMutableArray array];

    NSArray *titlebtn = @[@"放贷类型",@"年度分析"];
    
    //左边按钮
    UIButton *leftUPButton = [[UIButton alloc]init];
    self.leftUPButton = leftUPButton;
    leftUPButton.frame = CGRectMake(0, 0, ImageView.width/2, ImageView.height);
    [leftUPButton setTitle:titlebtn[0] forState:UIControlStateNormal];
    leftUPButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [leftUPButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    [leftUPButton setTitleColor:ZJColor00D3A3 forState:UIControlStateSelected];
    [ImageView addSubview:leftUPButton];
    leftUPButton.tag = 3;
    [leftUPButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //右边按钮
    UIButton *rightUPButton = [[UIButton alloc]init];
    self.rightButton = rightUPButton;
    rightUPButton.frame = CGRectMake(ImageView.width/2,0, ImageView.width/2, ImageView.height);
    [rightUPButton setTitle:titlebtn[1] forState:UIControlStateNormal];
    rightUPButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [rightUPButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    [rightUPButton setTitleColor:ZJColor00D3A3 forState:UIControlStateSelected];
     rightUPButton.tag = 4;
    [ImageView addSubview:rightUPButton];
    [rightUPButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

       [self.view addSubview:ImageView];
}

//顶部按钮事件
-(void)btnAction:(UIButton *)sender{
    if (sender.tag == 3) {
        
        [self.otherLeftButton removeFromSuperview];
        [self.otherRightButton removeFromSuperview];
        self.leftButton.hidden = NO;
        self.rightButton.hidden = NO;
        [self setButton:self.leftButton title:@"本月"];
        self.leftButton.imageView.hidden = YES;
        [self.leftButton addTarget:self action:@selector(clicktTimeselection:) forControlEvents:UIControlEventTouchUpInside];
        [self setButton:self.rightButton title:@"本季度"];
        self.rightButton.imageView.hidden = YES;
        [self.rightButton addTarget:self action:@selector(clicktTimeselection:) forControlEvents:UIControlEventTouchUpInside];
        self.imageView.image = [UIImage imageNamed:@"D-A_acklog"];
        //放贷类型滚动视图
        [self leftViewArray];
    }else if(sender.tag == 4){
        self.leftButton.hidden = YES;
        self.rightButton.hidden = YES;
        
        [self.otherLeftButton removeFromSuperview];
        [self.otherRightButton removeFromSuperview];
        UIButton *leftUPButton = [[UIButton alloc]init];
        leftUPButton.frame = CGRectMake(0, 0, self.upview.width/2, self.upview.height);
        leftUPButton.selected = YES;
        self.otherLeftButton = leftUPButton;
        [leftUPButton setTitle:@"全部" forState:UIControlStateNormal];
        leftUPButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
        [leftUPButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
        [leftUPButton setTitleColor:ZJColor00D3A3 forState:UIControlStateSelected];
        [leftUPButton setImage:[UIImage imageNamed:@"D-A_arrows"] forState:UIControlStateNormal];
        [leftUPButton setImage:[UIImage imageNamed:@"D-A_arrows-green"] forState:UIControlStateSelected];
        leftUPButton.tag = 5;
        [leftUPButton addTarget:self action:@selector(otherClick:) forControlEvents:UIControlEventTouchUpInside];
        [leftUPButton zj_changeImageAndTitel];
        [self.upview addSubview:leftUPButton];
        
        UIButton *rightUPButton = [[UIButton alloc]init];
        rightUPButton.frame = CGRectMake(self.upview.width/2, 0, self.upview.width/2, self.upview.height);
        self.otherRightButton = rightUPButton;
        rightUPButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
        [rightUPButton setTitle:[NSString stringWithFormat:@"%zd",self.year] forState:UIControlStateNormal];
        [rightUPButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
        [rightUPButton setTitleColor:ZJColor00D3A3 forState:UIControlStateSelected];
        [rightUPButton setImage:[UIImage imageNamed:@"D-A_arrows"] forState:UIControlStateNormal];
        [rightUPButton setImage:[UIImage imageNamed:@"D-A_arrows-green"] forState:UIControlStateSelected];
        [rightUPButton addTarget:self action:@selector(otherClick:) forControlEvents:UIControlEventTouchUpInside];
        [rightUPButton zj_changeImageAndTitel];
        rightUPButton.tag = 6;
        [self.upview addSubview:rightUPButton];
        
        self.imageView.image = [UIImage imageNamed:@"D-A_Done"];
        [self selectAllYear:self.year];
        //状型图显示
        self.piechart.hidden = YES;
        //创建状型图
        [self configUI];
        //创建label
        [self change];
        //创建视图
        [self middleView];
        //中间label
        self.changelabel.hidden = NO;
        //中间视图
        self.changeView.hidden = NO;
        //年度分析滚动视图
        [self ALLScorllView];
    }
}

//年度分析滚动视图
- (void)OtherScrollView{
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.scrollView.frame = CGRectMake(0,chartView.height + PX2PT(80+80+85+128),zjScreenWidth,zjScreenHeight - 64 - PX2PT(146 + 80 + 80 + 80 + 118 + 100) - chartView.height);
    self.scrollView.contentSize = CGSizeMake(zjScreenWidth, PX2PT(64+40)*self.yearsArray.count+PX2PT(20));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    
    self.scrollView.backgroundColor = ZJBackGroundColor;
    for (int i = 0; i < self.yearsArray.count; i++) {
        //添加视图到滚动视图中
        [self.scrollView addSubview:[self otherViewWithimageName:self.colorsArray[i] andText:self.yearsArray[i] andSource:self.ChannelArray[i]  andY:i andSums:[self.NumbersArray[i] integerValue]]];
    }

}

- (void)leftViewArray{
    [self.personsArray removeAllObjects];
    NSMutableArray *dataModel = [NSMutableArray array];
    NSMutableArray *pesrsonsArray = [NSMutableArray array];
    ZJCustomerItemsTableInfo *model = [ZJCustomerItemsTableInfo new];
    NSString *selct = @"SELECT * FROM crm_CustomerItems WHERE type='customerType';";
    [ZJFMdb sqlSelecteData:model selecteString:selct success:^(NSMutableArray *successMsg) {
        [dataModel addObjectsFromArray:successMsg];
    }];
    for (ZJCustomerItemsTableInfo *zj in dataModel) {
        [pesrsonsArray addObject:@(zj.iAutoID)];
    }
    for (int i = 0; i < pesrsonsArray.count; i++) {
        NSInteger ID = [pesrsonsArray[i] integerValue];
        NSString *pesron = [NSString stringWithFormat:@"SELECT count(iAutoID) AS NUM,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID=%zd) AS NAME FROM crm_CustomerInfo AS b WHERE (cLoanType_Tags LIKE '%zd;%%' OR cLoanType_Tags LIKE '%%;%zd;%%' OR cLoanType_Tags LIKE '%zd;') AND cCreateYear='%zd' AND cCreateMonth='%02zd' ",ID,ID,ID,ID,self.TodayYear,self.month];
        
        NSInteger sum = [ZJFMdb sqlSelecteCountWithString:pesron];
        
        
        [self.personsArray addObject:@(sum)];
    }
    //状型图隐藏
    chartView.hidden = YES;
    //中间label
    self.changelabel.hidden = YES;
    //中间视图
    self.changeView.hidden = YES;
    self.scrollView.frame = CGRectMake(0,self.view.bounds.origin.y + self.backView.height + PX2PT(40) + self.imageView.height,zjScreenWidth,zjScreenHeight - PX2PT(146+40 + 100) - 64 - self.backView.height - self.imageView.height);
    self.scrollView.contentSize = CGSizeMake(zjScreenWidth, PX2PT(64+40)*self.titleArray.count+PX2PT(20));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.titleArray.count; i++) {
        //添加视图到滚动视图中
        [self.scrollView addSubview:[self otheraddUpmiviewWithimageName:self.colorsArray[i] andTxet:self.titleArray[i] andY:i andSum:[self.personsArray[i] integerValue] ]];
    }
    //创建圆
    [self addyuan];
    [self.piechart reloadData];
    [self TempImageView:@"客户数据统计"];
}


//年度分析按钮事件
- (void)otherClick:(UIButton *)sender{
    
    switch (sender.tag) {
        case 5:
        {
            
            self.otherLeftButton.selected = YES;
            self.otherRightButton.selected = NO;
            
            NSMutableArray *Title = [NSMutableArray array];
            for (int i = 0; i < self.SourceArray.count; i++) {
                NSString *titleStr = self.SourceArray[i];
                BOOL isFirst  = [self isChineseFirst:titleStr];
                if (isFirst) {
                    [Title addObject:titleStr];
                }else {
                    BOOL isA = [self MatchLetter:titleStr];
                    if (isA) {
                        [Title addObject:titleStr];
                    }
                }
            }
            SGActionSheet *sheet = [SGActionSheet actionSheetWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" otherButtonTitleArray:Title];
            self.ActionSheet = sheet;
            sheet.messageTextFont = [UIFont systemFontOfSize:ZJTextSize55PX];
            sheet.messageTextColor = [UIColor redColor];
            sheet.otherTitleFont = [UIFont systemFontOfSize:ZJTextSize45PX];
            sheet.cancelButtonTitleFont = [UIFont systemFontOfSize:ZJTextSize55PX];
            [sheet show];
           
        }
            break;
        case 6:
        {
            self.otherLeftButton.selected = NO;
            self.otherRightButton.selected = YES;
            
            LTPickerView* pickerView = [[LTPickerView alloc]init];
            self.pickerView = pickerView;
              //设置要显示的数据
            pickerView.dataSource = @[@"2000",@"2001",@"2002",@"2003",@"2004",@"2005",@"2006",@"2007",@"2008",@"2009",@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030",@"2031",@"2032",@"2033",@"2034",@"2035",@"2036",@"2037",@"2038",@"2039",@"2040",@"2041",@"2042",@"2043",@"2044",@"2045",@"2046",@"2047",@"2048",@"2049",@"2050",@"2051",@"2052",@"2053",@"2054",@"2055",@"2056",@"2057",@"2058",@"2059",@"2060"];
            
            [pickerView show];//显示
            __weak __typeof(self) weakself=self;
            pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
               
                [weakself.otherRightButton setTitle:str forState:UIControlStateNormal];
                [weakself.otherRightButton zj_changeImageAndTitel];
                NSString *ButtonString = weakself.otherRightButton.titleLabel.text;
                NSString *yearString = [NSString stringWithFormat:@"%@年每月放贷类型排行",ButtonString];
                [weakself.changelabel zj_labelText:yearString textColor:ZJColorFFFFFF textSize:ZJTextSize45PX];
                NSString *String = str;
                self.year = [String integerValue];
                [weakself selectAllYear:[String integerValue]];
           
                //年度分析滚动视图
                [weakself ALLScorllView];
                //创建状型图
                [weakself configUI];
                
            };
            
            
        }
        default:
            break;
    }
    
    
}

//代理方法来显示点击的行数
- (void)SGActionSheet:(SGActionSheet *)actionSheet didSelectRowAtIndexPath:(NSInteger)indexPath{
    
    
    [self.otherLeftButton setTitle:self.SourceArray[indexPath] forState:UIControlStateNormal];
    [self.otherLeftButton zj_changeImageAndTitel];
    
    if (indexPath == 0) {
        self.SourceLabel.text = @"来源最多";
        [self selectAllYear:self.year];
        [self ALLScorllView];

    }else {
        self.SourceLabel.text = self.SourceArray[indexPath];
        
        
        if (indexPath < self.ThekeywordArray.count) {
            [self SelectThekeywordIndex:indexPath];
        }
        //年度分析滚动视图
        [self OtherScrollView];
    }
    

    //创建状型图
    [self configUI];

}
//全部数据统计的滚动视图

-(void)ALLScorllView{
    
    //创建滚动视图
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat scrollViewY = CGRectGetMaxY(self.changeView.frame);
    self.scrollView.frame = CGRectMake(0,scrollViewY+1,zjScreenWidth,zjScreenHeight - PX2PT(146+80+128+25 + 100) - 64 - chartView.height - 44);
    
    self.scrollView.backgroundColor = ZJColorFFFFFF;
    self.scrollView.contentSize = CGSizeMake(zjScreenWidth, PX2PT(64+40)*self.yearsArray.count + PX2PT(20));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    for (int i = 0; i < self.yearsArray.count; i++) {
        [self.scrollView addSubview:[self OtherScorViewWithimageName:self.colorsArray[i] andText:self.yearsArray[i] andY:i andThebiggestArray:[self.NumbersArray[i] integerValue] andThesamenumberArray:self.ChannelArray[i]]];
    }
    [self.view addSubview:self.scrollView];
}


- (UIView *)OtherScorViewWithimageName:(NSString*)name andText:(NSString*)text andY:(int)y andThebiggestArray:(NSInteger )Thebiggest andThesamenumberArray:(NSMutableArray *)TheMenNumber {
    
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = ZJColorFFFFFF;
    view.frame = CGRectMake(0, PX2PT(64+40)*y, zjScreenWidth,PX2PT(64+40) );
    //小方块
    UIView* imageview  = [[UIView alloc]initWithFrame:CGRectMake(PX2PT(60),(PX2PT(64+40)-PX2PT(64))/2, 64/3, PX2PT(64))];
    imageview.backgroundColor = [UIColor colorWithHexString:name];
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius = imageview.bounds.size.width/6;
    [view addSubview:imageview];
    // 月份
    UILabel *datelabel = [[UILabel alloc]init];
    datelabel.textAlignment = NSTextAlignmentRight;
    [datelabel zj_labelText:text
                  textColor:ZJColor505050
                   textSize:ZJTextSize45PX];
    datelabel.x = PX2PT(60 + 64 + 40);
    [datelabel zj_adjustWithMin];
    datelabel.centerY = view.height/2;
    
    [view addSubview:datelabel];
    
    
    
    //来源
    
    UILabel *sourcelabel = [[UILabel alloc]initWithFrame:CGRectMake(view.width / 3 , 0, (view.width - 2) / 3 + 1,view.height)];
    
    NSMutableString *sourceName = [NSMutableString string];
    
    for (int i = 0; i < TheMenNumber.count; i ++) {
        NSString *name = TheMenNumber[i];
        if (name == NULL) {
            break;
        }
        [sourceName appendFormat:@"%@, ",name];
    }
    if ([sourceName isEqualToString:@""]) {
        [sourcelabel zj_labelText:@"无" textColor:ZJColor848484 textSize:ZJTextSize45PX];
    }else {
         [sourceName deleteCharactersInRange:NSMakeRange(sourceName.length- 2, 1)];
        [sourcelabel zj_labelText:[NSString stringWithFormat:@"%@",sourceName] textColor:ZJColor848484 textSize:ZJTextSize45PX];
        if (sourcelabel.text.length > 10) {
            self.AllName = sourcelabel.text;
            UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bounced)];

            [view addGestureRecognizer:tapGesture];
        }
    }
    
    sourcelabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:sourcelabel];
    
    //人数
    UILabel *pesonlabel = [[UILabel alloc]initWithFrame:CGRectMake(view.width / 3 * 2, 0,(view.width - 3) /3 + 2 , view.height)];
    
    [pesonlabel zj_labelText:[NSString stringWithFormat:@"%zd人",Thebiggest]
                   textColor:ZJColor848484
                    textSize:ZJTextSize45PX];
    
    
    pesonlabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:pesonlabel];
    
    return view;
    
    
    
}
//来源最多文本超出时出现弹框
- (void)bounced{
    
    NSString *str = NSLocalizedString(self.AllName, nil);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"来源最多" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:Cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

//根据关键字从数据库取数据
- (void)SelectThekeywordIndex:(NSInteger)index{
    
    NSInteger sum = [self.ThekeywordArray[index] integerValue];
    sum = sum -1;
    [self.NumbersArray removeAllObjects];
    [self.ChannelArray removeAllObjects];
    NSInteger year = self.year;
    NSMutableArray *AllArray = [NSMutableArray array];
    
    for (int j = 1; j < 13; j++) {
        if  (index < self.ThekeywordArray.count){
            NSString *pesrson = [NSString stringWithFormat:@"SELECT * FROM(SELECT  count(iAutoID) AS NUM,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID=%zd) AS NAME  FROM crm_CustomerInfo WHERE (cLoanType_Tags LIKE '%zd;%%' OR cLoanType_Tags LIKE '%%;%zd;%%' OR cLoanType_Tags LIKE '%%%zd;') AND cCreateYear='%zd' AND cCreateMonth='%02d') ORDER BY NUM DESC LIMIT 1",sum ,sum ,sum ,sum ,year,j];
    
            AllArray = [ZJFMdb references:pesrson];
            for (int i = 0; i < AllArray.count; i++) {
                NSDictionary *dic = AllArray[i];
                NSString *num = dic[@"num"];
                [self.NumbersArray addObject:num];
                NSString *sum = dic[@"name"];
                [self.ChannelArray addObject:sum];
            }
        }
        
        
    }
    
    
}

#pragma mark - 渠道排行中间标题
-(void)change{
    
    UILabel *label = [UILabel new];
    self.changelabel = label;
    label.backgroundColor = ZJColor00D3A3;
    label.textAlignment = NSTextAlignmentCenter;
    [label zj_labelText:[NSString stringWithFormat:@"%zd年每月渠道排行",self.year]
              textColor:ZJColorFFFFFF
               textSize:ZJTextSize45PX];
    
    label.width = zjScreenWidth;
    label.height = PX2PT(80);
    label.y = chartView.height + PX2PT(80) + 28 ;
    [self.view addSubview:label];
}
#pragma mark - 三等分
-(void)middleView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, chartView.height + PX2PT(80+80+80), zjScreenWidth, PX2PT(128))];
    view.backgroundColor = ZJColorFFFFFF;
    //虚线
    self.changeView = view;
    UIView *lineview = [[UIView alloc]init];
    lineview.backgroundColor = ZJColorDCDCDC;
    lineview.frame = CGRectMake((zjScreenWidth- 3) / 3, 0,1,view.height);
    [view addSubview:lineview];
    UIView *otherview = [[UIView alloc]init];
    otherview.backgroundColor = ZJColorDCDCDC;
    otherview.frame = CGRectMake(2*(zjScreenWidth- 3) / 3 + 1, 0,1,view.height);
    [view addSubview:otherview];
    UIView *otherlineview = [[UIView alloc]init];
    otherlineview.backgroundColor = ZJColorDCDCDC;
    otherlineview.frame =CGRectMake(0,view.height-1, zjScreenWidth, 1);
    [view addSubview:otherlineview];
    
  
    //创建中间视图的文本显示
    UILabel *yearlabel = [[UILabel alloc]initWithFrame:
                          CGRectMake(0, 0,zjScreenWidth / 3,
                                     view.height)];
    [yearlabel zj_labelText:@"月份" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    yearlabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:yearlabel];
    
    UILabel *SourceLabel = [[UILabel alloc]initWithFrame:
                            CGRectMake(zjScreenWidth/3, 0,(zjScreenWidth - 2) / 3 ,
                                            view.height)];
    self.SourceLabel = SourceLabel;
    [SourceLabel zj_labelText:@"来源最多" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    SourceLabel.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:SourceLabel];
    
    UILabel *personLable = [[UILabel alloc]initWithFrame:
                            CGRectMake(zjScreenWidth/3 * 2, 0,(zjScreenWidth - 3 )/3, view.height)];
    [personLable zj_labelText:@"客户数" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    personLable.textAlignment = NSTextAlignmentCenter;
    [view addSubview:personLable];
    
    [self.view addSubview:view];
}

#pragma mark---------创建圆视图
-(void)addyuan{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,self.view.bounds.origin.y + PX2PT(40) + self.imageView.height, zjScreenWidth, 200)];
    view.backgroundColor = [UIColor whiteColor];
    self.backView = view;
    
    //创建圆
    self.piechart = [[XYPieChart alloc]initWithFrame:
                     CGRectMake(0, 0, zjScreenWidth, 200) Center:CGPointMake(zjScreenWidth/2, 200/2) Radius:80];
    [self.piechart setDataSource:self];
    [self.piechart setDelegate:self];
    [self.piechart setShowPercentage:NO];
    
   
    self.arraycolor = @[ZJRGBColor(41, 90, 165, 1),ZJRGBColor(82, 189, 189, 1),ZJRGBColor(255, 173, 107, 1),ZJRGBColor(247, 132, 165, 1),ZJRGBColor(206, 181, 90, 1),ZJRGBColor(49, 181, 214, 1),ZJRGBColor(255,126,62,1),ZJRGBColor(255,230,8, 1),ZJRGBColor(22,182,211,1),ZJRGBColor(115,123,181,1),ZJRGBColor(222,107,115,1),ZJRGBColor(58,165,90,1),ZJRGBColor(229,246,196,1),ZJRGBColor(115,140,197,1),ZJRGBColor(140,64,125,1),ZJRGBColor(255,113,0,1),ZJRGBColor(239,16,99,1),ZJRGBColor(230,58,140,1),ZJRGBColor(165,115,140,1),ZJRGBColor(189,33,25,1)];
    
    [view addSubview:self.piechart];
    
    [self.view addSubview:view];
}
//第三库的协议
-(NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart{
    return self.personsArray.count;
}

-(CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index{
    return [self.personsArray[index] integerValue];
}

-(UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index{
    
    return self.arraycolor[index];
}

//颜色数组
-(NSArray *)colorsArray{
    if (!_colorsArray) {
        _colorsArray = @[@"#295aa5",@"#52bdbd",@"#ffad6b",@"#f784a5",@"#ceb55a",@"#31b5d6",@"#ff7e3e",@"#ffe608",@"#16b6d3",@"#737bb5",@"#de6b73",@"#3aa55a",@"#e5f6c4",@"#738cc5",@"#8c407d",@"#ff7100",@"#ef1063",@"#e63a8c",@"#a5738c",@"#bd2119"];
    }
    return _colorsArray;
}

//月份数组
- (NSArray *)yearsArray{
    if (!_yearsArray){
        _yearsArray = @[@"一月份",@"二月份",@"三月份",@"四月份",@"五月份",@"六月份",@"七月份",@"八月份",@"九月份",@"十月份",@"十一月份",@"十二月份"];
    }
    return _yearsArray;
}
//月份颜色数组
- (NSArray *)yearsColorsArray{
    if (!_yearsColorsArray){
        _yearsColorsArray = @[@"#fca000",@"#fff500",@"#9ec700",@"#009800",@"#009e9f",@"#00a3e7",@"0072b6",@"#000c7a",@"#a1007e",@"#f00082",@"#ef005a",@"#ef0000"];
    }
    return _yearsColorsArray;
    
}
#pragma mark---------创建分类视图
-(void)addret{
    
    //创建滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,self.backView.height + PX2PT(40) + self.imageView.height,zjScreenWidth,zjScreenHeight - PX2PT(146+40 + 100) - 64 - self.backView.height - self.imageView.height)];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.scrollView = scrollView;
    scrollView.backgroundColor = ZJBackGroundColor;
    scrollView.contentSize = CGSizeMake(zjScreenWidth, PX2PT(64+40)*self.titleArray.count+PX2PT(20));
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    
    for (int i = 0; i < self.titleArray.count; i++) {
        //添加视图到滚动视图中
        [scrollView addSubview:[self otheraddUpmiviewWithimageName:self.colorsArray[i] andTxet:self.titleArray[i] andY:i andSum:[self.personsArray[i] unsignedIntegerValue]]];
    }
    
    [self.view addSubview:scrollView];
}


#pragma mark---------创建左边顶部点击按钮事件后的小分类视图
-(UIView*)otheraddUpmiviewWithimageName:(NSString*)name andTxet:(NSString*)text andY:(int)y andSum:(NSInteger) sum{
   
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = ZJColorFFFFFF;
    view.frame = CGRectMake(0, PX2PT(64+40)*y, zjScreenWidth,PX2PT(64+40) );
    //小方块
    UIView* imageview  = [[UIView alloc]initWithFrame:CGRectMake(PX2PT(40),(PX2PT(64+40)-PX2PT(64))/2, 64/3, PX2PT(64))];
    imageview.backgroundColor = [UIColor colorWithHexString:name];
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius = imageview.bounds.size.width/6;
    [view addSubview:imageview];
    // 月份
    UILabel *datelabel = [[UILabel alloc]init];
    datelabel.textAlignment = NSTextAlignmentRight;
    [datelabel zj_labelText:text
                  textColor:ZJColor505050
                   textSize:ZJTextSize45PX];
    datelabel.x = PX2PT(40 + 64 + 40);
    [datelabel zj_adjustWithMin];
    datelabel.centerY = view.height/2;
    
    [view addSubview:datelabel];
    
    //人数
    UILabel *pesonlabel = [UILabel new];
    pesonlabel.textAlignment = NSTextAlignmentRight;
    [pesonlabel zj_labelText:[NSString stringWithFormat:@"%zd人",sum]
                   textColor:ZJColor848484
                    textSize:ZJTextSize45PX];
    pesonlabel.x = zjScreenWidth - 60;
    [pesonlabel zj_adjustWithMin];
    pesonlabel.centerY = view.height/2;
    
    [view addSubview:pesonlabel];

    return view;
}

#pragma mark---------创建顶部右边按钮点击按钮事件后的小分类视图
-(UIView*)otherViewWithimageName:(NSString*)name andText:(NSString*)text andSource:(NSString *)source  andY:(int)y andSums:(NSInteger) sums{
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = ZJColorFFFFFF;
    view.frame = CGRectMake(0, PX2PT(64+40)*y, zjScreenWidth,PX2PT(64+40) );
    //小方块
    UIView* imageview  = [[UIView alloc]initWithFrame:CGRectMake(PX2PT(60),(PX2PT(64+40)-PX2PT(64))/2, 64/3, PX2PT(64))];
    imageview.backgroundColor = [UIColor colorWithHexString:name];
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius = imageview.bounds.size.width/6;
    [view addSubview:imageview];
    // 月份
    UILabel *datelabel = [[UILabel alloc]init];
    datelabel.textAlignment = NSTextAlignmentRight;
    [datelabel zj_labelText:text
                  textColor:ZJColor505050
                   textSize:ZJTextSize45PX];
    datelabel.x = PX2PT(60 + 64 + 40);
    [datelabel zj_adjustWithMin];
    datelabel.centerY = view.height/2;
    
    [view addSubview:datelabel];
//    //小方块
//    UIView* imageview  = [[UIView alloc]initWithFrame:CGRectMake(PX2PT(40),(PX2PT(64+40)-PX2PT(64))/2, 64/3, PX2PT(64))];
//    imageview.backgroundColor = [UIColor colorWithHexString:name];
//    imageview.layer.masksToBounds = YES;
//    imageview.layer.cornerRadius = imageview.bounds.size.width/6;
//    [view addSubview:imageview];
//    // 月份
//    UILabel *datelabel = [[UILabel alloc]init];
//    datelabel.textAlignment = NSTextAlignmentRight;
//    [datelabel zj_labelText:text
//                  textColor:ZJColor505050
//                   textSize:ZJTextSize45PX];
//    datelabel.x = PX2PT(40 + 64 + 40);
//    [datelabel zj_adjustWithMin];
//    datelabel.centerY = view.height/2;
//    
//    [view addSubview:datelabel];
    
    //来源
    UILabel *sourcelabel = [[UILabel alloc]initWithFrame:CGRectMake(view.width / 3 , 0, (view.width - 2) / 3 + 1,view.height)];
    if (sums == 0) {
        [sourcelabel zj_labelText:@"无" textColor:ZJColor848484 textSize:ZJTextSize45PX];
    }else{
        [sourcelabel zj_labelText:source textColor:ZJColor848484 textSize:ZJTextSize45PX];
    }
    sourcelabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:sourcelabel];
    
    //人数
    UILabel *pesonlabel = [[UILabel alloc]initWithFrame:CGRectMake(view.width / 3 * 2, 0,(view.width - 3) /3 + 2 , view.height)];
    [pesonlabel zj_labelText:[NSString stringWithFormat:@"%zd人",sums]
                   textColor:ZJColor848484
                    textSize:ZJTextSize45PX];
    pesonlabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:pesonlabel];
    
    [view addSubview:pesonlabel];
    
    return view;
}

//创建桩型图
- (void)configUI {
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    chartView.backgroundColor = ZJColorFFFFFF;
    chartView = [[SCChart alloc] initwithSCChartDataFrame:CGRectMake(0,self.view.bounds.origin.y + PX2PT(40) + self.imageView.height, zjScreenWidth, 200) withSource:self withStyle:SCChartBarStyle];
    [chartView showInView:self.view];
}

//状型图数据
- (NSArray *)getXTitles:(int)num {
    NSMutableArray *xTitles = [NSMutableArray array];
    NSArray *arrdate = @[@"一月",@"二月",@"三月",@"四月",
                         @"五月",@"六月",@"八月",@"七月",@"九月",
                         @"十月",@"十一月",@"十二月"];
    
    for (NSString *date in arrdate) {
        
        [xTitles addObject:date];
    }
    
    
    return xTitles;
}
#pragma mark - @required

//横坐标标题数组
- (NSArray *)SCChart_xLableArray:(SCChart *)chart {
    return [self getXTitles:11];
}

//数值多重数组
- (NSArray *)SCChart_yValueArray:(SCChart *)chart{
    NSMutableArray *ary = [NSMutableArray array];
    for (NSInteger i = 0; i < 12; i++) {
        CGFloat num = [self.NumbersArray[i] floatValue];
        NSString *str = [NSString stringWithFormat:@"%f",num];
        [ary addObject:str];
    }
    return @[ary];
}


#pragma mark - @optional
//颜色数组
- (NSArray *)SCChart_ColorArray:(SCChart *)chart {
    NSMutableArray *ColorArray = [NSMutableArray array];
    for (NSString *colorString in self.colorsArray) {
        UIColor *Color = [UIColor colorWithHexString:colorString];
        [ColorArray addObject:Color];
    }
    return ColorArray;
}

//查询数据
- (void)selectYear:(NSInteger) year andMonth:(NSInteger) month{
    
    self.titleArray = [NSMutableArray array];
    NSMutableArray *dataModel = [NSMutableArray array];
    NSMutableArray *pesrsonsArray = [NSMutableArray array];
    self.personsArray = [NSMutableArray array];
    ZJCustomerItemsTableInfo *model = [ZJCustomerItemsTableInfo new];
    NSString *selct = @"SELECT * FROM crm_CustomerItems WHERE type='customerType';";
    [ZJFMdb sqlSelecteData:model selecteString:selct success:^(NSMutableArray *successMsg) {
        [dataModel addObjectsFromArray:successMsg];
    }];
    for (ZJCustomerItemsTableInfo *zj in dataModel) {
        [self.titleArray addObject:zj.itemString];
        [pesrsonsArray addObject:@(zj.iAutoID)];
    }
    
    for (int i = 0; i < pesrsonsArray.count; i++) {
        NSInteger ID = [pesrsonsArray[i] integerValue];
        NSString *pesron = [NSString stringWithFormat:@"SELECT count(iAutoID) AS NUM,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID=%zd) AS NAME FROM crm_CustomerInfo AS b WHERE (cLoanType_Tags LIKE '%zd;%%' OR cLoanType_Tags LIKE '%%;%zd;%%' OR cLoanType_Tags LIKE '%zd;') AND cCreateYear='%zd' AND cCreateMonth='%02zd' ",ID,ID,ID,ID,year,month];
        NSInteger sum =   [ZJFMdb sqlSelecteCountWithString:pesron];
       
        [self.personsArray addObject:@(sum)];
        
    }
    
}

//查询全部年度分析
- (void)selectAllYear:(NSInteger) year{
    
    self.SourceArray = [NSMutableArray array];
    [self.SourceArray removeAllObjects];
    self.ChannelArray = [NSMutableArray array];
    [self.ChannelArray removeAllObjects];
    self.NumbersArray = [NSMutableArray array];
    [self.NumbersArray removeAllObjects];
    self.ThekeywordArray = [NSMutableArray array];
    
    NSMutableArray *dataModel = [NSMutableArray array];
    NSMutableArray *pesrsonsArray = [NSMutableArray array];
    self.ThekeywordArray = pesrsonsArray;
    NSMutableArray *AllArray = [NSMutableArray array];
    ZJCustomerItemsTableInfo *model = [ZJCustomerItemsTableInfo new];
    NSString *selct = @"SELECT iAutoID,itemString FROM crm_CustomerItems WHERE type='customerType';";
    [ZJFMdb sqlSelecteData:model selecteString:selct success:^(NSMutableArray *successMsg) {
        [dataModel addObjectsFromArray:successMsg];
    }];
    NSString *str = @"全部";
    [self.SourceArray addObject:str];
    
    for (ZJCustomerItemsTableInfo *zj in dataModel) {
        [self.SourceArray addObject:zj.itemString];
        [pesrsonsArray addObject:@(zj.iAutoID)];
    }
    
    for (int j = 1; j <= 12; j++){
        NSMutableString *sql = [[NSMutableString alloc]initWithString:@"SELECT * FROM ("];
        for (int i = 0; i < pesrsonsArray.count; i++) {
            NSInteger ID = [pesrsonsArray[i] integerValue];
            NSMutableString *person = [NSMutableString stringWithFormat:@"SELECT  count(iAutoID) AS NUM,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID=%zd) AS NAME  FROM crm_CustomerInfo WHERE (cLoanType_Tags LIKE '%zd;%%' OR cLoanType_Tags LIKE '%%;%zd;%%' OR cLoanType_Tags LIKE '%%%zd;') AND cCreateYear='%zd' AND cCreateMonth='%02d'  " ,ID,ID,ID,ID,year,j];
            if(i < pesrsonsArray.count-1)
            {
                [person appendString:@"UNION ALL "];
            }
            [sql appendString:person];
        }
        [sql appendString:@") ORDER BY NUM DESC "];
        
        //SQL结果
        AllArray = [ZJFMdb references:sql];
       
        NSMutableArray *AllArrayTemp = [NSMutableArray array];
        
        NSMutableArray *AllArrayTemp2 = [NSMutableArray array];
        NSMutableArray *AllArrayTemp3 = [NSMutableArray array];
        
        for (int i = 0; i < AllArray.count; i++) {
            NSDictionary *dic = AllArray[i];
            NSString *num = dic[@"num"];
            
            [AllArrayTemp addObject:num];
            NSString *sum = dic[@"name"];
            [AllArrayTemp2 addObject:sum];
            
        }
        [self.NumbersArray addObject:AllArrayTemp[0]];
        
      
        if ([AllArrayTemp[0] integerValue] != 0) {
            [AllArrayTemp3 addObject: AllArrayTemp2[0]];
        }
        for ( int i = 1; i < AllArrayTemp.count; i++) {
            
            if( [AllArrayTemp[0] integerValue]  != 0 )
            {
                if ( [AllArrayTemp[0] integerValue] == [AllArrayTemp[i] integerValue] )
                {
                    [AllArrayTemp3 addObject: AllArrayTemp2[i]];
                    
                }
            }
        }
        [self.ChannelArray addObject:AllArrayTemp3];
        
        
    }
}



- (void)TempImageView:(NSString *) imageName{
    NSInteger sum = 0;
    NSInteger K = 0;
    for (int i = 0; i < self.personsArray.count; i++) {
        NSInteger number = [self.self.personsArray[i] integerValue];
        if (sum == number) {
            K++;
        }
    }
    if (K < self.self.personsArray.count) {
        [self.backImageView removeFromSuperview];
        return;
    }else {
        UIImageView *ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(zjScreenWidth/ 4, PX2PT(300), PX2PT(638), PX2PT(323))];
        ImageView.image = [UIImage imageNamed:imageName];
        self.backImageView = ImageView;
        [self.view addSubview:ImageView];
        
    }
}


#pragma mark 正则表达式
-(BOOL)MatchLetter:(NSString *)str
{
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:str] == YES)
        return YES;
    else
        return NO;
}
-(BOOL)isChineseFirst:(NSString *)firstStr
{
    //是否以中文开头(unicode中文编码范围是0x4e00~0x9fa5)
    int utfCode = 0;
    void *buffer = &utfCode;
    NSRange range = NSMakeRange(0, 1);
    //判断是不是中文开头的,buffer->获取字符的字节数据 maxLength->buffer的最大长度 usedLength->实际写入的长度，不需要的话可以传递NULL encoding->字符编码常数，不同编码方式转换后的字节长是不一样的，这里我用了UTF16 Little-Endian，maxLength为2字节，如果使用Unicode，则需要4字节 options->编码转换的选项，有两个值，分别是NSStringEncodingConversionAllowLossy和NSStringEncodingConversionExternalRepresentation range->获取的字符串中的字符范围,这里设置的第一个字符 remainingRange->建议获取的范围，可以传递NULL
    BOOL b = [firstStr getBytes:buffer maxLength:2 usedLength:NULL encoding:NSUTF16LittleEndianStringEncoding options:NSStringEncodingConversionExternalRepresentation range:range remainingRange:NULL];
    if (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5))
        return YES;
    else
        return NO;
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
