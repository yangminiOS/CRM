//
//  ZJHeaderView.m
//  CRM
//
//  Created by 杨敏 on 16/9/27.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJHeaderView.h"
#import "ZJcustomerTableInfo.h"
#import "ZJItemdsCollectionCell.h"
#import "ZJCustomerItemsTableInfo.h"

@interface ZJHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIButton *_sendMsgButton;//发信息
    UIButton *_cellPhoneButton;//打电话
    UIView *_infoView;//底部内容视图
    UIImageView *_iconImgView;//头像
    UILabel *_nameLabel;//姓名
    UIImageView *_sexImgView;//性别
    UILabel *_phoneLabel;//电话
    UICollectionView *_collectionView;//放items
    UIButton *_coverButton;//覆盖Button
    UIView * _separatorLine;//分割线
    UIView * _separatorLine2;//分割线

    BOOL _isEnterNext;//判断是进入下一个界面还是cell返回

}
//**展开BUtton**//
@property(nonatomic,weak) UIButton *explainButton;
//****//
@property(nonatomic,strong) NSMutableArray *itemsArray;

@end

static NSString *identifier = @"itemCell";
@implementation ZJHeaderView

-(NSMutableArray *)itemsArray{
    
    if (!_itemsArray) {
        
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        
    }
    
    return self;
}

-(void)setupUI{
    
    UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipView:)];
    [leftSwip setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    
    UISwipeGestureRecognizer *rightSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipView:)];
    [rightSwip setDirection:UISwipeGestureRecognizerDirectionRight];
    
    _sendMsgButton = [[UIButton alloc]init];
    [self.contentView addSubview:_sendMsgButton];
    [_sendMsgButton setImage:[UIImage imageNamed:@"note"] forState:UIControlStateNormal];
    [_sendMsgButton setBackgroundColor:ZJRGBColor(102, 214, 255, 1.0)];
    [_sendMsgButton addTarget:self action:@selector(clickSendMsgButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _cellPhoneButton = [[UIButton alloc]init];
    [self.contentView addSubview:_cellPhoneButton];
    [_cellPhoneButton setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [_cellPhoneButton setBackgroundColor:ZJColor00D3A3];
    [_cellPhoneButton addTarget:self action:@selector(clickTellPhoneButton:) forControlEvents:UIControlEventTouchUpInside];

    _infoView = [[UIView alloc]init];
    [self.contentView addSubview:_infoView];
    _infoView.backgroundColor = ZJColorFFFFFF;
    [_infoView addGestureRecognizer:leftSwip];
    [_infoView addGestureRecognizer:rightSwip];
    //头像_iconImgView
    _iconImgView = [[UIImageView alloc]init];
    [ _infoView addSubview:_iconImgView];
    _iconImgView.layer.cornerRadius = 8;
    _iconImgView.clipsToBounds = YES;
    //姓名_nameLabel
    _nameLabel = [[UILabel alloc]init];
    [_infoView addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = ZJColor505050;
    //性别
    _sexImgView = [[UIImageView alloc]init];
    [_infoView addSubview:_sexImgView];
    //手机号_phoneLabel
    _phoneLabel = [[UILabel alloc]init];
    [_infoView addSubview:_phoneLabel];
    _phoneLabel.font = [UIFont systemFontOfSize:15];
    _phoneLabel.textColor = ZJColor505050;
    CGFloat margin = PX2PT(20);
    CGFloat itmewidth = (zjScreenWidth - PX2PT(192)-3*ZJmargin40-3*margin)/4.0;
    CGFloat itemHeight = 23;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(itmewidth, itemHeight);
    flowLayout.minimumLineSpacing = margin;
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [_infoView addSubview:collectionView];
    _collectionView = collectionView;
    collectionView.backgroundColor = ZJColorFFFFFF;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[ZJItemdsCollectionCell class] forCellWithReuseIdentifier:identifier];

    //展开和Button
    UIButton *button = [[UIButton alloc]init];
    self.explainButton = button;
    [button setImage:[UIImage imageNamed:@"An-arrow_b4b4b4"] forState:UIControlStateNormal];
//    [_explainButton setImage:[UIImage imageNamed:@"Contraction-arrow_b4b4b4"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(cliclExplainButton:) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:button];
    
    //遮盖Button
    _coverButton = [[UIButton alloc]init];
    [_infoView addSubview:_coverButton];
    [_coverButton addTarget:self action:@selector(clickCoverButton:) forControlEvents:UIControlEventTouchUpInside];

    //分割线
    _separatorLine = [[UIView alloc]init];
    _separatorLine.backgroundColor = ZJRGBColor(80, 80, 80, 0.3);
    [self addSubview:_separatorLine];
    
    //分割线
    _separatorLine2 = [[UIView alloc]init];
    _separatorLine2.backgroundColor = ZJRGBColor(80, 80, 80, 0.3);
    [self addSubview:_separatorLine2];
}

#pragma mark   cellectionView代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemsArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZJItemdsCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    ZJCustomerItemsTableInfo *items =self.itemsArray[indexPath.row];
    cell.itemLabel.text =items.itemString;

    return cell;
}
//左滑
-(void)leftSwipView:(UISwipeGestureRecognizer *)leftSwip{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _infoView.x = -140;

    }];
    _isEnterNext = NO;

}
//右滑
-(void)rightSwipView:(UISwipeGestureRecognizer *)rightSwip{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _infoView.x =0;
        
    }];
    _isEnterNext = YES;
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _sendMsgButton.frame = CGRectMake(zjScreenWidth-70, 0, 70, self.height);
    
    _cellPhoneButton.frame = CGRectMake(zjScreenWidth - 140, 0, 70, self.height);
    
    _infoView.frame = self.bounds;
    
    _iconImgView.frame = CGRectMake(ZJmargin40, PX2PT(44), PX2PT(192), PX2PT(192));
    _nameLabel.x =2*ZJmargin40 +PX2PT(192);
    _nameLabel.y = PX2PT(44);
    
    CGFloat sexX = CGRectGetMaxX(_nameLabel.frame)+10;
    _sexImgView.frame = CGRectMake(sexX, PX2PT(44), 13, 16);
    
    CGFloat phoneX = 2*ZJmargin40 +PX2PT(192);
    _phoneLabel.frame = CGRectMake(phoneX, PX2PT(44)+16, 120, 16);
    CGFloat collectViewY = PX2PT(44)+16+16+8;
    _collectionView.frame = CGRectMake(phoneX, collectViewY, self.width - phoneX - ZJmargin40, self.height - collectViewY);
    
    _explainButton.frame = CGRectMake(self.width - ZJmargin40 - 31,ZJmargin40, 31, 31);
    
    _coverButton.frame = CGRectMake(0, 0, self.width-31-ZJmargin40, self.height);
    _separatorLine.frame = CGRectMake(0, self.height -PX2PT(1), self.width, PX2PT(1));
    
    _separatorLine2.frame = CGRectMake(0, 0, self.width, PX2PT(1));
    
}

-(void)setCustomerModel:(ZJcustomerTableInfo *)customerModel{
    _isEnterNext = YES;

    _customerModel = customerModel;
    
    if (customerModel.iconPath.length>0) {
        _iconImgView.image = [UIImage imageWithContentsOfFile:customerModel.iconPath];
        
    }else{
        
        _iconImgView.image = [UIImage imageNamed:@"KHCD-head-portrait"];

    }
    
    UIImage *sexImg = nil;
    if (customerModel.iSex == 0) {
        
         sexImg= [UIImage imageNamed:@"MAN-0"];
    }else{
        sexImg = [UIImage imageNamed:@"WOMAN-0"];
    }
    _sexImgView.image = sexImg;
    _nameLabel.text = customerModel.cName;
    [_nameLabel zj_adjustWithMin];

    _phoneLabel.text = customerModel.cPhone;
    [self.itemsArray removeAllObjects];
    [self.itemsArray addObjectsFromArray:customerModel.itemsString];
    [_collectionView reloadData];
}
#pragma mark   点击遮盖Button

-(void)clickCoverButton:(UIButton *)button{
    
    if (_isEnterNext) {
        [self.delegate headerView:self didClickCoverButton:button];
    }else{
        [self rightSwipView:nil];
    }
    
    
}
#pragma mark   点击展开按钮
-(void)cliclExplainButton:(UIButton *)button{
    
    [self.delegate headerView:self didClickDecoilButton:button];
    

}
//图标处理
-(void)setRotageImgView:(BOOL)rotageImgView{
    _rotageImgView = rotageImgView;
    
    if (rotageImgView) {
        
        _explainButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }else{
        
        _explainButton.imageView.transform = CGAffineTransformIdentity;
    }
}

#pragma mark   打电话
- (void)clickTellPhoneButton:(UIButton *)button {
    
    NSString *phoneNumber = self.customerModel.cPhone ;
    NSString *url = [NSString stringWithFormat:@"telprompt://%@",phoneNumber];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
}
#pragma mark   发短信
- (void)clickSendMsgButton:(UIButton *)button {
    
    NSString *phoneNumber = self.customerModel.cPhone ;

    NSString *url=[NSString stringWithFormat:@"sms://%@",phoneNumber];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
