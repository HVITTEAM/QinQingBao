//
//  HealthBloodPressureViewController.m
//  QinQingBao
//
//  Created by shi on 15/8/21.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "HealthBloodPressureViewController.h"
#import "BloodCell.h"
#import "ChartCell.h"
#import "PromptCell.h"

@interface HealthBloodPressureViewController ()

@end

@implementation HealthBloodPressureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //设置表视图属性
        self.tableView.backgroundColor = HMGlobalBg;
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //去掉多余的分割线
        self.tableView.tableFooterView = [[UIView alloc] init];
        //导航栏标题
        self.navigationItem.title = @"王大爷";
        }
    return self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //
    if (section==0 ||section==2) {
            return 1;
    }
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID  = @"ChartCell";
    //分区为0时返回表格Cell
    if (indexPath.section == 0) {
        cellID = @"ChartCell";
        ChartCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[ChartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
      return cell;
    }
    
    //分区为1时返回BloodCell，表示血压
    if (indexPath.section == 1) {
        cellID = @"BloodCell";
        BloodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"BloodCell" owner:nil options:nil] lastObject];
        }
        return cell;
    }
    
    //分区为2时返回PromptCell，表示专家提示
    cellID = @"PromptCell";
    PromptCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"PromptCell" owner:nil options:nil] lastObject];
    }
    cell.contentLabel.text = @"绿叶蔬菜：很多高血压朋友都有这样的体会，吃芹菜有很好的降血压食疗功效，因为无论是钾、钙、镁，都在绿叶蔬菜中，而芹菜的确是绿叶蔬菜降血压的典型代表。通常越是颜色深的绿色蔬菜，钾、钙、镁含量越高，同一株蔬菜，叶子的颜色比杆茎深，自然有效成分含量也更高，吃芹菜一定要连同叶子一起吃。";
    return cell;

}

#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static PromptCell *promptCell = nil;
    
    if (indexPath.section ==0 ) {
        return 180.0f;
    }else if (indexPath.section ==1){
        return 40.0f;
    }else if(indexPath.section ==2){
        if (!promptCell) {
            promptCell =[[[NSBundle mainBundle] loadNibNamed:@"PromptCell" owner:nil options:nil] lastObject];
        }
        promptCell.contentLabel.text = @"绿叶蔬菜：很多高血压朋友都有这\n样的体会，吃芹菜有很好的降血压食疗功效，因为无论是钾、\n钙、镁，都在绿叶蔬菜中，而芹菜的确是绿叶蔬菜降血压的典型代\n表。通常越是颜色深的绿色蔬菜，钾、钙、镁含量越\n高，同一株蔬菜，叶子的颜色比杆茎深，自然有效成分含量也更高，吃芹菜一\n定要连同叶子一起吃。";
        
        [promptCell setNeedsLayout];
        [promptCell layoutIfNeeded];
        [promptCell setNeedsUpdateConstraints];
        [promptCell updateConstraintsIfNeeded];
        
        CGFloat height = [promptCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height+1;
    
        NSLog(@"%f",height);
        return height;
    }
    return 0;
}

@end
