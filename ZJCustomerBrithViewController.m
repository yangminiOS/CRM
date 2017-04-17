//
//  ZJCustomerBrithViewController.m
//  CRM
//
//  Created by mini on 16/10/12.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJCustomerBrithViewController.h"
#import "NSDate+Category.h"

@interface ZJCustomerBrithViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sexImgView;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;//多少岁

@property (weak, nonatomic) IBOutlet UILabel *bitrthDayLabel;//距离
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;//多少天

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间

@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

@property (weak, nonatomic) IBOutlet UIButton *switchButton;


//**判断是否开启提醒**//
@property(nonatomic,assign)NSInteger isSwitch;

@end

@implementation ZJCustomerBrithViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航
    [self setupNavi];
    //
    [self setupUI];

}
#pragma mark   设置导航
-(void)setupNavi{
    
    self.navigationItem.title=@"生日提醒";
    
    UIButton *back = [UIButton zj_creatDefaultLeftButton];
    
    [back addTarget:self action:@selector(birthBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    
}

#pragma mark   返回

-(void)birthBack{
    
    [self.delegate ZJCustomerBrith:self switctButton:self.isSwitch];
    
    [self.navigationController popViewControllerAnimated:YES];

    
}

-(void)setupUI{
    
    self.iconImgView.layer.cornerRadius = 3;
    
    [self.iconImgView clipsToBounds];
    
    //头像
    if (self.cPhotoUrl.length>0) {
        
        self.iconImgView.image = [UIImage imageWithContentsOfFile:self.cPhotoUrl];
    }else{
        self.iconImgView.image = [UIImage imageNamed:@"UN-remindhead-portrait"];
    }
    //姓名
    self.nameLabel.text = self.cName;
    //性别
    if (self.iSex ==0) {
        
        self.sexImgView.image = [UIImage imageNamed:@"UN-MAN-USER"];
    }else{
        self.sexImgView.image = [UIImage imageNamed:@"UN-WOMAN-USER"];
    }
    
    NSDate *nowDate = [NSDate new];
    
    NSDate *birthDate = [self.cBirthDay zj_getDateFromStringWithFormatter:@"yyyy-MM-dd"];
    
    NSDateComponents *cmpYear = [nowDate zj_intervalDeadlineFrom:birthDate calendarUnit:NSCalendarUnitYear];
    
    //一年后的生日日期
    
    NSString *afterYear = [birthDate zj_getDateAfterYears:cmpYear.year+2];
    
    NSDate *afterBirthDate = [afterYear zj_getDateFromStringWithFormatter:@"yyyy-MM-dd"];
    
    NSDateComponents *cmpday = [afterBirthDate zj_intervalDeadlineFrom:nowDate calendarUnit:NSCalendarUnitDay];
    
    
    NSInteger year = 0;
    NSInteger day = 0;
    
    if (cmpday.month>365) {
        
        year = cmpYear.year+1;
        day = cmpday.day-365;
        
    }else{
        
        year =cmpYear.year+2;
        day = cmpday.day+1;
    }
    
    
    self.yearLabel.text = [NSString stringWithFormat:@"%zd岁",year];
    
    self.bitrthDayLabel.text = [NSString stringWithFormat:@"距离%zd岁生日",year];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    self.dayLabel.text = [NSString stringWithFormat:@"%zd天",day];
    
    self.timeLabel.text = self.cBirthDay;
    
    
    if (self.openRemind) {
        
        [self clickSwitchButton:self.switchButton];
    }
    
}

#pragma mark   点击开启和关闭开关

- (IBAction)clickSwitchButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        self.isSwitch =1;
    }else{
        self.isSwitch = 0;
    }
    if (!sender.selected) {
        //头像
        if (self.cPhotoUrl.length>0) {
            
            self.iconImgView.image = [UIImage imageWithContentsOfFile:self.cPhotoUrl];
        }else{
            self.iconImgView.image = [UIImage imageNamed:@"UN-remindhead-portrait"];
        }
        
        //性别
        if (self.iSex ==0) {
            
            self.sexImgView.image = [UIImage imageNamed:@"UN-MAN-USER"];
        }else{
            
            self.sexImgView.image = [UIImage imageNamed:@"UN-WOMAN-USER"];
        }
        
    }else{
        
        //头像
        if (self.cPhotoUrl.length>0) {
            
            self.iconImgView.image = [UIImage imageWithContentsOfFile:self.cPhotoUrl];
        }else{
            self.iconImgView.image = [UIImage imageNamed:@"remindhead-portrait"];
        }
        
        //性别
        if (self.iSex ==0) {
            
            self.sexImgView.image = [UIImage imageNamed:@"MAN_iocn"];
        }else{
            
            self.sexImgView.image = [UIImage imageNamed:@"WOMAN_icon"];
        }
        
        
    }
    
    self.remindLabel.text = sender.selected?@"点击关闭生日提醒":@"点击开启生日提醒";
}




@end
