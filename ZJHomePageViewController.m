//
//  ZJHomePageViewController.m
//  CRM
//
//  Created by mini on 16/8/23.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJHomePageViewController.h"
#import <AFNetworking.h>
#import "ZJTimeGoalViewController.h"
#import "ZJGtasksViewController.h"
#import "ZJGoalTableInfo.h"
#import "ZJFMdb.h"
#import "NSDate+Category.h"
#import "ZJLearnViewController.h"
#import "ZJGeneralizeViewController.h"
#import "ZJCAndFViewController.h"
#import "ZJRemindTableInfo.h"
#import "ZJcustomerTableInfo.h"
#import "ZJFolloweViewController.h"
#import "ZJBirthViewController.h"
#import "ZJCustomerViewController.h"
#import "ZJFollowUpTableInfo.h"
@interface ZJHomePageViewController ()<UISearchBarDelegate>
{
    //目标和完成金额
    NSInteger _sqlMouthGoal;
    CGFloat _sqlMouthComplete;
    
    NSInteger _sqlSeasonGoal;
    CGFloat _sqlSeasonComplete;
    
    NSInteger _sqlYearGoal;
    CGFloat _sqlYearComplete;
    
    NSInteger _year;
    NSInteger _month;
    
    
}

//搜索
@property (weak, nonatomic) IBOutlet UISearchBar *searchView;

//目标类型  月目标  季目标  年目标
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UIButton *goalButton;
//剩余多少天
@property (weak, nonatomic) IBOutlet UILabel *surplusaDaysLabel;

//右边的目标和已完成

@property (weak, nonatomic) IBOutlet UILabel *rightGoalLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightCompleteLabel;

//意向客户//
@property (weak, nonatomic) IBOutlet UILabel *purposeLabel;

//本月新增//
@property (weak, nonatomic) IBOutlet UILabel *NewAddLabel;

//跟进中//
@property (weak, nonatomic) IBOutlet UILabel *followUPLabel;

//本月放贷//
@property (weak, nonatomic) IBOutlet UILabel *loanLabel;

//多少位客户过生日//
@property (weak, nonatomic) IBOutlet UILabel *birthLabel;

//多少位客户即将可以续贷//
@property (weak, nonatomic) IBOutlet UILabel *continueLabel;
//多少位客户即将首期还款//
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
//生日提醒标记
@property (weak, nonatomic) IBOutlet UIButton *birthMarkerButton;

//续贷提醒标记

@property (weak, nonatomic) IBOutlet UIButton *continueMarkerButton;

//首期还款日提醒标记
@property (weak, nonatomic) IBOutlet UIButton *firstMarkerButton;

//代办事宜条数提醒

@property (weak, nonatomic) IBOutlet UIButton *gtasksMarkerButton;


//目标显示百分比
@property (weak, nonatomic) IBOutlet UILabel *goaldView;
//完成显示百分比
@property (weak, nonatomic) IBOutlet UILabel *completeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *completeLen;

//**uiv=**//
@property(nonatomic,weak) UIView *coverView;

//**************************************************************************

@end


static  NSString *mouteTitle = @"本月度目标";

static  NSString *seasonTitle = @"本季度目标";
static  NSString *yearTitle = @"本年度目标";


@implementation ZJHomePageViewController


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self showCountFromSQL];
    //目标右边的目标和已完成Label
    [self setValueForRightGoalAndCompleteLabel];
    
//    [self showTodayData];

}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    [self isORC];
    [self setupNavigation];
    
    [self showTodayData];
//    [self LocalNotificationWithAlertBody:@"测试" actionDate:[NSDate new]];
    [self addnotification];
    
    
    
}

-(void)addnotification{
    
    //从后台进入
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fromBack)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notice:)
                                                 name:@"firstcount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) keyboardWillHide : (NSNotification*)notification {
    self.searchView.text = nil;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.searchView.showsCancelButton = NO;
    
    [self.searchView resignFirstResponder];
    [self.coverView removeFromSuperview];
    self.coverView = nil;
   

}
-(void)fromBack{
    
    [self showTodayData];

}

-(void)notice:(NSNotification *)notice{
    
    
//    [self showTodayData];
    NSDate *nowDate = [NSDate new];
    
    NSString *nowString = [nowDate zj_getStringFromDatWithFormatter:@"yyyy-MM-dd"];
    
    NSString *nowBString = [nowDate zj_getStringFromDatWithFormatter:@"MM-dd"];
    
    
    //生日提醒
    NSString *markerBirthSelect = [NSString stringWithFormat:@"SELECT COUNT (*) FROM %@ WHERE iRemindType=1 AND iSwitch=1 AND cRemindDate='%@'",ZJRemindTableName,nowBString];
    
    NSInteger birthC = [ZJFMdb sqlSelecteCountWithString:markerBirthSelect];
    
    if (birthC>0) {
        //SELECT COUNT (*) FROM crm_Remind WHERE iRemindType=1 AND iSwitch=1 AND cRemindDate='12-07'
        self.birthMarkerButton.hidden = NO;
        NSString *title = [NSString stringWithFormat:@"%zd",birthC];
        [self.birthMarkerButton setTitle:title forState:UIControlStateNormal];
    }else{
        self.birthMarkerButton.hidden = YES;
        
    }
    
    //SELECT COUNT (*) FROM crm_Remind WHERE iRemindType=1 AND iSwitch=1 AND cRemindDate='01-11'
    //续贷提醒
    NSString *markerContinueSelect = [NSString stringWithFormat:@"SELECT COUNT (*) FROM %@ WHERE iRemindType=2 AND iSwitch=1 AND cRemindDate='%@'",ZJRemindTableName,nowString];
    
    
    NSInteger continueC = [ZJFMdb sqlSelecteCountWithString:markerContinueSelect];
    
    if (continueC>0) {
        
        self.continueMarkerButton.hidden = NO;
        
        NSString *title = [NSString stringWithFormat:@"%zd",continueC];
        
        [self.continueMarkerButton setTitle:title forState:UIControlStateNormal];
    }else{
        self.continueMarkerButton.hidden = YES;
        
    }
    
    //首期还款日提醒
    
    
    NSString *markerFirstSelect = [NSString stringWithFormat:@"SELECT COUNT (*) FROM %@ WHERE iRemindType=3 AND iSwitch=1 AND cRemindDate='%@'",ZJRemindTableName,nowString];
    
    
    NSInteger firstC = [ZJFMdb sqlSelecteCountWithString:markerFirstSelect];
    
    if (firstC>0) {
        
        self.firstMarkerButton.hidden = NO;
        
        NSString *title = [NSString stringWithFormat:@"%zd",firstC];
        
        [self.firstMarkerButton setTitle:title forState:UIControlStateNormal];
    }else{
        self.firstMarkerButton.hidden = YES;
        
    }
    

    
    
//    NSDictionary *dic = [notice userInfo];
//    NSInteger bCount = [dic[@"birth"] integerValue];
//    
//    NSInteger cCount = [dic[@"continu"] integerValue];
//    
//    NSInteger fCount = [dic[@"first"] integerValue];
//    
//    if (bCount ) {
//        
//        if (_birthMarkerButton.hidden) {
//            
//            _birthMarkerButton.hidden = NO;
//            
//            NSString *title = [NSString stringWithFormat:@"%zd",bCount];
//            
//            [_birthMarkerButton setTitle:title forState:UIControlStateNormal];
//            
//        }else{
//            
//            NSInteger count = _birthMarkerButton.titleLabel.text.integerValue + bCount;
//            
//            NSString *title = [NSString stringWithFormat:@"%zd",count];
//            
//            [_birthMarkerButton setTitle:title forState:UIControlStateNormal];
//
//        }
//        
//    }
//    
//    if (cCount) {
//        
//        if (_continueMarkerButton.hidden) {
//            
//            _continueMarkerButton.hidden = NO;
//            
//            NSString *title = [NSString stringWithFormat:@"%zd",cCount];
//            
//            [_continueMarkerButton setTitle:title forState:UIControlStateNormal];
//            
//        }else{
//            
//            NSInteger count = _continueMarkerButton.titleLabel.text.integerValue + cCount;
//            
//            NSString *title = [NSString stringWithFormat:@"%zd",count];
//            
//            [_continueMarkerButton setTitle:title forState:UIControlStateNormal];
//            
//        }
//
//    }
//    
//    if (fCount) {
//        if (_firstMarkerButton.hidden) {
//            
//            _firstMarkerButton.hidden = NO;
//            
//            NSString *title = [NSString stringWithFormat:@"%zd",fCount];
//            
//            [_firstMarkerButton setTitle:title forState:UIControlStateNormal];
//            
//        }else{
//            
//            NSInteger count = _firstMarkerButton.titleLabel.text.integerValue + fCount;
//            
//            NSString *title = [NSString stringWithFormat:@"%zd",count];
//            
//            [_firstMarkerButton setTitle:title forState:UIControlStateNormal];
//            
//        }
//
//        
//    }

}


#pragma mark   设置UI
-(void)setupUI{
    self.searchView.delegate = self;
}


#pragma mark   设置导航栏
-(void)setupNavigation{
    
    self.view.backgroundColor = ZJRGBColor(247, 247, 247, 1.0);

    self.navigationItem.title = @"好客";
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem zj_BarButtonItemWithButtonItemImage:@"more" heightLightImage:@"more" target:self action:@selector(clickMoreButton)];
    
}

#pragma mark   点击导航上更多
-(void)clickMoreButton{
    
    
}

#pragma mark   判断是否开启ocr

-(void)isORC{
    //http://www.haoke77.com/interface/fun_OCRState.php
    NSString *url = [NSString stringWithFormat:@"%@/crm/interface/fun_OCRState.php",THEURL];
    
    [[AFHTTPSessionManager manager]GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"on-off"] forKey:@"ocr"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark   完成金额View的长度设置
-(void)completeViewLenght:(CGFloat)goald complete:(CGFloat)complete{
    
    CGFloat point = complete/goald;
    
    if (complete == 0) {
        self.completeLen.constant = self.goaldView.width;
        self.completeView.text = @"还没有业绩吗？加油哦~";
        self.completeView.textColor = [UIColor redColor];
                
    }else if (point>0 && point<=0.1){
        self.completeLen.constant = 50;
        self.completeView.text = [NSString stringWithFormat:@"%.2f%%",point*100];
        self.completeView.textColor = ZJColorFFFFFF;

    }else if (point>0 && point<1){
        CGFloat temp = self.goaldView.width -50;
        
        self.completeLen.constant = 50 +temp *point;
        self.completeView.text = [NSString stringWithFormat:@"%.2f%%",point*100];
        self.completeView.textColor = ZJColorFFFFFF;


    }else{
        self.completeLen.constant = self.goaldView.width;
        self.completeView.text = [NSString stringWithFormat:@"%.2f%%",point*100];
        self.completeView.textColor = ZJColorFFFFFF;

    }
}

#pragma mark  封装点击弹框的方法
-(void)clickAlertActionWithButton:(UIButton *)sender goalTitle:(NSString *)goalTitle sqlTimeGoal:(NSInteger)sqlTimeGoal sqlTimeComplete:(CGFloat)sqlTimeComplete{
    //判断月是否相同  相同就退出
    if ([self.goalLabel.text isEqualToString:goalTitle]){
        sender.selected = NO;
        return ;
    }
    
    self.goalLabel.text = goalTitle;
    sender.selected = NO;
    //目标右边的目标和已完成Label
    self.rightGoalLabel.text = [NSString stringWithFormat:@"%zd万",sqlTimeGoal];
    self.rightCompleteLabel.text = [NSString stringWithFormat:@"%.2f万",sqlTimeComplete];
    
    
}

#pragma mark   设置不同时期目标
- (IBAction)goalType:(UIButton *)sender {
    
    self.goalButton.selected = !self.goalButton.selected;
    
    UIAlertController *goalAler = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //选择月份
    UIAlertAction *mouth = [UIAlertAction actionWithTitle:mouteTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self clickAlertActionWithButton:self.goalButton
                               goalTitle:mouteTitle
                             sqlTimeGoal:_sqlMouthGoal
                         sqlTimeComplete:_sqlMouthComplete];
       
        //当前月还有多少天
        NSInteger days = [[NSDate new] zj_daysInThisMouth];
        self.surplusaDaysLabel.text = [self setdays:days];

        //长度
        [self completeViewLenght:_sqlMouthGoal complete:_sqlMouthComplete];
        
    }];
    
    //选择季度
    UIAlertAction *jidu = [UIAlertAction actionWithTitle:seasonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self clickAlertActionWithButton:self.goalButton
                               goalTitle:seasonTitle
                             sqlTimeGoal:_sqlSeasonGoal
                         sqlTimeComplete:_sqlSeasonComplete];

        //当前季度还有多少天
        NSInteger days = [[NSDate new] zj_daysInThisSeason];
        self.surplusaDaysLabel.text = [self setdays:days];

        
        //长度
        [self completeViewLenght:_sqlSeasonGoal complete:_sqlSeasonComplete];
        
       
    }];
    
    //选择年份
    UIAlertAction *year = [UIAlertAction actionWithTitle:yearTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //判断年是否相同  相同就退出
        
        [self clickAlertActionWithButton:self.goalButton
                               goalTitle:yearTitle
                             sqlTimeGoal:_sqlYearGoal
                         sqlTimeComplete:_sqlYearComplete];
        //当前年度还有多少天
        NSInteger days = [[NSDate new] zj_daysInThisYear];
        
        self.surplusaDaysLabel.text = [self setdays:days];

        
        //长度
        [self completeViewLenght:_sqlYearGoal complete:_sqlYearComplete];
        

    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        sender.selected = NO;
    }];
    
    [goalAler addAction:mouth];
    [goalAler addAction:jidu];
    [goalAler addAction:year];
    [goalAler addAction:cancel];
    
    [self presentViewController:goalAler animated:YES completion:nil];
}

#pragma mark   设置时间目标Button
- (IBAction)GoalButton:(UIButton *)sender {
     
    ZJTimeGoalViewController *goal = [[ZJTimeGoalViewController alloc]init];
    goal.timeType = @"月度目标";
    [self.navigationController pushViewController:goal animated:YES];
}


#pragma mark   右边目标、已完成Label
-(void)setValueForRightGoalAndCompleteLabel{
    
    ZJGoalTableInfo *goal = [[ZJGoalTableInfo alloc]init];
    //月度数据
    NSDate *nowDate = [[NSDate alloc]init];
    NSString *mouthTag = [nowDate zj_getStringFromDatWithFormatter:@"yyyy年MM月"];
    NSString *mouthselect = [NSString stringWithFormat:@"select *from %@ where tag='%@'",ZJGoalTableName,mouthTag];
    
    [ZJFMdb sqlSelecteData:goal selecteString:mouthselect success:^(NSMutableArray *successMsg) {
        
        if (successMsg.count ==0) {
            
            _sqlMouthGoal = defaultMouthGoal;
            
        }else{
            ZJGoalTableInfo *mouthGoal = successMsg[0];
            _sqlMouthGoal = mouthGoal.goalCount;
            
        }
        
    }];
    
    //设置右边的已完成金额
    NSString *monthcom = [NSString stringWithFormat:@"SELECT SUM(fBorrowMoney) FROM %@ where (cCustomerState_Tags LIKE '2;%%' OR cCustomerState_Tags LIKE '%%;2;%%' OR cCustomerState_Tags LIKE '%%;2;' ) AND cLoanDate like '%zd-%02zd%%'",ZJCustomerTableName,_year,_month];
    _sqlMouthComplete = [ZJFMdb sqlSelecteResultValueWithString:monthcom];
    //完成的长度
    [self completeViewLenght:_sqlMouthGoal complete:_sqlMouthComplete];

    //季度数据
    NSInteger season = [nowDate zj_getSeadonFromDate];
    NSString *seasonTag = [NSString stringWithFormat:@"%zd",season];
    NSString *seasonhselect = [NSString stringWithFormat:@"select *from %@ where tag='%@' AND  year='%zd'",ZJGoalTableName,seasonTag,_year];
    [ZJFMdb sqlSelecteData:goal selecteString:seasonhselect success:^(NSMutableArray *successMsg) {
        
        if (successMsg.count ==0) {
            _sqlSeasonGoal = defaultSeasonGoal;
            
        }else{
            ZJGoalTableInfo *seasonGoal = successMsg[0];
            _sqlSeasonGoal = seasonGoal.goalCount;
        }
        
    }];
    
    //右边已完成数据
    NSString *seasoncom = [NSString stringWithFormat:@"SELECT SUM(fBorrowMoney) FROM %@ where (cCustomerState_Tags LIKE '2;%%' OR cCustomerState_Tags LIKE '%%;2;%%' OR cCustomerState_Tags LIKE '%%;2;' ) AND (%@)",ZJCustomerTableName,[self getMonthFromSeason:season]];
    
    _sqlSeasonComplete = [ZJFMdb sqlSelecteResultValueWithString:seasoncom];

    NSString *yearTag = [NSString stringWithFormat:@"%@",[nowDate zj_getStringFromDatWithFormatter:@"yyyy年"]];
    NSString *yearhselect = [NSString stringWithFormat:@"select *from %@ where tag='%@'",ZJGoalTableName,yearTag];

    [ZJFMdb sqlSelecteData:goal selecteString:yearhselect success:^(NSMutableArray *successMsg) {
        
        if (successMsg.count ==0) {
            _sqlYearGoal = defaultYearGoal;
            
        }else{
            ZJGoalTableInfo *yearGoal = successMsg[0];
            _sqlYearGoal = yearGoal.goalCount;
        }
        
    }];
    
    //右边已完成数据
    NSString *yearcom = [NSString stringWithFormat:@"SELECT SUM(fBorrowMoney) FROM %@ WHERE(cCustomerState_Tags LIKE '2;%%' OR cCustomerState_Tags LIKE '%%;2;%%' OR cCustomerState_Tags LIKE '%%;2;' ) AND cLoanDate like '%zd%%'",ZJCustomerTableName,_year];
    
    _sqlYearComplete = [ZJFMdb sqlSelecteResultValueWithString:yearcom];

    self.rightGoalLabel.text = [NSString stringWithFormat:@"%zd万",_sqlMouthGoal];
    self.rightCompleteLabel.text = [NSString stringWithFormat:@"%.2f万",_sqlMouthComplete];
    //当前月还有多少天
    NSInteger days = [[NSDate new] zj_daysInThisMouth];
    
    self.surplusaDaysLabel.text = [self setdays:days];

    
}

#pragma mark   判断还有多少天
-(NSString *)setdays:(NSInteger)days{
    
    NSString *temp = nil;
    
    if (days>7) {//大于7  出现周的情况
        if (days%7==0) {//剩余0天
            temp = [NSString stringWithFormat:@"本月剩余%zd周",days/7];

            
        }else{//剩余若干天
            
            temp = [NSString stringWithFormat:@"本月剩余%zd周加%zd天",days/7,days%7];

            
        }
        
    }else{//天数小于7
        temp = [NSString stringWithFormat:@"本月剩余%zd天",days];
    }
    return temp;
}

#pragma mark   点击学习
- (IBAction)clickLearnButton:(UIButton *)sender {
    
    ZJLearnViewController *learn = [[ZJLearnViewController alloc]init];
    
    [self.navigationController pushViewController:learn animated:YES];
}

#pragma mark   点击推广

- (IBAction)clickGeneralizeButton:(UIButton *)sender {
    
    ZJGeneralizeViewController *generalize = [[ZJGeneralizeViewController alloc]init];
    
    [self.navigationController pushViewController:generalize animated:YES];
}
#pragma mark   点击跟进
- (IBAction)clickFollowUPButton:(UIButton *)sender {
    
    ZJFolloweViewController *follow = [[ZJFolloweViewController alloc]init];
    follow.FollowEnterModel = FirstEnterModel;
    
    [self.navigationController pushViewController:follow animated:YES];
    
}
//  select count(t.counts) from (select * from crm_FollowUp  group by iCustomerID) t

#pragma mark   代办事宜

- (IBAction)Gtasks:(UIButton *)sender {
    
    ZJGtasksViewController *gtasks = [[ZJGtasksViewController alloc]init];
    [self.navigationController pushViewController:gtasks animated:YES];
}
#pragma mark   生日提醒
- (IBAction)clickBirthButton:(UIButton *)sender {
    
    ZJBirthViewController *birth = [[ZJBirthViewController alloc]init];
    self.birthMarkerButton.hidden = YES;
    [self.navigationController pushViewController:birth animated:YES];
    
}

#pragma mark   续贷提醒
- (IBAction)clickContinueButton:(UIButton *)sender {
    ZJCAndFViewController *continueVC = [[ZJCAndFViewController alloc]init];
    continueVC.ViewType = NSContinueViewController;
    
    self.continueMarkerButton.hidden = YES;

    
    [self.navigationController pushViewController:continueVC animated:YES];
}


#pragma mark   首期还款日提醒

- (IBAction)clickFirstButton:(UIButton *)sender {
    
    ZJCAndFViewController *first = [[ZJCAndFViewController alloc]init];
    
    first.ViewType = NSFirstViewController;


    self.firstMarkerButton.hidden = YES;

    [self.navigationController pushViewController:first animated:YES];
}



#pragma mark   点击意向客户

- (IBAction)clickTopPurposeButton:(UIButton *)sender {
    
    ZJCustomerViewController *purpose = [[ZJCustomerViewController alloc]init];
    purpose.enterModel = FirstPurposeModel;
    purpose.naviTitle = @"意向客户";
    purpose.select = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE  (cCustomerState_Tags LIKE '1;%%' OR cCustomerState_Tags LIKE '%%;1;%%' OR cCustomerState_Tags LIKE '%%;1')",ZJCustomerTableName];
//    purpose.select = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE iFrom=2",ZJCustomerTableName];
    
    [self.navigationController pushViewController:purpose animated:YES];

}

#pragma mark   本月新增
- (IBAction)clickTopNewAddButton:(UIButton *)sender {
    ZJCustomerViewController *NewAdd = [[ZJCustomerViewController alloc]init];
    NewAdd.enterModel = FirstNewAddModel;

    NewAdd.naviTitle = @"本月新增";
    NewAdd.select = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE cCreateYear='%zd' AND cCreateMonth='%zd'",ZJCustomerTableName,_year,_month];
    
    [self.navigationController pushViewController:NewAdd animated:YES];
}
#pragma mark   跟进中
- (IBAction)clickTopFollowingButton:(UIButton *)sender {
    ZJCustomerViewController *Following = [[ZJCustomerViewController alloc]init];
    Following.enterModel = FirstFollowingModel;

    Following.naviTitle = @"跟进中的";
    ZJFollowUpTableInfo *model = [[ZJFollowUpTableInfo alloc]init];

    NSString * selectF = [NSString stringWithFormat:@"SELECT * FROM %@ GROUP BY iCustomerID ",ZJFollowTableName];
    [ZJFMdb sqlSelecteData:model selecteString:selectF success:^(NSMutableArray *successMsg) {
        
        ZJFollowUpTableInfo *followfirst = nil;
        if (successMsg.count>0) {
            
            followfirst = successMsg.firstObject;
            
        }
        
        NSString *idString = [NSString stringWithFormat:@"iAutoID=%zd",followfirst.iCustomerID];

        
        for ( NSInteger i = 1 ;i<successMsg.count;i++) {
            
            ZJFollowUpTableInfo *followModel = successMsg[i];
            
            NSString *temp = [NSString stringWithFormat:@" OR iAutoID=%zd",followModel.iCustomerID];
            
            idString = [idString stringByAppendingString:temp];

        }
        idString = [NSString stringWithFormat:@"select *from %@ where %@",ZJCustomerTableName,idString];
        
        Following.select = idString;

        
    }];
    
    [self.navigationController pushViewController:Following animated:YES];
}
#pragma mark   本月放贷
- (IBAction)clickTopLoanButton:(UIButton *)sender {
    ZJCustomerViewController *Loan = [[ZJCustomerViewController alloc]init];
    Loan.enterModel = FirstLoanModel;
    Loan.naviTitle = @"本月放贷";
    NSString *loanSelect = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE cCreateYear='%zd'AND cCreateMonth='%zd' AND (cCustomerState_Tags LIKE '2;%%' OR cCustomerState_Tags LIKE '%%;2;%%' OR cCustomerState_Tags LIKE '%%;2')",ZJCustomerTableName,_year,_month];
    Loan.select = loanSelect;
    [self.navigationController pushViewController:Loan animated:YES];
}

#pragma mark   数据库查询

-(void)customerDataFromSqlWithRemindArray:(NSMutableArray *)array resultArray:(NSMutableArray *)resultArray{
    ZJRemindTableInfo *remindFirst = nil;

    if (array.count>0) {
        
        remindFirst = array[0];

    }else{
        return;
    }
    ZJcustomerTableInfo *customer = [[ZJcustomerTableInfo alloc]init];
    
    NSString *idString = [NSString stringWithFormat:@"iAutoID=%zd",remindFirst.iCustomerID];

    for (NSInteger i = 1; i<array.count; i++) {
        
        ZJRemindTableInfo *remind = array[i];
        
        NSString *temp = [NSString stringWithFormat:@" OR iAutoID=%zd",remind.iCustomerID];
        
        idString = [idString stringByAppendingString:temp];
    }
    
    idString = [NSString stringWithFormat:@"select *from %@ where %@",ZJCustomerTableName,idString];
    
    
    [ZJFMdb sqlSelecteData:customer selecteString:idString success:^(NSMutableArray *successMsg) {
        [resultArray removeAllObjects];
        [resultArray  addObjectsFromArray:successMsg];
    }];
    
}

#pragma mark   展示客户数量

-(void)showCountFromSQL{
    
    self.goalLabel.text = mouteTitle;
    NSDate *nowDate = [NSDate new];

    //意向客户数量
    NSString *purposeSelect = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE  (cCustomerState_Tags LIKE '1;%%' OR cCustomerState_Tags LIKE '%%;1;%%' OR cCustomerState_Tags LIKE '%%;1')",ZJCustomerTableName];
    NSInteger purposeCount = [ZJFMdb sqlSelecteCountWithString:purposeSelect];
    
    if (purposeCount>0) {
        
        self.purposeLabel.text = [NSString stringWithFormat:@"%zd位",purposeCount];
    }else{
        
        self.purposeLabel.text = @"暂无";
    }
    //本月新增数量
     _year = [nowDate zj_getRealTimeForRequire:NSCalendarUnitYear];
    
    _month = [nowDate zj_getRealTimeForRequire:NSCalendarUnitMonth];
    
    NSString *newSelect = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE cCreateYear='%zd'AND cCreateMonth='%zd'",ZJCustomerTableName,_year,_month];
    NSInteger newCount = [ZJFMdb sqlSelecteCountWithString:newSelect];
    if (newCount>0) {
        
        self.NewAddLabel.text = [NSString stringWithFormat:@"%zd位",newCount];
    }else{
        
        self.NewAddLabel.text = @"暂无";
    }
    //跟进中数量
    NSString *followSelect = [NSString stringWithFormat:@"SELECT COUNT(*) FROM (SELECT * FROM %@ GROUP BY iCustomerID) t",ZJFollowTableName];
   
    NSInteger followCount = [ZJFMdb sqlSelecteCountWithString:followSelect];
    if (followCount>0) {
        
        self.followUPLabel.text = [NSString stringWithFormat:@"%zd位",followCount];
    }else{
        
        self.followUPLabel.text = @"暂无";
    }
    
    //本月放贷数量
    NSString *loanSelect = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE cCreateYear='%zd'AND cCreateMonth='%zd' AND (cCustomerState_Tags LIKE '2;%%' OR cCustomerState_Tags LIKE '%%;2;%%' OR cCustomerState_Tags LIKE '%%;2')",ZJCustomerTableName,_year,_month];
    
    NSInteger loanCount = [ZJFMdb sqlSelecteCountWithString:loanSelect];
    
    if (loanCount>0) {
        
        self.loanLabel.text = [NSString stringWithFormat:@"%zd位",loanCount];
    }else{
        
        self.loanLabel.text = @"暂无";
    }
   
    
    //生日
    NSString *nowAfter = [nowDate zj_getDateAfterDays:7 dateFormat:@"yyyy-MM-dd"];
    
    NSString *nowBString = [nowDate zj_getStringFromDatWithFormatter:@"MM-dd"];
    NSString *birthDaysAppend = [NSString stringWithFormat:@"cRemindDate LIKE '%%%@%%'",nowBString];
    for (NSInteger i = 1; i<=7; i++) {
        NSString *birthnowAfter = [nowDate zj_getDateAfterDays:i dateFormat:@"yyyy-MM-dd"];
        
        NSString *BAfterDate = [birthnowAfter zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"MM-dd"];
        
        birthDaysAppend = [NSString stringWithFormat:@"%@ OR cRemindDate LIKE '%%%@%%'",birthDaysAppend,BAfterDate];
        
    }
    
    NSString *birthSelect = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE iRemindType=1 AND iSwitch=1 AND (%@)",ZJRemindTableName,birthDaysAppend];
    NSInteger birthCount = [ZJFMdb sqlSelecteCountWithString:birthSelect];
    
    if (birthCount>0) {
        
        self.birthLabel.text = [NSString stringWithFormat:@"%zd位客户生日到了，快送个生日祝福吧",birthCount];
    }else{
        
        self.birthLabel.text = @"暂无客户生日提醒";
    }

    //续贷提醒
    
    NSString *nowString = [nowDate zj_getStringFromDatWithFormatter:@"yyyy-MM-dd"];
    
    
    NSString *continueSelect = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE iRemindType=2 AND iSwitch=1 AND cRemindDate Between '%@' and '%@'",ZJRemindTableName,nowString,nowAfter];
    
    NSInteger continueConut = [ZJFMdb sqlSelecteCountWithString:continueSelect];
    
    if (continueConut>0) {
        
        self.continueLabel.text = [NSString stringWithFormat:@"%zd位客户即将可续贷，快来看看吧",continueConut];
        
    }else{
        
        self.continueLabel.text = @"暂无续贷提醒";
    }
    
    
    //首期还款
    
    NSString *firstSelect = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE iRemindType=3 AND iSwitch=1 AND cRemindDate Between '%@' and '%@'",ZJRemindTableName,nowString,nowAfter];
    
    NSInteger firstCount = [ZJFMdb sqlSelecteCountWithString:firstSelect];
    
    if (firstCount>0) {
        
        self.firstLabel.text = [NSString stringWithFormat:@"%zd位客户即将到达首期还款日，快来看看吧",firstCount];
        
    }else{
        
        self.firstLabel.text = @"暂无首期客户首期还款";
    }
    
    //*********************************************

    //待办事宜
    
    NSString *gtasksSelect = [ NSString stringWithFormat:@"SELECT COUNT (*) FROM %@ WHERE completeOrGtasks=0",ZJGtasksTableName];
    
    NSInteger gtasksCount = [ZJFMdb sqlSelecteCountWithString:gtasksSelect];
    
    if (gtasksCount>0) {
        
        self.gtasksMarkerButton.hidden = NO;
        
        NSString *gtasksString = [NSString stringWithFormat:@"%zd",gtasksCount];
        
        [self.gtasksMarkerButton setTitle:gtasksString forState:UIControlStateNormal];
        
    }else{
        
        self.gtasksMarkerButton.hidden = YES;
        
    }

}
-(void)showTodayData{
    
    NSDate *nowDate = [NSDate new];

    NSString *nowString = [nowDate zj_getStringFromDatWithFormatter:@"yyyy-MM-dd"];

    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *birthmark = [defaults objectForKey:@"birthMarker"];
    
    NSString *firstmark = [defaults objectForKey:@"firstMarker"];
    NSString *continuemark = [defaults objectForKey:@"continueMarker"];
    
    NSString *nowBString = [nowDate zj_getStringFromDatWithFormatter:@"MM-dd"];

    

    
    //当天的生日提醒
    if (![birthmark isEqualToString:nowString]) {
        
        NSString *markerBirthSelect = [NSString stringWithFormat:@"SELECT COUNT (*) FROM %@ WHERE iRemindType=1 AND iSwitch=1 AND cRemindDate='%@'",ZJRemindTableName,nowBString];
        
        NSInteger birthC = [ZJFMdb sqlSelecteCountWithString:markerBirthSelect];
        
        if (birthC>0) {
            //SELECT COUNT (*) FROM crm_Remind WHERE iRemindType=1 AND iSwitch=1 AND cRemindDate='12-07'
            self.birthMarkerButton.hidden = NO;
            NSString *title = [NSString stringWithFormat:@"%zd",birthC];
            [self.birthMarkerButton setTitle:title forState:UIControlStateNormal];
        }
        
        [defaults setObject:nowString forKey:@"birthMarker"];
        
        [defaults synchronize];
        
    }
    //当天的续贷提醒
    if (![continuemark isEqualToString:nowString]) {
        NSString *markerContinueSelect = [NSString stringWithFormat:@"SELECT COUNT (*) FROM %@ WHERE iRemindType=2 AND iSwitch=1 AND cRemindDate='%@'",ZJRemindTableName,nowString];
        
        
        NSInteger continueC = [ZJFMdb sqlSelecteCountWithString:markerContinueSelect];
        
        if (continueC>0) {
            
            self.continueMarkerButton.hidden = NO;
            
            NSString *title = [NSString stringWithFormat:@"%zd",continueC];
            
            [self.continueMarkerButton setTitle:title forState:UIControlStateNormal];
        }
        [defaults setObject:nowString forKey:@"continueMarker"];
        
        [defaults synchronize];
        
    }
    //当天的首期还款提醒
    if (![firstmark isEqualToString:nowString]) {
        
        NSString *markerFirstSelect = [NSString stringWithFormat:@"SELECT COUNT (*) FROM %@ WHERE iRemindType=3 AND iSwitch=1 AND cRemindDate='%@'",ZJRemindTableName,nowString];
        
        
        NSInteger firstC = [ZJFMdb sqlSelecteCountWithString:markerFirstSelect];
        
        if (firstC>0) {
            
            self.firstMarkerButton.hidden = NO;
            
            NSString *title = [NSString stringWithFormat:@"%zd",firstC];
            
            [self.firstMarkerButton setTitle:title forState:UIControlStateNormal];
        }
        //
        [defaults setObject:nowString forKey:@"firstMarker"];
        
        [defaults synchronize];
        
    }

}
//获取季度数据
-(NSString *)getMonthFromSeason:(NSInteger)seasonIndex{
    
    NSString *month = nil;
    
    if (seasonIndex ==1 ){
        
        month = [NSString stringWithFormat:@"(cLoanDate like '%zd-01%%' OR cLoanDate like '%zd-02%%' OR cLoanDate like '%zd-03%%')",_year,_year,_year];
    }else if (seasonIndex ==2){
        month = [NSString stringWithFormat:@"(cLoanDate like '%zd-04%%' OR cLoanDate like '%zd-05%%' OR cLoanDate like '%zd-06%%')",_year,_year,_year];
    }else if (seasonIndex ==3){
        month = [NSString stringWithFormat:@"(cLoanDate like '%zd-07%%' OR cLoanDate like '%zd-08%%' OR cLoanDate like '%zd-09%%')",_year,_year,_year];
    }else{
        month = [NSString stringWithFormat:@"(cLoanDate like '%zd-10%%' OR cLoanDate like '%zd-11%%' OR cLoanDate like '%zd-12%%')",_year,_year,_year];
    }
    return month;
}


#pragma mark   searchBad 代理方法
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.searchView.showsCancelButton = YES;
    for (UIView *searchViews in searchBar.subviews) {
        for (UIView *view in searchViews.subviews) {
            //是按钮
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                [button setTitle:@"取消" forState:UIControlStateNormal];
                [button setTitleColor:ZJColor505050 forState:UIControlStateNormal];
                [button setTitleColor:ZJColor505050 forState:UIControlStateHighlighted];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
            }
        }
    }
    UIView *coverView = [[UIView alloc]init];
    [self.view addSubview:coverView];
    self.coverView = coverView;
    coverView.backgroundColor = ZJRGBColor(220, 220, 220, 0.7);
    coverView.x = 0;
    coverView.y = CGRectGetMaxY(self.searchView.frame)+20;
    coverView.width = zjScreenWidth;
    coverView.height = zjScreenHeight - coverView.y - 49;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = nil;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.searchView.showsCancelButton = NO;

    [self.searchView resignFirstResponder];
    [self.coverView removeFromSuperview];
    self.coverView = nil;
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.searchView.showsCancelButton = NO;
  
    [self.searchView resignFirstResponder];
    [self.coverView removeFromSuperview];
    self.coverView = nil;
    
    NSString *select = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE (cName LIKE '%%%@%%' OR cCardID LIKE '%%%@%%' OR cPhone LIKE '%%%@%%')",ZJCustomerTableName,searchBar.text,searchBar.text,searchBar.text];
    
    ZJCustomerViewController *searchC = [[ZJCustomerViewController alloc]init];
    
    searchC.enterModel = FirstSearchModel;
    searchC.select = select;
//    searchC.enterModel = FirstFollowingModel;
    
    searchC.naviTitle = @"客户被搜索到";
    searchBar.text = nil;
    
    [self.navigationController pushViewController:searchC animated:YES];
}

//-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    
//    NSString *temp = [searchBar.text stringByAppendingString:text];
//    
//    if (temp.length<=25) {
//        
//        return YES;
//    }
//    
//    return NO;
//
//}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end



















