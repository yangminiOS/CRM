//
//  CRMScanMsg.m
//  CRM
//
//  Created by mini on 16/8/29.
//  Copyright © 2016年 mini. All rights reserved.
//

#import "ZJcustomerTableInfo.h"
#import "ZJFMdb.h"
#import "ZJCustomerItemsTableInfo.h"
#import "ZJDirectorie.h"


@implementation ZJcustomerTableInfo

//所有的标签
-(NSMutableArray *)itemsString{
    //cCustomerState_Tags  cCustomerSource_Tags  cLoanType_Tags
    NSMutableArray *items = [NSMutableArray array];
    
    if (_cCustomerState_Tags.length>0) {
        NSArray *state = [_cCustomerState_Tags componentsSeparatedByString:@";"];
        [items addObjectsFromArray:state];
    }
    
    if (_cCustomerSource_Tags.length>0) {
        NSArray *source = [_cCustomerSource_Tags componentsSeparatedByString:@";"];
        [items addObjectsFromArray:source];
    }
    
    if (_cLoanType_Tags.length>0) {
        NSArray *type = [_cLoanType_Tags componentsSeparatedByString:@";"];
        [items addObjectsFromArray:type];
    }
    
    NSString *IDS = nil;
    if (items.count>0) {
        
         IDS= [NSString stringWithFormat:@"%zd",[items[0]intValue]];

        
    }
    for (NSInteger i = 1; i<items.count; i++) {
        
        IDS = [NSString stringWithFormat:@"%@,%zd",IDS,[items[i] intValue]];
    }
    NSMutableArray *itemsModel = [NSMutableArray array];
    NSString *select = [NSString stringWithFormat:@"select * from %@ where iAutoID in (%@)",ZJCustomerItemsTableName,IDS];
    ZJCustomerItemsTableInfo *tableInfo = [[ZJCustomerItemsTableInfo alloc]init];
    [ZJFMdb sqlSelecteData:tableInfo selecteString:select success:^(NSMutableArray *successMsg) {
        [itemsModel addObjectsFromArray:successMsg];
        
    }];
    return itemsModel;
}
//客户状态
-(NSMutableArray *)stateArray{
    if (!_stateArray) {
        
        _stateArray = [NSMutableArray array];
        [_stateArray addObjectsFromArray:[_cCustomerState_Tags componentsSeparatedByString:@";"]];
    }
    return _stateArray;
}
//客户来源

-(NSMutableArray *)sourceArray{
    if (!_sourceArray) {
        
        _sourceArray = [NSMutableArray array];
        [_sourceArray addObjectsFromArray:[_cCustomerSource_Tags componentsSeparatedByString:@";"]];

    }
    return _sourceArray;
}
//贷款类型

-(NSMutableArray *)typeArray{
    if (!_typeArray) {
        
        _typeArray = [NSMutableArray array];
        
        [_typeArray addObjectsFromArray:[_cLoanType_Tags componentsSeparatedByString:@";"]];
    }
    return _typeArray;
}
//录入信息的照片路径
-(NSMutableArray *)photosPath{
    
    _photosPath = [NSMutableArray array];
    
    if (![_cRelatedPhotos isEqualToString:@"(null)"] &&![_cRelatedPhotos isEqualToString:@""]) {
        
        [_photosPath addObjectsFromArray:[_cRelatedPhotos componentsSeparatedByString:@";"]];

    }
    
    
    return _photosPath;
}

//录音信息的路径

-(NSArray *)recodePath{
    
    if (!_recodePath) {
        _recodePath = [NSMutableArray array];
        
        if (![_cCustomerRemark_VoiceUrl isEqualToString:@""]&&![_cCustomerRemark_VoiceUrl isEqualToString:@"(null)"]) {
            
            [_recodePath addObjectsFromArray:[_cCustomerRemark_VoiceUrl componentsSeparatedByString:@";"]];
            
        }
        
        
    }
    

    return _recodePath;
}

//头像的路径
-(NSString *)iconPath{
    
    if (_cPhotoUrl.length<1) {
        
        return @"";
    }
    
    NSString *path = [ZJDirectorie getImagePathWithDirectoryName:self.GUID];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",_cPhotoUrl]];
    
    return path;
}

//**客户状态备注信息**//

-(NSString *)cCustomerState_Remark{
    
    if ([_cCustomerState_Remark isEqualToString:@"(null)"])  {
        return @"";
    }else{
        
        return _cCustomerState_Remark;
    }
}

/**
 *  介绍人电话
 */

-(NSString *)cCustomerSource_IntroducerPhone{
    
    if ([_cCustomerSource_IntroducerPhone isEqualToString:@"(null)"])  {
        return @"";
    }else{
        
        return _cCustomerSource_IntroducerPhone;
    }
    
}
//生日
-(NSString *)cBirthDay{
    
    if ([_cBirthDay isEqualToString:@"(null)"]||[_cBirthDay isEqualToString:@""]) {
        
        return @"";
    }else{
        return _cBirthDay;
    }
}

//身份证号
-(NSString *)cCardID{
    
    if ([_cCardID isEqualToString:@"(null)"]||[_cCardID isEqualToString:@""]) {
        
        return @"";
    }else{
        return _cCardID;
    }
}
//贷款日期
-(NSString *)cLoanDate{
    if ([_cLoanDate isEqualToString:@"(null)"]||[_cLoanDate isEqualToString:@""]) {
        
        return @"";
    }else{
        return _cLoanDate;
    }
}

////贷款期限
-(NSString *)cLoanTimeLimit{
    if ([_cLoanTimeLimit isEqualToString:@"(null)"]||[_cLoanTimeLimit isEqualToString:@""]) {
        
        return @"";
    }else{
        return _cLoanTimeLimit;
    }
}
//介绍人
-(NSString *)cCustomerSource_IntroducerName{
    if ([_cCustomerSource_IntroducerName isEqualToString:@"(null)"]||[_cCustomerSource_IntroducerName isEqualToString:@""])  {
        return @"";
    }else{
        
        return _cCustomerSource_IntroducerName;
    }
    
}
//客户备注信息
-(NSString *)cCustomerRemark_Text{
    if ([_cCustomerRemark_Text isEqualToString:@"(null)"]||[_cCustomerRemark_Text isEqualToString:@""])  {
        return @"";
    }else{
        
        return _cCustomerRemark_Text;
    }
    
}
-(NSMutableArray *)customerModelArray{
    if (!_customerModelArray) {
        
        _customerModelArray = [NSMutableArray array];
    }
    return _customerModelArray;
}

//返回头部视图高度
-(CGFloat)headViewHeight{
    
    CGFloat height = 0;
    
    if (!_headViewHeight) {
        
        NSArray *items = self.itemsString;
        
        if (items.count<1) {
            height = 95;
        }else{
            
            height = (items.count-1)/4 *(22 +PX2PT(22))+95;

        }
        
        
    }
    
    return height;

}
//返回cell高度

-(CGFloat)cellHeight{
    
    CGFloat height = 0;
    
    if (!_cellHeight) {
        
        CGFloat cmsgH = 0;
        
        
        if (self.cCustomerRemark_Text.length>0) {
            
             cmsgH= [self.cCustomerRemark_Text zj_getStringRealHeightWithWidth:zjScreenWidth -2*ZJmargin40-10 fountSize:11]+ZJmargin40+10;

        }
        
        
        CGFloat msgH = 0;
        
        if (self.cCustomerState_Remark.length>0) {
            msgH = [self.cCustomerState_Remark zj_getStringRealHeightWithWidth:zjScreenWidth -2*ZJmargin40-10 fountSize:11]+ZJmargin40+10;

        }
        
        CGFloat recodeH = self.recodePath.count*(30+ZJmargin40);
        
        if (msgH+recodeH+cmsgH == 0) {
            
            return 20+2*ZJmargin40;
        }else{
            
            height =cmsgH+ msgH +recodeH +ZJmargin40;
        }
        
        
    }
    
    return height;
}

@end
