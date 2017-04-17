//
//  ZJAddGoaldViewController.m
//  CRM
//
//  Created by mini on 16/10/22.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJAddGoaldViewController.h"
#import "ZJDatePickView.h"
#import "NSDate+Category.h"
#import "ZJGoalTableInfo.h"//数据库模型
#import "ZJFMdb.h"//数据库操作
#import "ZJYearAndMonthView.h"



@interface ZJAddGoaldViewController ()<ZJDatePickViewDelegate,ZJYearAndMonthViewDelegate,UITextFieldDelegate>

//目标类型Button
@property(nonatomic,weak) UIButton *typeButton;
//**时间节点Button**//
@property(nonatomic,weak) UIButton *timeButton;

//**目标类型tf**//
@property(nonatomic,weak) UITextField *typeTF;
//**时间节点**//
@property(nonatomic,weak) UITextField *timeTF;
//**目标额度**//
@property(nonatomic,weak) UITextField *countTF;

//**时间选择器**//
@property(nonatomic,strong) ZJYearAndMonthView *dateView;
//**年份**//
@property(nonatomic,copy)NSString *year;

//**判断日期选择器是否已经加载**//
@property(nonatomic,assign)BOOL isAdd;
//**季节的数组**//
@property(nonatomic,strong) NSMutableArray *seasonArray;

//**存放季节**//
@property(nonatomic,copy) NSString *seasonIndex;

@end

@implementation ZJAddGoaldViewController

-(ZJYearAndMonthView *)dateView{
    if (!_dateView) {
        
        _dateView = [[ZJYearAndMonthView alloc]initWithFrame:CGRectMake(0, self.view.height, self.view.width, 0)];
        _dateView.delegate = self;
        [self.view addSubview:_dateView];
        
    }
    return _dateView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZJBackGroundColor;
    
    //导航
    //
    if (_addGoaldModel == ZJAddGoaldModelEdit) {
        
        self.goaldTypeString = self.editDataModel.type;
        
        self.countString = [NSString stringWithFormat:@"%zd",self.editDataModel.goalCount];
        self.iAutoID = self.editDataModel.iAutoID;
        
        self.year = self.editDataModel.year;
        
        if ([self.editDataModel.type isEqualToString:@"季度目标"]) {
            
            self.seasonIndex = self.editDataModel.tag;
            
            NSString *seasonstring = [self.editDataModel.tag zj_getSeasonFromIndex];
            
            self.dateString = [NSString stringWithFormat:@"%@年%@",self.editDataModel.year,seasonstring];
            
        }else{
            
            self.dateString = self.editDataModel.tag;
        }
        
        
    }
    
    
    [self setupUI];
    
    [self setupNavi];
    
    self.seasonArray = [self seasonGoalAlertTitle];
}
#pragma mark   设置导航
-(void)setupNavi{
    
    
    if (_addGoaldModel == ZJAddGoaldModelEdit) {
        
        [self.countTF becomeFirstResponder];
        
        self.navigationItem.title = @"修改目标";
        
    }else{
        self.navigationItem.title = @"新增目标";
        
    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem zj_BarButtonItemWithTitle:@"完成" titleColor:ZJColorFFFFFF target:self action:@selector(clickDone)];
}
#pragma mark   点击导航上的完成
-(void)clickDone{
    
    [self ZJYearAndMonthView:_dateView isChoose:NO];
    //判断该时间节点是否存在
    
    ZJGoalTableInfo *model = [[ZJGoalTableInfo alloc]init];
    
    if (self.addGoaldModel == ZJAddGoaldModelWhite) {
        
        NSString *select = [NSString stringWithFormat:@"select * from %@ where year='%@' and tag='%@'",ZJGoalTableName,self.year,self.timeTF.text];
        
        if ([self.typeTF.text isEqualToString:@"季度目标"]) {
            
            select = [NSString stringWithFormat:@"select * from %@ where year='%@' and tag='%@'",ZJGoalTableName,self.year,_seasonIndex];
            
        }
        
        [ZJFMdb sqlSelecteData:model selecteString:select success:^(NSMutableArray *successMsg) {
            if (successMsg.count>0) {
                [self autorAlertViewWithMsg:@"该目标已存在，请勿重复设定"];
                return;
            }else{//***************插入数据
                //存储设置
                model.type = self.typeTF.text;//类型
                
                NSInteger  money =self.countTF.text.integerValue;
                if (self.countTF.text.length==0 || money<1) {
                    
                    [self autorAlertViewWithMsg:@"目标金额必须大于0"];
                    
                    return;
                    
                }
                model.goalCount = money;//金额
                if ([self.typeTF.text isEqualToString:@"季度目标"]) {
                    
                    model.tag = self.seasonIndex;
                    
                }else{
                    
                    model.tag = self.timeTF.text;//时间
                }
                model.year =self.year;//年份
                [ZJFMdb sqlInsertData:model tableName:ZJGoalTableName];//存储
                
            }
            
        }];
        
    }else if (self.addGoaldModel == ZJAddGoaldModelEdit){//更新数据
        model.type = self.editDataModel.type;//类型
        NSInteger  money =self.countTF.text.integerValue;
        if (self.countTF.text.length==0 || money<1) {
            
            [self autorAlertViewWithMsg:@"目标金额必须大于0"];
            
            return;
            
        }
        model.goalCount = money;//金额
        
        model.tag = self.editDataModel.tag;
        
        model.year =self.editDataModel.year;//年份
        model.iAutoID = self.iAutoID;//唯一标示
        [ZJFMdb sqlUpdata:model tableName:ZJGoalTableName];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark   内容
-(void)setupUI{
    NSDate *date = [NSDate date];
    self.seasonIndex = [NSString stringWithFormat:@"%zd",[date zj_getSeadonFromDate]];
    //设置当前年份
    self.year = [NSString stringWithFormat:@"%zd",[date zj_getRealTimeForRequire:NSCalendarUnitYear]];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:tap];
    
    
    UIView *typeView = [[UIView alloc]init];
    [self.view addSubview:typeView];
    typeView.frame = CGRectMake(0, 0, self.view.width, PX2PT(128));
    [self addView:typeView labelTitle:@"目标类型" textFiledText:@"" ViewTag:1];
    
    UIView *timeView = [[UIView alloc]init];
    [self.view addSubview:timeView];
    timeView.frame = CGRectMake(0, PX2PT(128), self.view.width, PX2PT(128));
    [self addView:timeView labelTitle:@"时间节点" textFiledText:@"" ViewTag:2];
    
    UIView *countView = [[UIView alloc]init];
    [self.view addSubview:countView];
    countView.frame = CGRectMake(0, 2*PX2PT(128), self.view.width, PX2PT(128));
    [self addView:countView labelTitle:@"目标额度" textFiledText:@"" ViewTag:3];
    
    if (self.addGoaldModel ==ZJAddGoaldModelEdit ) {
        
        self.typeButton.enabled = NO;
        self.timeButton.enabled = NO;
    }
}

#pragma mark   封装View
-(void)addView:(UIView *)view labelTitle:(NSString *)title textFiledText:(NSString *)text ViewTag:(NSInteger)tag{
    
    view.backgroundColor = ZJColorFFFFFF;
    //标题
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    label.text = title;
    label.textColor = ZJColor00D3A3;
    label.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [label zj_adjustWithMin];
    label.x = ZJmargin40;
    label.y = PX2PT(42);
    
    //右边内容
    UIButton *button = [[UIButton alloc]init];
    button.tag = tag;
    [view addSubview:button];
    if (tag ==3) {
        button.x = self.view.width - ZJmargin40 - 21;
        button.width = 21;
        button.height = PX2PT(128);
        [button setTitle:@"万" forState:UIControlStateNormal];
        [button setTitleColor:ZJColorDCDCDC forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.enabled = NO;
        
    }else{
        button.frame = CGRectMake(0, 0, view.width, view.height - 1);
        [button setImage:[UIImage imageNamed:@"closed"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"unfold"] forState:UIControlStateSelected];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, ZJmargin40);
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //内容
    UITextField *textF = [[UITextField alloc]init];
    [view addSubview:textF];
    textF.textColor = ZJColorDCDCDC;
    textF.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    textF.x = CGRectGetMaxX(label.frame)+PX2PT(100);
    textF.y = PX2PT(42);
    textF.width = self.view.width - ZJmargin40 -21 -textF.x;
    textF.height = 20;
    UIView *Sview = [[UIView alloc]init];
    
    [view addSubview:Sview];
    Sview.backgroundColor = ZJColorDCDCDC;
    Sview.frame = CGRectMake(0, view.height-1, view.width, 1);
    
    if (tag ==1) {
        self.typeTF = textF;
        self.typeButton = button;
        textF.enabled = NO;
        textF.text = self.goaldTypeString;
    }else if (tag == 2){
        self.timeTF = textF;
        textF.text = self.dateString;
        self.timeButton = button;
        textF.enabled = NO;
    }else{
        self.countTF = textF;
        textF.delegate = self;
        textF.text = self.countString;
        textF.clearButtonMode =UITextFieldViewModeWhileEditing;
        textF.keyboardType = UIKeyboardTypeDecimalPad;
        
    }
    
    
}

-(void)clickButton:(UIButton *)button{
    //设置年份
    self.year = [NSString stringWithFormat:@"%zd",[[[NSDate alloc]init] zj_getRealTimeForRequire:NSCalendarUnitYear]];
    
    [self.countTF resignFirstResponder];
    button.selected = !button.selected;
    if (button.tag ==1) {
        
        NSArray *titleArray = @[@"月度目标",@"季度目标",@"年度目标"];
        [self alertViewWithArray:titleArray viewTag:button.tag];
        
    }else if (button.tag ==2){
        
        if ([self.typeTF.text isEqualToString:@"季度目标"]) {
            [self alertViewWithArray:self.seasonArray viewTag:button.tag];
            
        }else{
            
            if (_isAdd){
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.dateView.frame = CGRectMake(0, self.view.height, self.view.width, 0);
                }];
                self.timeButton.selected = NO;
                _isAdd = NO;
                
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.dateView.frame = CGRectMake(0, self.view.height-(40+zjScreenHeight/3.0), self.view.width, 40+zjScreenHeight/3.0);
                    
                }];
                _isAdd = YES;
            }
            
            
        }
        
    }
    
}
#pragma mark   ZJDatePickViewDelegate 代理方法



-(void) ZJYearAndMonthView:(ZJYearAndMonthView *)view date:(NSDate*)date
{
    if ([self.typeTF.text isEqualToString:@"月度目标"]){
        
        self.timeTF.text = [date zj_getStringFromDatWithFormatter:@"yyyy年MM月"];
        
    }else if ([self.typeTF.text isEqualToString:@"年度目标"]){
        
        self.timeTF.text = [date zj_getStringFromDatWithFormatter:@"yyyy年"];
    }
    self.year = [NSString stringWithFormat:@"%zd",[date zj_getRealTimeForRequire:NSCalendarUnitYear]];
    
    
}
-(void)ZJYearAndMonthView:(ZJYearAndMonthView *)view isChoose:(BOOL)choose{
    
    //    [view removeFromSuperview];
    //
    //    view = nil;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.dateView.frame = CGRectMake(0, self.view.height, self.view.width, 0);
    }];
    self.timeButton.selected = NO;
    _isAdd = NO;
}


#pragma mark   封装弹框
-(void)alertViewWithArray:(NSArray *)titleArray viewTag:(NSUInteger)tag{
    
    UIAlertController *goalAler = [UIAlertController alertControllerWithTitle:nil
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSInteger i = 0; i<titleArray.count; i++) {
        
        UIAlertAction *Action = [UIAlertAction actionWithTitle:titleArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (tag == 1) {
                
                self.typeButton.selected = NO;
                self.typeTF.text = titleArray[i];
                [self goaldTypeChangeWithString:titleArray[i]];
            }else if (tag ==2){
                self.timeButton.selected = NO;
                NSDate *date = [NSDate date];
                NSString *year = [date zj_getStringFromDatWithFormatter:@"yyyy年"];
                //判断是否要加上当前年
                NSString *string = titleArray[i];
                
                if (string.length<4) {
                    
                    if (i==1) {
                        
                        self.seasonIndex = [NSString stringWithFormat:@"%zd",[[NSDate new]zj_getSeadonFromDate]+1];
                    }else{
                        self.seasonIndex = [NSString stringWithFormat:@"%zd",[[NSDate new]zj_getSeadonFromDate]];
                    }
                    self.timeTF.text = [year stringByAppendingString:titleArray[i]];
                    self.year = [NSString stringWithFormat:@"%zd",[date zj_getRealTimeForRequire:NSCalendarUnitYear]];
                    
                    
                }else{
                    self.timeTF.text = string;
                    
                    self.seasonIndex = @"1";
                    NSString *yearstring = [date zj_getDateAfterYears:1];
                    
                    NSDate *yearDate = [yearstring zj_getDateFromStringWithFormatter:@"yyyy-MM-dd"];
                    
                    self.year = [NSString stringWithFormat:@"%zd",[yearDate zj_getRealTimeForRequire:NSCalendarUnitYear]];
                    
                }
                
                
            }
        }];
        [goalAler addAction:Action];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.typeButton.selected = NO;
        self.timeButton.selected = NO;
    }];
    
    [goalAler addAction:cancel];
    
    [self presentViewController:goalAler animated:YES completion:nil];
    
}
#pragma mark   目标类型发生改变时  时间节点发生相应的改变
-(void)goaldTypeChangeWithString:(NSString *)string{
    
    if ([string isEqualToString:@"月度目标"]) {
        
        self.timeTF.text = [[[NSDate alloc]init] zj_getStringFromDatWithFormatter:@"yyyy年MM月"];
        self.countTF.text = @"200";
        
    }else if ([string isEqualToString:@"季度目标"]){
        NSInteger season = [[[NSDate alloc]init] zj_getSeadonFromDate];
        
        self.seasonIndex = [NSString stringWithFormat:@"%zd",season];
        NSString  *seasonS = [self.seasonIndex zj_getSeasonFromIndex];
        
        NSString *year = [[[NSDate alloc]init] zj_getStringFromDatWithFormatter:@"yyyy年"];
        self.timeTF.text = [year stringByAppendingString:seasonS];
        
        self.countTF.text = @"600";
        
    }else{
        
        self.timeTF.text = [[[NSDate alloc]init] zj_getStringFromDatWithFormatter:@"yyyy年"];
        self.countTF.text = @"2400";
        
    }
}
#pragma mark   返回季节目标数组
-(NSMutableArray *)seasonGoalAlertTitle{
    NSDate *nowDate = [NSDate new];
    NSInteger month = [nowDate zj_getRealTimeForRequire:NSCalendarUnitMonth];
    NSMutableArray *array= [NSMutableArray array];
    
    NSString *one = nil;
    NSString *two = nil;
    if (month<=3) {
        one = @"一季度";
        two = @"二季度";
        
    }else if (month>3&&month<=6){
        one = @"二季度";
        two = @"三季度";
    }else if (month>6&&month<=9){
        one = @"三季度";
        two = @"四季度";
    }else{
        NSString *yearString = [nowDate zj_getDateAfterYears:1];
        yearString  = [yearString substringToIndex:4];
        
        //        self.year = yearString;
        one = @"四季度";
        two = [NSString stringWithFormat:@"%@年一季度",yearString];
    }
    [array addObject:one];
    [array addObject:two];
    return array;
}


#pragma mark   退回键盘
-(void)tapView:(UITapGestureRecognizer *)tap{
    [self.countTF resignFirstResponder];
    
}

#pragma mark   textFielddelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * temp = [textField.text stringByAppendingString:string];
    
    if (textField == self.countTF&&([temp zj_isStringAccordWith:@"^[1-9][0-9]{0,4}?$"])) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
    return YES;
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    [self ZJYearAndMonthView:_dateView isChoose:NO];
    
    return YES;
}


@end












