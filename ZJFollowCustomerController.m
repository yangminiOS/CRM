//
//  ZJFollowCustomerController.m
//  CRM
//
//  Created by mini on 16/11/24.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJFollowCustomerController.h"
#import "ZJcustomerTableInfo.h"
#import "ZJFMdb.h"

@interface ZJFollowCustomerController ()<UITableViewDelegate,UITableViewDataSource>

//tableView
@property(nonatomic,weak) UITableView *tableView;

//**dataArray**//
@property(nonatomic,strong) NSMutableArray *dataArray;

//**标题**//
@property(nonatomic,strong) NSMutableArray *indexArray;
@end

static NSString *identifier = @"followCustomer";
@implementation ZJFollowCustomerController

#pragma mark   懒加载

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)indexArray{
    if (!_indexArray) {
        
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavi];
    
    [self dataFromSQL];
    
    [self setupTableView];

}
#pragma mark   导航
-(void)setupNavi{
    
    self.view.backgroundColor = ZJColorFFFFFF;
    self.navigationItem.title = @"选择跟进客户";
}

#pragma mark   设置tableView
-(void)setupTableView{
    
    CGRect frame = CGRectMake(0, 0, zjScreenWidth, self.view.height - 64);
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self ;
    self.tableView = tableView;
//    tableView.contentInset = UIEdgeInsetsMake(15, 0, 20, 0);
    [self.view addSubview:tableView];
    
}


#pragma mark   UITableViewDelegate,UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    ZJcustomerTableInfo *customer = self.dataArray[section];
    
    return customer.customerModelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    ZJcustomerTableInfo *customer = self.dataArray[indexPath.section];
    
    ZJcustomerTableInfo *model = customer.customerModelArray[indexPath.row];

    cell.textLabel.text = model.cName;
    
    cell.detailTextLabel.text = model.cPhone;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    ZJcustomerTableInfo *customer = self.dataArray[section];
    return customer.cFirstAlphabet;

}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _indexArray;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJcustomerTableInfo *customer = self.dataArray[indexPath.section];
    
    ZJcustomerTableInfo *model = customer.customerModelArray[indexPath.row];
    
    [self.delegate ZJFollowCustomerController:self customerModel:model];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

#pragma mark   数据库
-(void)dataFromSQL{
    
    ZJcustomerTableInfo *customer = [[ZJcustomerTableInfo alloc]init];
    NSString *selectGroup = [NSString stringWithFormat:@"SELECT * FROM %@ GROUP BY cFirstAlphabet",ZJCustomerTableName];
    [ZJFMdb sqlSelecteData:customer selecteString:selectGroup success:^(NSMutableArray *successMsg) {
        
        [self.dataArray addObjectsFromArray:successMsg];
    }];
    
    for (NSInteger i = 0; i<self.dataArray.count; i++) {
        
        ZJcustomerTableInfo *model = self.dataArray[i];
        
        NSString *first = model.cFirstAlphabet;
        
        [self.indexArray addObject:first];
        
        NSString *selectFirst = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE cFirstAlphabet='%@'",ZJCustomerTableName,first];
        [ZJFMdb sqlSelecteData:model selecteString:selectFirst success:^(NSMutableArray *successMsg) {
            
            [model.customerModelArray addObjectsFromArray:successMsg];
            
        }];

    }
    
    
}

@end
