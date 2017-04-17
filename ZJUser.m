//
//  ZJUser.m
//  CRM
//
//  Created by 蒙建东 on 16/12/1.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJUser.h"
static ZJUser *user;
@implementation ZJUser
+(ZJUser *)shareUser{
    
    @synchronized (self) {
        if (user == nil) {
            user = [[ZJUser alloc ]init];
        }
    }
    return user;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    
    [coder encodeObject:self.Name forKey:@"name"];
    [coder encodeObject:self.Head forKey:@"photourl"];
    [coder encodeObject:self.Sex forKey:@"sex"];
    [coder encodeObject:self.Phone forKey:@"phone"];
    [coder encodeObject:self.Logintype forKey:@"Logintype"];
    [coder encodeObject:self.City forKey:@"city"];
    [coder encodeObject:self.Image forKey:@"Head"];
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super init];
    
    if (self) {
        self.Head = [coder decodeObjectForKey:@"photourl"];
        self.Name = [coder decodeObjectForKey:@"name"];
        self.Sex= [coder decodeObjectForKey:@"sex"];
        self.Phone = [coder decodeObjectForKey:@"phone"];
        self.Logintype = [coder decodeObjectForKey:@"Logintype"];
        self.City = [coder decodeObjectForKey:@"city"];
        self.Image = [coder decodeObjectForKey:@"Head"];
    }
    return self;
}

@end
