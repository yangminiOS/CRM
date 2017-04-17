//
//  NSString+Cagetory.h
//  CRM
//
//  Created by mini on 16/9/18.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Cagetory)
/**
 *  返回字符串的尺寸
 */

-(CGSize)zj_getRealSizeWithMaxSize:(CGSize)masSize fount:(UIFont *)fount;

/**
 *  返回字符串的宽度
 */

-(CGFloat)zj_getStringRealWidthWithHeight:(CGFloat)height fountSize:(CGFloat)fontSize;


/**
 *  返回字符串的高度
 */
-(CGFloat)zj_getStringRealHeightWithWidth:(CGFloat)width fountSize:(CGFloat)fontSize;
//*****************************************************************

//从字符串获取时间
-(NSDate *)zj_getDateFromStringWithFormatter:(NSString *)formatter;

//从yyyy-MM-dd到yyyy年MM月dd日

-(NSString *)zj_dateStringFormatter:(NSString *)FString toFromatter:(NSString *)TString;
-(NSString *)zj_getSeasonFromIndex;

//*****************************************************************
//判断只能输入数字
-(BOOL)zj_isNumber;

//判断是否是身份证
-(BOOL)zj_isCodeID;

//判断是否是手机号码
-(BOOL)zj_isPhoneNumber;
//判断字符串是否输入正确
-(BOOL)zj_isStringAccordWith:(NSString *)pre;


//网络请求解码

-(NSString *)zj_urlDecode;

//*****************************
/** 将字符串经MD5加密 */
- (NSString *)zj_getMd5_32Bit:(NSString *)input;


-(NSString *)encodeString;

//去掉手机号码的+ 和— ——

- (NSString *)zj_disposePoneNumber;

@end
