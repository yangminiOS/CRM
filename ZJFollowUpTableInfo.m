//
//  CRMFollowUp.m
//  CRM
//
//  Created by 杨敏 on 16/9/1.
//  Copyright © 2016年 mini. All rights reserved.
//

#import "ZJFollowUpTableInfo.h"

@implementation ZJFollowUpTableInfo

//模型集合

-(NSMutableArray *)followModelArray{
    if (!_followModelArray) {
        
        _followModelArray = [NSMutableArray array];
        
    }
    return _followModelArray;
}
//录音信息的路径
-(NSMutableArray *)recodeNameArray{
    if (!_recodeNameArray) {
        
        _recodeNameArray = [NSMutableArray array];
        
        if (![_cVoiceUrl isEqualToString:@""]) {
            [_recodeNameArray addObjectsFromArray:[_cVoiceUrl componentsSeparatedByString:@";"]];
        }
        
    }
    
    return _recodeNameArray;
}

//照片名字
-(NSMutableArray *)photosArray{
    if (!_photosArray) {
        
        _photosArray = [NSMutableArray array];
        
        if (![_cPhotoUrl isEqualToString:@"(null)"]&&![_cPhotoUrl isEqualToString:@""]) {
            
            [_photosArray addObjectsFromArray:[_cPhotoUrl componentsSeparatedByString:@";"]];
          
        }
        
    }
    return _photosArray;
}

//详细文字
-(NSString *)cText{
    if ([_cText isEqualToString:@"(null)"]) {
        
        return @"";
        
    }
    
    return _cText;
}

-(CGFloat)cellHeight{
    if (!_cellHeight) {
        
        //文字的高度
        CGFloat textHeight = [self.cText zj_getStringRealHeightWithWidth:zjScreenWidth - PX2PT(80)-30 fountSize:ZJTextSize35PX];
        //图片高度
        CGFloat margin = 3;
        CGFloat width = (zjScreenWidth - 2*ZJmargin40 - 3*margin)/4.0;
        
        CGFloat photosHeight = 0;
        
        if (self.photosArray.count>0) {
            
            photosHeight= (self.photosArray.count-1)/4*(width + margin)+PX2PT(30)+width;

        }
        //录音高度
        CGFloat recodeHeight = self.recodeNameArray.count*(30+ZJmargin40);
        
        _cellHeight  = textHeight + photosHeight +recodeHeight+ZJmargin40+PX2PT(76);
    }
    return _cellHeight;
}

@end
