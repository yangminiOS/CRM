//
//  ZJFollowTableViewCell.h
//  
//
//  Created by mini on 16/11/5.
//
//

#import <UIKit/UIKit.h>
@class ZJFollowUpTableInfo,ZJFollowTableViewCell;

@protocol ZJFollowTableViewCellDelegate <NSObject>


-(void)ZJFollowTableViewCell:(ZJFollowTableViewCell *)view cellIndexPath:(NSIndexPath *)indexPath;

@end


@interface ZJFollowTableViewCell : UITableViewCell

//*代理**//
@property(nonatomic,weak) id<ZJFollowTableViewCellDelegate> delegate;
//**模型**//
@property(nonatomic,strong) ZJFollowUpTableInfo *model;

//**文件夹名字**//
@property(nonatomic,copy)NSString *dirName;

//**<#注释#>**//
@property(nonatomic,strong) NSIndexPath *indexPath;

@end
