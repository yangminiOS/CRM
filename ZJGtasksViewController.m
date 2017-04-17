//
//  ZJGtasksViewController.m
//  CRM
//
//  Created by mini on 16/10/25.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJGtasksViewController.h"
#import "ZJGtasksTableViewCell.h"
#import "ZJDatePickView.h"
#import "NSDate+Category.h"
#import "ZJGtasksTableInfo.h"
#import "ZJFMdb.h"
#import "CalenderObject.h"//添加到日历提醒事件


@interface ZJGtasksViewController ()<UITableViewDelegate,UITableViewDataSource,ZJDatePickViewDelegate,UITextFieldDelegate>
//顶部视图
@property(weak,nonatomic)UIImageView *topImgView;

//**代办Button**//
@property(nonatomic,weak) UIButton *gtasksButton;
//**完成Button**//
@property(nonatomic,weak) UIButton *completeButton;

//**tableView**//
@property(nonatomic,weak) UITableView *tableView;
//**表视图数据**//
@property(nonatomic,strong) NSMutableArray *dataArray;

//**弹出视图**//
@property(nonatomic,weak) UIView *alateView;
//**弹出视图中白色视图**//
@property(nonatomic,weak) UIView *whiteView;
//**输入内容**//
@property(nonatomic,weak) UITextField *contentTF;
//**显示时间Label**//
@property(nonatomic,weak) UILabel *timeLabel;
//**时间选择器**//
@property(nonatomic,strong) ZJDatePickView *dateView;
//**时间选择器是否已经在视图上**//
@property(nonatomic,assign) BOOL isAdd;
//**时间选择器选定的时间**//
@property(nonatomic,strong) NSDate *datePickDate;

//**占位图**//
@property(nonatomic,strong) UIImageView *imgView;


@end

static NSString *identifier = @"gtasksCell";
@implementation ZJGtasksViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(ZJDatePickView *)dateView{
    if (!_dateView) {
        
        _dateView = [[ZJDatePickView alloc]initWithFrame:CGRectMake(0, self.alateView.height, self.alateView.width, 0)];
        _dateView.delegate = self;
        [self.alateView addSubview:_dateView];
        
    }
    return _dateView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航
    [self setupNavi];
    
    //设置TabelView
    [self setupTableView];
    //设置UI
    [self setupTopView];
    
}

#pragma mark   设置导航
-(void)setupNavi{
    self.view.backgroundColor = ZJBackGroundColor;
    self.navigationItem.title = @"待办事宜";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem zj_BarButtonItemWithButtonItemImage:@"add" heightLightImage:@"add" target:self action:@selector(clickAdd)];
    
}
#pragma mark   点击导航加号按钮
-(void)clickAdd{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = ZJRGBColor(80, 80, 80, 0.6);
    self.alateView = view;
    view.frame = CGRectMake(0, 0, zjScreenWidth, zjScreenHeight);
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [root.view addSubview:view];
    [view addGestureRecognizer:tap];
    //模拟导航View
    UIView *naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, zjScreenWidth, 66)];
    naviView.backgroundColor = ZJColor00D3A3;
    [view addSubview:naviView];
    //返回
    UIButton *backButton = [[UIButton alloc]init];
    [naviView addSubview:backButton];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:PX2PT(55)];
    backButton.frame = CGRectMake(ZJmargin40, 20, 50, 44);
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    //保存
    UIButton *saveButton = [[UIButton alloc]init];
    [naviView addSubview:saveButton];
    saveButton.frame = CGRectMake(zjScreenWidth - ZJmargin40-50, 20, 50, 44);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:PX2PT(55)];
    [saveButton addTarget:self action:@selector(clickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    //底部白色视图
    UIView *whiteV = [[UIView alloc]init];
    [view addSubview:whiteV];
    self.whiteView = whiteV;
    whiteV.frame = CGRectMake(0, 66, zjScreenWidth, PX2PT(264));
    whiteV.backgroundColor = ZJColorFFFFFF;
    //textfield
    UITextField *textF = [[UITextField alloc]init];
    [whiteV addSubview:textF];
    textF.placeholder = @"只能输入一行内容";
    textF.clearButtonMode = UITextFieldViewModeWhileEditing;
    textF.frame = CGRectMake(ZJmargin40, PX2PT(20), zjScreenWidth-2*ZJmargin40, PX2PT(90));
    [textF becomeFirstResponder];
    self.contentTF = textF;
    self.contentTF.delegate = self;
    
    textF.borderStyle =UITextBorderStyleLine;
    [textF.layer setMasksToBounds:YES];
    [textF.layer setBorderWidth:1.0];
    textF.layer.borderColor = ZJColor505050.CGColor;
    //设定时间
    UIButton *Timebutton = [[UIButton alloc]init];
    [whiteV addSubview:Timebutton];
    [Timebutton setTitle:@"设定时间" forState:UIControlStateNormal];
    [Timebutton setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    Timebutton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    Timebutton.width = 65;
    Timebutton.height = PX2PT(264)-ZJmargin40 -15;
    Timebutton.y = ZJmargin40+15;
    Timebutton.centerX = textF.centerX;
    [Timebutton addTarget:self action:@selector(clickTimeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //时间Label
    UILabel *timeLabel = [[UILabel alloc]init];
    [whiteV addSubview:timeLabel];
    self.timeLabel = timeLabel;
    timeLabel.font = [UIFont systemFontOfSize:ZJTextSize35PX];
    timeLabel.textColor = ZJColor505050;
    timeLabel.width = Timebutton.x - ZJmargin40;
    timeLabel.height = 13;
    timeLabel.x = ZJmargin40;
    timeLabel.centerY = Timebutton.centerY;
    

}
//点击退回键盘
-(void)tapView:(UITapGestureRecognizer *)tap{
    
    [self.contentTF resignFirstResponder];
}
//点击返回
-(void)clickBackButton{
    self.isAdd = NO;
    [self.dateView removeFromSuperview];
    self.dateView = nil;
    [self.alateView removeFromSuperview];
    self.alateView = nil;
    [self addData];
}

#pragma mark   //点击保存
-(void)clickSaveButton:(UIButton *)button{
    
    if (self.contentTF.text.length<1) {
        
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
        
        [root presentViewController:alert animated:YES completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
        
        return;
    }
    if (self.timeLabel.text.length<1){
        
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请设定时间" preferredStyle:UIAlertControllerStyleAlert];
        
        [root presentViewController:alert animated:YES completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }
    

    NSArray *weekDay = @[@"星期天",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    ZJGtasksTableInfo *gtasks = [[ZJGtasksTableInfo alloc]init];
    gtasks.dateString = [self.datePickDate zj_getStringFromDatWithFormatter:@"yyyy年MM月dd日"];
    gtasks.timeString = [self.datePickDate zj_getStringFromDatWithFormatter:@"HH:mm"];
    
    NSInteger weekIndex = [self.datePickDate zj_getRealTimeForRequire:NSCalendarUnitWeekday];
    gtasks.weekString = weekDay[weekIndex-1];
    
    gtasks.contentText = self.contentTF.text;
    gtasks.completeOrGtasks = 0;
    
    [ZJFMdb sqlInsertData:gtasks tableName:ZJGtasksTableName];
    
    
    NSString *starTime = [self.datePickDate zj_getStringFromDatWithFormatter:@"yyyy-MM-dd HH:mm"];
    

    NSString *idefitier = [NSString stringWithFormat:@"%@%@",gtasks.dateString,gtasks.timeString];

    NSString *title = [NSString stringWithFormat:@"[好客]:%@",self.contentTF.text];
    
    [CalenderObject initWithTitle:title andIdetifider:idefitier WithStartTime:starTime andEndTime:starTime Location:nil andNoticeFirTime:0 withNoticeEndTime:0];
    //点击返回
    [self clickBackButton];
}
//点击设定时间
-(void)clickTimeButton:(UIButton *)button{
    [self.contentTF resignFirstResponder];
    if (self.isAdd)return;
    NSDate *now = [[NSDate alloc]init];
    NSString *tomString = [now zj_getDateAfterDays:1 dateFormat:@"yyyy-MM-dd HH:mm"];
    
    self.datePickDate = [tomString zj_getDateFromStringWithFormatter:@"yyyy-MM-dd HH:mm"];
    
    NSString *nowString = [self.datePickDate zj_getStringFromDatWithFormatter:@"HH:mm"];
    
    self.timeLabel.text = [NSString stringWithFormat:@"明天 %@",nowString];
    self.dateView.dateModel = ZJDatePickViewDateAndHoursModel;
    self.dateView.minDate = now;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.dateView.frame = CGRectMake(0, zjScreenHeight-(40+zjScreenHeight/3.0), zjScreenWidth, 40+zjScreenHeight/3.0);
        
    }];
    self.isAdd = YES;
}
#pragma mark   设置顶部视图
-(void)setupTopView{
    //底部imgView
    CGFloat height = PX2PT(104);
    CGFloat width = self.view.width - 2*ZJmargin40;
    UIImageView *topView = [[UIImageView alloc]init];
    topView.userInteractionEnabled = YES;
    [self.view addSubview:topView];
    self.topImgView = topView;
    topView.frame = CGRectMake(ZJmargin40, ZJmargin40, width, height);
    
    //左边代办Button
    UIButton *gtaskeB = [[UIButton alloc]init];
    self.gtasksButton = gtaskeB;
    gtaskeB.frame = CGRectMake(0, 0, width/2.0, height);
    [self setButton:gtaskeB title:@"待办"];
    [gtaskeB addTarget:self action:@selector(clickGatsksButton:) forControlEvents:UIControlEventTouchUpInside];

    //右边已完成Button
    UIButton *comButton = [[UIButton alloc]init];
    self.completeButton = comButton;
    comButton.frame = CGRectMake(width/2.0, 0, width/2.0, height);
    [self setButton:comButton title:@"已完成"];
    [comButton addTarget:self action:@selector(clickCompleteButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //点击代办Button
    [self clickGatsksButton:self.gtasksButton];
}
-(void)setButton:(UIButton *)button title:(NSString *)title{
    [self.topImgView addSubview:button];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:ZJColorFFFFFF forState:UIControlStateSelected];
    [button setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
}

#pragma mark   设置tableView
-(void)setupTableView{
    UIView *line = [[UIView alloc]init];
    [self.view addSubview:line];
    line.backgroundColor = ZJColorDCDCDC;
    line.frame = CGRectMake(0, PX2PT(182), zjScreenWidth, PX2PT(2));
    CGFloat tableY = PX2PT(184);
    CGRect frame = CGRectMake(0, tableY, self.view.width, self.view.height - tableY-64);
    UITableView *table = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    self.tableView = table;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [table registerNib:[UINib nibWithNibName:@"ZJGtasksTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    table.rowHeight= PX2PT(200);
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark   tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJGtasksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZJGtasksTableInfo *gtasks = self.dataArray[indexPath.row];
    cell.model =gtasks;
    return cell;
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJGtasksTableInfo *gtasks = self.dataArray[indexPath.row];
    
    if (gtasks.completeOrGtasks == 1) {
        
        UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            //删除数据库中的数据
            [ZJFMdb sqlDelecteData:gtasks tableName:ZJGtasksTableName headString:gtasks.iAutoID];
            [self removeCanderRemind:gtasks];
            //删除数组中的数据
            [self.dataArray removeObject:gtasks];
            
            [self.tableView reloadData];
            
        }];
        delete.backgroundColor = ZJRGBColor(253, 1, 0, 1.0);
        return @[delete];


    }else{
        UITableViewRowAction *complete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"完成" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [self removeCanderRemind:gtasks];
            
            gtasks.completeOrGtasks = 1;
            
            [ZJFMdb sqlUpdata:gtasks tableName:ZJGtasksTableName];
            
            [self addData];
            
        }];
        UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [self removeCanderRemind:gtasks];
            
            //删除数组中的数据
            [self.dataArray removeObject:gtasks];
            [self.tableView reloadData];
            //删除数据库中的数据
            [ZJFMdb sqlDelecteData:gtasks tableName:ZJGtasksTableName headString:gtasks.iAutoID];
            
        }];
        
        complete.backgroundColor = ZJColor00D3A3;
        delete.backgroundColor = ZJRGBColor(253, 1, 0, 1.0);
        return @[delete,complete];

        
    }

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJGtasksTableInfo *gtasks = self.dataArray[indexPath.row];
    
    [self alertViewWithTitle:@"内容" message:gtasks.contentText];
    

}

#pragma mark   ZJDatePickView代理方法
-(void)ZJDatePickView:(ZJDatePickView *)view isChoose:(BOOL)choose{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.dateView.frame = CGRectMake(0, zjScreenHeight, zjScreenWidth, 0);
    }];
    self.isAdd = NO;

}
-(void)ZJDatePickView:(ZJDatePickView *)view datePickView:(UIDatePicker *)datePick{
    
    
    NSString *nowString = [[[NSDate alloc]init]zj_getStringFromDatWithFormatter:@"yyyy年MM月dd日"];
    NSString *pickString = [datePick.date zj_getStringFromDatWithFormatter:@"yyyy年MM月dd日"];
    NSDate *nowDate = [nowString zj_getDateFromStringWithFormatter:@"yyyy年MM月dd日"];
    
    NSDate *pickDate = [pickString zj_getDateFromStringWithFormatter:@"yyyy年MM月dd日"];
    NSDateComponents *com = [pickDate zj_intervalDeadlineFrom:nowDate calendarUnit:NSCalendarUnitDay];
    
    NSString *dateString = nil;
    if (com.day == 0) {
        dateString = @"今天";
    }else if (com.day == 1){
        dateString = @"明天";
    }else if (com.day ==2){
        
        dateString = @"后天";
    }else{
        
        dateString = [datePick.date zj_getStringFromDatWithFormatter:@"MM月dd日"];
    }
    
    NSString *time = [datePick.date zj_getStringFromDatWithFormatter:@"HH:mm"];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",dateString,time];
    
    self.datePickDate = datePick.date;

}
#pragma mark  点击代办Button
-(void)clickGatsksButton:(UIButton *)button{
    if (button.selected)return;
    self.completeButton.selected = NO;
    button.selected = YES;
    self.topImgView.image = [UIImage imageNamed:@"acklog"];

    [self addData];
    
}
#pragma mark   点击已完成Button
-(void)clickCompleteButton:(UIButton *)button{
     if (button.selected)return;
    self.gtasksButton.selected = NO;
    button.selected = YES;
    self.topImgView.image = [UIImage imageNamed:@"Done"];

    [self addData];
}

-(void)addData{
    [self.dataArray removeAllObjects];
    ZJGtasksTableInfo *gtasks = [[ZJGtasksTableInfo alloc]init];
    NSString *select = nil;
    if (self.gtasksButton.selected) {
        select = [NSString stringWithFormat:@"select * from %@ where completeOrGtasks=0",ZJGtasksTableName];
        
    }else if (self.completeButton.selected){
        select = [NSString stringWithFormat:@"select * from %@ where completeOrGtasks=1",ZJGtasksTableName];
        
    }
    
    [ZJFMdb sqlSelecteData:gtasks selecteString:select success:^(NSMutableArray *successMsg) {
        NSMutableArray *temp = (NSMutableArray*)[successMsg reverseObjectEnumerator];
        [self.dataArray addObjectsFromArray:temp];
        
        [self.tableView reloadData];
        
    }];
    
    if (self.gtasksButton.selected&&!self.imgView&&self.dataArray.count==0) {
        self.imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"待办事宜"]];
        [self.view addSubview:self.imgView ];
        self.imgView .center = self.view.center;
        
    }else if (!self.gtasksButton.selected||self.dataArray.count>0) {
        
        if (self.imgView) {
            
            [self.imgView  removeFromSuperview];
            
            self.imgView  = nil;
        }
        
        
    }
}

-(void)removeCanderRemind:(ZJGtasksTableInfo *)gtasks{
    
    NSString *identifer = [NSString stringWithFormat:@"%@%@",gtasks.dateString,gtasks.timeString];
    
    NSString *temp = [NSString stringWithFormat:@"%@ %@",gtasks.dateString,gtasks.timeString];
    
    NSString *star = [temp zj_dateStringFormatter:@"yyyy年MM月dd日 HH:mm" toFromatter:@"yyyy-MM-dd HH:mm"];
    
    [CalenderObject deleteCalenderEvent:star andEndTime:star withIdetifier:identifer];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *temp = [textField.text stringByAppendingString:string];
    
    if (temp.length<=50) {
        
        return YES;
    }
    return NO;
}


@end










