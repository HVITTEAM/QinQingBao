//
//  PostsDetailViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PostsDetailViewController.h"
#import "DetailPostsModel.h"

@interface PostsDetailViewController ()
{
    DetailPostsModel *detailData;
}
@end

@implementation PostsDetailViewController


-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    [self getDetailData];
}

-(void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)getDetailData
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_articledetail parameters: @{@"uid" : @"1",
                                                                          @"tid" : self.itemdata.tid
                                                                       }
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         detailData = [DetailPostsModel objectWithKeyValues:[dict objectForKey:@"datas"]];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];

}

@end
