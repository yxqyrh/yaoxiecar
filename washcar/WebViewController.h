//
//  WebViewController.h
//  washcar
//
//  Created by CSB on 15/9/26.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface WebViewController : BaseViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSString *url;

-(void)setTitle:(NSString *)title andUrl:(NSString *)url;

@end
