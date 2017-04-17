//
//  ZJRemindView.m
//  CRM
//
//  Created by mini on 16/9/23.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJRemindView.h"
#import <Masonry.h>
@interface ZJRemindView()

{
    UIImageView *_imgView;
    UILabel *_titleLabel;
    
    UILabel *_detailLabel;
    CGFloat iconWH;
    
}

@end
@implementation ZJRemindView

-(instancetype)initWithViewType:(ZJRemindViewType)viewType ONImgName:(NSString *)ONName OFFImgName:(NSString *)OFFName title:(NSString *)title{
    
    if (self = [super init]) {
        
        self.viewType = viewType;
        self.backgroundColor = ZJColorFFFFFF;
        //图片
        _imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:ONName]];
        iconWH = _imgView.image.size.width;
        [self addSubview:_imgView];
        //大标题
        _titleLabel = [[UILabel alloc]init];
        [self addSubview:_titleLabel];
        [_titleLabel zj_labelText:title textColor:ZJColor505050 textSize:ZJTextSize45PX];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        //小标题
        _detailLabel = [[UILabel alloc]init];
        [self addSubview:_detailLabel];
        _detailLabel.textColor =ZJRGBColor(180, 180, 180, 1.0);
        _detailLabel.font = [UIFont systemFontOfSize:ZJTextSize35PX];
        _detailLabel.textAlignment = NSTextAlignmentLeft;

        
        _clickButton = [[UIButton alloc]init];
        [_clickButton setImage:[UIImage imageNamed:@"arrows"] forState:UIControlStateNormal];
        _clickButton.tag = viewType;
        _clickButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self addSubview:_clickButton];
        //判断是否有swich
//        if (viewType !=RemindFollowType) {
//            
//            _swich = [[UISwitch alloc]init];
//            _swich.on = NO;
//            
//            [_swich addTarget:self action:@selector(swichChange:) forControlEvents:UIControlEventValueChanged];
//            
//            [_clickButton addSubview:_swich];
//            
//        }
    }
    
    return self;
}

-(void)swichChange:(UISwitch *)switchView{
    
}
//
-(void)setDetailText:(NSString *)detailText{
    
    _detailText = detailText;
    _detailLabel.text = detailText;
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat PX60 = PX2PT(60);
    //图片
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).offset(ZJmargin40);
        make.centerY.mas_equalTo(self);
//        make.width.height.mas_equalTo(iconWH);
    }];
    //点击按钮
    [_clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self.width -ZJmargin40);
        
        
    }];
    //大标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_imgView.mas_right).offset(PX60);
        make.top.mas_equalTo(self.mas_top).offset(PX60);
        make.height.mas_equalTo(ZJTextSize45PX);
        make.right.mas_equalTo(200);
        
    }];
    //小标题
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_imgView.mas_right).offset(PX60);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(PX2PT(20));
        make.height.mas_equalTo(PX2PT(35));
        make.width.mas_equalTo(200);
    }];

    //选择开关
//    
//    if (_viewType != RemindFollowType) {
//        
//        [_swich mas_makeConstraints:^(MASConstraintMaker *make) {
//          
//            make.centerY.mas_equalTo(_clickButton);
//            make.right.mas_equalTo(_clickButton.mas_right).offset(-ZJmargin40-31);
//            
//        }];
//    }
    
}


@end
