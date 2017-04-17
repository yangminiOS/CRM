//
//  UIViewController+getContactInfor.m
//  CH_GetContactInfor
//
//  Created by 耗子 on 16/10/21.
//  Copyright © 2016年 DogCat. All rights reserved.
//

#import "UIViewController+getContactInfor.h"

#define Is_up_Ios_9      ([[UIDevice currentDevice].systemVersion floatValue]) >= 9.0

@implementation UIViewController (getContactInfor)

#pragma  mark -获取通讯录联系人
void(^addressBlock)(NSDictionary *);
- (NSString *)CheckAddressBookAuthorizationandGetPeopleInfor:(void (^)(NSDictionary *data))handler{
    addressBlock = [handler copy];
    __block NSString *string = nil;
    if (Is_up_Ios_9) {
        CNContactStore * contactStore = [[CNContactStore alloc]init];
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {
                if (error)
                {
                    string = @"打开通讯录失败";
                }
                else if (!granted)
                {
                    //iOS9 没有权限
                    
                    string = @"请到设置>隐私>通讯录打开本应用的权限设置";
                }
                else
                {
                    //iOS9 有权限
                    [self methodForNineOrMore];
                }
            }];
        }
        else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized){
            //ios9 有权限
            [self methodForNineOrMore];
        }
        else {
            string = @"请到设置>隐私>通讯录打开本应用的权限设置";
        }
    }else {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        
        if (authStatus == kABAuthorizationStatusNotDetermined)
        {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error)
                    {
                        string = @"打开通讯录失败";
                    }
                    else if (!granted)
                    {
                        // ios9 以下 没权限
                        string = @"请到设置>隐私>通讯录打开本应用的权限设置";
                    }
                    else
                    {
                        //iOS9以下  有权限
                        [self methodForNineLess];
                    }
                });
            });
        }else if (authStatus == kABAuthorizationStatusAuthorized)
        {
            //iOS9以下  有权限
            [self methodForNineLess];
        }else {
            string = @"请到设置>隐私>通讯录打开本应用的权限设置";
        }
    }
    
    return string;
    
}

//调起iOS9以上调用通讯录的方法
-(void)methodForNineOrMore{
    CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
    contactPicker.delegate = self;
    contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
    [self presentViewController:contactPicker animated:YES completion:nil];
}

//iOS以下
-(void)methodForNineLess{
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self presentViewController:peoplePicker animated:YES completion:nil];
}
//iOS9 通讯代理
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    CNPhoneNumber *phoneNumber = (CNPhoneNumber *)contactProperty.value;
    [self dismissViewControllerAnimated:YES completion:^{
        /// 联系人
        NSString *text1 = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName,contactProperty.contact.givenName];
        /// 电话
        NSString *text2 = phoneNumber.stringValue;
        
        /// 转换电话号码格式    -20161226 mjd
        text2 = [self encodePhoneNumber:text2];
        
        NSDictionary *dic = @{@"name":text1,@"phone":text2};
        addressBlock(dic);
    }];
}
#pragma mark 手机号码格式化
-(NSString *)encodePhoneNumber:(NSString * )phone{
    if(nil == phone ){
        return @"";
    }
    //处理“+86”   --20170103mjd
    NSRange range = [phone rangeOfString:@"+"];
    if(range.location != NSNotFound)
    {
        phone = [phone substringFromIndex:4];
    }
    //处理“-”
    NSMutableData *array = [[NSMutableData alloc] init];
    NSUInteger nLength = [phone length];
    const char *string = [phone UTF8String];
    for(NSUInteger i = 0; i < nLength; ++i){
        if([self isPhoneFormat:[phone substringWithRange:NSMakeRange(i,1)]]){
            [array appendBytes:string length:1];
        }
        ++string;
    }
    
    return [[NSString alloc] initWithData:array encoding:NSASCIIStringEncoding];
}
-(BOOL)isPhoneFormat:(NSString *)str{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789()\n"] invertedSet];
    NSString *filtered = [[str componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [str isEqualToString:filtered];
    return basicTest;
}


//iOS9以下代理
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef,index);
    CFStringRef anFullName = ABRecordCopyCompositeName(person);
    
    [self dismissViewControllerAnimated:YES completion:^{
        /// 联系人
        NSString *text1 = [NSString stringWithFormat:@"%@",anFullName];
        /// 电话
        NSString *text2 = (__bridge NSString*)value;
        NSLog(@"联系人：%@, 电话：%@",text1,text2);
        NSDictionary *dic = @{@"name":text1,@"phone":text2};
        addressBlock(dic);
    }];
}

@end
