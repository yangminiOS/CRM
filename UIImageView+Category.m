//
//  UIImageView+Category.m
//  CRM
//
//  Created by mini on 16/11/30.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "UIImageView+Category.h"

@implementation UIImageView (Category)

-(void)zj_imageName:(UIImage *)image HoldPlaceImageName:(NSString *)placeName{
    
    if (image == nil) {
        
        self.image = [UIImage imageNamed:placeName];
    }else{
        
        self.image = image;
    }
    
}


    



@end
