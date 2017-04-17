//
//  ZJSelectView.h
//  CRM
//
//  Created by mini on 16/11/10.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJSelectView,ZJCustomerItemsTableInfo;

@protocol  ZJSelectViewDelegate<NSObject>


-(void)ZJSelectView:(ZJSelectView *)view didSelectItemID:(NSInteger)ID clickRow:(NSInteger)row;

@end

@interface ZJSelectView : UIView
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame tableViewData:(NSMutableArray *)array;

//**代理方法**//
@property(nonatomic,weak) id <ZJSelectViewDelegate>delegate;

//**选中的cell**//
@property(nonatomic,assign)NSInteger selectCell;
@end
