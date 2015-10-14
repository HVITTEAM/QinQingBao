//
//  EzvizFindDeviceListViewController.m
//  EzvizOpenSDKDemo
//
//  Created by DeJohn Dong on 15/6/25.
//  Copyright (c) 2015年 Hikvision. All rights reserved.
//

#import "EzvizFindDeviceListViewController.h"
#import "EzvizBonjourManager.h"
#import "EzvizSimpleWifi.h"
#import <netdb.h>
#import <arpa/inet.h>

@interface EzvizFindDeviceListViewController ()<UITableViewDataSource, UITableViewDelegate,EzvizBonjourManagerDelegate,NSNetServiceDelegate,UIAlertViewDelegate>{
    NSMutableArray *devices;
    EzvizSimpleWifi *wifiConfig;
    
    NSString *deviceIp;
}

@property (nonatomic, weak) IBOutlet UITableView *deviceList;
@property (nonatomic, weak) IBOutlet UIView *deviceView;
@property (nonatomic, weak) IBOutlet UITextField *tfIp;
@property (nonatomic, weak) IBOutlet UILabel *lblIp;
@property (nonatomic, weak) IBOutlet UITextField *tfPwd;
@property (nonatomic, weak) IBOutlet UILabel *lblPwd;

@end

@implementation EzvizFindDeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:@[@"自动搜索",@"手动添加"]];
    [control addTarget:self action:@selector(selectIndex:) forControlEvents:UIControlEventValueChanged];
    control.selectedSegmentIndex = 1;
    self.navigationItem.titleView = control;
    
    self.tfIp.leftView = self.lblIp;
    self.tfIp.leftViewMode = UITextFieldViewModeAlways;
    self.tfPwd.leftView = self.lblPwd;
    self.tfPwd.leftViewMode = UITextFieldViewModeAlways;
    
    if(!devices)
        devices = [NSMutableArray new];
    [devices removeAllObjects];
    
    if(!wifiConfig)
        wifiConfig = [[EzvizSimpleWifi alloc] init];
    [wifiConfig startWifiConfig:self.params[@"ssid"] andKey:@"strkey"];
    
    [self.deviceList registerClass:[UITableViewCell class] forCellReuseIdentifier:@"deviceCell"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [EzvizBonjourManager shareManager].delegate = self;
    [[EzvizBonjourManager shareManager] bonjourSearchStartWithTypes:@[@"_http._tcp.",@"_smart._tcp."]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[EzvizBonjourManager shareManager] bonjourSearchStop];
    [wifiConfig stopWifiConfig];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        NSString *password = [alertView textFieldAtIndex:0].text;
        [UIViewController go2LocalPlayerViewController:self andParams:@{@"ip":deviceIp?:@"",
                                                                        @"pwd":password?:@""}];
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell" forIndexPath:indexPath];
    NSNetService *service = [devices objectAtIndex:indexPath.row];
    
    cell.textLabel.text = service.name;
    cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNetService *service = [devices objectAtIndex:indexPath.row];
    service.delegate = self;
    [service resolveWithTimeout:0.5];
}

#pragma mark -

- (void)localServiceClientList:(NSArray *)list{
    [devices removeAllObjects];
    [devices addObjectsFromArray:list];
    [self.deviceList reloadData];
    [wifiConfig stopWifiConfig];
    [[EzvizBonjourManager shareManager] bonjourSearchStop];
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender{
    NSNetService *service = sender;
    
    NSArray *addressList = service.addresses;
    if(addressList){
        for (NSData *data in addressList){
            struct sockaddr *addr = (struct sockaddr *)[data bytes];
            if(addr->sa_family == AF_INET){
                [self nameWithSockaddr:addr];
            }else if(addr->sa_family == AF_INET6){
                
            }
        }
    }
}

- (void)nameWithSockaddr:(struct sockaddr *)saddr{
    int errorCode = 0;
    char host[1024];
    char serv[20];
    
    errorCode = getnameinfo(saddr, sizeof(saddr), host, sizeof(host), serv, sizeof(serv), NI_NUMERICHOST|NI_NUMERICSERV);
    NSString *hostIP = [NSString stringWithUTF8String:host];
    int hostPort = [[NSString stringWithUTF8String:serv] intValue];
    NSLog(@"host = %@ port =%d", hostIP, hostPort);
    
    deviceIp = hostIP;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:@"请输入设备[%@]的密码，已注册平台输入userCode,未注册平台请输入设备验证码",hostIP]
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)selectIndex:(id)sender{
    [self.tfIp resignFirstResponder];
    [self.tfPwd resignFirstResponder];
    if([(UISegmentedControl *)sender selectedSegmentIndex] == 0){
        self.deviceList.hidden = NO;
        self.deviceView.hidden = YES;
    }else{
        self.deviceList.hidden = YES;
        self.deviceView.hidden = NO;
    }
}

- (IBAction)go2Start:(id)sender{
    [UIViewController go2LocalPlayerViewController:self andParams:@{@"ip":self.tfIp.text?:@"",
                                                                    @"pwd":self.tfPwd.text?:@""}];
}

@end
