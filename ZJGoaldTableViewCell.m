//
//  ZJGoaldTableViewCell.m
//  CRM
//
//  Created by mini on 16/10/24.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJGoaldTableViewCell.h"
#import "ZJGoalTableInfo.h"


@interface ZJGoaldTableViewCell ()

//**类型  月度  季度  年**//
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

//**goal目标金额**//
@property (weak, nonatomic) IBOutlet UILabel *goalCountLabel;

//**已完成目标**//
@property (weak, nonatomic) IBOutlet UILabel *completeCountLabel;
//百分比
@property (weak, nonatomic) IBOutlet UILabel *presentLabel;

//目标视图
@property (weak, nonatomic) IBOutlet UIView *goalView;

//完成视图的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *completeViewWidth;

//完成的进度图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indexViewX;
//左边指示器View
@property (weak, nonatomic) IBOutlet UIView *indexView;



@end

@implementation ZJGoaldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(ZJGoalTableInfo *)model{
    _model = model;
    self.indexView.hidden = model.hidden;
    
    
    if (model.isSeason) {
        NSString *seasonstring = [model.tag zj_getSeasonFromIndex];

        self.typeLabel.text = [NSString stringWithFormat:@"%@年%@",model.year,seasonstring];
        
    }else{
        
        self.typeLabel.text = model.tag;
        
    }

    self.goalCountLabel.text = [NSString stringWithFormat:@"%zd万",model.goalCount];
    
    self.completeCountLabel.text = [NSString stringWithFormat:@"%.1f万",model.completeCount];
    
    CGFloat present = model.completeCount/model.goalCount;
    
    self.presentLabel.text = [NSString stringWithFormat:@"%.1f%%",present*100];
    present = present>1?1:present;
    self.completeViewWidth.constant = (zjScreenWidth-2*ZJmargin40) *present;
    
    self.indexViewX.constant =5+self.completeViewWidth.constant;
    
}

@end


















