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
    
    UIActivityIndicatorView *loadingView;
}

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView.delegate = self;
//    if (isUrl2) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
//    }else{
//        [self.webView loadHTMLString:_url baseURL:nil];
////    }
    
    loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];//指定进度轮的大小
    [self.view addSubview:loadingView];
    //    [loadingView setCenter:CGPointMake(160, 140)];//指定进度轮中心点
    loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    //设置显示位置
    [loadingView setCenter:CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2)];
    //设置背景色
    loadingView.backgroundColor = UIColorWithRGBA(158.0f, 158.0f, 158.0f, 1.0f);
    //设置背景透明
    loadingView.alpha = 1.0;
    [loadingView startAnimating];

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

-(void)setTitle:(NSString *)title andUrl:(NSString *)url  isUrl:(BOOL)isUrl{
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
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
//    [webView stringByEvaluatingJavaScriptFromString:meta];
    [loadingView removeFromSuperview];
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
