//
//  ZJSourceViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/10.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJSourceViewController.h"
//第三库图形
#import "XYPieChart.h"
#import "UIColor+K.h"
#import "NSDate+Category.h"
#import "ZJFMdb.h"
//第三方日期
#import "LTPickerView/LTPickerView.h"
#import "ZJCustomerItemsTableInfo.h"

@interface ZJSourceViewController ()<XYPieChartDelegate,XYPieChartDataSource>
{
    //中间的文本视图
    UIView *_tempView;
    //记录来源按钮
    UIButton *_QuarterButton;
    UIButton *_MonthButton;
    UIButton *_YearButton;
    //记录介绍人按钮
    UIButton *_RightYearButton;
    UIButton *_RightMonthButton;
    UIButton *_RightQuarterButton;
}
//顶部选择按钮
@property (nonatomic,strong)NSMutableArray *upbutton;
//顶部按钮背景图片
@property (nonatomic,weak)UIImageView *imageView;
//控制视图
@property (nonatomic,weak)UIView *backView;
//三方类
@property (nonatomic,strong)XYPieChart *piechart;
//圆存放颜色数组
@property (nonatomic,strong)NSArray *arraycolor;
//底部视图
@property (nonatomic,weak)UIView *upview;
//底部按钮数组
@property (nonatomic,strong)NSMutableArray *buttons;
//人数数组
@property (nonatomic,strong)NSArray *prseonbutton;
//第三方日期类
@property (nonatomic,weak)LTPickerView *pickerView;
//底部最后一个按钮;
@property (nonatomic,weak)UIButton *LastButton;
//年份
@property (nonatomic,assign)NSInteger year;
//月份
@property (nonatomic,assign)NSInteger month;
//来源数组
@property (nonatomic,strong)NSMutableArray *titleArray;
//来源人数数组
@property (nonatomic,strong)NSMutableArray *personArray;
//记录上方按钮的状态
@property (nonatomic,assign)BOOL lefBtn;
//颜色数组
@property (nonatomic,strong)NSArray *ColorArray;
//来源滚动视图
@property (nonatomic,weak)UIScrollView *ScrollView;
//介绍人数组
@property (nonatomic,strong)NSMutableArray *ReferencesArray;

@property (nonatomic,weak)UIScrollView *ReferencesScrollView;

@property (nonatomic,assign)int i;

@property (nonatomic,weak)UIImageView *backImageView;

@property (nonatomic,weak)UIImageView *UPImageView;
@end

@implementation ZJSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户来源分析";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ZJBackGroundColor;
    NSDate *date = [NSDate new];
    NSInteger year = [date zj_getRealTimeForRequire:NSCalendarUnitYear];
    self.year = year;
    NSInteger month = [date zj_getRealTimeForRequire:NSCalendarUnitMonth];
    self.month = month;
    //创建顶部按钮
    [self UpButton];
    //创建底部视图
    [self addUpview];
    [self selectYear:year andMonth:month];
    //创建圆
    [self addyuan];
    //创建滚动视图分类
    [self addret];
   
   

    //介绍人按钮
    [self addUPButton];
    
    
    [self TempImageView:@"客户数据统计" andCGRect:CGRectMake(zjScreenWidth / 4.5 , PX2PT(300), PX2PT(638), PX2PT(323))];
    
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
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.piechart reloadData];
}




//创建顶部按钮
-(void)UpButton{
    UIImageView *ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX2PT(40), self.view.bounds.origin.y + PX2PT(40), zjScreenWidth - PX2PT(80), 40)];
    ImageView.image = [UIImage imageNamed:@"D-A_acklog"];
    ImageView.userInteractionEnabled = YES;
    self.imageView = ImageView;
    self.upbutton = [NSMutableArray array];
    NSArray *titlebtn = @[@"来源统计",@"介绍人统计"];
    UIButton *leftUPButton = [[UIButton alloc]init];
    leftUPButton.frame = CGRectMake(0, 0, ImageView.width/2, ImageView.height);
    [leftUPButton setTitle:titlebtn[0] forState:UIControlStateNormal];
    leftUPButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [leftUPButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    [leftUPButton setTitleColor:ZJColor00D3A3 forState:UIControlStateSelected];
    [ImageView addSubview:leftUPButton];
    leftUPButton.tag = 1;
    leftUPButton.selected = NO;
    _lefBtn = leftUPButton.selected;
    [leftUPButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *rightUPButton = [[UIButton alloc]init];
    rightUPButton.frame = CGRectMake(ImageView.width/2,0, ImageView.width/2, ImageView.height);
    [rightUPButton setTitle:titlebtn[1] forState:UIControlStateNormal];
    rightUPButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [rightUPButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    [rightUPButton setTitleColor:ZJColor00D3A3 forState:UIControlStateSelected];
    rightUPButton.tag = 2;
    [ImageView addSubview:rightUPButton];
    [rightUPButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:ImageView];
    
    
}

//顶部按钮事件
-(void)btnAction:(UIButton *)sender{
    
    if (sender.tag == 1) {
        _YearButton.hidden = NO;
        _MonthButton.hidden = NO;
        _QuarterButton.hidden = NO;
        _RightYearButton.hidden = YES;
        _RightMonthButton.hidden = YES;
        _RightQuarterButton.hidden = YES;
        _tempView.hidden = YES;
     [_YearButton  addTarget:self action:@selector(timeselection:) forControlEvents:UIControlEventTouchUpInside];
         self.imageView.image = [UIImage imageNamed:@"D-A_acklog"];
       [self leftViewArray];
    }else if(sender.tag == 2){
        _YearButton.hidden = YES;
        _MonthButton.hidden = YES;
        _QuarterButton.hidden = YES;
        _RightYearButton.hidden = NO;
        _RightMonthButton.hidden = NO;
        _RightQuarterButton.hidden = NO;
        //介绍人中间文本
        [self addText];
        //顶部按钮的背景颜色
      self.imageView.image = [UIImage imageNamed:@"D-A_Done"];
       [self.ScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //创建滚动视图
        self.ScrollView.frame = CGRectMake(0,self.backView.height + PX2PT(20) + self.imageView.height + _upview.height ,zjScreenWidth,zjScreenHeight - PX2PT(146+ 30 + 100) - 64 - self.backView.height - self.imageView.height - _upview.height);
        self.ScrollView.backgroundColor = ZJColorFFFFFF;
        self.ScrollView.contentSize = CGSizeMake(zjScreenWidth, PX2PT(64+40)*self.ReferencesArray.count);
        self.ScrollView.showsHorizontalScrollIndicator = NO;
        self.ScrollView.bounces = NO;
        
        
        [self selectReferences];
    [self TempBackImageView:@"客户来源统计" andCGRect:CGRectMake(zjScreenWidth / 4.5 ,PX2PT(1100),PX2PT(732), PX2PT(323))];
        //创建圆
        [self addyuan];
        //绘制图形
        [self.piechart reloadData];
       [self TempImageView:@"客户数据统计" andCGRect:CGRectMake(zjScreenWidth / 4.5 , PX2PT(300), PX2PT(638), PX2PT(323))];
    
    }
}

//创建介绍人底部按钮
- (void)addUPButton{
    UIButton *leftUPButton = [[UIButton alloc]init];
    _RightMonthButton = leftUPButton;
    leftUPButton.frame = CGRectMake(0, 0, self.upview.width/3, self.upview.height);
    leftUPButton.hidden = YES;
    leftUPButton.selected = YES;
    [leftUPButton setTitle:@"本月" forState:UIControlStateNormal];
    leftUPButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [leftUPButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    [leftUPButton setTitleColor:ZJColor00D3A3 forState:UIControlStateSelected];
    leftUPButton.tag = 6;
    [leftUPButton addTarget:self action:@selector(References:) forControlEvents:UIControlEventTouchUpInside];
    [self.upview addSubview:leftUPButton];
    
    UIButton *rightUPButton = [[UIButton alloc]init];
    _RightQuarterButton = rightUPButton;
    rightUPButton.frame = CGRectMake(self.upview.width/3, 0, self.upview.width/3, self.upview.height);
    rightUPButton.hidden = YES;
    rightUPButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [rightUPButton setTitle:@"本季度" forState:UIControlStateNormal];
    [rightUPButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    [rightUPButton setTitleColor:ZJColor00D3A3 forState:UIControlStateSelected];
    [rightUPButton addTarget:self action:@selector(References:) forControlEvents:UIControlEventTouchUpInside];
    rightUPButton.tag = 7;
    [self.upview addSubview:rightUPButton];
    
    UIButton *YearButton = [[UIButton alloc]init];
    _RightYearButton = YearButton ;
    YearButton.frame = CGRectMake((self.upview.width / 3) * 2, 0, self.upview.width / 3, self.upview.height);
    YearButton.hidden = YES;
    YearButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [YearButton setTitle:[NSString stringWithFormat:@"%zd",self.year] forState:UIControlStateNormal];
    [YearButton setImage:[UIImage imageNamed:@"D-A_arrows"] forState:UIControlStateNormal];
    [YearButton setImage:[UIImage imageNamed:@"D-A_arrows-green"] forState:UIControlStateSelected];
    YearButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [YearButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    [YearButton setTitleColor:ZJColor00D3A3 forState:UIControlStateSelected];
    [YearButton addTarget:self action:@selector(References:) forControlEvents:UIControlEventTouchUpInside];
    [YearButton zj_changeImageAndTitel];
    YearButton.tag = 8;
    [self.upview addSubview:YearButton];
    
}

//来源统计视图
- (void)leftViewArray{
    _RightMonthButton.selected = YES;
    [self.ScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.personArray removeAllObjects];
    
    [self selectYear:self.year andMonth:self.month];
    //创建滚动视图分类
    [self addret];
    //创建圆
    [self addyuan];
    //绘制图形
    [self.piechart reloadData];
    
   [self TempImageView:@"客户数据统计" andCGRect:CGRectMake(zjScreenWidth / 4.5 , PX2PT(300), PX2PT(638), PX2PT(323))];
    
}
//介绍人按钮事件
- (void)References:(UIButton *)sender{
    [self.ScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //创建滚动视图
    self.ScrollView.frame = CGRectMake(0,PX2PT(20) +self.imageView.height + self.backView.height  + _upview.height,zjScreenWidth,zjScreenHeight - PX2PT(146+ 30 + 100) - 64 - self.backView.height - self.imageView.height - _upview.height);
    self.ScrollView.backgroundColor = ZJColorFFFFFF;
    self.ScrollView.contentSize = CGSizeMake(zjScreenWidth, PX2PT(64+40)*self.ReferencesArray.count);
    self.ScrollView.showsHorizontalScrollIndicator = NO;
    self.ScrollView.bounces = NO;
    self.ScrollView.pagingEnabled = YES;
   [self.UPImageView removeFromSuperview];
    switch (sender.tag) {
        case 6:
        {
            
            _RightMonthButton.selected = YES;
            _RightQuarterButton.selected = NO;
            _RightYearButton.selected = NO;
            //查询介绍人本月数据库数据
            [self selectReferences];
            
             [self TempBackImageView:@"客户来源统计" andCGRect:CGRectMake(zjScreenWidth / 4.5 , PX2PT(1100), PX2PT(732), PX2PT(323))];
            //创建圆
            [self addyuan];
            //绘制图形
            [self.piechart reloadData];
            [self TempImageView:@"客户数据统计" andCGRect:CGRectMake(zjScreenWidth / 4.5 , PX2PT(300), PX2PT(638), PX2PT(323))];
        }
            break;
        case 7:
        {
            _RightMonthButton.selected = NO;
            _RightYearButton.selected = NO;
            _RightQuarterButton.selected = YES;
            //查询介绍人本季度数据
            [self selectReferencesQuarter];
            [self TempBackImageView:@"客户来源统计" andCGRect:CGRectMake(zjScreenWidth / 4.5 , PX2PT(1100), PX2PT(732), PX2PT(323))];
            //创建圆
            [self addyuan];
            //绘制图形
            [self.piechart reloadData];
            [self TempImageView:@"客户数据统计" andCGRect:CGRectMake(zjScreenWidth / 4.5 , PX2PT(300), PX2PT(638), PX2PT(323))];
        }
            break;
        case 8:
        {
            _RightQuarterButton.selected = NO;
            _RightMonthButton.selected = NO;
            _RightYearButton.selected = YES;
            LTPickerView* pickerView = [[LTPickerView alloc]init];
            self.pickerView = pickerView;
            pickerView.dataSource = @[@"2000",@"2001",@"2002",@"2003",@"2004",@"2005",@"2006",@"2007",@"2008",@"2009",@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030",@"2031",@"2032",@"2033",@"2034",@"2035",@"2036",@"2037",@"2038",@"2039",@"2040",@"2041",@"2042",@"2043",@"2044",@"2045",@"2046",@"2047",@"2048",@"2049",@"2050",@"2051",@"2052",@"2053",@"2054",@"2055",@"2056",@"2057",@"2058",@"2059",@"2060"];//设置要显示的数据
            [pickerView show];//显示
             __weak __typeof(self) weakself=self;
            pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
                
                [_RightYearButton setTitle:str forState:UIControlStateNormal];
                [_RightYearButton zj_changeImageAndTitel];
                //查询本年本季度数据
                [weakself selectReferencesYear];
                [self TempBackImageView:@"客户来源统计" andCGRect:CGRectMake(zjScreenWidth / 4.5 , PX2PT(1100), PX2PT(732), PX2PT(323))];
                //创建圆
                [weakself addyuan];
                //绘制图形
                [weakself.piechart reloadData];
                [self TempImageView:@"客户数据统计" andCGRect:CGRectMake(zjScreenWidth / 4.5 , PX2PT(300), PX2PT(638), PX2PT(323))];
               
            };

            
        }
            break;
        default:
            break;
    }
    
   

}

#pragma mark---------从数据库中取介绍人本年数据
- (void)selectReferencesYear{
    [self.personArray removeAllObjects];
    NSMutableArray *contrastArray = [NSMutableArray array];
    [contrastArray removeAllObjects];
    self.ReferencesArray = contrastArray;
    NSString *str = [NSString stringWithFormat:@"SELECT  cCustomerSource_IntroducerName AS NAME,cCustomerSource_IntroducerPhone AS PHONE,count(iAutoID) AS NUM,(SELECT COUNT(iAutoID) FROM crm_CustomerInfo WHERE cCustomerSource_IntroducerName=B.cCustomerSource_IntroducerName AND cCustomerSource_IntroducerPhone=B.cCustomerSource_IntroducerPhone AND(cCustomerState_Tags LIKE '2;%%' OR cCustomerState_Tags LIKE '%%2;%%' OR cCustomerState_Tags LIKE '%%2;')) AS RIGHTNUM FROM crm_CustomerInfo AS B WHERE (cCreateYear='%zd') GROUP BY cCustomerSource_IntroducerName,cCustomerSource_IntroducerPhone ORDER BY NUM DESC",[_RightYearButton.titleLabel.text integerValue]];
    contrastArray = [ZJFMdb references:str];
    for (int i = 0; i < contrastArray.count; i++) {
        NSDictionary *dic = contrastArray[i];
        NSString *num = dic[@"name"];
        
        NSString *sum = dic[@"num"];
        NSInteger person = [sum integerValue];
        NSString *Customer = dic[@"rightnum"];
        [self.personArray addObject:sum];
        NSInteger coustomerPerson = [Customer integerValue];
        [self addotheraddUpmiviewWithimageName:self.ColorArray[i] andText:num andY:i andSum:person andCustomerSum:coustomerPerson];
    }

   
}


- (void)TempBackImageView:(NSString *) imageName andCGRect:(CGRect) frame{
    NSInteger sum = 0;
    NSInteger K = 0;
    
    for (int i = 0; i < self.personArray.count; i++) {
        NSInteger number = [self.self.personArray[i] integerValue];
        if (sum == number) {
            K++;
        }
    }
    if (K < self.self.personArray.count) {
        [self.UPImageView removeFromSuperview];
        return;
    }else {
        UIImageView *ImageView = [[UIImageView alloc]init];
        ImageView.frame = frame;
        self.UPImageView = ImageView;
        ImageView.image = [UIImage imageNamed:imageName];
        [self.view addSubview:ImageView];
        
    }
}


#pragma mark---------从数据库中取介绍人数据
- (void)selectReferencesQuarter{
    [self.personArray removeAllObjects];
    NSDate *dete = [NSDate new];
    //记录当前季度的月份
    NSInteger onemoth = 0;
    NSInteger twomonth = 0;
    NSInteger threemoth = 0;
    NSInteger moth =  [dete zj_getSeadonFromDate];
    [self.ScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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
    NSMutableArray *contrastArray = [NSMutableArray array];
    [contrastArray removeAllObjects];
    self.ReferencesArray = contrastArray;
    NSInteger year = [_RightYearButton.titleLabel.text integerValue];
    NSString *str = [NSString stringWithFormat:@"SELECT  cCustomerSource_IntroducerName AS NAME,cCustomerSource_IntroducerPhone AS PHONE,count(iAutoID) AS NUM,(SELECT COUNT(iAutoID) FROM crm_CustomerInfo WHERE cCustomerSource_IntroducerName=B.cCustomerSource_IntroducerName AND cCustomerSource_IntroducerPhone=B.cCustomerSource_IntroducerPhone AND(cCustomerState_Tags LIKE '2;%%' OR cCustomerState_Tags LIKE '%%2;%%' OR cCustomerState_Tags LIKE '%%2;')) AS RIGHTNUM FROM crm_CustomerInfo AS B WHERE cCreateYear='%zd' AND (cCreateMonth='%02zd' OR cCreateMonth='%02zd' OR cCreateMonth='%02zd') GROUP BY cCustomerSource_IntroducerName,cCustomerSource_IntroducerPhone ORDER BY NUM DESC",year,onemoth,twomonth,threemoth];
    contrastArray = [ZJFMdb references:str];
    for (int i = 0; i < contrastArray.count; i++) {
        NSDictionary *dic = contrastArray[i];
        NSString *num = dic[@"name"];
        
        NSString *sum = dic[@"num"];
        NSInteger person = [sum integerValue];
        NSString *Customer = dic[@"rightnum"];
        [self.personArray addObject:sum];
        NSInteger coustomerPerson = [Customer integerValue];
        [self addotheraddUpmiviewWithimageName:self.ColorArray[i] andText:num andY:i andSum:person andCustomerSum:coustomerPerson];
    }

    
    
}

#pragma mark---------从数据库中取介绍人本月数据
- (void)selectReferences{
    [self.personArray removeAllObjects];
    NSMutableArray *contrastArray = [NSMutableArray array];
    [contrastArray removeAllObjects];
    self.ReferencesArray = contrastArray;
    NSInteger year = [_RightYearButton.titleLabel.text integerValue];
    
    NSString *str = [NSString stringWithFormat:@"SELECT  cCustomerSource_IntroducerName AS NAME,cCustomerSource_IntroducerPhone AS PHONE,count(iAutoID) AS NUM,(SELECT COUNT(iAutoID) FROM crm_CustomerInfo WHERE cCustomerSource_IntroducerName=B.cCustomerSource_IntroducerName AND cCustomerSource_IntroducerPhone=B.cCustomerSource_IntroducerPhone AND(cCustomerState_Tags LIKE '2;%%' OR cCustomerState_Tags LIKE '%%2;%%' OR cCustomerState_Tags LIKE '%%2;')) AS RIGHTNUM FROM crm_CustomerInfo AS B WHERE (cCreateYear='%zd' AND cCreateMonth='%02zd' ) GROUP BY cCustomerSource_IntroducerName,cCustomerSource_IntroducerPhone ORDER BY NUM DESC",year,self.month];
    
        contrastArray = [ZJFMdb references:str];
        for (int i = 0; i < contrastArray.count; i++) {
            NSDictionary *dic = contrastArray[i];
            NSString *num = dic[@"name"];
            NSString *sum = dic[@"num"];
            
            NSInteger person = [sum integerValue];
            NSString *Customer = dic[@"rightnum"];
            
            [self.personArray addObject:sum];
            NSInteger coustomerPerson = [Customer integerValue];
            
        
            [self addotheraddUpmiviewWithimageName:self.ColorArray[self.i] andText:num andY:i andSum:person andCustomerSum:coustomerPerson];
            
            self.i++;
            
            if (self.i == self.ColorArray.count) {
                self.i = 0;
            }
            
        }
        self.i = 0;

}

#pragma mark---------添加中间文字
- (void)addText{
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, self.piechart.height + self.imageView.height + PX2PT(40), zjScreenWidth, PX2PT(128))];
    _tempView = middleView;
  
    middleView.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:middleView];
    
    UIView *Line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, zjScreenWidth, 1)];
    Line.backgroundColor = ZJColorDCDCDC;
    [middleView addSubview:Line];
    
    UIView *lastLine = [[UIView alloc]initWithFrame:CGRectMake(0, middleView.height - 1, zjScreenWidth, 1)];
    lastLine.backgroundColor = ZJColorDCDCDC;
    [middleView addSubview:lastLine];
    
    UIView *oneLine = [[UIView alloc]initWithFrame:CGRectMake((zjScreenWidth-3)/3, 0, 1, PX2PT(128))];
    oneLine.backgroundColor = ZJColorDCDCDC;
    [middleView addSubview:oneLine];
    
    UIView *twoLine = [[UIView alloc]initWithFrame:CGRectMake((zjScreenWidth ) / 3  *  2 ,0 , 1, PX2PT(128))];
    twoLine.backgroundColor = ZJColorDCDCDC;
    [middleView addSubview:twoLine];
    //介绍人
    UILabel *references = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,zjScreenWidth / 3,middleView.height)];
    [references zj_labelText:@"介绍人" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    references.textAlignment = NSTextAlignmentCenter;
    [middleView addSubview:references];
    //客户数
    UILabel *customerNumber = [[UILabel alloc]initWithFrame:CGRectMake(zjScreenWidth / 3 , 0, (zjScreenWidth - 2) / 3 + 1,middleView.height)];
    [customerNumber zj_labelText:@"客户数" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    customerNumber.textAlignment = NSTextAlignmentCenter;
    [middleView addSubview:customerNumber];
    //已贷人数
    UILabel *Haveborrow = [[UILabel alloc]initWithFrame:CGRectMake(zjScreenWidth / 3 * 2, 0,(zjScreenWidth - 3) /3 + 2 , middleView.height)];
    [Haveborrow zj_labelText:@"已贷人数" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    Haveborrow.textAlignment = NSTextAlignmentCenter;
    [middleView addSubview:Haveborrow];
    
    
}





#pragma mark---------添加介绍人滚动视图
- (void)addotheraddUpmiviewWithimageName:(NSString*)name andText:(NSString*)text andY:(int)y andSum:(NSInteger) Sum andCustomerSum:(NSInteger) customerSum {
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = ZJColorFFFFFF;
    
    view.frame = CGRectMake(0, PX2PT(64+40)*(y+0.4) , zjScreenWidth,PX2PT(64+40) );
    
    //小方块
    UIView* imageview  = [[UIView alloc]initWithFrame:CGRectMake(PX2PT(120),(PX2PT(64+40)-PX2PT(64))/2, 64/3, PX2PT(64))];
    
    
    imageview.backgroundColor = [UIColor colorWithHexString:name];
    
    
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius = imageview.bounds.size.width/6;
    [view addSubview:imageview];
    // 介绍人
    
    UILabel *datelabel = [[UILabel alloc]init];
    datelabel.textAlignment = NSTextAlignmentRight;
    if ([text isEqual: @""]) {
        [datelabel zj_labelText:@"无"
                      textColor:ZJColor505050
                       textSize:ZJTextSize45PX];
    } else {
        [datelabel zj_labelText:text
                      textColor:ZJColor505050
                       textSize:ZJTextSize45PX];
    }
    
    datelabel.x = PX2PT(120 + 64 + 40);
    [datelabel zj_adjustWithMin];
    datelabel.centerY = view.height/2;
    [view addSubview:datelabel];
    
    //客户人数
    UILabel *pesonlabel = [[UILabel alloc]initWithFrame:CGRectMake(view.width / 3 , 0, (view.width - 2) / 3 + 1,view.height)];
    [pesonlabel zj_labelText:[NSString stringWithFormat:@"%zd人",Sum]
                   textColor:ZJColor848484
                    textSize:ZJTextSize45PX];
    pesonlabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:pesonlabel];
    
    //已贷人数
    UILabel *customerLabel = [[UILabel alloc]initWithFrame:CGRectMake(view.width / 3 * 2, 0,(view.width - 3) /3 + 2 , view.height)];
    [customerLabel zj_labelText:[NSString stringWithFormat:@"%zd人",customerSum]
                   textColor:ZJColor848484
                    textSize:ZJTextSize45PX];
    customerLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:customerLabel];
    
    [self.ScrollView addSubview:view];
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
    
    self.arraycolor = @[@"#fca000",@"#fff500",@"#9ec700",@"#009800",@"#009e9f",@"#00a3e7",@"0072b6",@"#000c7a",@"#a1007e",@"#f00082",@"#ef005a",@"#ef0000",@"#fca000",@"#fff500",@"#9ec700",@"#009800",@"#009e9f",@"#00a3e7",@"0072b6",@"#ef0000"];
    
    [view addSubview:self.piechart];
    
    [self.view addSubview:view];
}
//第三库的协议
-(NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart{
    return self.personArray.count;
}

-(CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index{
    return [self.personArray[index] integerValue];
}

-(UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index{
    
    return [UIColor colorWithHexString:self.arraycolor[index]];
}

#pragma mark---------添加底部视图
-(void)addUpview{
    CGFloat heigt = PX2PT(146);
    UIView *upview = [[UIView alloc]initWithFrame:CGRectMake(0, zjScreenHeight - 64 - heigt, zjScreenWidth, heigt)];
    
    upview.backgroundColor = ZJColorFFFFFF;
    self.upview = upview;
    [self setSeparatorViewWithFrame:CGRectMake((zjScreenWidth-3)/3, 0, 1, heigt)];
    
    [self setSeparatorViewWithFrame:CGRectMake(2*(zjScreenWidth-3)/3+1, 0, 1, heigt)];
    
    [self setSeparatorViewWithFrame:CGRectMake(3*(zjScreenWidth-3)/3+2, 0, 1, heigt)];
    
    [self setSeparatorViewWithFrame:CGRectMake(0, 0, zjScreenWidth, 1)];
    
    self.buttons = [[NSMutableArray alloc]init];
    NSString *year = [NSString stringWithFormat:@"%zd",self.year];
    NSArray *titleArray = @[@"本月",@"本季度",year];
    
    //本月按钮
    UIButton *MonthButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, upview.width / 3, upview.height)];
    _MonthButton = MonthButton;
    MonthButton.selected = YES;
    [self setButton:MonthButton title:titleArray[0]];
    [MonthButton addTarget:self action:@selector(timeselection:) forControlEvents:UIControlEventTouchUpInside];
    MonthButton.tag = 3;
    [self.buttons addObject:MonthButton];
    [upview addSubview:MonthButton];
    
    //本季度按钮
    UIButton *QuarterButton = [[UIButton alloc]initWithFrame:CGRectMake(upview.width / 3, 0, upview.width / 3, upview.height)];
    _QuarterButton = QuarterButton;
    [self setButton:QuarterButton title:titleArray[1]];
    [QuarterButton addTarget:self action:@selector(timeselection:) forControlEvents:UIControlEventTouchUpInside];
    QuarterButton.tag = 4;
    [self.buttons addObject:QuarterButton];
    [upview addSubview:QuarterButton];

    //年份按钮
    UIButton *YearButton = [[UIButton alloc]initWithFrame:CGRectMake((upview.width / 3) * 2, 0, upview.width /3, upview.height)];
    self.LastButton = YearButton;
    _YearButton = YearButton;
    [YearButton setTitle:titleArray[2] forState:UIControlStateNormal];
    [YearButton setImage:[UIImage imageNamed:@"D-A_arrows"] forState:UIControlStateNormal];
    [YearButton setImage:[UIImage imageNamed:@"D-A_arrows-green"] forState:UIControlStateSelected];
    YearButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [YearButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    [YearButton setTitleColor:ZJColor00D3A3 forState:UIControlStateSelected];
    YearButton.tag = 5;
    [YearButton addTarget:self action:@selector(timeselection:) forControlEvents:UIControlEventTouchUpInside];
    [YearButton zj_changeImageAndTitel];
    [self.buttons addObject:YearButton];
    [upview addSubview:YearButton];
    
   
    [self.view addSubview:upview];
}
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

#pragma mark---------选择颜色高亮
-(void)timeselection:(UIButton*)sender
{
    for (UIButton *btn in self.buttons) {
        btn.selected = NO;
    }
    sender.selected = YES;
    switch (sender.tag) {
        case 3:
        {
            [self.personArray removeAllObjects];
            [self selectYear:self.year andMonth:self.month];
            //创建滚动视图分类
            [self addret];
            //创建圆
            [self addyuan];
            //绘制图形
            [self.piechart reloadData];
             [self TempImageView:@"客户数据统计" andCGRect:CGRectMake(zjScreenWidth / 4.5 , PX2PT(300), PX2PT(638), PX2PT(323))];
        }
            
            break;
        case 4:
        {
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
           
                [self.personArray removeAllObjects];
                NSMutableArray *dataModel = [NSMutableArray array];
                NSMutableArray *pesrsonsArray = [NSMutableArray array];
               [pesrsonsArray removeAllObjects];
                ZJCustomerItemsTableInfo *model = [ZJCustomerItemsTableInfo new];
                NSString *selct = @"SELECT iAutoID,itemString FROM crm_CustomerItems WHERE type='customerSource';";
                [ZJFMdb sqlSelecteData:model selecteString:selct success:^(NSMutableArray *successMsg) {
                    [dataModel addObjectsFromArray:successMsg];
                }];
                for (ZJCustomerItemsTableInfo *zj in dataModel) {
                    [pesrsonsArray addObject:@(zj.iAutoID)];
                }
                for (int i = 0; i < pesrsonsArray.count; i++) {
                    NSInteger ID = [pesrsonsArray[i] integerValue];
                    
                    NSString *pesron = [NSString stringWithFormat:@"SELECT count(iAutoID) AS NUM,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID=%zd) AS NAME FROM crm_CustomerInfo AS b WHERE (cCustomerSource_Tags LIKE '%zd;%%' OR cCustomerSource_Tags LIKE '%%;%zd;%%' OR cCustomerSource_Tags LIKE '%zd;') AND cCreateYear='%zd' AND (  cCreateMonth='%02zd' OR cCreateMonth='%02zd' OR cCreateMonth='%02zd' )  ",ID,ID,ID,ID,self.year,onemoth,twomonth,threemoth];
     
                    NSInteger sum = [ZJFMdb sqlSelecteCountWithString:pesron];
    
                    [self.personArray addObject:@(sum)];
                }
                //创建滚动视图分类
                [self addret];
                //创建圆
                [self addyuan];
                //绘制图形
                [self.piechart reloadData];
              [self TempImageView:@"客户数据统计" andCGRect:CGRectMake(zjScreenWidth /4.5, PX2PT(300), PX2PT(638), PX2PT(323))];
        }
            break;
        case 5:
        {
            
            LTPickerView* pickerView = [[LTPickerView alloc]init];
            self.pickerView = pickerView;
            pickerView.dataSource = @[@"2000",@"2001",@"2002",@"2003",@"2004",@"2005",@"2006",@"2007",@"2008",@"2009",@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030",@"2031",@"2032",@"2033",@"2034",@"2035",@"2036",@"2037",@"2038",@"2039",@"2040",@"2041",@"2042",@"2043",@"2044",@"2045",@"2046",@"2047",@"2048",@"2049",@"2050",@"2051",@"2052",@"2053",@"2054",@"2055",@"2056",@"2057",@"2058",@"2059",@"2060"];//设置要显示的数据
            [pickerView show];//显示
            __weak __typeof(self) weakself=self;
            pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
                NSInteger Year  = [str integerValue];
                
                [weakself.LastButton setTitle:str forState:UIControlStateNormal];
                [weakself.LastButton zj_changeImageAndTitel];
                
                [weakself.personArray removeAllObjects];
                [weakself selectYear:Year andMonth:self.month];
                //创建滚动视图分类
                [weakself addret];
                //创建圆
                [weakself addyuan];
                //绘制图形
                [weakself.piechart reloadData];
                 [self TempImageView:@"客户数据统计" andCGRect:CGRectMake(zjScreenWidth / 4.5 , PX2PT(300), PX2PT(638), PX2PT(323))];
            };
            
            
        }
        default:
            break;
    }
}
#pragma mark---------懒加载颜色数组
- (NSArray *)ColorArray{
    if (!_ColorArray) {
        _ColorArray = @[@"#fca000",@"#fff500",@"#9ec700",@"#009800",@"#009e9f",@"#00a3e7",@"0072b6",@"#000c7a",@"#a1007e",@"#f00082",@"#ef005a",@"#ef0000"];
    }
    return _ColorArray;
}

#pragma mark---------创建分类视图
-(void)addret{
       //创建滚动视图
    UIScrollView *scorView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,self.backView.height + PX2PT(40) + self.imageView.height,zjScreenWidth,zjScreenHeight - PX2PT(146+40 + 100) - 64 - self.backView.height - self.imageView.height)];
    self.ScrollView = scorView;
    [scorView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.ScrollView = scorView;
    scorView.backgroundColor = ZJColorFFFFFF;
    NSInteger count = self.titleArray.count + 1;
    scorView.contentSize = CGSizeMake(zjScreenWidth, PX2PT(64+40)*count);
    scorView.showsHorizontalScrollIndicator = NO;
    scorView.bounces = NO;
    
   
    for (int i = 0; i < self.titleArray.count; i++) {
        //添加视图到滚动视图中
        [scorView addSubview:[self otheraddUpmiviewWithimageName:self.ColorArray[self.i] andTxet:self.titleArray[i] andY:i andSum:[self.personArray[i] unsignedIntegerValue]]];
        
        self.i++;
        
        if (self.i > self.ColorArray.count - 1) {
            self.i = 0;
        }
    }
    self.i = 0;
    [scorView addSubview:[self other]];
    
    
    [self.view addSubview:scorView];
}

- (UIView *)other{
    
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = ZJColorFFFFFF;
    view.frame = CGRectMake(0, PX2PT(64+40)* self.titleArray.count, zjScreenWidth,PX2PT(64+40) );
    //小方块
    UIView* imageview  = [[UIView alloc]initWithFrame:CGRectMake(PX2PT(140),(PX2PT(64+40)-PX2PT(64))/2, 64/3, PX2PT(64))];
    imageview.backgroundColor = [UIColor colorWithHexString:[self.ColorArray lastObject]];
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius = imageview.bounds.size.width/6;
    [view addSubview:imageview];
    // 来源名称
    UILabel *datelabel = [[UILabel alloc]init];
    datelabel.textAlignment = NSTextAlignmentRight;
    [datelabel zj_labelText:@"其它"
                  textColor:ZJColor505050
                   textSize:ZJTextSize45PX];
    datelabel.x = PX2PT(140 + 64 + 40);
    [datelabel zj_adjustWithMin];
    datelabel.centerY = view.height/2;
   
    [view addSubview:datelabel];
    //人数
    UILabel *pesonlabel = [UILabel new];
    pesonlabel.textAlignment = NSTextAlignmentRight;
    [pesonlabel zj_labelText:[NSString stringWithFormat:@"%zd人",[[self.personArray lastObject] integerValue]]
                   textColor:ZJColor848484
                    textSize:ZJTextSize45PX];
    pesonlabel.x = zjScreenWidth - 60;
    [pesonlabel zj_adjustWithMin];
    pesonlabel.centerY = view.height/2;
    
    [view addSubview:pesonlabel];
    
    return view;
}
#pragma mark---------创建点击按钮事件后的小分类视图
-(UIView*)otheraddUpmiviewWithimageName:(NSString*)name andTxet:(NSString*)text andY:(int)y andSum:(NSInteger) sum{
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = ZJColorFFFFFF;
    view.frame = CGRectMake(0, PX2PT(64+40)*y, zjScreenWidth,PX2PT(64+40) );
    //小方块
    UIView* imageview  = [[UIView alloc]initWithFrame:CGRectMake(PX2PT(140),(PX2PT(64+40)-PX2PT(64))/2, 64/3, PX2PT(64))];

    
    imageview.backgroundColor = [UIColor colorWithHexString:name];
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius = imageview.bounds.size.width/6;
    [view addSubview:imageview];
    // 来源名称
    UILabel *datelabel = [[UILabel alloc]init];
    datelabel.textAlignment = NSTextAlignmentRight;
    [datelabel zj_labelText:text
                  textColor:ZJColor505050
                   textSize:ZJTextSize45PX];
    datelabel.x = PX2PT(140 + 64 + 40);
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


//查询数据
- (void)selectYear:(NSInteger) year andMonth:(NSInteger) month{
    
    self.titleArray = [NSMutableArray array];
    self.personArray = [NSMutableArray array];
    NSMutableArray *dataModel = [NSMutableArray array];
    NSMutableArray *pesrsonsArray = [NSMutableArray array];
   
    ZJCustomerItemsTableInfo *model = [ZJCustomerItemsTableInfo new];
    NSString *selct = @"SELECT * FROM crm_CustomerItems WHERE type='customerSource';";
    [ZJFMdb sqlSelecteData:model selecteString:selct success:^(NSMutableArray *successMsg) {
        [dataModel addObjectsFromArray:successMsg];
    }];
    
    for (ZJCustomerItemsTableInfo *zj in dataModel) {
        [self.titleArray addObject:zj.itemString];
        [pesrsonsArray addObject:@(zj.iAutoID)];
    }
    
    for (int i = 0; i < pesrsonsArray.count; i++) {
        NSInteger ID = [pesrsonsArray[i] integerValue];
        NSString *pesron = [NSString stringWithFormat:@"SELECT count(iAutoID) AS NUM,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID=%zd) AS NAME FROM crm_CustomerInfo AS b WHERE (cCustomerSource_Tags LIKE '%zd;%%' OR cCustomerSource_Tags LIKE '%%;%zd;%%' OR cCustomerSource_Tags LIKE '%zd;') AND (cCreateYear='%zd' AND cCreateMonth='%02zd' ) UNION ALL SELECT count(iAutoID) AS NUM,'其它' AS NAME FROM crm_CustomerInfo WHERE cCustomerSource_Tags=''",ID,ID,ID,ID,year,month];
        
        NSInteger sum =   [ZJFMdb sqlSelecteCountWithString:pesron];
        [self.personArray addObject:@(sum)];
    }
    

}


- (void)TempImageView:(NSString *) imageName andCGRect:(CGRect) frame{
    NSInteger sum = 0;
    NSInteger K = 0;
    for (int i = 0; i < self.personArray.count; i++) {
        NSInteger number = [self.self.personArray[i] integerValue];
        if (sum == number) {
            K++;
        }
    }
    if (K < self.self.personArray.count) {
        [self.backImageView removeFromSuperview];
        return;
    }else {
        UIImageView *ImageView = [[UIImageView alloc]init];
        ImageView.frame = frame;
        ImageView.image = [UIImage imageNamed:imageName];
        self.backImageView = ImageView;
        [self.view addSubview:ImageView];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
