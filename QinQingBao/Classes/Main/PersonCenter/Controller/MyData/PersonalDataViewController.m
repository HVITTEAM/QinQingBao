//
//  PersonalDataViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/21.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "UpdatePwdViewController.h"
#import "TextFieldViewController.h"

//NSData *data = UIImageJPEGRepresentation(uiImage, 0.7);


@interface PersonalDataViewController ()

@property (nonatomic, retain) UpdatePwdViewController *updateView;
@property (nonatomic, retain) TextFieldViewController *textView;

@end

@implementation PersonalDataViewController
{
    NSMutableArray *dataProvider;
}

- (void)viewDidLoa
{
    [super viewDidLoad];
    
    self.title = @"个人资料";
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dataProvider = [[NSMutableArray alloc] initWithObjects:
                    @{@"title" : @"",@"placeholder" : @"",@"text" : @"头像", @"value" : @"未上传"},
                    @{@"title" : @"修改姓名",@"placeholder" : @"请输入姓名",  @"text" : @"姓名",@"value" : @"张三"},
                    @{@"title" : @"",@"placeholder" : @"",@"text" : @"性别",@"value" : @"男"},
                    @{@"title" : @"修改电话",@"placeholder" : @"请输入电话号码", @"text" : @"电话",@"value" : @"15268126119"},
                    @{@"title" : @"修改EMail",@"placeholder" : @"请输入EMail地址",@"text" : @"EMail",@"value" : @"287178790@qq.com"},
                    @{@"title" : @"修改地址",@"placeholder" : @"请输入地址",@"text" : @"住址",@"value" : @"杭州市西湖区计量大厦1212号"},
                    nil];
    [self initTableviewSkin];
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 6;
    else
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content = @"contentCell";
    
    UITableViewCell *contentcell = [tableView dequeueReusableCellWithIdentifier:content];
    
    if (indexPath.section == 0)
    {
        if(contentcell == nil)
        {
            contentcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:content];
            contentcell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            contentcell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        }
        contentcell.accessoryType = UITableViewCellAccessoryNone;
        NSDictionary *dict = [dataProvider objectAtIndex:indexPath.row];
        contentcell.textLabel.text = [dict objectForKey:@"text"];
        contentcell.detailTextLabel.text = [dict objectForKey:@"value"];
        contentcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        if(contentcell == nil)
        {
            contentcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:content];
            contentcell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            contentcell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        }
        contentcell.textLabel.text = @"修改密码";
        contentcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    return  contentcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (!self.updateView)
            self.updateView = [[UpdatePwdViewController alloc]init];
        [self.navigationController pushViewController:self.updateView animated:YES];
    }
    else if(indexPath.row == 0)
    {
        UIAlertView *alertPic = [[UIAlertView alloc] initWithTitle:@"请选择图片来源" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        alertPic.tag = 101;
        [alertPic show];
    }
    else if(indexPath.row == 2)
    {
        UIAlertView *alertSex = [[UIAlertView alloc] initWithTitle:@"请选择性别" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女", nil];
        alertSex.tag = 99;
        [alertSex show];
    }
    else
    {
        NSDictionary *dict = [dataProvider objectAtIndex:indexPath.row];
        if (!self.textView)
            self.textView = [[TextFieldViewController alloc] init];
        self.textView.dict = dict;
        [self.navigationController pushViewController:self.textView animated:YES];
    }
}

#pragma mark -- 拍照选择模块
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag > 100)
    {
        //        if(buttonIndex==1)
        //            [self shootPiicturePrVideo];
        //        else if(buttonIndex==2)
        //            [self selectExistingPictureOrVideo];
        
    }
    else
    {
        //        if(buttonIndex==1)
        //            [self shootPiicturePrVideo];
        //        else if(buttonIndex==2)
        //            [self selectExistingPictureOrVideo];
    }
}

@end
