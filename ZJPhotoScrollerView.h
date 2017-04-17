//
//  ScrollerView.h
//  照片测试
//
//  Created by mini on 16/9/9.
//  Copyright © 2016年 杨敏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,photosViewType){
    
    EditType,
    
    CheckType,
};

@class ZJPhotoScrollerView;

@protocol ZJPhotoScrollerViewDeleagte <NSObject>

-(void)ZJPhotoScrollerView:(ZJPhotoScrollerView *)view;

@end

@interface ZJPhotoScrollerView : UIView

//**代理方法**//
@property(nonatomic,weak) id<ZJPhotoScrollerViewDeleagte> delegate;

@property(nonatomic,strong) NSMutableArray *photosArray;

//**photosViewType**//
@property(nonatomic,assign)photosViewType photoViewType;

-(void) clickItemIndex:(NSInteger)index;

-(instancetype)initWithFrame:(CGRect)frame PhotosArray:(NSMutableArray *)array viewType:(photosViewType)type;
@end
