//
//  ZJSelectTableViewCell.h
//  CRM
//
//  Created by 杨敏 on 16/11/9.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJCustomerItemsTableInfo;

@interface ZJSelectTableViewCell : UITableViewCell

//**数据模型**//
@property(nonatomic,strong) ZJCustomerItemsTableInfo*model;

@end
