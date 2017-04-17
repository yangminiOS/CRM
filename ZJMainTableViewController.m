//
//  ZJMainTableViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/11/21.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJMainTableViewController.h"
#import "ZJSetupViewController.h"
#import "ZJPersonViewController.h"
#import "ZJLoginViewControllerViewController.h"
#import "ZJUser.h"
#import "UIImageView+WebCache.h"
#import "ZJSynchronousCloudViewController.h"
@interface ZJMainTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *UserImageView;
@property (weak, nonatomic) IBOutlet UILabel *SignatureLable;
@property (weak, nonatomic) IBOutlet UILabel *SynchronousLabel;
@property (weak, nonatomic) IBOutlet UILabel *SetupLabel;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *PhoneLabel;



//声明一个cell 用于 临时保存点中的cell
@property(nonatomic,strong)UITableViewCell *selectCell;
@end

@implementation ZJMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我";
    //设置每行字体样式
    [self loadStyle];
    
    self.UserImageView.layer.masksToBounds = YES;
    self.UserImageView.layer.cornerRadius = PX2PT(20);
    
   
    
}

- (void)viewWillAppear:(BOOL)animated{
    // 取出个人信息
    NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"];
    NSData *data = [NSData dataWithContentsOfFile:documentsPath];
    ZJUser * User = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (User) {
        self.SignatureLable.hidden = YES;
        self.PhoneLabel.hidden = NO;
        [self.PhoneLabel zj_labelText:[NSString stringWithFormat:@"%@",User.Phone] textColor:ZJColor505050 textSize:ZJTextSize45PX];
        
        self.NameLabel.hidden = NO;
        if (User.Name == NULL) {
            [self.NameLabel zj_labelText:@"请设置姓名" textColor:ZJColor505050 textSize:ZJTextSize45PX];
        }else {
            NSString *urldecode = [User.Name zj_urlDecode];
        [self.NameLabel zj_labelText:[NSString stringWithFormat:@"%@",urldecode] textColor:ZJColor505050 textSize:ZJTextSize45PX];
        }
        if (User.Image == NULL) {
        [self.UserImageView sd_setImageWithURL:[NSURL URLWithString:User.Head] placeholderImage:[UIImage imageNamed:@"I_head-portrait"]];
           
        }else {
            self.UserImageView.image = User.Image;
        }
    }else {
        self.PhoneLabel.hidden = YES;
        self.NameLabel.hidden = YES;
        self.SignatureLable.hidden = NO;
        self.UserImageView.image = [UIImage imageNamed:@"I_head-portrait"];
    }
    [self.tableView reloadData];
}


- (void)loadStyle{
    
    [self.SynchronousLabel zj_labelText:@"云同步" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    [self.SetupLabel zj_labelText:@"关于好客" textColor:ZJColor505050 textSize:ZJTextSize45PX];
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //把选中的Cell 获取出来
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //将点中的cell 保存到 属性中
    self.selectCell = cell;
    
    switch (cell.tag) {
        case 0:
        {
          
            NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"]];
            ZJUser * User = [NSKeyedUnarchiver unarchiveObjectWithData:data];
           
            if (User.Phone != NULL) {
                [self performSegueWithIdentifier:@"person" sender:nil];
            }else {
                ZJLoginViewControllerViewController *Login = [[ZJLoginViewControllerViewController alloc]init];
            [self.navigationController pushViewController:Login animated:YES];
            }            
            
        }
            break;
        case 1:
        {
            ZJSynchronousCloudViewController *Cloud=  [[ZJSynchronousCloudViewController alloc]init];
            [self.navigationController pushViewController:Cloud animated:YES];
            
        }
            break;
        case 2:
            break;
        case 4:
        {
            ZJSetupViewController *setup = [ZJSetupViewController new];
            [self.navigationController pushViewController:setup animated:YES];
        }
            break;
        default:
            break;
    }
}

//设置rowHeight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 91;
    }else {
        return 40;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return PX2PT(40);
    }else {
        return 1;
    }
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return PX2PT(40);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
