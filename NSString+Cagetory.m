//
//  NSString+Cagetory.m
//  CRM
//
//  Created by mini on 16/9/18.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "NSString+Cagetory.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Cagetory)


/**
 *  返回字符串的尺寸
 */
-(CGSize)zj_getRealSizeWithMaxSize:(CGSize)maxSize fount:(UIFont *)fount{
    
    NSDictionary *dict = @{NSFontAttributeName:fount};
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}



/**
 *  返回字符串的宽度
 */

-(CGFloat)zj_getStringRealWidthWithHeight:(CGFloat)height fountSize:(CGFloat)fontSize{
    
    CGSize size = CGSizeMake(MAXFLOAT, height);
    
    return [self zj_getRealSizeWithMaxSize:size fount:[UIFont systemFontOfSize:fontSize]].width;
                    
}

/**
 *  返回字符串高度
 */
-(CGFloat)zj_getStringRealHeightWithWidth:(CGFloat)width fountSize:(CGFloat)fontSize{
    
    CGSize size = CGSizeMake(width , MAXFLOAT);

    return [self zj_getRealSizeWithMaxSize:size fount:[UIFont systemFontOfSize:fontSize]].height;

    
}

//*********************************************************************************

//从字符串获取时间
-(NSDate *)zj_getDateFromStringWithFormatter:(NSString *)formatter{
    NSDateFormatter *form = [[NSDateFormatter alloc]init];
    
    form.dateFormat = formatter;
    
    return [form dateFromString:self];
}

//从yyyy-MM-dd到yyyy年MM月dd日

-(NSString *)zj_dateStringFormatter:(NSString *)FString toFromatter:(NSString *)TString{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat =FString;
    NSDate *date = [formatter dateFromString:self];
    formatter.dateFormat = TString;
    return [formatter stringFromDate:date];
}

-(NSString *)zj_getSeasonFromIndex{
    NSString *season = nil;
    if ([self isEqualToString:@"1"]) {
        
        season = @"一季度";
        
    }else if ([self isEqualToString:@"2"]){
        
        season = @"二季度";
    }else if ([self isEqualToString:@"3"]){
        
        season = @"三季度";
    }else{
        season = @"四季度";
    }
    return season;
}
//*********************************************************************************
//判断只能输入数字
-(BOOL)zj_isNumber{
    BOOL num = YES;
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSInteger i  = 0;
    while (i<self.length) {
        
        NSString *string = [self substringWithRange: NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:set];
        
        if (range.length==0) {
            
            num = NO;
            break;
        }
        i++;
    }
    return num;
}


/*    //判断手机号码
 //    NSString *phoneNumber = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
 
 NSString *phoneNumber = @"^1[0-9]\\d{9}$";
 
 NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNumber];
 if ([pre evaluateWithObject:self.phoneLabel.text] == NO)*/
//判断是否是身份证
-(BOOL)zj_isCodeID{
    

    NSString *CodeID = @"/^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$/";
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CodeID];
    return [pre evaluateWithObject:self];
    
}
//判断是否是手机号码
-(BOOL)zj_isPhoneNumber{
    
    NSString *phoneNumber = @"^1[0-9]\\d{9}$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNumber];

    return [pre evaluateWithObject:self];
}

//判断字符串是否输入正确
-(BOOL)zj_isStringAccordWith:(NSString *)pre{
    
    NSPredicate *ispre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pre];

    return [ispre evaluateWithObject:self];

}

//网络请求解码

-(NSString *)zj_urlDecode{
    
//    NSString *urlDecode = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSMutableString *outputStr = [NSMutableString stringWithString:self];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    //stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding
    return [outputStr stringByRemovingPercentEncoding];
}

//**********************
//md5 32位 加密 （小写）
- (NSString *)zj_getMd5_32Bit:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];//
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

//----------------------------------encode
-(NSString*)encodeString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}


- (NSString *)zj_disposePoneNumber{
    
    NSString *result = self;
    if(nil == result ){
        return @"";
    }
    //处理“+86”   --20170103mjd
    NSRange range = [result rangeOfString:@"+"];
    if(range.location != NSNotFound)
    {
        result = [result substringFromIndex:4];
    }
    //处理“-”
    NSMutableData *array = [[NSMutableData alloc] init];
    NSUInteger nLength = [result length];
    const char *string = [result UTF8String];
    for(NSUInteger i = 0; i < nLength; ++i){
        if([[result substringWithRange:NSMakeRange(i,1) ] isPhoneFormat]){
            [array appendBytes:string length:1];
        }
        ++string;
    }
    
    return [[NSString alloc] initWithData:array encoding:NSASCIIStringEncoding];
    
}

-(BOOL)isPhoneFormat{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789()\n"] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [self isEqualToString:filtered];
    return basicTest;
}


@end
