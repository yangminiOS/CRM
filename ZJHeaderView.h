//
//  ZJHeaderView.h
//  CRM
//
//  Created by 杨敏 on 16/9/27.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJcustomerTableInfo,ZJHeaderView;

@protocol ZJHeaderViewDelegate <NSObject>

@required
//点击展开Button
- (void)headerView:(ZJHeaderView *)headerView didClickDecoilButton:(UIButton *)button;
//点击遮盖Button
- (void)headerView:(ZJHeaderView *)headerView didClickCoverButton:(UIButton *)button;
@end
@interface ZJHeaderView : UITableViewHeaderFooterView

//**代理方法**//
@property(nonatomic,weak) id<ZJHeaderViewDelegate>delegate;

//**模型**//
@property(nonatomic,strong)ZJcustomerTableInfo *customerModel;



//**图标处理**//
@property(nonatomic,assign)BOOL rotageImgView;


@end
