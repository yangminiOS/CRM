//
//  CollectionViewCell.m
//  照片测试
//
//  Created by mini on 16/9/8.
//  Copyright © 2016年 杨敏. All rights reserved.
//



#import "ZJPhotoCollectionCell.h"
@interface ZJPhotoCollectionCell ()

@end

@implementation ZJPhotoCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.imageV = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        
        [self addSubview:self.imageV];
        
        self.imageV.userInteractionEnabled = YES;
        
    }
    
    return self;
}

-(void)setImageV:(UIImageView *)imageV{
    
    _imageV = imageV;
    
    
}

@end
