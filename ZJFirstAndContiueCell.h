//
//  ZJFirstAndContiueCell.h
//  CRM
//
//  Created by 杨敏 on 16/11/11.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJcustomerTableInfo,ZJFirstAndContiueCell;
@protocol ZJFirstAndContiueCellDelegate <NSObject>

-(void) ZJFirstAndContiueCell:(ZJFirstAndContiueCell *)view viewTag:(NSInteger)tag;

-(void) ZJFirstAndContiueCell:(ZJFirstAndContiueCell *)view viewTag:(NSInteger)tag Switch:(BOOL)isSwitch;

@end



@interface ZJFirstAndContiueCell : UITableViewCell

//**代理**//
@property(nonatomic,weak) id <ZJFirstAndContiueCellDelegate>delegate;
//**模型**//
@property(nonatomic,strong)ZJcustomerTableInfo *model;

//判断是续贷还是还款换
@property(nonatomic,copy)NSString *firstDateString;

//**continue**//
@property(nonatomic,copy)NSString *continueString;
@end
