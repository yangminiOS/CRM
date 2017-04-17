//
//  LTPickerView.h
//  protoBuffer
//
//  Created by chenfujie on 15/11/20.
//  Copyright © 2015年 Meeno04. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTPickerView : UIView
@property (nonatomic,strong) void (^block)(id obj,NSString* str,int num);
@property (nonatomic,copy) NSString* title;
@property (nonatomic,strong) NSArray* dataSource;//数据源
@property (nonatomic,copy) NSString* defaultStr;
-(void)show;
-(void)close;
@end
