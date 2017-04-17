//
//  ZJGtasksTableViewCell.h
//  CRM
//
//  Created by mini on 16/10/25.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJGtasksTableInfo;

@interface ZJGtasksTableViewCell : UITableViewCell

//**数据模型**//
@property(nonatomic,strong) ZJGtasksTableInfo *model;

@end
