//
//  ZJaBaseInfoView.m
//  CRM
//
//  Created by mini on 16/9/29.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJCustomerMsgView.h"
#import "ZJcustomerTableInfo.h"
#import "ZJItemdsCollectionCell.h"
#import "ZJPhotoCollectionCell.h"
#import "ZJCustomerItemsTableInfo.h"
#import "ZJDirectorie.h"
#import "ZJPhotoScrollerView.h"
@interface ZJCustomerMsgView()<UICollectionViewDelegate,UICollectionViewDataSource,ZJPhotoScrollerViewDeleagte>

{

    UILabel *_loanCountLabel;
    UILabel *_insterestLabel;
    UILabel *_loanTimeLabel;
    UICollectionView *_itemsCollectView;//放items
    UIView *_introducerView;//介绍人
    UICollectionView *_photosCollectView;//照片
    
}
//**模型**//
@property(nonatomic,strong)ZJcustomerTableInfo *model;
//**items数据**//
@property(nonatomic,strong) NSMutableArray *ItemsdateArray;
//**照片数据**//
@property(nonatomic,strong) NSMutableArray *photosArray;

@end

static NSString *itemsIdentifier = @"itemCell";
static NSString *photosIdentifier = @"photosCell";


@implementation ZJCustomerMsgView

-(NSMutableArray *)ItemsdateArray{
    
    if (!_ItemsdateArray) {
        
        _ItemsdateArray = [NSMutableArray array];
    }
    return _ItemsdateArray;
}
-(NSMutableArray *)photosArray{
    if (!_photosArray) {
        
        _photosArray = [NSMutableArray array];
    }
    return _photosArray;
}
-(instancetype)initWithFrame:(CGRect)frame withModel:(ZJcustomerTableInfo*)model{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = ZJBackGroundColor;
        self.model = model;
        [self setupUI];
        
    }
    
    return self;
}

-(void)setupUI{
    [self setupBaseInfo];
    [self setupItemsView];
    [self setupIntroducerView];
    [self setupPhotosView];
    [self setupMoreInfoView];
}
#pragma mark   基本信息
-(void)setupBaseInfo{
    _loanCountLabel = [[UILabel alloc]init];
    
    [_loanCountLabel zj_labelText:@"(万元)"
                        textColor:ZJColorDCDCDC
                         textSize:ZJTextSize45PX];
    
    _loanCountLabel.textAlignment = NSTextAlignmentRight;
    
    _insterestLabel = [[UILabel alloc]init];
    
    [_insterestLabel zj_labelText:@"(%)"
                        textColor:ZJColorDCDCDC
                         textSize:ZJTextSize45PX];
    
    _insterestLabel.textAlignment = NSTextAlignmentRight;
    
    
    _loanTimeLabel = [[UILabel alloc]init];
    
    [_loanTimeLabel zj_labelText:@"个月"
                       textColor:ZJColorDCDCDC
                        textSize:ZJTextSize45PX];
    
    _loanTimeLabel.textAlignment = NSTextAlignmentRight;
    
    NSArray*titlesArray = @[@"    姓        名",@"    生        日",@"    身份证号",@"    手        机",@"    贷款金额",@"    利       息",@"    贷款日期",@"    贷款期限"];
    NSArray *array = @[self.model.cName,self.model.cBirthDay,self.model.cCardID,self.model.cPhone ,@(self.model.fBorrowMoney),@(self.model.fMonthlyInterest),self.model.cLoanDate,self.model.cLoanTimeLimit];
    
    for (NSInteger i = 0; i<titlesArray.count; i++) {
        
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = ZJColorFFFFFF;

        NSString *content = array[i];
        
        if ([content isKindOfClass:[NSString class]]&&[content isEqualToString:@""]) {
            
            content = @"未填写";
        }
        NSString *text = [NSString stringWithFormat:@"%@      %@",titlesArray[i],content];
        [label zj_labelText:text textColor:ZJColor505050 textSize:ZJTextSize45PX];
        [self addSubview:label];
        label.frame = CGRectMake(0, i*PX2PT(128), self.width, PX2PT(128));
        
        
        //分割线
        UIView *line = [[UIView alloc]init];
        [self addSubview:line];
        line.backgroundColor = ZJColorDCDCDC;
        line.frame = CGRectMake(ZJmargin40, (i+1)*PX2PT(128)-1, zjScreenWidth-ZJmargin40, 1);
        
        if (i ==4) {
            
            [self addSubview:_loanCountLabel];
            _loanCountLabel.frame = CGRectMake(self.width - ZJmargin40 - 50, i*PX2PT(128), 50, PX2PT(128));
            
        }else if (i == 5){
            
            [self addSubview:_insterestLabel];
            _insterestLabel.frame = CGRectMake(self.width - ZJmargin40 - 50, i*PX2PT(128), 50, PX2PT(128));
            
        }else if (i == 7){
            
            [self addSubview:_loanTimeLabel];
            _loanTimeLabel.frame = CGRectMake(self.width - ZJmargin40 - 50, i*PX2PT(128), 50, PX2PT(128));
            
        }
        
    }
    
}
#pragma mark   展示items
-(void)setupItemsView{
    [self.ItemsdateArray addObjectsFromArray:self.model.itemsString];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleLabel zj_labelText:@"客户状态" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    CGFloat itemsY =16+ZJmargin40 +PX2PT(30);
    CGFloat height = 0;
    if (self.ItemsdateArray.count>0) {
        
         height = itemsY+23+ZJmargin40 +(self.ItemsdateArray.count -1)/4*(PX2PT(20)+23);
    }
    
    CGFloat margin = PX2PT(20);
    CGFloat itmewidth = (self.width -2*ZJmargin40-3*margin)/4.0;
    CGFloat itemHeight = 23;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(itmewidth, itemHeight);
    flowLayout.minimumLineSpacing = margin;
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(itemsY, ZJmargin40, ZJmargin40, ZJmargin40);
    CGRect frame = CGRectMake(0, 8*PX2PT(128), self.width, height);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
    [self addSubview:collectionView];
    _itemsCollectView = collectionView;
    collectionView.backgroundColor = ZJColorFFFFFF;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[ZJItemdsCollectionCell class] forCellWithReuseIdentifier:itemsIdentifier];
    //添加标题
    [collectionView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(ZJmargin40, ZJmargin40, self.width, 16);
    //分割线
    UIView *line= [[UIView alloc]init];
    [collectionView addSubview:line];
    line.backgroundColor = ZJColorDCDCDC;
    line.frame = CGRectMake(0, collectionView.height -1, zjScreenWidth, 1);
    
}
#pragma mark   collectView代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == _itemsCollectView) {
        return self.ItemsdateArray.count;

    }else{
        return self.photosArray.count;

    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _itemsCollectView) {
        ZJItemdsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemsIdentifier forIndexPath:indexPath];
        
        ZJCustomerItemsTableInfo *items =self.ItemsdateArray[indexPath.row];
        cell.itemLabel.text =items.itemString;
        return cell;

    }else{
        ZJPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photosIdentifier forIndexPath:indexPath];
   
            
//            NSString*path= [ZJDirectorie getImagePathWithDirectoryName:self.model.GUID];
//            path = [path stringByAppendingPathComponent:self.photosArray[indexPath.row]];
        
        cell.imageV.image = self.photosArray[indexPath.row];
        
        
        return cell;
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == _itemsCollectView)return;
    
    CGRect frame = CGRectMake(0, 0, zjScreenWidth, zjScreenHeight);
    ZJPhotoScrollerView *PhotoScroll = [[ZJPhotoScrollerView alloc]initWithFrame:frame PhotosArray:self.photosArray viewType:CheckType];
    
    PhotoScroll.delegate = self;
    
    [[UIApplication sharedApplication].keyWindow addSubview:PhotoScroll];
    
    [PhotoScroll clickItemIndex:indexPath.row];
}

-(void)ZJPhotoScrollerView:(ZJPhotoScrollerView *)view{
    
    [view removeFromSuperview];
    
    view = nil;
}

#pragma mark   介绍人
-(void)setupIntroducerView{
    
    CGFloat remarkLabelH = 0;
    if (self.model.cCustomerState_Remark.length>0) {
        remarkLabelH = [self.model.cCustomerState_Remark zj_getStringRealHeightWithWidth:self.width - 2*ZJmargin40-10 fountSize:ZJTextSize35PX]+10;
    }
        
    
    CGFloat viewHeight = ZJmargin40+24+PX2PT(30)+remarkLabelH + ZJmargin40;
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = ZJColorFFFFFF;
    [self addSubview:view];
    _introducerView = view;
    CGFloat viewY = CGRectGetMaxY(_itemsCollectView.frame);
    view.frame = CGRectMake(0, viewY, self.width, viewHeight);
    //分割线
    
    UIView *line= [[UIView alloc]init];
    [view addSubview:line];
    line.backgroundColor = ZJColorDCDCDC;
    line.frame = CGRectMake(0, view.height -1, zjScreenWidth, 1);
    //介绍人
    UILabel*introLabel = [[UILabel alloc]init];
    [view addSubview:introLabel];
    NSString *tempName = self.model.cCustomerSource_IntroducerName;
    if ([tempName isEqualToString:@""]) {
        
        tempName = @"无";
    }
    NSString *text = [NSString stringWithFormat:@"介绍人：%@",tempName];
    [introLabel zj_labelText:text textColor:ZJColor505050 textSize:ZJTextSize45PX];
    [introLabel zj_adjustWithMin];
    introLabel.x = ZJmargin40;
    introLabel.y = ZJmargin40;
    //打电话
    if (self.model.cCustomerSource_IntroducerPhone.length>1) {
        UIButton *phoneButton = [[UIButton alloc]init];
        [view addSubview:phoneButton];
        [phoneButton setImage:[UIImage imageNamed:@"PHONE"] forState:UIControlStateNormal];
        phoneButton.frame = CGRectMake(ZJmargin40 +introLabel.width, PX2PT(30), 24, 24);
        [phoneButton addTarget:self action:@selector(clickPhoneButton) forControlEvents:UIControlEventTouchUpInside];
    }
    //客户状态备注

    UIButton *remarkButton = [[UIButton alloc]init];
    remarkButton.enabled = NO;
    remarkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    remarkButton.titleLabel.numberOfLines = 0;
    remarkButton.backgroundColor = ZJBackGroundColor;
    remarkButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [view addSubview:remarkButton];
    [remarkButton setTitle:self.model.cCustomerState_Remark forState:UIControlStateNormal];
    remarkButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize35PX];
    [remarkButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    CGFloat remarkY = CGRectGetMaxY(introLabel.frame)+PX2PT(30);
    remarkButton.frame = CGRectMake(ZJmargin40, remarkY, self.width - 2*ZJmargin40, remarkLabelH);

}

#pragma mark   展示图片
-(void)setupPhotosView{
    
//    [self.photosArray addObjectsFromArray:self.model.photosPath];
    
    for (NSInteger i = 0; i<self.model.photosPath.count; i++) {
        
        NSString*path= [ZJDirectorie getImagePathWithDirectoryName:self.model.GUID];
        
        path = [path stringByAppendingPathComponent:_model.photosPath[i]];
        
        UIImage *img = [[UIImage alloc]initWithContentsOfFile:path];
        
        [self.photosArray addObject:img];
    }
    NSInteger count =self.photosArray.count;
    if (count ==0) {
        
        UIImage *img = [UIImage imageNamed:@"no_photos"];
        
        [self.photosArray addObject:img];
    }
    
    CGFloat margin = 3;
    CGFloat itemWidth = (self.width - 2*ZJmargin40 - 3*margin)/4.0;
    CGFloat itemHeight = itemWidth;
    CGFloat photosHeight = (count-1)/4*(itemWidth + margin)+PX2PT(30)+itemWidth;
    
    CGFloat viewHeight = 2*ZJmargin40 +16 + photosHeight;
    
    UILabel *label = [[UILabel alloc]init];
    [label zj_labelText:@"资料照片" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    label.frame = CGRectMake(ZJmargin40, ZJmargin40, 80, 16);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    flowLayout.minimumLineSpacing = margin;
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(PX2PT(70)+16, ZJmargin40, ZJmargin40, ZJmargin40);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat photoY = CGRectGetMaxY(_introducerView.frame);
    CGRect frame = CGRectMake(0, photoY, self.width, viewHeight);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
    [self addSubview:collectionView];
    _photosCollectView = collectionView;
    collectionView.backgroundColor = ZJColorFFFFFF;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[ZJPhotoCollectionCell class] forCellWithReuseIdentifier:photosIdentifier];
    
    [collectionView addSubview:label];
    
    //分割线
    UIView *line= [[UIView alloc]init];
    [collectionView addSubview:line];
    line.backgroundColor = ZJColorDCDCDC;
    line.frame = CGRectMake(0, collectionView.height -1, zjScreenWidth, 1);
    
}

-(void)setupMoreInfoView{
    
    CGFloat buttonHeight = 0;
    NSString *tempRemark = self.model.cCustomerRemark_Text;
    if (tempRemark.length>0) {
        
        buttonHeight = [tempRemark zj_getStringRealHeightWithWidth:self.width - 2*ZJmargin40-10 fountSize:ZJTextSize45PX]+10;
    }else{
        tempRemark = @"无";
        
        buttonHeight = [tempRemark zj_getStringRealHeightWithWidth:self.width - 2*ZJmargin40-10 fountSize:ZJTextSize45PX]+10;

    }
    CGFloat viewHeight =buttonHeight + 16 +2*ZJmargin40;
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = ZJColorFFFFFF;
    [self addSubview: view];
    CGFloat viewY = CGRectGetMaxY(_photosCollectView.frame)+1;
    view.frame = CGRectMake(0, viewY, self.width, viewHeight);
    
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    [label zj_labelText:@"更多信息" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    label.frame =CGRectMake(ZJmargin40, ZJmargin40, self.width, 16);
    
    UIButton *remarkButton = [[UIButton alloc]init];
    [view addSubview:remarkButton];
    remarkButton.enabled = NO;
    remarkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    remarkButton.titleLabel.numberOfLines = 0;
    remarkButton.backgroundColor = ZJBackGroundColor;
    remarkButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [view addSubview:remarkButton];
    
    [remarkButton setTitle:tempRemark forState:UIControlStateNormal];
    remarkButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize35PX];
    [remarkButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    remarkButton.frame = CGRectMake(ZJmargin40, PX2PT(70)+16, self.width - 2*ZJmargin40, buttonHeight);
    self.msgViewHeight = CGRectGetMaxY(view.frame)+ZJmargin40 ;
    self.height = self.msgViewHeight;
        
}

#pragma mark   打电话
-(void)clickPhoneButton{
    
    NSString *url=[NSString stringWithFormat:@"telprompt://%@",self.model.cCustomerSource_IntroducerPhone];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];


}

@end
