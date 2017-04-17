//
//  ZJSelectTableViewCell.m
//  CRM
//
//  Created by 杨敏 on 16/11/9.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJSelectTableViewCell.h"
#import "ZJCustomerItemsTableInfo.h"
@interface ZJSelectTableViewCell ()

//状态
@property(nonatomic,strong) UILabel *stateLabel;

//**对号**//
@property(nonatomic,strong)UIImageView *rightImgView;


@end

@implementation ZJSelectTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
        
    }
    return self;
}

-(void)setupUI{
    
    _stateLabel = [[UILabel alloc]init];
    
    _stateLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    
    _stateLabel.textColor = ZJColor505050;
    
    [self.contentView addSubview:_stateLabel];
    
    _rightImgView = [[UIImageView alloc]init];
    
    _rightImgView.image =[UIImage imageNamed:@"choose"];
    
    _rightImgView.hidden = YES;
    
    [self.contentView addSubview:_rightImgView];
    
}

-(void)setModel:(ZJCustomerItemsTableInfo *)model{
    
    _model = model;
    
    _stateLabel.text = model.itemString;
    
    [_stateLabel zj_adjustWithMin];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _stateLabel.x = PX2PT(81);
    
    _stateLabel.centerY = PX2PT(128)/2.0;
    
    _rightImgView.width = PX2PT(60);
    
    _rightImgView.height = PX2PT(60);
    _rightImgView.x = zjScreenWidth - PX2PT(100);
    
    _rightImgView.centerY = _stateLabel.centerY;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    _rightImgView.hidden = !self.selected;
    _stateLabel.textColor = selected?ZJColor00D3A3:ZJColor505050;
    
}

@end
