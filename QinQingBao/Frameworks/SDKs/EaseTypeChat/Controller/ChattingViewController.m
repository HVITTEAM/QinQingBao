//
//  ChattingViewController.m
//  QinQingBao
//
//  Created by Dual on 15/12/30.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "ChattingViewController.h"
#import "EaseMob.h"
#import "IMessageModel.h"
#import "EaseMobHeaders.h"
#import "EaseChatToolbar.h"
#import "CustomMessageCell.h"
#import "EaseEmotionManager.h"
#import "EaseEmoji.h"
#import "EaseRecordView.h"
#import "BusinessDataCenter.h"

#import "EaseHandler.h"
@interface ChattingViewController ()<EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource,UIAlertViewDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
}

@property (nonatomic, strong) NSString *iconURL;
@property (nonatomic, strong) NSString *businessImageURL;
@end

@implementation ChattingViewController
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}
-(id)initWithConversationChatter:(NSString *)conversationChatter conversationType:(EMConversationType)conversationType {
    self = [super initWithConversationChatter:conversationChatter conversationType:conversationType];
    if (self) {
        
    }
    return self;
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark --- rightBarButtonItem
-(void)createRightBarButtonItem {
    UIBarButtonItem *clear = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(deleteAllMessages:)];
    self.navigationItem.rightBarButtonItem = clear;
}


- (void)deleteAllMessages:(id)sender
{
    //删除内容
    if (self.dataArray.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [groupId isEqualToString:self.conversation.chatter];
        if (self.conversation.conversationType != eConversationTypeChat && isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation removeAllMessages];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else if ([sender isKindOfClass:[UIBarButtonItem class]]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"确定要删除吗？", @"Prompt") message:NSLocalizedString(@"", @"please make sure to delete") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"Cancel") otherButtonTitles:NSLocalizedString(@"确定", @"OK"), nil];
        [alertView show];
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        self.messageTimeIntervalTag = -1;
        [self.conversation removeAllMessages];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        [self.tableView reloadData];
    }
}


#pragma mark --- notification
- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessageToDataSource:message progress:nil];
        [[EaseMob sharedInstance].chatManager insertMessageToDB:message append2Chat:YES];
    }
}

- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isViewDidAppear = NO;
    } else {
        //结束call
        self.isViewDidAppear = YES;
    }
}

#pragma mark --- 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.font = [UIFont boldSystemFontOfSize:16];  //设置文本字体与大小
    titleLabel.textColor = [UIColor blackColor];  //设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"健康咨询";
    self.navigationItem.titleView = titleLabel;
    
    //注册并登录当前用户
    EaseHandler *handler = [[EaseHandler alloc] init];
    [handler registerAndLoginEase:[NSString stringWithFormat:@"qqb%@",[SharedAppUtil defaultCommonUtil].userVO.member_id]];
    
    self.delegate = self;
    self.dataSource = self;
    self.showRefreshHeader = YES;
    //NSLog(@"【环信】聊天对象：%@",self.conversation.chatter);
    [self createRightBarButtonItem];
    
    //消息
    [EaseBaseMessageCell appearance].sendBubbleBackgroundImage = [[UIImage imageNamed:@"chat_sender_bg"]stretchableImageWithLeftCapWidth:5 topCapHeight:35];
    [EaseBaseMessageCell appearance].recvBubbleBackgroundImage = [[UIImage imageNamed:@"chat_receiver_bg"]stretchableImageWithLeftCapWidth:35 topCapHeight:35];
    //声音
    UIImage *voiceSenderImageFull = [UIImage imageNamed:@"chat_sender_audio_playing_full"];
    UIImage *voiceSenderImage_000 = [UIImage imageNamed:@"chat_sender_audio_playing_000"];
    UIImage *voiceSenderImage_001 = [UIImage imageNamed:@"chat_sender_audio_playing_001"];
    UIImage *voiceSenderImage_002 = [UIImage imageNamed:@"chat_sender_audio_playing_002"];
    UIImage *voiceSenderImage_003 = [UIImage imageNamed:@"chat_sender_audio_playing_003"];
    //UIImage *voiceImage_004 = [UIImage imageNamed:@"chat_sender_audio_playing_004"];
    [EaseBaseMessageCell appearance].sendMessageVoiceAnimationImages = @[voiceSenderImageFull, voiceSenderImage_000, voiceSenderImage_001, voiceSenderImage_002, voiceSenderImage_003];
    UIImage *voiceReceiverImageFull = [UIImage imageNamed:@"chat_receiver_audio_playing_full"];
    UIImage *voiceReceiverImage_000 = [UIImage imageNamed:@"chat_receiver_audio_playing000"];
    UIImage *voiceReceiverImage_001 = [UIImage imageNamed:@"chat_receiver_audio_playing001"];
    UIImage *voiceReceiverImage_002 = [UIImage imageNamed:@"chat_receiver_audio_playing002"];
    UIImage *voiceReceiverImage_003 = [UIImage imageNamed:@"chat_receiver_audio_playing003"];
    [EaseBaseMessageCell appearance].recvMessageVoiceAnimationImages = @[voiceReceiverImageFull, voiceReceiverImage_000, voiceReceiverImage_001, voiceReceiverImage_002, voiceReceiverImage_003];
    //头像
    [EaseBaseMessageCell appearance].avatarSize = 40;
    [EaseBaseMessageCell appearance].avatarCornerRadius = 20;
    
    //[EaseChatBarMoreView appearance].moreViewBackgroundColor = [UIColor colorWithRed:240 green:242 blue:247 alpha:1];
    [[EaseChatBarMoreView appearance] setMoreViewBackgroundColor:[UIColor whiteColor]];
    //消息处理
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callControllerClose" object:nil];
    //通过会话管理者获取已收发消息
    //[self tableViewDidTriggerHeaderRefresh];
    //表情
    EaseEmotionManager *manager = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:[EaseEmoji allEmoji]];
    [self.faceView setEmotionManagers:@[manager]];
    
    
//    EMChatText *txt = [[EMChatText alloc] initWithText:@"服务工单"];
//    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txt];
//    // 6001，环信id，消息接收方。
//    EMMessage *message = [[EMMessage alloc] initWithReceiver:[SharedAppUtil defaultCommonUtil].serviceCount bodies:@[body]];
//    message.ext = @{@"sid":@"1107"};
//    
//    [[EaseMob sharedInstance].chatManager sendMessage:message progress:nil error:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.frame = [UIScreen mainScreen].bounds;
    CGRect rect = [EaseChatToolbar appearance].frame;
    rect.size.width = self.view.frame.size.width;
    [EaseChatToolbar appearance].frame = rect;
    [self getDataProvider];
    [self getBusinessData];

}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.deleteConversationIfNull) {
        //判断当前会话是否为空，若符合则删除该会话
        EMMessage *message = [self.conversation latestMessage];
        if (message == nil) {
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:self.conversation.chatter deleteMessages:NO append2Chat:YES];
        }
    }
    BusinessDataCenter *businessDataCenter = [BusinessDataCenter sharedBusinessDataCenter];
    BusinessInfoModel *businessInfo = [BusinessInfoModel new];
    businessInfo.member_id = self.businessInfoModel.member_id;
    businessInfo.orgname = self.businessInfoModel.orgname;
    businessInfo.member_avatar = self.businessInfoModel.member_avatar;
    businessInfo.member_name = self.conversation.chatter;
    businessDataCenter.businessDataDic[self.conversation.chatter] = businessInfo;
}

#pragma mark --- EaseMessageViewControllerDataSource
- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController modelForMessage:(EMMessage *)message {
    EaseMessageModel *model = [[EaseMessageModel alloc]initWithMessage:message];
    //[NSThread sleepForTimeInterval:0.2];
    if (model.isSender) {  //发送者
        if (_iconURL.length != 0) {
            NSString *url = [NSString stringWithFormat:@"%@%@",URL_Icon,_iconURL];
            model.avatarURLPath = url;
        }else {
            model.avatarImage = [UIImage imageNamed:@"pc_user.png"];
        }
        if (self.userinforModel.member_truename != nil) {
            model.nickname = _userinforModel.member_truename;
        }else {
            model.nickname = @"我";
        }
    }else {
        if (self.businessInfoModel.member_avatar.length != 0) {
            NSString *url = [NSString stringWithFormat:@"%@%@",URL_Icon,self.businessInfoModel.member_avatar];
            model.avatarURLPath = url;
        }else {
            model.avatarImage = [UIImage imageNamed:@"pc_user.png"];
        }
           model.nickname = self.businessInfoModel.member_truename;
    }
    if ([self.conversation.chatter isEqualToString:@"admin"]) {
        model.nickname = @"消息中心";
    }
        return model;
}

//长按
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//触发长按手势
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath {
   
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        [self _showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}
- (void)_showMenuViewController:(UIView *)showInView
                   andIndexPath:(NSIndexPath *)indexPath
                    messageType:(MessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"删除", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"复制", @"Copy") action:@selector(copyMenuAction:)];
    }
    if (messageType == eMessageBodyType_Text) {
        [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    } else if (messageType == eMessageBodyType_Image){
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    } else {
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    }
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}

- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    self.menuIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation removeMessage:model.message];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    self.menuIndexPath = nil;
}

- (UITableViewCell *)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)messageModel {
    if (messageModel.bodyType == eMessageBodyType_Text) {
        NSString *cell = [CustomMessageCell cellIdentifierWithModel:messageModel];
        CustomMessageCell *sendCell = [tableView dequeueReusableCellWithIdentifier:cell];
        if (!sendCell) {
            sendCell = [[CustomMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell model:messageModel];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        sendCell.model = messageModel;
        return sendCell;
    }
    return nil;
}

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController heightForMessageModel:(id<IMessageModel>)messageModel withCellWidth:(CGFloat)cellWidth {
    if (messageModel.bodyType == eMessageBodyType_Text) {
        return [CustomMessageCell cellHeightWithModel:messageModel];
    }
    return 0;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController didSelectMessageModel:(id<IMessageModel>)messageModel {
    BOOL flag = NO;
    return flag;
}

- (void)messageViewController:(EaseMessageViewController *)viewController didSelectAvatarMessageModel:(id<IMessageModel>)messageModel {
    //点击头像
}

- (void)messageViewController:(EaseMessageViewController *)viewController didSelectMoreView:(EaseChatBarMoreView *)moreView AtIndex:(NSInteger)index {
    [self.chatToolbar endEditing:YES];  //隐藏键盘
}

- (void)messageViewController:(EaseMessageViewController *)viewController didSelectRecordView:(UIView *)recordView withEvenType:(EaseRecordViewType)type {
     switch (type) {
        case EaseRecordViewTypeTouchDown:
        {
            if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
                [(EaseRecordView *)self.recordView recordButtonTouchDown];
            }
        }
            break;
        case EaseRecordViewTypeTouchUpInside:
        {
            if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
                [(EaseRecordView *)self.recordView recordButtonTouchUpInside];
            }
            [self.recordView removeFromSuperview];
        }
            break;
        case EaseRecordViewTypeTouchUpOutside:
        {
            if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
                [(EaseRecordView *)self.recordView recordButtonTouchUpOutside];
            }
            [self.recordView removeFromSuperview];
        }
            break;
        case EaseRecordViewTypeDragInside:
        {
            if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
                [(EaseRecordView *)self.recordView recordButtonDragInside];
            }
        }
            break;
        case EaseRecordViewTypeDragOutside:
        {
            if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
                [(EaseRecordView *)self.recordView recordButtonDragOutside];
            }
        }
            break;
        default:
            break;
    }

}

//用户信息
-(void)getDataProvider
{
    [CommonRemoteHelper RemoteWithUrl:URL_GetUserInfor parameters: @{@"id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                     @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"client" : @"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                         [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                     }
                                     else
                                     {
                                         NSDictionary *di = [dict objectForKey:@"datas"];
                                         if ([di count] != 0)
                                         {
                                             self.userinforModel = [UserInforModel objectWithKeyValues:di];
                                             _iconURL = [di objectForKey:@"member_avatar"];
                                             [self tableViewDidTriggerHeaderRefresh];
                                         }
                                         else
                                             [NoticeHelper AlertShow:@"个人资料为空!" view:self.view];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];
}

//商家信息
-(void)getBusinessData {
    NSString *businessPath = [NSString stringWithFormat:@"%@/shop/mobile/?access_token=token&act=org&op=get_chat_bymemberid",URL_Local];
    [CommonRemoteHelper RemoteWithUrl:businessPath parameters:@{@"member_id" : [[SharedAppUtil defaultCommonUtil].serviceCount componentsSeparatedByString:@"qqb"][1]}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if ([codeNum isKindOfClass:[NSString class]]) {
                                        
                                     }else {
                                         NSDictionary *di = [dict objectForKey:@"datas"];
                                         if ([di count] != 0) {
                                             self.businessInfoModel = [BusinessInfoModel businessInfo:dict];
                                         }else {
                                             [NoticeHelper AlertShow:@"商家资料为空!" view:self.view];
                                             NSLog(@"【商家信息】%@",self.businessInfoModel);
                                         }
                                     }
                                     [self.tableView reloadData];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];
}

@end
