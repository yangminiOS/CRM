//
//  ZJFollowTableViewCell.m
//  
//
//  Created by mini on 16/11/5.
//
//

#import "ZJFollowTableViewCell.h"
#import "ZJFollowUpTableInfo.h"
#import <AVFoundation/AVFoundation.h>
#import "ZJDirectorie.h"
#import "ZJPhotoCollectionCell.h"
#import "ZJPhotoScrollerView.h"

@interface ZJFollowTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,ZJPhotoScrollerViewDeleagte>
{
    CGFloat _recodeLayoutY;//录音开始布局的Y值
    CGFloat _collectLayoutY;//照片开始布局的Y值
    
    CGFloat _detailLabelH;//详细信息的高度
    
    CGFloat _collectViewH;//照片视图的高度
    
    CGFloat _margin ;//照片间距
    CGFloat _itemWidth;//照片宽度
    
    NSInteger _time;//录音时间
}

//显示时间的Label
@property(nonatomic,strong) UILabel *timeLabel;

//分割线
@property(nonatomic,strong) UIView *lineView;

//**删除按钮**//
@property(nonatomic,strong) UIButton *deleButton;

//显示文字的Label
@property(nonatomic,strong) UILabel *detailLabel;

//**录音**//
@property(nonatomic,strong) UIButton *recodeButton1;

//**录音**//
@property(nonatomic,strong) UIButton *recodeButton2;

//**录音**//
@property(nonatomic,strong) UIButton *recodeButton3;

//**展示照片**//
@property(nonatomic,strong) UICollectionView *collectView;

//**装录音Button的数组**//
@property(nonatomic,strong) NSMutableArray *buttonArray;
//播放器
@property(nonatomic,strong) AVAudioPlayer *player;

//**照片数据**//
@property(nonatomic,strong) NSMutableArray *photosArray;

@end

static NSString *photosIdentifier = @"photosCell";


@implementation ZJFollowTableViewCell

-(NSMutableArray *)photosArray{
    if (!_photosArray) {
        
        _photosArray = [NSMutableArray array];
    }
    return _photosArray;
}

-(NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
        
    }
    return self;
}

-(void)setupUI{
    
    //分割线
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = ZJColorDCDCDC;
    [self.contentView addSubview:_lineView];
    
    //时间
    _timeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_timeLabel];
    _timeLabel.textColor = ZJColor00D3A3;
    _timeLabel.font = [UIFont systemFontOfSize:ZJTextSize35PX];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.backgroundColor = ZJColorFFFFFF;
    
    _deleButton = [[UIButton alloc]init];
    
    [self.contentView addSubview:_deleButton];
    [_deleButton setImage:[UIImage imageNamed:@"BIN"] forState:UIControlStateNormal];
    
    [_deleButton addTarget:self action:@selector(clickDeleButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //详细资料
    _detailLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_detailLabel];
    _detailLabel.font = _timeLabel.font;
    _detailLabel.textColor = ZJColor505050;
    _detailLabel.numberOfLines = 0;
    
    //录音Button
    _recodeButton1 = [[UIButton alloc]init];
    _recodeButton2 = [[UIButton alloc]init];
    _recodeButton3 = [[UIButton alloc]init];
    
    [self setRecodeButton:_recodeButton1];
    [self setRecodeButton:_recodeButton2];
    [self setRecodeButton:_recodeButton3];
 
    //照片
    _margin = 3;
    _itemWidth = (zjScreenWidth - 2*ZJmargin40 - 3*_margin)/4.0;
    CGFloat itemHeight = _itemWidth;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(_itemWidth, itemHeight);
    flowLayout.minimumLineSpacing = _margin;
    flowLayout.minimumInteritemSpacing = _margin;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, ZJmargin40, 0, ZJmargin40);
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.contentView addSubview:_collectView];
    _collectView.backgroundColor = ZJColorFFFFFF;
    _collectView.showsVerticalScrollIndicator = NO;
    _collectView.showsHorizontalScrollIndicator = NO;
    _collectView.delegate = self;
    _collectView.dataSource = self;
    [_collectView registerClass:[ZJPhotoCollectionCell class] forCellWithReuseIdentifier:photosIdentifier];


}

//设置录音Button
-(void)setRecodeButton:(UIButton *)button{
    
    [self.contentView addSubview:button];
    
    //边框
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:1.0];
    button.layer.borderColor = ZJColor505050.CGColor;
    //    圆角
    button.layer.cornerRadius = 2.0;
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [button setImage:[UIImage imageNamed:@"trumpet"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [button setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

    button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self.buttonArray addObject:button];

}

-(void)setModel:(ZJFollowUpTableInfo *)model{
    _model = model;
    
    _recodeLayoutY = PX2PT(116);
    _collectLayoutY = PX2PT(116);
    
    _timeLabel.text = model.cLogTime;
    
    if (model.cText.length>0) {
        
        _detailLabelH = [model.cText zj_getStringRealHeightWithWidth:zjScreenWidth - PX2PT(80) fountSize:PX2PT(35)];
        _detailLabel.text = model.cText;
        _recodeLayoutY +=_detailLabelH +ZJmargin40;
        _collectLayoutY+=_detailLabelH +ZJmargin40;
    }
    
    for (NSInteger i = 0; i<model.recodeNameArray.count; i++) {
        
        UIButton *button = self.buttonArray[i];
        button.tag = i;
        
        NSString *path = [ZJDirectorie getVoicePathWithDirectoryName:self.dirName];
        
        path = [path stringByAppendingPathComponent:model.recodeNameArray[i]];
        
        NSInteger time =[[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:path isDirectory:YES] error:nil].duration;
        _time = time;
        NSString *title = [NSString stringWithFormat:@"%zd\"", time];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickPlaterButton:) forControlEvents:UIControlEventTouchUpInside];
        
        button.width = 60 + (self.width - 2*ZJmargin40 - 60)*time/180;
        
        _collectLayoutY+=ZJmargin40 +30;

    }
    
    if (model.photosArray.count>0) {
        [self.photosArray removeAllObjects];
        
        for (NSInteger i = 0; i<model.photosArray.count; i++) {
            
            NSString*path= [ZJDirectorie getImagePathWithDirectoryName:self.dirName];
            path = [path stringByAppendingPathComponent:model.photosArray[i]];
            
            UIImage *img = [[UIImage alloc]initWithContentsOfFile:path];
            
            [self.photosArray addObject:img];
            
        }
        _collectViewH =(self.photosArray.count-1)/4*(_itemWidth + _margin)+PX2PT(30)+_itemWidth;
        [_collectView reloadData];
    }else{
        
        [self.photosArray removeAllObjects];

        self.collectView.frame = CGRectZero;
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _lineView.frame = CGRectMake(0, PX2PT(52.5), zjScreenWidth, 1);
    
    _timeLabel.frame = CGRectMake((zjScreenWidth - 60)/2.0, PX2PT(40), 60, PX2PT(36));
    
    _deleButton.y = PX2PT(75.5);
    
    _deleButton.x = zjScreenWidth - PX2PT(20) - 30;
    
    _deleButton.width = 30;
    
    _deleButton.height = 30;
    //详细信息
    if (_model.cText.length>0) {
        _detailLabel.frame = CGRectMake(ZJmargin40, PX2PT(116), zjScreenWidth - PX2PT(80)-30, _detailLabelH);
    }
    //有录音的情况
    
    for (NSInteger i = 0; i<_model.recodeNameArray.count; i++) {
        UIButton *button = _buttonArray[i];
        button.y = i*(30+ZJmargin40)+_recodeLayoutY;
        button.x = ZJmargin40;
        button.height = 30;
//        button.width = _time/180.0*(zjScreenWidth -2*ZJmargin40 -80)+60;
    }
    //没有录音的情况
//    for (NSInteger i = 0 ; i<self.buttonArray.count; i++) {
//        UIButton *button = _buttonArray[i];
//        if (i >=_model.recodeNameArray.count) {
//            
//            button.frame = CGRectZero;
//            button.hidden = YES;
//        }
//    }
    NSInteger index = 0;
    for (UIButton *button in self.buttonArray) {
        if (index>=_model.recodeNameArray.count) {
            button.frame = CGRectZero;

        }
        index++;
        
    }
    //有照片的情况
    if (self.photosArray.count>0) {
        
        _collectView.frame = CGRectMake(0, _collectLayoutY, zjScreenWidth, _collectViewH);
    }else{    //没有照片的情况

        _collectView.frame = CGRectZero;
    }
    
}

#pragma mark   点击播放按钮
-(void)clickPlaterButton:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        
        NSString *path = [ZJDirectorie getVoicePathWithDirectoryName:self.dirName];
        
        path = [path stringByAppendingPathComponent:_model.recodeNameArray[button.tag]];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:path isDirectory:YES] error:nil];
        [_player play];
    }else{
        
        [_player pause];
    }
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photosArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photosIdentifier forIndexPath:indexPath];
    
//    NSString*path= [ZJDirectorie getImagePathWithDirectoryName:self.dirName];
//    path = [path stringByAppendingPathComponent:self.photosArray[indexPath.row]];
    
//    cell.imageV.image = [UIImage imageWithContentsOfFile:path];
    
    cell.imageV.image = self.photosArray[indexPath.row];
    
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
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

#pragma mark   点击删除按钮
-(void)clickDeleButton:(UIButton *)button{
    
    [self.delegate ZJFollowTableViewCell:self cellIndexPath:self.indexPath];
}
@end






















