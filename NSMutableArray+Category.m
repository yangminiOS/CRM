//
//  NSMutableArray+Category.m
//  CRM
//
//  Created by mini on 16/9/27.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "NSMutableArray+Category.h"

@implementation NSMutableArray (Category)

-(NSString *)zj_stringFromArrayString{
    
    NSString *string = @" ";
    for (NSString *str in self) {
        
        string = [NSString stringWithFormat:@"%@;%@",string,str];
        
    }
    NSString *itemsString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (itemsString.length>1) {
        itemsString = [itemsString substringFromIndex:1];
    }

    return itemsString;
}


@end
