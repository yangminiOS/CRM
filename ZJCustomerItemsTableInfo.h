//
//  ZJCustomerItemsTableInfo.h
//  CRM
//
//  Created by mini on 16/10/27.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJCustomerItemsTableInfo : NSObject

//**自增长唯一标识**//
@property(nonatomic,assign)NSInteger  iAutoID;

//**客户标签类型**//
@property(nonatomic,copy)NSString *type;

//**标签内容**//
@property(nonatomic,copy)NSString *itemString;

//**是否能删除**//1代表不能0代表可以
@property(nonatomic,assign)NSInteger delect;

@end
