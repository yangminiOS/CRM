//
//  ZJFirstAndContiueCell.m
//  CRM
//
//  Created by 杨敏 on 16/11/11.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJFirstAndContiueCell.h"
#import "ZJcustomerTableInfo.h"
#import "NSDate+Category.h"



@interface ZJFirstAndContiueCell ()

@property (strong, nonatomic)  UIImageView *iconImgView;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *phoneLabel;
@property (strong, nonatomic)  UILabel *dateLabel;
@property (strong, nonatomic)  UIImageView *sexImgView;
@property (strong, nonatomic)  UILabel *refundDateLabel;

//**选择**//
@property(nonatomic,strong) UISwitch *switchView;

@property (strong, nonatomic)  UIButton *backContentView;
//**发短信**//
@property(nonatomic,strong) UIButton *sendMsgButton;

//**打电话**//
@property(nonatomic,strong) UIButton *cellPhoneButton;

//**分割性**//
@property(nonatomic,weak) UIView *line;

//**判断是否滑动**//
@property(nonatomic,assign)BOOL slide;
@end

@implementation ZJFirstAndContiueCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
        
    }
    
    return self;
}

-(void) setupUI{
    
    UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipView:)];
    [leftSwip setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    UISwipeGestureRecognizer *rightSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipView:)];
    [rightSwip setDirection:UISwipeGestureRecognizerDirectionRight];
    
    
    
    //打电话
    _cellPhoneButton = [[UIButton alloc]init];
    [self.contentView addSubview:_cellPhoneButton];
    [_cellPhoneButton setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [_cellPhoneButton setBackgroundColor:ZJColor00D3A3];
    [_cellPhoneButton addTarget:self action:@selector(clickTellPhoneButton:) forControlEvents:UIControlEventTouchUpInside];
    //发短信
    _sendMsgButton = [[UIButton alloc]init];
    [self.contentView addSubview:_sendMsgButton];
    [_sendMsgButton setImage:[UIImage imageNamed:@"note"] forState:UIControlStateNormal];
    [_sendMsgButton setBackgroundColor:ZJRGBColor(102, 214, 255, 1.0)];
    [_sendMsgButton addTarget:self action:@selector(clickSendMsgButton:) forControlEvents:UIControlEventTouchUpInside];
    //n内容视图
    _backContentView = [[UIButton alloc]init];
    [self.contentView addSubview:_backContentView];
    _backContentView.backgroundColor = ZJColorFFFFFF;
    [_backContentView addGestureRecognizer:leftSwip];
    [_backContentView addGestureRecognizer:rightSwip];
    [_backContentView addTarget:self action:@selector(clickContentView:) forControlEvents:UIControlEventTouchUpInside];
    //图像
    _iconImgView = [[UIImageView alloc]init];
    [ _backContentView addSubview:_iconImgView];
    _iconImgView.layer.cornerRadius = 8;
    _iconImgView.clipsToBounds = YES;
    //姓名
    _nameLabel = [[UILabel alloc]init];
    [_backContentView addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = ZJColor505050;
    //性别
    _sexImgView = [[UIImageView alloc]init];
    [_backContentView addSubview:_sexImgView];
    //手机号码
    _phoneLabel = [[UILabel alloc]init];
    [_backContentView addSubview:_phoneLabel];
    _phoneLabel.font = [UIFont systemFontOfSize:15];
    _phoneLabel.textColor = ZJColor505050;
    //放款日
    _dateLabel = [[UILabel alloc]init];
    [_backContentView addSubview:_dateLabel];
    _dateLabel.font = [UIFont systemFontOfSize:15];
    _dateLabel.textColor = ZJColor505050;
    //首期还款日
    _refundDateLabel = [[UILabel alloc]init];
    [_backContentView addSubview:_refundDateLabel];
    _refundDateLabel.font = [UIFont systemFontOfSize:15];
    _refundDateLabel.textColor = ZJColor505050;
    //分割性
    UIView *line = [[UIView alloc]init];
    [_backContentView addSubview:line];
    line.backgroundColor = ZJColorDCDCDC;
    self.line = line;
    
    //seitchView
    self.switchView = [[UISwitch alloc]init];
    [_backContentView addSubview:_switchView];
    self.switchView.on = YES;
    [self.switchView addTarget:self action:@selector(clickSwitchView:) forControlEvents:UIControlEventValueChanged];
    
    
}

-(void)setModel:(ZJcustomerTableInfo *)model{
    
    _model = model;
    
    if (self.model.iconPath.length>0) {
        
        _iconImgView.image = [UIImage imageWithContentsOfFile:_model.iconPath];

    }else{
        _iconImgView.image = [UIImage imageNamed:@"KHCD-head-portrait"];

    }
    
    //头像
    if (model.iSex==0) {
        _sexImgView.image = [UIImage imageNamed:@"MAN_iocn"];
        
    }else{
        _sexImgView.image = [UIImage imageNamed:@"WOMAN_icon"];

    }
    _nameLabel.text = model.cName;
    [_nameLabel zj_adjustWithMin];
    
    _phoneLabel.text = model.cPhone;
    [_phoneLabel zj_adjustWithMin];
    
    _dateLabel.text = [NSString stringWithFormat:@"放款日：%@",model.cLoanDate];
    [_dateLabel zj_adjustWithMin];
}

-(void)setFirstDateString:(NSString *)firstDateString{
    
    _firstDateString = firstDateString;
    NSString *temp = [[NSDate date] zj_isDateString:firstDateString];
    _refundDateLabel.text = [NSString stringWithFormat:@"首期还款日：%@",temp];
    [_refundDateLabel zj_adjustWithMin];
}

-(void)setContinueString:(NSString *)continueString{
    _continueString = continueString;
    NSString *temp = [[NSDate date] zj_isDateString:continueString];
    _refundDateLabel.text = [NSString stringWithFormat:@"可续贷时间：%@",temp];
    [_refundDateLabel zj_adjustWithMin];
}

//左滑
-(void)leftSwipView:(UISwipeGestureRecognizer *)leftSwip{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _backContentView.x = -140;
        
    }];
    self.slide = YES;
}
//右滑
-(void)rightSwipView:(UISwipeGestureRecognizer *)rightSwip{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _backContentView.x =0;
        
    }];
    self.slide = NO;
}
#pragma mark   发短信
- (void)clickSendMsgButton:(UIButton *)button {
    NSString *url=[NSString stringWithFormat:@"sms://%@",self.model.cPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark   打电话
- (void)clickTellPhoneButton:(UIButton *)button {
    
    NSString *url = [NSString stringWithFormat:@"telprompt://%@",self.model.cPhone];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    
}

#pragma mark   点击内容视图
-(void)clickContentView:(UIButton *)button{
    
    if (self.slide) {
        
        [self rightSwipView:nil];
    }else{
        
        [self.delegate ZJFirstAndContiueCell:self viewTag:self.tag];
    }
}

#pragma mark   点击switchview
-(void)clickSwitchView:(UISwitch *)switchView{
    
    [self.delegate ZJFirstAndContiueCell:self viewTag:self.tag Switch:switchView.on];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _sendMsgButton.frame = CGRectMake(zjScreenWidth-PX2PT(210), 0, PX2PT(210), self.height);
    
    _cellPhoneButton.frame = CGRectMake(zjScreenWidth - PX2PT(420), 0, PX2PT(210), self.height);

    _backContentView.frame = self.bounds;

    _iconImgView.frame = CGRectMake(ZJmargin40, ZJmargin40, PX2PT(192), PX2PT(192));

    CGFloat nameX=2*ZJmargin40 +PX2PT(192);
    _nameLabel.x =nameX;
    _nameLabel.y = ZJmargin40;
    
    CGFloat sexX = CGRectGetMaxX(_nameLabel.frame)+10;
    _sexImgView.frame = CGRectMake(sexX, ZJmargin40, PX2PT(50), PX2PT(50));

    _phoneLabel.x = nameX;
    _phoneLabel.y = CGRectGetMaxY(_nameLabel.frame);

    _dateLabel.x = nameX;
    _dateLabel.y = CGRectGetMaxY(_phoneLabel.frame)+ZJmargin40;
    
    _refundDateLabel.x = ZJmargin40;
    _refundDateLabel.y = CGRectGetMaxY(_iconImgView.frame)+ZJmargin40;
    
    _line.frame = CGRectMake(0, self.height -1, zjScreenWidth, 1);
    
    _switchView.x = self.width - 51 - ZJmargin40 ;
    
    _switchView.centerY = _backContentView.centerY;
}

@end
