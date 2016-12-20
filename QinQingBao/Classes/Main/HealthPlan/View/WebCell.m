//
//  WebCell.m
//  QinQingBao
//
//  Created by 董徐维 on 2016/12/16.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "WebCell.h"

@interface WebCell()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end
@implementation WebCell


+ (WebCell*) webCell
{
    WebCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"WebCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.webview.delegate = cell;
    cell.webview.scrollView.bounces = NO;
    cell.webview.scrollView.showsHorizontalScrollIndicator = NO;
    cell.webview.scrollView.scrollEnabled = NO;
    [cell.webview sizeToFit];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setURLStr:(NSString *)URLStr
{
    if ([URLStr isEqualToString:_URLStr]) {
        return;
    }
    _URLStr = URLStr;
    
    NSURL *url = [[NSURL alloc] initWithString:_URLStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.timeoutInterval = 60;
    
    [_webview loadRequest:request];
}

#pragma mark UIWebViewDelegate


- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CX_Log(@"结束loadHTMLString");
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    webView.height = newFrame.size.height;
    self.height  = webView.height;
    
    if (self.loadCompleteBlock)
        self.loadCompleteBlock(self.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
