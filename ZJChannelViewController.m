//
//  ZJChannelViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/10.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJChannelViewController.h"
#import "SGActionSheet.h"
#import "SGAlertView.h"
#import "ZJCustomerItemsTableInfo.h"

#import "ZJFMdb.h"
//第三方日期
#import "LTPickerView/LTPickerView.h"
@interface ZJChannelViewController ()<SCChartDataSource,SGActionSheetDelegate, SGAlertViewDelegate>
{
    //创建状型图类
    SCChart *chartView;
}
//底部视图
@property (nonatomic,weak)UIView *upview;
//来源最多
@property (nonatomic,strong)NSMutableArray *Sourcearray;
//视图中间改变的label
@property (nonatomic,weak)UILabel *SourceLabel;
//底部视图左边按钮
@property (nonatomic,weak)UIButton *leftButton;
//底部视图右边按钮
@property (nonatomic,weak)UIButton *rightButton;
//滚动视图数组数据
@property (nonatomic,strong)NSArray *otherSourarray;
//控制中间label
@property (nonatomic,weak)UILabel *changelabel;
//第三方日期类
@property (nonatomic,weak)LTPickerView *pickerView;
//当前年份
@property (nonatomic,assign)NSInteger year;
//颜色数组
@property (nonatomic,strong)NSArray *ColorArray;
//年份数组
@property (nonatomic,strong)NSArray *YearArray;
//记录滚动视图
@property (nonatomic,weak)UIScrollView *RankingScrollView;
//来源最多
@property (nonatomic,strong)NSMutableArray *ChannelArray;
//客户数数组
@property (nonatomic,strong)NSMutableArray *NumbersArray;
//匹配点击的关键字数组
@property (nonatomic,strong)NSMutableArray *ThekeywordArray;

@property (nonatomic,strong)NSMutableArray *AllPersonArray;

@property (nonatomic,strong)NSMutableArray *SumsArray;

@property (nonatomic,strong)NSMutableArray *ThebiggestArray;

@property (nonatomic,strong)NSMutableArray *ThesamenumberArray;

@property (nonatomic,strong)NSString *AllName;

@property (nonatomic,weak)SGActionSheet *ActionSheet;
@end

@implementation ZJChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"客户渠道分析";
    self.view.backgroundColor = ZJBackGroundColor;
    
    NSDate *date = [NSDate new];
    NSInteger year = [date zj_getRealTimeForRequire:NSCalendarUnitYear];
    self.year = year;
    //创建底部视图
    [self addUpview];
    //查询全部类型
    [self selectStringYear:year];
    //创建状型图
    [self configUI];
    //创建中间lable
    [self change];
    //中间视图
    [self middleView];
    //添加滚动视图
    [self ALLScorllView];
    
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
#pragma mark---------添加底部视图
-(void)addUpview{
    CGFloat heigt = PX2PT(146);
    UIView *upview = [[UIView alloc]initWithFrame:CGRectMake(0, zjScreenHeight - 64 - heigt, zjScreenWidth, heigt)];
    
    upview.backgroundColor = ZJColorFFFFFF;
    self.upview = upview;
    [self setSeparatorViewWithFrame:CGRectMake((zjScreenWidth-2)/2, 0, 1, heigt)];
    
    [self setSeparatorViewWithFrame:CGRectMake(0, 0, zjScreenWidth, 1)];
   NSString *year = [NSString stringWithFormat:@"%zd",self.year];
    NSArray *titleArray = @[@"全部",year];
    //左边按钮
    UIButton *leftButton = [[UIButton alloc]init];
    self.leftButton = leftButton;
    leftButton.selected = YES;
    leftButton.frame = CGRectMake(0, 0, upview.width/2, upview.height);
    [self setButton:leftButton title:titleArray[0]];
    leftButton.tag = 1;
    [leftButton addTarget:self action:@selector(timeselection:) forControlEvents:UIControlEventTouchUpInside];
    [upview addSubview:leftButton];
    
    //右边按钮
    UIButton *rightButton = [[UIButton alloc]init];
    self.rightButton = rightButton;
    rightButton.frame = CGRectMake(upview.width/2,0, upview.width/2, heigt);
    [self setButton:rightButton title:titleArray[1]];
    rightButton.tag = 2;
    [rightButton addTarget:self action:@selector(timeselection:) forControlEvents:UIControlEventTouchUpInside];
    [upview addSubview:rightButton];

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
//画虚线的方法
-(void)setSeparatorViewWithFrame:(CGRect)frame{
    
    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = ZJColorDCDCDC;
    
    [self.upview addSubview:view];
    
    view.frame = frame;
    
}
#pragma mark---------底部按钮的选中事件
-(void)timeselection:(UIButton*)sender
{
    switch (sender.tag) {
        case 1:
        {
            
            self.leftButton.selected = YES;
            self.rightButton.selected = NO;
            
            NSMutableArray *Title = [NSMutableArray array];
            for (int i = 0; i < self.Sourcearray.count; i++) {
                NSString *titleStr = self.Sourcearray[i];
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
        case 2:
        {
            self.leftButton.selected = NO;
            self.rightButton.selected = YES;
            
            [self.NumbersArray removeAllObjects];
            [self.ChannelArray removeAllObjects];
            LTPickerView* pickerView = [[LTPickerView alloc]init];
            self.pickerView = pickerView;
            pickerView.dataSource = @[@"2000",@"2001",@"2002",@"2003",@"2004",@"2005",@"2006",@"2007",@"2008",@"2009",@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030",@"2031",@"2032",@"2033",@"2034",@"2035",@"2036",@"2037",@"2038",@"2039",@"2040",@"2041",@"2042",@"2043",@"2044",@"2045",@"2046",@"2047",@"2048",@"2049",@"2050",@"2051",@"2052",@"2053",@"2054",@"2055",@"2056",@"2057",@"2058",@"2059",@"2060"];//设置要显示的数据
            [pickerView show];//显示
            
            __weak __typeof(self) weakself=self;
            pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
                [weakself.rightButton setTitle:str forState:UIControlStateNormal];
                [weakself.rightButton zj_changeImageAndTitel];
                NSString *ButtonString = self.rightButton.titleLabel.text;
                NSString *yearString = [NSString stringWithFormat:@"%@年每月渠道排行",ButtonString];
                [weakself.changelabel zj_labelText:yearString textColor:ZJColorFFFFFF textSize:ZJTextSize45PX];
                NSString *String = str;
                self.year = [String integerValue];
                [weakself selectStringYear:[String integerValue]];
                //创建状型图
                [weakself configUI];
                //添加滚动视图
                [weakself ALLScorllView];
                
            };
    
            
            
        }
            
            
            
            break;
    
        default:
            
            
            break;
    }
}
//代理方法来显示点击的行数
- (void)SGActionSheet:(SGActionSheet *)actionSheet didSelectRowAtIndexPath:(NSInteger)indexPath{
    
    [self.leftButton setTitle:self.Sourcearray[indexPath] forState:UIControlStateNormal];
    [self.leftButton zj_changeImageAndTitel];
    
    if (indexPath == 0) {
        self.SourceLabel.text = @"来源最多";
        [self selectStringYear:self.year];
        [self ALLScorllView];

    }else{
        self.SourceLabel.text = self.Sourcearray[indexPath];
        
        if (indexPath < self.ThekeywordArray.count) {
            [self SelectThekeywordIndex:indexPath];
        }
        
        //添加滚动视图
        [self addret];
    }
    //创建状型图
    [self configUI];
}

//全部数据统计的滚动视图

-(void)ALLScorllView{
    
    //创建滚动视图
    UIScrollView *scorView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,self.view.bounds.origin.y + chartView.height + PX2PT(80+135) + PX2PT(80)/3,zjScreenWidth,zjScreenHeight - PX2PT(146+80+128+40 + 100) - 64 - chartView.height )];
    [self.RankingScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.RankingScrollView = scorView;
    scorView.backgroundColor = ZJColorFFFFFF;
    scorView.contentSize = CGSizeMake(zjScreenWidth, PX2PT(64+40)*self.YearArray.count + PX2PT(20));
    scorView.showsHorizontalScrollIndicator = NO;
    scorView.bounces = NO;
    for (int i = 0; i < self.YearArray.count; i++) {
        [self.RankingScrollView addSubview:[self OtherScorViewWithimageName:self.ColorArray[i] andText:self.YearArray[i] andY:i andThebiggestArray:[self.NumbersArray[i] integerValue] andThesamenumberArray:self.ChannelArray[i]]];
    }
    [self.view addSubview:scorView];
}


- (UIView *)OtherScorViewWithimageName:(NSString*)name andText:(NSString*)text andY:(int)y andThebiggestArray:(NSInteger )Thebiggest andThesamenumberArray:(NSMutableArray *)TheMenNumber {
    
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = ZJColorFFFFFF;
    view.frame = CGRectMake(0, PX2PT(64+40)*(y+0.3), zjScreenWidth,PX2PT(64+40) );
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
        [sourceName appendFormat:@"%@,",name];
    }
    if ([sourceName isEqualToString:@""]) {
        [sourcelabel zj_labelText:@"无" textColor:ZJColor848484 textSize:ZJTextSize45PX];
    }else {
        
        [sourceName deleteCharactersInRange:NSMakeRange(sourceName.length- 1, 1)];
        
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
    
    NSString *str = NSLocalizedString(self.AllName, nil);;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"来源最多" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
  
    [alert addAction:Cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

//根据关键字从数据库取数据
- (void)SelectThekeywordIndex:(NSInteger)index{
    NSInteger sum = [self.ThekeywordArray[index] integerValue];
        [self.NumbersArray removeAllObjects];
        [self.ChannelArray removeAllObjects];
        NSMutableArray *AllArray = [NSMutableArray array];
            for (int j = 1; j < 13; j++) {
               if  (index < self.ThekeywordArray.count){
                NSString *pesrson = [NSString stringWithFormat:@"SELECT * FROM (SELECT  '%d' as MONTH,count(iAutoID) AS NUM,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID= %zd) AS NAME  FROM crm_CustomerInfo WHERE (cCustomerSource_Tags LIKE '%zd;%%' OR cCustomerSource_Tags LIKE '%%;%zd;%%' OR cCustomerSource_Tags LIKE '%zd;') AND cCreateYear='%zd' AND cCreateMonth= '%02d' ) ORDER BY NUM DESC LIMIT 1",j,sum -1,sum -1,sum -1,sum -1,self.year,j];
                  
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

//创建桩型图
- (void)configUI {
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    chartView.backgroundColor = ZJColorFFFFFF;
    chartView = [[SCChart alloc] initwithSCChartDataFrame:CGRectMake(0,self.view.bounds.origin.y + PX2PT(80)/3, zjScreenWidth,200)
                                               withSource:self
                                                withStyle:SCChartBarStyle];

    [chartView showInView:self.view];
}

//状型图数据
- (NSArray *)getXTitles:(int)num {
    NSMutableArray *xTitles = [NSMutableArray array];
    NSArray *arrdate = @[@"一月",@"二月",@"三月",@"四月",
                         @"五月",@"六月",@"七月",@"八月",@"九月",
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
    for (NSString *colorString in self.ColorArray) {
        UIColor *Color = [UIColor colorWithHexString:colorString];
        [ColorArray addObject:Color];
    }
    return ColorArray;
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
    label.y = chartView.height + 10;
    [self.view addSubview:label];
}
#pragma mark - 三等分
-(void)middleView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 210 + PX2PT(80), zjScreenWidth, PX2PT(128))];
    view.backgroundColor = ZJColorFFFFFF;
    //虚线
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
                            CGRectMake(zjScreenWidth/3, 0,
                            (zjScreenWidth - 2) / 3 ,view.height)];
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

//懒加载年份
- (NSArray *)ColorArray{
    if (!_ColorArray) {
        _ColorArray = @[@"#fca000",@"#fff500",@"#9ec700",@"#009800",@"#009e9f",@"#00a3e7",@"0072b6",@"#000c7a",@"#a1007e",@"#f00082",@"#ef005a",@"#ef0000"];
    }
    return _ColorArray;
}

//懒加载月份
- (NSArray *)YearArray{
    if (!_YearArray) {
        _YearArray = @[@"一月份",@"二月份",@"三月份",@"四月份",@"五月份",@"六月份",@"七月份",@"八月份",@"九月份",@"十月份",@"十一月份",@"十二月份"];
    }
    return _YearArray;
    
}

#pragma mark---------创建分类视图
-(void)addret{
    //创建滚动视图
    UIScrollView *scorView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,self.view.bounds.origin.y + chartView.height + PX2PT(80+135) + PX2PT(80)/3,zjScreenWidth,zjScreenHeight - PX2PT(146+80+128+40 + 100) - 64 - chartView.height )];
    [self.RankingScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.RankingScrollView = scorView;

    scorView.backgroundColor = ZJColorFFFFFF;
    scorView.contentSize = CGSizeMake(zjScreenWidth, PX2PT(64+40)*self.YearArray.count + PX2PT(20));
    scorView.showsHorizontalScrollIndicator = NO;
    scorView.bounces = NO;
    for (int i = 0; i < self.YearArray.count; i++) {
        [self.RankingScrollView addSubview:[self otheraddUpmiviewWithimageName:self.ColorArray[i] andText:self.YearArray[i] andSource:self.ChannelArray[i] andY:i andSums:[self.NumbersArray[i] integerValue]]];
    }
    
    
    
    
    [self.view addSubview:scorView];
}
#pragma mark---------创建点击按钮事件后的小分类视图
-(UIView *)otheraddUpmiviewWithimageName:(NSString*)name andText:(NSString*)text andSource:(NSString *)source  andY:(int)y andSums:(NSInteger) sums{
   
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = ZJColorFFFFFF;
    view.frame = CGRectMake(0, PX2PT(64+40)*(y+0.3), zjScreenWidth,PX2PT(64+40) );
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
    
    return view;
}


//查询全部类型
- (void)selectStringYear:(NSInteger) year{
    self.Sourcearray = [NSMutableArray array];
    [self.Sourcearray removeAllObjects];
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
    NSString *selct = @"SELECT * FROM crm_CustomerItems WHERE type='customerSource';";
    [ZJFMdb sqlSelecteData:model selecteString:selct success:^(NSMutableArray *successMsg) {
        [dataModel addObjectsFromArray:successMsg];
    }];
     NSString *str = @"全部";
    [self.Sourcearray addObject:str];
    for (ZJCustomerItemsTableInfo *zj in dataModel) {
        [self.Sourcearray addObject:zj.itemString];
        [pesrsonsArray addObject:@(zj.iAutoID)];
    }
   
    
    for (int j = 1; j <= 12; j++){
        NSMutableString *sql = [[NSMutableString alloc]initWithString:@"SELECT * FROM ("];
         for (int i = 0; i < pesrsonsArray.count; i++) {
            NSInteger ID = [pesrsonsArray[i] integerValue];
              NSMutableString *person = [NSMutableString stringWithFormat:@"SELECT  '%d' as MONTH,count(iAutoID) AS NUM,(SELECT itemString FROM crm_CustomerItems WHERE iAutoID= %zd) AS NAME  FROM crm_CustomerInfo WHERE (cCustomerSource_Tags LIKE '%zd;%%' OR cCustomerSource_Tags LIKE '%%;%zd;%%' OR cCustomerSource_Tags LIKE '%zd;') AND cCreateYear='%zd' AND cCreateMonth= '%02d' " ,j,ID,ID,ID,ID,year,j];
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
        
        NSInteger k = 0;
        if ([AllArrayTemp[0] integerValue] != 0) {
            [AllArrayTemp3 addObject: AllArrayTemp2[0]];
        }
        for ( int i = 1; i < AllArrayTemp.count; i++) {
            
            if( [AllArrayTemp[0] integerValue]  != 0 )
            {
                if ( [AllArrayTemp[0] integerValue] == [AllArrayTemp[i] integerValue] )
                {
                    k++;
                   
                    
                    [AllArrayTemp3 addObject: AllArrayTemp2[i]];
            
                }
            }
        }
         [self.ThesamenumberArray addObject:@(k)];
        
        [self.ChannelArray addObject:AllArrayTemp3];
        
        
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
