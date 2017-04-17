//
//  UILabel+Cagetory.m
//  CRM
//
//  Created by mini on 16/9/18.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "UILabel+Cagetory.h"

@implementation UILabel (Cagetory)

-(void)zj_adjustWithMin{
    
    [self sizeToFit];
}

-(void)zj_labelText:(NSString *)text textColor:(UIColor *)color textSize:(CGFloat)size;{
    self.text = text;
    self.textColor = color;
    self.font = [UIFont systemFontOfSize:size];
}


@end
