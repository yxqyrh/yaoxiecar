//
//  WebViewController.m
//  washcar
//
//  Created by CSB on 15/9/26.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController (){
    BOOL isUrl2;
}

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView.delegate = self;
    if (isUrl2) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }else{
        [self.webView loadHTMLString:_url baseURL:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)setTitle:(NSString *)title andUrl:(NSString *)url
//{
//    self.title = title;
//    _url = url;
//    
//}

-(void)setTitle:(NSString *)title andUrl:(NSString *)url :(BOOL)isUrl{
    self.title = title;
    _url = url;
    isUrl2 = isUrl;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    DLog(@"webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
     DLog(@"didFailLoadWithError:%@",error);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
