//
//  ZJNameViewController.h
//  CRM
//
//  Created by 蒙建东 on 16/11/21.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJBaseViewController.h"
typedef void(^Username)(NSString *name);
@interface ZJNameViewController : ZJBaseViewController
@property (nonatomic,copy)Username name;
@end
