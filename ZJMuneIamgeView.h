//
//  ZJMuneIamgeView.h
//  CRM
//
//  Created by mini on 16/11/28.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJMuneIamgeView;

@protocol ZJMuneIamgeViewDelegte <NSObject>


-(void)ZJMuneIamgeView:(ZJMuneIamgeView *)view didDlickButton:(UIButton *)button;

@end

@interface ZJMuneIamgeView : UIView

//**代理**//
@property(nonatomic,weak) id <ZJMuneIamgeViewDelegte>delegate;

@end
