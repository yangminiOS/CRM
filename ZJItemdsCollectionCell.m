//
//  ZJHeadCollectionCell.m
//  CRM
//
//  Created by mini on 16/10/10.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJItemdsCollectionCell.h"

@implementation ZJItemdsCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.itemLabel = [[UILabel alloc]initWithFrame:self.contentView.bounds];
        [self addSubview:self.itemLabel];
        self.itemLabel.backgroundColor = ZJRGBColor(178, 238, 223, 1.0);
        self.itemLabel.textAlignment = NSTextAlignmentCenter;
        self.itemLabel.font = [UIFont systemFontOfSize:ZJTextSize35PX];
        self.itemLabel.layer.cornerRadius = 3;
        self.itemLabel.clipsToBounds = YES;
        self.itemLabel.textColor = ZJColor505050;
        
//        self.itemButton = [[UIButton alloc]initWithFrame:self.contentView.bounds];
//        [self addSubview:self.itemButton];
//        [self.itemButton setBackgroundColor:ZJRGBColor(178, 238, 223, 1.0)];
//        self.itemButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize35PX];
//        self.itemButton.layer.cornerRadius = 3;
//        self.itemButton.clipsToBounds = YES;
//        [self.itemButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    }
    
    return self;
}


@end
