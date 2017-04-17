//
//  ZJBirthViewController.m
//  CRM
//
//  Created by mini on 16/11/10.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJBirthViewController.h"
#import "ZJcustomerTableInfo.h"
#import "ZJcustomerTableInfo.h"
#import "ZJRemindTableInfo.h"
#import "ZJFMdb.h"
#import <AFNetworking.h>
#import <MessageUI/MessageUI.h>
@interface ZJBirthViewController ()<MFMessageComposeViewControllerDelegate>

{
    NSInteger _row ;//多少行
    NSInteger _linde;//多少列
    
    NSInteger _msgIndex;//短信的索引
    
    
}

//底部照片视图
@property(nonatomic,weak) UIImageView *barckImageView;

//**显示文本**//
@property(nonatomic,weak) UITextView *textView;
//**scrollerView**//
@property(nonatomic,weak) UIScrollView *scrollView;

//**内容视图**//
@property(nonatomic,weak) UIView *contentView;
//**顶部button**//
@property(nonatomic,strong) NSMutableArray *topButtonsArray;


//**换句祝福Button**//
@property(nonatomic,weak) UIButton *changeButton;
//**已发送图片**//
@property(nonatomic,weak) UIImageView *hadSendImageView;

//**已发送按钮**//
@property(nonatomic,weak) UIButton *sendMsgButton;

//**顶部被选中的视图标号**//
@property(nonatomic,strong) NSMutableArray *selectTopButton;

//**模型**//
@property(nonatomic,strong) NSMutableArray *customerArray;

//**生日祝福短信**//
@property(nonatomic,strong) NSMutableArray *birthMsgArray;

//**<#注释#>**//
@property(nonatomic,assign)BOOL isNoNet;

@end


@implementation ZJBirthViewController

-(NSMutableArray *)customerArray{
    if (!_customerArray) {
        
        _customerArray = [NSMutableArray array];
    }
    return _customerArray;
}

-(NSMutableArray *)topButtonsArray{
    if (!_topButtonsArray) {
        
        _topButtonsArray = [NSMutableArray array];
    }
    return _topButtonsArray;
}

-(NSMutableArray *)selectTopButton{
    if (!_selectTopButton) {
        
        _selectTopButton = [NSMutableArray array];
    }
    
    return _selectTopButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupHappyBirthday];
    [self remindDataFromSql];
    [self setupCustomerUI];
    //获取数据
    
    self.birthMsgArray = [NSMutableArray array];
    
    [self getDataFromURL];
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    [manger startMonitoring];
    
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @try{
        if (status ==AFNetworkReachabilityStatusNotReachable) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [self.birthMsgArray addObject:[defaults objectForKey:@"birth1"]];
            [self.birthMsgArray addObject:[defaults objectForKey:@"birth2"]];

            [self.birthMsgArray addObject:[defaults objectForKey:@"birth3"]];

            [self.birthMsgArray addObject:[defaults objectForKey:@"birth4"]];

            [self.birthMsgArray addObject:[defaults objectForKey:@"birth5"]];
            NSString *text = self.birthMsgArray[0];
            self.textView.text = text;
            self.isNoNet = YES;
        }
        }@catch (NSException *ne ){
            //断网返回数据为nil无生日提醒文本,随机从plist当中10条取5条 --20161226  mjd
            ZJLog(@"-----(NSException *ne ) : %@", ne);
            [self outsideNet];
        }
    }];
    

}

#pragma mark 断网返回数据为nil无生日提醒文本,随机从plist当中9条取5条 
-(void)outsideNet{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BirthMsgText" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    for (NSInteger i = 1; i<=5; i++) {
        
        NSInteger ivalue = (arc4random()% 9 ) + 1;
        
        NSString *num = [NSString stringWithFormat:@"birth%zd", ivalue ];
        
        NSString *temp = data[num];
        
        [self.birthMsgArray addObject:temp];
    }
    
    NSString *text = self.birthMsgArray[0];
    self.textView.text = text;
    self.isNoNet = YES;
    
}


#pragma mark   设置导航
-(void) setupNavi{
    self.view.backgroundColor = ZJColorFFFFFF;
    self.navigationItem.title = @"送祝福";
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.birthMsgArray.count>5) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.birthMsgArray[0] forKey:@"birth1"];
        [defaults setObject:self.birthMsgArray[1] forKey:@"birth2"];

        [defaults setObject:self.birthMsgArray[2] forKey:@"birth3"];

        [defaults setObject:self.birthMsgArray[3] forKey:@"birth4"];

        [defaults setObject:self.birthMsgArray[4] forKey:@"birth5"];
        [defaults synchronize];


        
    }
}

#pragma mark   点击发送
-(void) clickHadSend{
    
    NSMutableArray *teleNum = [NSMutableArray array];
    for (NSInteger i = 0; i<self.selectTopButton.count; i++) {
        
        UIButton *button = self.selectTopButton[i];
        
        ZJcustomerTableInfo *model = self.customerArray[button.tag];
        
        [teleNum addObject:model.cPhone];
        
    }
    
    if (teleNum.count>0) {
        
        
        self.changeButton.hidden = YES;
        MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc]init];
        vc.body = self.textView.text;
        vc.recipients = teleNum;
        vc.messageComposeDelegate = self;
        
        [self presentViewController:vc animated:YES completion:nil];
        

    }
    
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
    self.hadSendImageView.hidden = NO;

}

#pragma mark   换句祝福

-(void)clickChangButton:(UIButton *)button{
    
    if (_msgIndex == self.birthMsgArray.count) {
        
        [self getDataFromURL];
        return;
    }
    
    NSString *text = self.birthMsgArray[_msgIndex];
    
    self.textView.text = text;
    
    _msgIndex ++;
    
    if (self.isNoNet &&_msgIndex == 5 ) {
        
        _msgIndex = 0;
        
    }
    
    
}

#pragma mark   获取网络短信数据
-(void) getDataFromURL{
    
    NSString *url = [NSString stringWithFormat:@"%@/crm/interface/fun_getsms.php",THEURL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //content - type
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.isNoNet = NO;
        //删除数组内容
        [self.birthMsgArray removeAllObjects];
        //短信数组下标
        _msgIndex = 0;
        NSDictionary *dict = responseObject;
        
        NSString *code = dict[@"code"];
        
        NSInteger  count = [dict[@"count"]integerValue];
        
        if ([code isEqualToString:@"0000"]) {
            
            for (NSInteger i = 0; i<count; i++) {
                
                NSString *num = [NSString stringWithFormat:@"%zd",i];
                
                NSString *temp = dict[num];
                
                temp = [temp zj_urlDecode];
                
                [self.birthMsgArray addObject:temp];
            }
            
        }
        
        [self clickChangButton:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    }];

    
}
#pragma mark   设置UI
-(void) setupHappyBirthday{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    
    [self.view addGestureRecognizer:tap];
    
    UIImageView *BarckImgV = [[UIImageView alloc]init];
    [self.view addSubview:BarckImgV];
    self.barckImageView = BarckImgV;
    BarckImgV.userInteractionEnabled= YES;
    BarckImgV.frame = CGRectMake(0, 0, zjScreenWidth, PX2PT(850));
    BarckImgV.image = [UIImage imageNamed:@"HAPPY-BIRTHDAY"];
    
    //祝福语句
    UITextView *contnetText = [[UITextView alloc]init];
    [BarckImgV addSubview:contnetText];
    self.textView = contnetText;
    contnetText.height = PX2PT(256);
    contnetText.width = PX2PT(960);
    contnetText.centerY = PX2PT(850)/2+35;
    contnetText.centerX = zjScreenWidth/2;
    //切换语句Button
    
    UIButton *changeButton = [[UIButton alloc]init];
    [BarckImgV addSubview:changeButton];
    self.changeButton = changeButton;
    [changeButton setTitle:@"换句祝福" forState:UIControlStateNormal];
    [changeButton setTitleColor:ZJRGBColor(241, 80, 88, 1.0) forState:UIControlStateNormal];
    changeButton.titleLabel.font = [UIFont systemFontOfSize:PX2PT(35)];
    changeButton.width = 50;
    changeButton.height = 13;
    changeButton.y = CGRectGetMaxY(contnetText.frame)+5;
    changeButton.x = CGRectGetMaxX(contnetText.frame)-50;
    [changeButton addTarget:self action:@selector(clickChangButton:) forControlEvents:UIControlEventTouchUpInside];
    //已发送
    UIImageView *imgView = [[UIImageView alloc]init];
    [BarckImgV addSubview:imgView];
    self.hadSendImageView = imgView;
    imgView.image = [UIImage imageNamed:@"Sent"];
    
    imgView.width = PX2PT(170);
    imgView.height = PX2PT(170);
    imgView.centerX = changeButton.centerX;
    imgView.centerY = changeButton.centerY-PX2PT(30);
    imgView.hidden = YES;

}

-(void)tap{
    [self.textView resignFirstResponder];
}
#pragma mark   设置下方客户生日视图

-(void)setupCustomerUI{
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIView *content = [[UIView alloc]init];
    [scrollView addSubview:content];
    self.contentView = content;
    content.backgroundColor = ZJBackGroundColor;
    
    UIButton *sendButton = [[UIButton alloc]init];
    [self.view addSubview:sendButton];
    self.sendMsgButton = sendButton;
    sendButton.backgroundColor = ZJColor00D3A3;
    [sendButton setTitleColor:ZJColorFFFFFF forState:UIControlStateNormal];
    [sendButton setTitle:@"发送祝福" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize55PX];
    sendButton.layer.cornerRadius = PX2PT(10);
    sendButton.clipsToBounds = YES;
    CGFloat buttonhH = self.barckImageView.height +PX2PT(625);
    sendButton.frame = CGRectMake(PX2PT(80), buttonhH, zjScreenWidth - PX2PT(160), PX2PT(128));
    [sendButton addTarget:self action:@selector(clickHadSend) forControlEvents:UIControlEventTouchUpInside];
    
    //提示语
    UILabel *remindLabel = [[UILabel alloc]init];
    [self.view addSubview:remindLabel];
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [remindLabel zj_labelText:@"祝福将会以短信的方式发送给用户" textColor:ZJRGBColor(180, 180, 180, 1.0) textSize:ZJTextSize35PX];
    remindLabel.y = CGRectGetMaxY(sendButton.frame)+PX2PT(60);
    remindLabel.x = 0;
    remindLabel.width = zjScreenWidth;
    remindLabel.height = PX2PT(40);
    
    if (self.customerArray.count ==0) {
        
        scrollView.frame = CGRectZero;
        content.frame = CGRectZero;
        
        remindLabel.hidden = YES;
        sendButton.enabled = NO;
        sendButton.backgroundColor = [UIColor grayColor];
        
        UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"无生日提醒"]];
        [self.view addSubview:imgV];
        imgV.x = (zjScreenWidth - imgV.width)/2;
        imgV.centerY = self.barckImageView.height+ (sendButton.y - CGRectGetMaxY(self.barckImageView.frame))/2;
    }else{
        NSInteger count = self.customerArray.count;

        CGFloat margin = (zjScreenWidth - 4*PX2PT(260))/2;

        _row = 3;
        _linde = (1+(count-1)/3);
        
        CGFloat realHeight = PX2PT(185)+ _linde*PX2PT(440);
        
        CGFloat scrollY = CGRectGetMaxY(self.barckImageView.frame);
        
        scrollView.frame = CGRectMake(0, scrollY, zjScreenWidth, PX2PT(625));
        scrollView.contentSize = CGSizeMake(0, realHeight);
        content.frame = CGRectMake(0, 0, zjScreenWidth, realHeight);
        for (NSInteger i = 0; i<count; i++) {
            
            CGFloat X = PX2PT(130) + (i%_row) *PX2PT(260)+(i%_row)*margin;
            
            CGFloat Y = PX2PT(125) +(i/3)*PX2PT(440);
            
            CGRect frame = CGRectMake(X, Y, PX2PT(260), PX2PT(400));
            
            ZJcustomerTableInfo *customer = self.customerArray[i];
            
            NSString *birthDate = [customer.cBirthDay zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"MM月dd日"];
            
            [self custonerInfoViewWithFrame:frame name:customer.cName date:birthDate index:i];
            
        }
    }
    
    
}

#pragma mark   封装单个客户生日视图
-(void) custonerInfoViewWithFrame:(CGRect)frame name:(NSString *)name date:(NSString *)date index:(NSInteger)index{
    
    UIView *iconView = [[UIView alloc]init];
    iconView.frame = frame;
    [self.contentView addSubview:iconView];
    //头像Button
    UIButton *iconButton = [[UIButton alloc]init];
    iconButton.tag = index;
    [iconView addSubview:iconButton];
    iconButton.frame = CGRectMake(0, 0, PX2PT(260), PX2PT(260));
    [iconButton addTarget:self action:@selector(clickIconButton:) forControlEvents:UIControlEventTouchUpInside];
    
     ZJcustomerTableInfo *customer = self.customerArray[index];
    UIImage *img = nil;
    if (customer.iconPath.length>0) {
        
        img = [UIImage imageWithContentsOfFile:customer.iconPath];
        
        
    }else{
        
        img = [UIImage imageNamed:@"head-portrait"];
        
    }
//    [iconButton setImage:img forState:UIControlStateNormal];
    [iconButton setBackgroundImage:img forState:UIControlStateNormal];

    //名字
    UILabel *nameLabel = [[UILabel alloc]init];
    [nameLabel zj_labelText:name textColor:ZJColor505050 textSize:PX2PT(35)];
    [iconView addSubview:nameLabel];
    [nameLabel zj_adjustWithMin];
    nameLabel.centerX = iconButton.centerX;
    nameLabel.y = PX2PT(300);
    //日期
    UILabel *dateLabel = [[UILabel alloc]init];
    [iconView addSubview:dateLabel];
    [dateLabel zj_labelText:date textColor:ZJColor505050 textSize:PX2PT(35)];
    [dateLabel zj_adjustWithMin];
    dateLabel.centerX = iconButton.centerX;
    dateLabel.y = CGRectGetMaxY(nameLabel.frame)+PX2PT(10);
    
    //顶部小按钮
    UIButton *topButton = [[UIButton alloc]init];
    topButton.tag = index;
    [iconView addSubview:topButton];
    [topButton setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    [topButton setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
    [topButton addTarget:self action:@selector(clickTopButton:) forControlEvents:UIControlEventTouchUpInside];
    topButton.selected = YES;
    topButton.width = PX2PT(50);
    topButton.height = PX2PT(50);
    topButton.y = -topButton.width/2;
    topButton.centerX = iconButton.centerX;
    [self.selectTopButton addObject:topButton];
    [self.topButtonsArray addObject:topButton];
    
    
//    return iconView;
}

#pragma mark   点击头像
-(void)clickIconButton:(UIButton*)button{
    
    UIButton *topButton = self.topButtonsArray[button.tag];
    
    topButton.selected = !topButton.selected;
    
    if (topButton.selected) {
        
        [self.selectTopButton addObject:topButton];
        
    }else{
        
        [self.selectTopButton removeObject:topButton];
        
    }
    
    
    //当选中的人数为0是  发送不能点击
    if (self.selectTopButton.count ==0) {
        self.sendMsgButton.enabled = NO;
        
        self.sendMsgButton.backgroundColor = [UIColor grayColor];
        
    }else{
        
        self.sendMsgButton.enabled = YES;
        
        self.sendMsgButton.backgroundColor = ZJColor00D3A3;
    }
}

#pragma mark   点击上面的小圆圈
-(void)clickTopButton:(UIButton *)button{
    
    button.selected =!button.selected;
    if (button.selected) {
        
        [self.selectTopButton addObject:button];

    }else{
        
        [self.selectTopButton removeObject:button];

    }
    
    //当选中的人数为0是  发送不能点击
    if (self.selectTopButton.count ==0) {
        self.sendMsgButton.enabled = NO;
        
        self.sendMsgButton.backgroundColor = [UIColor grayColor];
        
    }else{
        
        self.sendMsgButton.enabled = YES;
        
        self.sendMsgButton.backgroundColor = ZJColor00D3A3;
    }
}
#pragma mark   数据库查询
-(void) remindDataFromSql{
    
    NSDate *nowDate = [NSDate date];
    
    NSString *nowBString = [nowDate zj_getStringFromDatWithFormatter:@"MM-dd"];
    
    NSString *birthDaysAppend = [NSString stringWithFormat:@"cRemindDate LIKE '%%%@%%'",nowBString];
    for (NSInteger i = 1; i<=7; i++) {
        NSString *birthnowAfter = [nowDate zj_getDateAfterDays:i dateFormat:@"yyyy-MM-dd"];
        
        NSString *BAfterDate = [birthnowAfter zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"MM-dd"];
        
        birthDaysAppend = [NSString stringWithFormat:@"%@ OR cRemindDate LIKE '%%%@%%'",birthDaysAppend,BAfterDate];
        
    }
    
    
    NSString *birthSelect = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE iRemindType=1 AND iSwitch=1 AND (%@)",ZJRemindTableName,birthDaysAppend];
    ZJRemindTableInfo *remind = [[ZJRemindTableInfo alloc]init];
    [ZJFMdb sqlSelecteData:remind selecteString:birthSelect success:^(NSMutableArray *successMsg) {
        
        if (successMsg.count==0)return;
            
        [self customerDateFromSql:successMsg];

    }];
}

-(void)customerDateFromSql:(NSMutableArray *)array{
    
    ZJRemindTableInfo *remindFirst =array[0];
    
  
    ZJcustomerTableInfo *customer = [[ZJcustomerTableInfo alloc]init];
    
    NSString *idString = [NSString stringWithFormat:@"iAutoID=%zd",remindFirst.iCustomerID];
    
    for (NSInteger i = 1; i<array.count; i++) {
        
        ZJRemindTableInfo *remind = array[i];
        
        NSString *temp = [NSString stringWithFormat:@" OR iAutoID=%zd",remind.iCustomerID];
        
        idString = [idString stringByAppendingString:temp];
    }
    
    idString = [NSString stringWithFormat:@"select *from %@ where %@",ZJCustomerTableName,idString];
    
    
    [ZJFMdb sqlSelecteData:customer selecteString:idString success:^(NSMutableArray *successMsg) {
        
        [self.customerArray  addObjectsFromArray:successMsg];
    }];

}

@end
