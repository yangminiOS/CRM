//
//  ZJSpeedUpViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/9.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJSpeedUpViewController.h"
#import "SGActionSheet.h"
#import "SGAlertView.h"
//第三方日期
#import "LTPickerView/LTPickerView.h"
//第三方折线图
#import "SCChart.h"
//颜色分类
#import "UIColor+K.h"

#import "ZJFMdb.h"
#import <FMDB.h>
#import "ZJcustomerTableInfo.h"
#import "ZJCustomerItemsTableInfo.h"
@interface ZJSpeedUpViewController ()<SCChartDataSource,SGActionSheetDelegate, SGAlertViewDelegate>
{
    //三方类
    SCChart *chartView;
    NSInteger _Year;
}
//底部视图
@property (nonatomic,weak)UIView *upview;
//底部按钮数组
@property (nonatomic,strong)NSMutableArray *buttons;
//底部左边按钮
@property (nonatomic,weak)UIButton *leftButton;
//底部后边按钮
@property (nonatomic,weak)UIButton *rigthtButton;

//人数数组
@property (nonatomic,strong)NSMutableArray *personArray;

@property (nonatomic,strong)NSMutableArray *dataModel;
//第三方日期类
@property (nonatomic,weak)LTPickerView *pickerView;
//客户信息数据类
@property (nonatomic,strong)NSMutableArray *array;

@property (nonatomic,strong)NSString *str;

@property (nonatomic,copy)NSMutableArray *sumpersonArray;

@property (nonatomic,weak)SGActionSheet *ActionSheet;
@end

@implementation ZJSpeedUpViewController


//创建折线图
- (void)configUI {
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    chartView.backgroundColor = ZJColorFFFFFF;
    chartView = [[SCChart alloc] initwithSCChartDataFrame:CGRectMake(0,self.view.bounds.origin.y + PX2PT(80)/3, zjScreenWidth - 4,200)
                                               withSource:self
                                                withStyle:SCChartLineStyle];
    [chartView showInView:self.view];
}

//折线图数据
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
        
        CGFloat num = [self.sumpersonArray[i] floatValue];
        
        NSString *str = [NSString stringWithFormat:@"%f",num];
        
        [ary addObject:str];
    }
    return @[ary];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户增速分析";
    self.view.backgroundColor = ZJBackGroundColor;
    NSDate *date = [NSDate new];
    NSInteger year = [date zj_getRealTimeForRequire:NSCalendarUnitYear];
    _Year = year;
    NSString *str = [NSString stringWithFormat:@"%zd",year];
    self.rigthtButton.titleLabel.text = str;
    NSInteger month = [date zj_getRealTimeForRequire:NSCalendarUnitMonth];
  
    [self selectYear:year andMonth:month];
    
    //添加底部按钮
    [self addUpview];
    [self ThequerySum:0 andYear:year];
    
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

- (void)ThequerySum:(NSInteger )number andYear:(NSInteger) year{
    
    NSString *sum = [NSString stringWithFormat:@"SELECT  cCreateMonth,COUNT(iAutoID) AS NUM  FROM  crm_CustomerInfo WHERE  cCreateYear='%zd' AND  (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE  '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%zd;') GROUP  BY cCreateMonth",year,number + 1,number+ 1,number + 1];
    
    self.sumpersonArray = [ZJFMdb sqlMothSums:sum];
    
    //创建折线图
    [self configUI];
    //创建滚动视图
    [self addret];
}

#pragma mark - @optional
//颜色数组
- (NSArray *)SCChart_ColorArray:(SCChart *)chart {
    return @[SCBlue];
}

#pragma mark 折线图专享功能
//标记数值区域
- (CGRange)SCChartMarkRangeInLineChart:(SCChart *)chart {
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)SCChart:(SCChart *)chart ShowHorizonLineAtIndex:(NSInteger)index {
    return YES;
}

//判断显示最大最小值
- (BOOL)SCChart:(SCChart *)chart ShowMaxMinAtIndex:(NSInteger)index {
    return NO;
}

#pragma mark---------添加视图
-(void)addUpview{
    CGFloat heigt = PX2PT(146);
    UIView *upview = [[UIView alloc]initWithFrame:CGRectMake(0, zjScreenHeight - 64 - heigt, zjScreenWidth, heigt)];
    
    upview.backgroundColor = ZJColorFFFFFF;
    self.upview = upview;
    [self setSeparatorViewWithFrame:CGRectMake((zjScreenWidth-2)/2, 0, 1, heigt)];
    
    [self setSeparatorViewWithFrame:CGRectMake(2*(zjScreenWidth-2)/2+1, 0, 1, heigt)];
    
    [self setSeparatorViewWithFrame:CGRectMake(0, 0, zjScreenWidth, 1)];
    
    NSString *year = [NSString stringWithFormat:@"%zd",_Year];
    NSArray *titleArray = @[@"全部",year];
    //左边按钮
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton = leftbutton;
    leftbutton.frame = CGRectMake(0, 0, upview.width/2, upview.height);
    leftbutton.selected = YES;
    [self setButton:leftbutton title:titleArray[0]];
    
    [leftbutton addTarget:self action:@selector(clickleftButton:) forControlEvents:UIControlEventTouchUpInside];
    //右边按钮
    UIButton * rightButton = [UIButton new];
    self.rigthtButton = rightButton;
    rightButton.frame = CGRectMake(upview.width/2,0, upview.width/2, heigt);
    [self setButton:rightButton title:titleArray[1]];
    [rightButton addTarget:self action:@selector(clickrightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
   

     [self.view addSubview:upview];

    
}
//左边按钮事件
- (void)clickleftButton:(UIButton *)sender{
    
    sender.selected = YES;

    self.rigthtButton.selected = NO;
//    NSMutableArray *Title = [NSMutableArray array];
//    for (int i = 0; i < self.array.count; i++) {
//        NSString *titleStr = self.array[i];
//        BOOL isFirst  = [self isChineseFirst:titleStr];
//        if (isFirst) {
//            [Title addObject:titleStr];
//        }else {
//            BOOL isA = [self MatchLetter:titleStr];
//            if (isA) {
//                [Title addObject:titleStr];
//            }
//        }
//    }
    

    SGActionSheet *sheet = [SGActionSheet actionSheetWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" otherButtonTitleArray:self.array];
    self.ActionSheet = sheet;
    sheet.messageTextFont = [UIFont systemFontOfSize:ZJTextSize55PX];
    sheet.messageTextColor = [UIColor redColor];
    sheet.otherTitleFont = [UIFont systemFontOfSize:ZJTextSize45PX];
    sheet.cancelButtonTitleFont = [UIFont systemFontOfSize:ZJTextSize55PX];
    [sheet show];
    
    
    
}
//右边按钮事件
- (void)clickrightButton:(UIButton *)sender{
    
    sender.selected = YES;
    
    self.leftButton.selected = NO;
    LTPickerView* pickerView = [[LTPickerView alloc]init];
    self.pickerView = pickerView;
    pickerView.dataSource = @[@"2000",@"2001",@"2002",@"2003",@"2004",@"2005",@"2006",@"2007",@"2008",@"2009",@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030",@"2031",@"2032",@"2033",@"2034",@"2035",@"2036",@"2037",@"2038",@"2039",@"2040",@"2041",@"2042",@"2043",@"2044",@"2045",@"2046",@"2047",@"2048",@"2049",@"2050",@"2051",@"2052",@"2053",@"2054",@"2055",@"2056",@"2057",@"2058",@"2059",@"2060"];//设置要显示的数据
    [pickerView show];//显示
     __weak __typeof(self) weakself=self;
    pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
        [weakself.rigthtButton setTitle:str forState:UIControlStateNormal];
        [weakself.rigthtButton zj_changeImageAndTitel];
        
        [weakself ThequerySum:sum andYear:[str integerValue]];
        
    };
}
static NSInteger sum = 0;
//代理方法来显示点击的行数
- (void)SGActionSheet:(SGActionSheet *)actionSheet didSelectRowAtIndexPath:(NSInteger)indexPath{
    sum = indexPath;
    [self.leftButton setTitle:self.array[indexPath] forState:UIControlStateNormal];
    [self.leftButton zj_changeImageAndTitel];
    [self ThequerySum:indexPath andYear:_Year];
    
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




#pragma mark---------创建分类视图
-(void)addret{
    NSArray* titleArray = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
    NSArray* colorArray = @[@"#fca000",@"#fff500",@"#9ec700",@"#009800",@"#009e9f",@"#00a3e7",@"0072b6",@"#000c7a",@"#a1007e",@"#f00082",@"#ef005a",@"#ef0000"];
    //创建滚动视图
    UIScrollView *scorView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,self.view.bounds.origin.y + PX2PT(80)/3 + chartView.height,zjScreenWidth,zjScreenHeight  - 64 - chartView.height - PX2PT(146 + 130))];
   
    scorView.backgroundColor = ZJColorFFFFFF;
    scorView.contentSize = CGSizeMake(zjScreenWidth, PX2PT(64+40)*titleArray.count );
    scorView.showsHorizontalScrollIndicator = NO;
    scorView.bounces = NO;
    
 
    for (int i = 0; i < titleArray.count; i++) {
        //添加视图到滚动视图中
        [scorView addSubview:[self otheraddUpmiviewWithimageName:colorArray[i] andTxet:titleArray[i] andY:i andSum:[self.sumpersonArray[i] intValue]]];
    }
    [self.view addSubview:scorView];
    
    
  
    
}


#pragma mark---------创建点击按钮事件后的小分类视图
-(UIView*)otheraddUpmiviewWithimageName:(NSString*)name andTxet:(NSString*)text andY:(int)y andSum:(int)sum{
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = ZJColorFFFFFF;
    view.frame = CGRectMake(0, PX2PT(64+40)*y, zjScreenWidth,PX2PT(64+40) );
    //小方块
    UIView* imageview  = [[UIView alloc]initWithFrame:CGRectMake(PX2PT(140),(PX2PT(64+40)-PX2PT(64))/2, 64/3, PX2PT(64))];
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
    datelabel.x = PX2PT(140 + 64 + 40);
    [datelabel zj_adjustWithMin];
    datelabel.centerY = view.height/2;
    
    [view addSubview:datelabel];
    
    //人数
    UILabel *pesonlabel = [UILabel new];
    pesonlabel.textAlignment = NSTextAlignmentRight;
    [pesonlabel zj_labelText:[NSString stringWithFormat:@"%zd",sum]                  textColor:ZJColor848484
                   textSize:ZJTextSize45PX];
    pesonlabel.x = zjScreenWidth - 60;
    [pesonlabel zj_adjustWithMin];
    pesonlabel.centerY = view.height/2;
    
    [view addSubview:pesonlabel];
    
    
    
    return view;
}


-(void)setSeparatorViewWithFrame:(CGRect)frame{
    
    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = ZJColorDCDCDC;
    
    [self.upview addSubview:view];
    
    view.frame = frame;
    
}

//查询数据
- (void)selectYear:(NSInteger) year andMonth:(NSInteger) month{
    
    self.array = [NSMutableArray array];
    NSMutableArray *dataModel = [NSMutableArray array];
    NSMutableArray *pesrsonsArray = [NSMutableArray array];
    self.personArray = pesrsonsArray;
    ZJCustomerItemsTableInfo *model = [ZJCustomerItemsTableInfo new];
    NSString *selct = @"SELECT * FROM crm_CustomerItems WHERE type='customerState';";
    NSString *all = @"全部";
    [self.array addObject:all];
    [ZJFMdb sqlSelecteData:model selecteString:selct success:^(NSMutableArray *successMsg) {
        [dataModel addObjectsFromArray:successMsg];
    }];
    for (ZJCustomerItemsTableInfo *zj in dataModel) {
        [self.array addObject:zj.itemString];
        [pesrsonsArray addObject:@(zj.iAutoID)];
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
