//
//  ZJCustomerTableViewCell.m
//  CRM
//
//  Created by 杨敏 on 16/10/20.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJCustomerTableViewCell.h"
#import "ZJcustomerTableInfo.h"
#import <AVFoundation/AVFoundation.h>
#import "ZJDirectorie.h"

@interface ZJCustomerTableViewCell()//<AVAudioPlayerDelegate>


//客户备注信息
@property(strong,nonatomic)UIButton *CMsgButton;
//备注信息
@property(strong,nonatomic)UIButton *msgButton;

//**录音1**//
@property(nonatomic,strong)UIButton *recodeButton1;

//**录音2**//
@property(nonatomic,strong)UIButton *recodeButton2;

//**录音3**//
@property(nonatomic,strong)UIButton *recodeButton3;

//**装Button数组**//
@property(nonatomic,strong)NSMutableArray *buttonArray;

//**cmsgHeight**//
@property(nonatomic,assign)CGFloat  cMsgButtonH;
//**msgHeight**//
@property(nonatomic,assign)CGFloat  msgButtonH;

//**msgButtonY**//
@property(nonatomic,assign)CGFloat  msgButtonY;

//**录音Y**//
@property(nonatomic,assign)CGFloat recodeButtonY;

//分割线
@property(nonatomic,strong)UIView *sepLine;
//**bofangqi**//
@property(nonatomic,strong) AVAudioPlayer *player;


@end

@implementation ZJCustomerTableViewCell

-(NSMutableArray *)buttonArray{
    
    if (!_buttonArray) {
        
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
        
    }
    
    return self;
}

-(void)setupUI{
    //小信息  客户状态备注
    _CMsgButton = [[UIButton alloc]init];
    [self setMsgButton:_CMsgButton];
    _CMsgButton.backgroundColor = ZJBackGroundColor;
    //大信息
    _msgButton = [[UIButton alloc]init];
    [self setMsgButton:_msgButton];
    _msgButton.backgroundColor = ZJBackGroundColor;

    //录音
    _recodeButton1 = [[UIButton alloc]init];
    _recodeButton2 = [[UIButton alloc]init];
    _recodeButton3 = [[UIButton alloc]init];


    [self setRecodeButton:self.recodeButton1];
    [self setRecodeButton:self.recodeButton2];
    [self setRecodeButton:self.recodeButton3];
    [self.buttonArray addObject:_recodeButton1];
    [self.buttonArray addObject:_recodeButton2];
    [self.buttonArray addObject:_recodeButton3];

    //分割线
    _sepLine = [[UIView alloc]init];
    [self.contentView addSubview:_sepLine];
    _sepLine.backgroundColor = ZJColorDCDCDC;

    
}
//设置备注信息Button
-(void)setMsgButton:(UIButton *)button{
    button.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:button];
    [button setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.backgroundColor = ZJColorDCDCDC;
    button.layer.cornerRadius = 3;
    button.clipsToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    button.titleLabel.numberOfLines = 0;
    button.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);

}
//设置录音Button
-(void)setRecodeButton:(UIButton *)button{
    [self.contentView addSubview:button];
    //边框
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:1.0];
    button.layer.borderColor = ZJColor505050.CGColor;
    //    圆角
    button.layer.cornerRadius = PX2PT(10);
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [button setImage:[UIImage imageNamed:@"trumpet"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [button setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
}

-(void)setModel:(ZJcustomerTableInfo *)model{
    _model = model;
    self.msgButtonY = 0;
    _recodeButton1.hidden = YES;
    _recodeButton2.hidden = YES;
    _recodeButton3.hidden = YES;
    _msgButton.hidden = YES;
    _CMsgButton.hidden = YES;
    //客户状态备注信息
    _msgButtonY = ZJmargin40;
    self.recodeButtonY = ZJmargin40;
    if (model.cCustomerState_Remark.length<1&&model.cCustomerRemark_Text.length<1&&model.recodePath.count<1) {
        _CMsgButton.hidden = NO;
        [_CMsgButton setTitle:@"暂无备注" forState:UIControlStateNormal];

        _cMsgButtonH = 20;
        return;
    }
    if (model.cCustomerState_Remark.length>1) {
        _CMsgButton.hidden = NO;
        [_CMsgButton setTitle:model.cCustomerState_Remark forState:UIControlStateNormal];
        _cMsgButtonH = [model.cCustomerState_Remark zj_getStringRealHeightWithWidth:zjScreenWidth -2*ZJmargin40-10 fountSize:11]+10;
        _msgButtonY+=_cMsgButtonH+ZJmargin40;
        self.recodeButtonY +=_cMsgButtonH+ZJmargin40;

    }
    //客户备注信息
    if (model.cCustomerRemark_Text.length>1) {
        _msgButton.hidden = NO;
        [_msgButton setTitle:model.cCustomerRemark_Text forState:UIControlStateNormal];
        _msgButtonH = [model.cCustomerRemark_Text zj_getStringRealHeightWithWidth:zjScreenWidth -2*ZJmargin40-10 fountSize:11]+10;
        self.recodeButtonY+=_msgButtonH+ZJmargin40;
    }
    //录音信息
    for (NSInteger i = 0; i<model.recodePath.count; i++) {
        UIButton *button = self.buttonArray[i];
        button.tag = i;
        button.hidden = NO;
//        [button setBackgroundImage:[UIImage imageNamed:@"Voice-icon"] forState:UIControlStateNormal];
        
        NSString *path = [ZJDirectorie getVoicePathWithDirectoryName:self.model.GUID];
        path = [path stringByAppendingPathComponent:model.recodePath[i]];


        NSInteger time =[[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:path isDirectory:YES] error:nil].duration;
        NSString *title = [NSString stringWithFormat:@"%zd\"", time];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickPlaterButton:) forControlEvents:UIControlEventTouchUpInside];
        button.width = 60 + (self.width - 2*ZJmargin40 - 60)*time/180;

    }
    
}
#pragma mark   点击播放按钮
-(void)clickPlaterButton:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        NSString *path = [ZJDirectorie getVoicePathWithDirectoryName:self.model.GUID];
        path = [path stringByAppendingPathComponent:_model.recodePath[button.tag]];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:path isDirectory:YES] error:nil];
        [_player play];
        
    }else{
        
        [_player pause];
    }

}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _sepLine.frame = CGRectMake(0, 0, zjScreenWidth, 0.3);
    
    _CMsgButton.frame = CGRectMake(ZJmargin40, ZJmargin40, zjScreenWidth - 2*ZJmargin40, self.cMsgButtonH);
    
    _msgButton.x = ZJmargin40;
    _msgButton.y  = _msgButtonY;
    _msgButton.height = self.msgButtonH;
    _msgButton.width = zjScreenWidth - 2*ZJmargin40;
        
    for (NSInteger i = 0; i<self.buttonArray.count; i++) {
        
        UIButton *button = self.buttonArray[i];
        
        button.x =ZJmargin40;
        button.y = self.recodeButtonY+(30+ZJmargin40)*i;
        button.height = 30;
        
//        button.frame = CGRectMake(ZJmargin40, self.recodeButtonY+(40+ZJmargin40)*i, 246, 40);
    }
}


@end
