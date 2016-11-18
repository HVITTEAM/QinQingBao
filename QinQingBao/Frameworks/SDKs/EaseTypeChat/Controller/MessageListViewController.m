//
//  MessageListViewController.m
//  QinQingBao
//
//  Created by Dual on 15/12/30.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "MessageListViewController.h"
//#import "EMMessage.h"
#import "EaseUI.h"
#import "EaseMob.h"
#import "ChattingViewController.h"
#import "BusinessDataCenter.h"


@interface MessageListViewController ()<EaseConversationListViewControllerDelegate,EaseConversationListViewControllerDataSource>
//@property (nonatomic, strong) UITableView *table;

@end

@implementation MessageListViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)initWithNavigation {
    self.title = @"我的消息";
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithNavigation];
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [[[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO] mutableCopy];
    
    [self removeEmptyConversationsFromDB];
    [self tableViewDidTriggerHeaderRefresh];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


//删除回话列表
-(void)removeEmptyConversationsFromDB {
    //当前登录用户的会话对象列表
    //NSArray *conversations = [EaseMob sharedInstance].chatManager.conversations;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.conversationType == eConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

//点击跳转
#pragma mark --- EaseConversationListViewControllerDelegate
- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel {
    //样例展示为根据conversationModel,进入不同的会话ViewController
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
            ChattingViewController *chatController = [[ChattingViewController alloc] initWithConversationChatter:conversation.chatter conversationType:conversation.conversationType];
            BusinessDataCenter *businessData = [BusinessDataCenter sharedBusinessDataCenter];
            chatController.businessInfoModel = businessData.businessDataDic[conversation.chatter];
            if ([conversation.chatter isEqualToString:@""]) {
                chatController.title = @"未知商家";
            }else {
            chatController.title = conversationModel.title;
            }
            NSLog(@"【商家信息】%@",chatController.businessInfoModel);
            chatController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatController animated:YES];
        }
    }
}



#pragma mark --- EaseConversationListViewControllerDataSource
- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation {
    EaseConversationModel *model = [[EaseConversationModel alloc]initWithConversation:conversation];
    switch (model.conversation.conversationType) {
        case eConversationTypeChat:
            break;
        case eConversationTypeGroupChat:
            break;
        default:
            break;
    }
    model.avatarImage = [UIImage imageNamed:@"chatListCellHead"];
    BusinessDataCenter *businessDataCenter = [BusinessDataCenter sharedBusinessDataCenter];
    BusinessInfoModel *businessInfo = businessDataCenter.businessDataDic[model.conversation.chatter];
    if (!businessInfo) {
        if (![model.conversation.chatter isEqualToString:@"admin"]) {
            [self getBusinessData:model.conversation.chatter];
        }
    }else {
    if ([model.conversation.chatter isEqualToString:businessInfo.member_name]) {
        if (businessInfo.member_avatar) {
            NSString *url = [NSString stringWithFormat:@"%@%@",URL_Icon,businessInfo.member_avatar];
            model.avatarURLPath = url;
        }
        if (businessInfo.orgname != nil) {
            model.title = businessInfo.orgname;
        }else {
            model.title = @"未知商家";
        }
    }
    }
    if ([model.conversation.chatter isEqualToString:@"admin"]) {
        model.title = @"消息中心";
    }
    return model;
}


//最后一条消息展示内容样例----OK
- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
      latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    //用户获取最后一条message,根据message的messageBodyType展示显示最后一条message对应的文案
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                latestMessageTitle = NSLocalizedString(@"[图片]", @"[image]");
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                latestMessageTitle = NSLocalizedString(@"[声音]", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                latestMessageTitle = NSLocalizedString(@"[定位]", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                latestMessageTitle = NSLocalizedString(@"[视频]", @"[video]");
            } break;
            case eMessageBodyType_File: {
                latestMessageTitle = NSLocalizedString(@"[文件]", @"[file]");
            } break;
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}

//最后一条消息展示时间样例
- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    //用户获取最后一条message,根据lastMessage中timestamp,自定义时间文案显示(例如:"1分钟前","14:20")
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    return latestMessageTime;
}

//商家信息
-(void)getBusinessData:(NSString *)member_name {
    NSString *businessPath = [NSString stringWithFormat:@"%@/shop/mobile/?access_token=token&act=org&op=get_chat_bymemberid",URL_Local];
    [CommonRemoteHelper RemoteWithUrl:businessPath parameters:@{@"member_name" : member_name}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if ([codeNum isKindOfClass:[NSString class]]) {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                         [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                     }else {
                                         NSDictionary *di = [dict objectForKey:@"datas"];
                                         if ([di count] != 0) {
                                             BusinessDataCenter *businessData = [BusinessDataCenter sharedBusinessDataCenter];
                                             businessData.businessDataDic[member_name] = [BusinessInfoModel businessInfo:dict];
                                             [self tableViewDidTriggerHeaderRefresh];

                                         }else {
                                             [NoticeHelper AlertShow:@"商家资料为空!" view:self.view];
                                         }
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];
}
@end
