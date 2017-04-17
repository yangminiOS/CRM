//
//  ZJPersonViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/21.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJPersonViewController.h"

#import "ZJNameViewController.h"
#import "ZJContactViewController.h"
#import "ZJChangePasswordViewController.h"
#import "UIImageView+WebCache.h"
#import "GYZChooseCityController.h"
//归档对象
#import "ZJUser.h"
#import "CartoonUtils.h"
#import "AESCrypt.h"
#import "ZJIconViewController.h"
#import "TFFileUploadManager.h"

#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "ZJLoginViewControllerViewController.h"

#import "ZJUUID.h"

#import "SGActionSheet.h"
#import "SGAlertView.h"
@interface ZJPersonViewController ()<GYZChooseCityDelegate,ZJIconViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSURLConnectionDataDelegate,SGActionSheetDelegate, SGAlertViewDelegate>
{
    //记录用户选择的性别
    NSInteger _Save;
    //用于比较用户选择的性别
    NSInteger _Temp;
    
    NSMutableData *_reveivedData;
    
}
@property (weak, nonatomic) IBOutlet UIButton *HeadButton;
//头像标签
@property (weak, nonatomic) IBOutlet UILabel *HeadLabel;
//姓名标签
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
//用户姓名
@property (weak, nonatomic) IBOutlet UILabel *TheNameLabel;
//退出按钮
@property (weak, nonatomic) IBOutlet UIButton *ExitButton;
//联系方式标签
@property (weak, nonatomic) IBOutlet UILabel *ContactLabel;
//城市标签
@property (weak, nonatomic) IBOutlet UILabel *CityLabel;
//电话号码
@property (weak, nonatomic) IBOutlet UILabel *TelPhoneLabel;
//城市
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;
//修改密码标签
@property (weak, nonatomic) IBOutlet UILabel *ChangePassword;
//退出标签
@property (weak, nonatomic) IBOutlet UILabel *ExitLabel;
//性别背景图片
@property (weak, nonatomic) IBOutlet UIImageView *GenderImageView;
//性别按钮
@property (weak, nonatomic) IBOutlet UIButton *MenButton;
@property (weak, nonatomic) IBOutlet UIButton *WomenButton;
//头像图片
@property (weak, nonatomic) IBOutlet UIImageView *HeadImagView;

@property (nonatomic,assign)NSInteger SexNumber;

//**//判断头像是否改变**//
@property(nonatomic,assign)BOOL isChangeIcon ;

@property (nonatomic,strong)NSString *number;

@property (nonatomic,strong)NSString *SEX;

@property (nonatomic,strong)NSString *PhoneNumber;

@property (nonatomic,strong)NSString *Error;

@property (nonatomic,strong)NSArray *ExitArray;

@property (nonatomic,weak)SGActionSheet *ActionSheet;
@end

@implementation ZJPersonViewController
MBProgressHUD *HUD;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self loadSyte];
    self.view.backgroundColor = ZJBackGroundColor;
   
    self.HeadImagView.layer.masksToBounds = YES;
    self.HeadImagView.layer.cornerRadius = PX2PT(20);
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(SaveClick)];
    leftItem.tintColor = ZJColorFFFFFF;
    self.navigationItem.leftBarButtonItem = leftItem;
    
 
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.ActionSheet removeFromSuperview];
}

- (void)SaveClick{
    
    if (_Temp == _Save) {
        [self.navigationController popViewControllerAnimated:YES];
    }else  {
        UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否放弃修改" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *Giveup = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alerController addAction:Giveup];
        [alerController addAction:determine];
        [self presentViewController:alerController animated:YES completion:nil];
    }
}

#pragma mark---------获取系统相册
-(void)getPictureFromeSystem{
    
    if (_isChangeIcon) {
        ZJIconViewController *iconvc = [[ZJIconViewController alloc]init];
        iconvc.delegate = self;
        iconvc.iconImg =  self.HeadImagView.image;
        [self.navigationController pushViewController:iconvc animated:YES];
    }else{
        [self getPictureForIcon];
    }
}

#pragma mark   获取标记模式的照片

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    UIImage *HeadImage = [self OriginImage:image scaleToSize:CGSizeMake(PX2PT(1024), PX2PT(1024))];
    
    _isChangeIcon= YES;
    
    //设备唯一标识
     NSString *identifierForVendor = [ZJUUID getUUID];
   
    //从沙盒取TOKEN值
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *Token = [ud stringForKey:@"TOKEN"];
    //网络地址
    NSString *URL = [NSString stringWithFormat:@"%@/crm/interface/user_SetPhoto.php",THEURL];
    //沙盒临时文件夹
    NSString *path_document = NSTemporaryDirectory();
    NSString *imagePath = [path_document stringByAppendingString:@"/head.jpg"];
    [UIImagePNGRepresentation(HeadImage) writeToFile:imagePath atomically:YES];
  
    NSString *message = [NSString stringWithFormat:@"&token=%@&meid=%@",Token,identifierForVendor];
    NSString *password = CIPHER;
    NSString *encryptedData = [AESCrypt encrypt:message password:password];
    NSString *Ecode = [encryptedData encodeString];
    NSDictionary* param = @{@"params":Ecode};
    
    HUD =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    HUD.labelText = @"正在上传";
    [HUD hide:YES afterDelay:2];
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    __weak __typeof(self) weakself=self;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status ==AFNetworkReachabilityStatusNotReachable) {
            [weakself autorAlertViewWithMsg:@"亲，您的网络开小差了~"];
        }else{
            self.HeadButton.userInteractionEnabled = NO;
            TFFileUploadManager *tr = [TFFileUploadManager shareInstance];
            [[TFFileUploadManager shareInstance] uploadFileWithURL:URL params:param fileKey:@"file" filePath:imagePath completeHander:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            }];
            tr.username = ^(NSString *error){
                if ([error isEqualToString:@"网络异常，请稍后重试"]) {
                    [weakself bounced:error];
                    return ;
                }
                if([error isEqualToString:@"1111111"]){
                    [weakself autorAlertViewWithMsg:@"头像上传成功"];
                    weakself.HeadButton.userInteractionEnabled = YES;
                    //更新归档对象
                    NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"];
                    NSData *data = [NSData dataWithContentsOfFile:documentsPath];
                    ZJUser * User = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    User.Image = self.HeadImagView.image;
                    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:User];
                    [data1 writeToFile:documentsPath atomically:YES];
                }else if([error isEqualToString:@"token错误，请重新登录"]){
                    NSString *urldecode = [error zj_urlDecode];
                    [weakself bounced:urldecode];
                    return;
                }else {
                    NSString *urldecode = [error zj_urlDecode];
                    [weakself autorAlertViewWithMsg:urldecode];
                }
            };

            
        }
    }];
    //开始检测
    [manager startMonitoring];
    
    self.HeadImagView.image = image;
}



//压缩图片大小
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}




#pragma mark   获取用户头像
-(void)ZJIconViewController:(ZJIconViewController *)view iconImg:(UIImage *)iconImg{
    self.HeadImagView.image = iconImg;
}

//懒加载
- (NSArray *)ExitArray{
    if (!_ExitArray) {
        _ExitArray = @[@"退出登录"];
    }
    return _ExitArray;
}

// 所有按钮的点击事件
- (IBAction)AllClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
          
             [self getPictureFromeSystem];
        }
            break;
        case 2:
        {
            ZJNameViewController *ZJName = [[ZJNameViewController alloc]init];
            ZJName.name = ^(NSString *username){
                
                self.TheNameLabel.text = username;
            };
            [self.navigationController pushViewController:ZJName animated:YES];
        }
            break;
        case 3:
        {
            
            ZJContactViewController *contact = [[ZJContactViewController alloc]init];
           
            contact.phone = self.PhoneNumber;

            [self.navigationController pushViewController:contact animated:YES];
        }
            break;
        case 4:
        {
            GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
            [cityPickerVC setDelegate:self];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:nil];
        }
            break;
        case 5:
        {
            ZJChangePasswordViewController *change = [ZJChangePasswordViewController new];
            change.Phone = self.PhoneNumber;
            [self.navigationController pushViewController:change animated:YES];
        }
            break;
        case 6:
        {
           // [self bounced];
            SGActionSheet *sheet = [SGActionSheet actionSheetWithTitle:@"是否退出登陆？退出后不会删除任何数据，下次登陆依然可以使用本账号。" delegate:self cancelButtonTitle:@"取消" otherButtonTitleArray:self.ExitArray];
            self.ActionSheet = sheet;
            sheet.messageTextFont = [UIFont systemFontOfSize:ZJTextSize45PX];
            sheet.messageTextColor = ZJColorDCDCDC;
            sheet.otherTitleFont = [UIFont systemFontOfSize:ZJTextSize55PX];
            sheet.otherTitleColor = [UIColor redColor];
            sheet.cancelButtonTitleFont = [UIFont systemFontOfSize:ZJTextSize55PX];
            [sheet show];
        }
        default:
            break;
    }
    
}
//代理方法来显示点击的行数
- (void)SGActionSheet:(SGActionSheet *)actionSheet didSelectRowAtIndexPath:(NSInteger)indexPath{
    if (indexPath == 0) {
        __weak __typeof(self) weakself=self;
        
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
           
            if (status ==AFNetworkReachabilityStatusNotReachable) {
                [weakself autorAlertViewWithMsg:@"亲，您的网络开小差了~"];
            }else{
                [weakself exit];
            }
        }];
        //开始检测
        [manager startMonitoring];
    }
}


- (void)exit{
    NSString *identifierForVendor = [ZJUUID getUUID];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *Token = [ud stringForKey:@"TOKEN"];
    
     __weak __typeof(self) weakself=self;
    [CartoonUtils requestWithThecanToken:Token andMeid:identifierForVendor andCallback:^(id obj) {
        NSString *str = obj;
        if ([str isEqualToString:@"网络异常，请稍后重试"]) {
            [weakself autorAlertViewWithMsg:str];
            return ;
        }
        if ( str != NULL && ![str isEqualToString:@"1023"]) {
            NSString *urldecode = [str zj_urlDecode];
            [weakself autorAlertViewWithMsg:urldecode];
            
        }else {
            
            NSFileManager * fileManager = [[NSFileManager alloc]init];
            NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"];
            [fileManager removeItemAtPath:documentsPath error:nil];
            ZJLoginViewControllerViewController *Login = [ZJLoginViewControllerViewController new];
            [weakself.navigationController pushViewController:Login animated:YES];
        }
    }];
}



- (void)loadSyte{
    //性别
   
    [self.MenButton setImage:[UIImage imageNamed:@"MAN-USER"] forState:UIControlStateDisabled];
    [self.MenButton setImage:[UIImage imageNamed:@"MAN_iocn"] forState:UIControlStateNormal];
    [self.MenButton setTitle:@"男" forState:UIControlStateNormal];
    [self.MenButton setTitleColor:ZJColorFFFFFF forState:UIControlStateDisabled];
    [self.MenButton setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    self.MenButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize35PX];
    [self.MenButton addTarget:self action:@selector(clickManButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.WomenButton setImage:[UIImage imageNamed:@"WOMAN_icon"] forState:UIControlStateNormal];
    [self.WomenButton setImage:[UIImage imageNamed:@"WOMAN-USER"] forState:UIControlStateDisabled];
    [self.WomenButton setTitle:@"女" forState:UIControlStateNormal];
    [self.WomenButton setTitleColor:ZJRGBColor(255, 171, 195, 1.0) forState:UIControlStateNormal];
    [self.WomenButton setTitleColor:ZJColorFFFFFF forState:UIControlStateDisabled];
    self.WomenButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize35PX];
    [self.WomenButton addTarget:self action:@selector(clickWoManButton:) forControlEvents:UIControlEventTouchUpInside];
   
    // 取出个人信息
    NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"]];
    ZJUser * User = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (User) {
        if(User.Image == NULL){
          [self.HeadImagView sd_setImageWithURL:[NSURL URLWithString:User.Head] placeholderImage:[UIImage imageNamed:@"I_head-portrait"]];
        }else {
            self.HeadImagView.image = User.Image;
        }
        NSString *urldecode = [User.Name zj_urlDecode];
        [self.TheNameLabel zj_labelText:[NSString stringWithFormat:@"%@",urldecode] textColor:ZJColorDCDCDC textSize:ZJTextSize45PX];
       
        [self.TelPhoneLabel zj_labelText:[NSString stringWithFormat:@"+86 %@",User.Phone] textColor:ZJColorDCDCDC textSize:ZJTextSize45PX];
        self.PhoneNumber = User.Phone;
        if (User.City != NULL) {
             NSString *urldecode = [User.City zj_urlDecode];
            [self.AddressLabel zj_labelText:[NSString stringWithFormat:@"%@",urldecode] textColor:ZJColorDCDCDC textSize:ZJTextSize45PX];
        }
        NSString *sex = User.Sex;
        NSInteger Sex = [sex integerValue];
        if (Sex == 1) {
            self.MenButton.enabled = NO;
            self.GenderImageView.image = [UIImage imageNamed:@"gender_man"];
            _Temp = 1;
            _Save = 1;
        }else if(Sex == 0){
            self.WomenButton.enabled = NO;
            self.GenderImageView.image = [UIImage imageNamed:@"gender_woman"];
            _Temp = 0;
            _Save = 0;
        }
    }else {
        self.MenButton.enabled = NO;
    }
    
    [self.HeadLabel zj_labelText:@"头像" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    [self.NameLabel zj_labelText:@"姓名" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    [self.ContactLabel zj_labelText:@"联系方式" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    [self.CityLabel zj_labelText:@"所在城市" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    [self.ChangePassword zj_labelText:@"修改密码" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    [self.ExitLabel zj_labelText:@"退出" textColor:ZJColor505050 textSize:ZJTextSize45PX];

   
   
}

//  性别男
-(void)clickManButton:(UIButton *)button{
    _Save = 1;
    if (_Save != _Temp) {
        [self add];
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    self.WomenButton.enabled = YES;
    button.enabled = NO;
    self.GenderImageView.image = [UIImage imageNamed:@"gender_man"];
    
    
}
//性别女
-(void)clickWoManButton:(UIButton *)button{
    _Save = 0;
    if (_Save != _Temp) {
        [self add];
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    self.MenButton.enabled = YES;
    button.enabled = NO;
    self.GenderImageView.image = [UIImage imageNamed:@"gender_woman"];
}

- (void)add{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(add:)];
    rightItem.tintColor = ZJColorFFFFFF;
    self.navigationItem.rightBarButtonItem = rightItem;

}


- (void)viewWillAppear:(BOOL)animated{
    
}

//发送更改性别网络请求
- (void)add:(UIBarButtonItem *)butt{
    
    if (_Save == _Temp) {
        return;
    }
   
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *identifierForVendor = [ZJUUID getUUID];
    NSString *Token = [ud stringForKey:@"TOKEN"];
    __weak __typeof(self) weakself=self;
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
       
        if (status ==AFNetworkReachabilityStatusNotReachable) {
            [weakself autorAlertViewWithMsg:@"亲，您的网络开小差了~"];
        }else{
            [CartoonUtils requestWithModifyUser:[NSString stringWithFormat:@"%zd",_Save] andType:@"sex" andToken:Token andMeid:identifierForVendor andCallback:^(id obj) {
                NSString *str = obj;
                if ([str isEqualToString:@"网络异常，请稍后重试"]) {
                    [weakself autorAlertViewWithMsg:str];
                    return ;
                }
                if ([str isEqualToString:@"token错误，请重新登录"]) {
                    NSString *urldecode = [str zj_urlDecode];
                    [weakself bounced:urldecode];
                    return;
                }else if(str != NULL){
                    NSString *urldecode = [str zj_urlDecode];
                    [weakself autorAlertViewWithMsg:urldecode];
                }else {
                    NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"];
                    NSData *data = [NSData dataWithContentsOfFile:documentsPath];
                    ZJUser * User = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    User.Sex = [NSString stringWithFormat:@"%zd",_Save];
                    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:User];
                    [data1 writeToFile:documentsPath atomically:YES];
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
        }
    }];
    //开始检测
    [manager startMonitoring];
}




#pragma mark - GYZCityPickerDelegate
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city
{
    if (city.capital != NULL) {
        self.AddressLabel.text = [NSString stringWithFormat:@"%@ %@",city.capital,city.cityName];
    }else {
        self.AddressLabel.text = city.cityName;
    }
 
    // 取出个人信息
    NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"]];
    ZJUser * User = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (![User.City isEqualToString:self.AddressLabel.text]) {
        [self ModifyTheCity:self.AddressLabel.text];
    }
   
    [chooseCityController dismissViewControllerAnimated:YES completion:nil];
}

// 更改城市网络请求
- (void)ModifyTheCity:(NSString *)city{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *identifierForVendor = [ZJUUID getUUID];
    NSString *Token = [ud stringForKey:@"TOKEN"];
    __weak __typeof(self) weakself=self;
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
       
        if (status ==AFNetworkReachabilityStatusNotReachable) {
            [weakself autorAlertViewWithMsg:@"亲，您的网络开小差了~"];
        }else{
            [CartoonUtils requestWithModifyUser:city andType:@"city" andToken:Token andMeid:identifierForVendor andCallback:^(id obj) {
                NSString *str = obj;
                if ([str isEqualToString:@"网络异常，请稍后重试"]) {
                    [weakself autorAlertViewWithMsg:str];
                    return ;
                }
                if ([str isEqualToString:@"token错误，请重新登录"]) {
                    NSString *urldecode = [str zj_urlDecode];
                    [weakself bounced:urldecode];
                    return;
                }else if(str != NULL){
                    NSString *urldecode = [str zj_urlDecode];
                    [weakself autorAlertViewWithMsg:urldecode];
                }else{
                    
                    NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"];
                    NSData *data = [NSData dataWithContentsOfFile:documentsPath];
                    ZJUser * User = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    User.City = city;
                    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:User];
                    [data1 writeToFile:documentsPath atomically:YES];
                    [weakself autorAlertViewWithMsg:@"修改成功"];
                }
            }];
            
        }
    }];
    //开始检测
    [manager startMonitoring];
}

//选择城市
#pragma mark - GYZCityPickerDelegate 错误时返回的方法
- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController
{
    [chooseCityController dismissViewControllerAnimated:YES completion:nil];
}

// 根据返回值错误信息提示
- (void)bounced:(NSString *) Error{
    
    NSString *str = NSLocalizedString(Error, nil);;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([str isEqualToString:@"token错误，请重新登录"]) {
            NSFileManager * fileManager = [NSFileManager defaultManager];
            NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"];
            [fileManager removeItemAtPath:documentsPath error:nil];
            ZJLoginViewControllerViewController *Login = [[ZJLoginViewControllerViewController alloc]init];
            [self.navigationController pushViewController:Login animated:YES];
        }
        
    }];
    
    [alert addAction:Cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
