//
//  ZJrankView.h
//  CRM
//
//  Created by mini on 16/11/10.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJrankView;

@protocol ZJrankViewDelegate <NSObject>

-(void)ZJrankView:(ZJrankView *)view clickRow:(NSInteger)row;


@end

@interface ZJrankView : UIView


//**代理方法**//
@property(nonatomic,weak) id<ZJrankViewDelegate> delegate;

//**记录选中的cell**//
@property(nonatomic,assign)NSInteger selectCell;

@end
