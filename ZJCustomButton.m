//
//  ZJCustomButton.m
//  CRM
//
//  Created by 杨敏 on 16/10/1.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJCustomButton.h"

@implementation ZJCustomButton

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        
        
    }
    return self;
}
-(instancetype)initWithMargin:(CGFloat)margin{
    if (self = [super init]) {
        
        self.margin = margin;
    }
    
    return self;
}
- (void)awakeFromNib
{
    [self setup];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.x = (self.width - self.currentImage.size.width)/2.0;
    self.imageView.y = 0;
    self.imageView.width = self.currentImage.size.width;
    self.imageView.height = self.currentImage.size.height;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height +self.margin;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}



@end
