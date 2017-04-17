//
//  ZJGtasksTableViewCell.m
//  CRM
//
//  Created by mini on 16/10/25.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJGtasksTableViewCell.h"
#import <Masonry.h>
#import "ZJGtasksTableInfo.h"
#import "NSDate+Category.h"
@interface ZJGtasksTableViewCell()
@property(weak,nonatomic)UIView *CView;
//
@property(weak,nonatomic)IBOutlet UILabel *titleLabel;

//**子标题**//
@property(nonatomic,weak) IBOutlet UILabel *subLabel;

//分割线
@property(weak,nonatomic)UIView *spaView;
@end

@implementation ZJGtasksTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    UIView *view = [[UIView alloc]init];
    [self.contentView addSubview:view];
    self.CView = view;
    view.backgroundColor = [UIColor yellowColor];
    
    //大标题
    UILabel *label = [[UILabel alloc]init];
    self.titleLabel = label;
    [self.CView addSubview:label];
    label.textColor = ZJColor505050;
    label.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    
    //小标题
    UILabel *sub = [[UILabel alloc]init];
    self.subLabel = sub;
    [self.CView addSubview:sub];
    sub.textColor = ZJColor505050;
    sub.font = [UIFont systemFontOfSize:ZJTextSize35PX];
    //分割线
//    UIView *spaLine = [[UIView alloc]init];
//    self.spaView = spaLine;
//    [self.CView addSubview:spaLine];
//    spaLine.backgroundColor = ZJColorDCDCDC;
//    
}

-(void)setModel:(ZJGtasksTableInfo *)model{
    _model = model;
    self.titleLabel.text = model.contentText;
    NSString *nowDateString = [[[NSDate alloc]init] zj_getStringFromDatWithFormatter:@"yyyy年MM月dd日"];
    NSDate *nowDate = [nowDateString zj_getDateFromStringWithFormatter:@"yyyy年MM月dd日"];
    NSDate *modeDate = [model.dateString zj_getDateFromStringWithFormatter:@"yyyy年MM月dd日"];
    NSDateComponents *com = [modeDate zj_intervalDeadlineFrom:nowDate calendarUnit:NSCalendarUnitDay];
        
    NSString *dateString = nil;
    if (com.day == 0) {
        dateString = @"今天";
    }else if (com.day == 1){
        dateString = @"明天";
    }else if (com.day ==2){
        
        dateString = @"后天";
    }else{
        
        dateString = [modeDate zj_getStringFromDatWithFormatter:@"MM月dd天"];
    }
    self.subLabel.text = [NSString stringWithFormat:@"%@ %@ %@",dateString,model.weekString,model.timeString];
    
}
//-(void)layoutSubviews{
//    
//    self.CView.frame = CGRectMake(0, 0, self.width, self.height);
//    
//    self.titleLabel.frame = CGRectMake(ZJmargin40, PX2PT(50), zjScreenWidth-2*ZJmargin40, PX2PT(45));
//    
//    self.subLabel.frame = CGRectMake(ZJmargin40, CGRectGetMaxY(self.titleLabel.frame)+5,  zjScreenWidth-2*ZJmargin40, PX2PT(35));
//    
//    self.spaView.frame = CGRectMake(0, self.height-1, zjScreenWidth, 1);
//    
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
