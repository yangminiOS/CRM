//
//  ZJaBaseInfoView.h
//  CRM
//
//  Created by mini on 16/9/29.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJcustomerTableInfo;

@interface ZJCustomerMsgView : UIView


-(instancetype)initWithFrame:(CGRect)frame withModel:(ZJcustomerTableInfo*)model;

//**视图高度**//
@property(nonatomic,assign)CGFloat msgViewHeight;



@end
