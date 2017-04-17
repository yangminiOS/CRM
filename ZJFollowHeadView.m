//
//  ZJFollowHeadView.m
//  CRM
//
//  Created by mini on 16/11/5.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJFollowHeadView.h"
#import "ZJFollowUpTableInfo.h"
@interface  ZJFollowHeadView()

//日期label
@property(nonatomic,strong) UILabel *dateLabel;

//**右边图片**//
@property(nonatomic,strong) UIImageView *rightImageView;

@end;
@implementation ZJFollowHeadView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = ZJColor00D3A3;
//        [self setupUI];
        
    }
    return self;
}
/*

-(void)setupUI{
    
    _dateLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_dateLabel];
//    _dateLabel.textColor = ZJColorFFFFFF;
    _dateLabel.textColor = [UIColor redColor];

    _dateLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    
    _rightImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_rightImageView];
    _rightImageView.image = [UIImage imageNamed:@"calendar"];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _dateLabel.height = 15;
    _dateLabel.width = 150;
    _dateLabel.centerY = self.centerY;
    _dateLabel.centerX = self.centerX;
    
    _rightImageView.width = PX2PT(50);
    _rightImageView.height = PX2PT(50);
    _rightImageView.centerY = self.centerY;
    _rightImageView.x = self.width - PX2PT(90);
    
}

-(void)setModel:(ZJFollowUpTableInfo *)model{
    _model = model;
    _dateLabel.text = [NSString stringWithFormat:@"%@ %@",model.cLogDate,model.cWeekDay];
    
}
 
 */
@end
