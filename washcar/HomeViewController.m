//
//  HomeViewController.m
//  washcar
//
//  Created by CSB on 15/9/25.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "HomeViewController.h"
#import "WebViewController.h"
#import "WashEditViewController.h"
#import "ReChargeViewController.h"
#import <Masonry.h>

@interface HomeViewController ()

@property (strong, nonatomic) IBOutlet SGFocusImageFrame *imageFrame;



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)setupViews
{
    SGFocusImageItem *item1 = [[SGFocusImageItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"av1.jpg"] tag:0];
    
    
    
    SGFocusImageItem *item2 = [[SGFocusImageItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"av1.jpg"] tag:1];
//
    SGFocusImageFrame *imageFrame = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.3)
                                                                    delegate:self
                                                             focusImageItems:item1, item2, nil];
    [self.view addSubview:imageFrame];

    
    [_imageFrame setViewsWithdelegate:self focusImageItems:item1,item2, nil];
    
//    [item1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(_imageFrame.mas_width);
//        make.height.equalTo(_imageFrame.mas_height);
//    }];
//
//    _searchControl.backgroundColor = RgbHex2UIColor(246, 218, 185);
//    _searchControl.layer.cornerRadius = 30;
//    _searchControlInner.layer.cornerRadius = 25;
//    _searchControlInner.backgroundColor = RgbHex2UIColor(251, 152, 51);
//    
//    _washControl.backgroundColor = RgbHex2UIColor(242, 198, 205);
//    _washControl.layer.cornerRadius = 53;
//    _washControlInner.layer.cornerRadius = 43;
//    _washControlInner.backgroundColor = RgbHex2UIColor(233, 83, 108);
//    
//    _weatherControl.backgroundColor = RgbHex2UIColor(206, 233, 254);
//    _weatherControl.layer.cornerRadius = 30;
//    _weatherControlInner.layer.cornerRadius = 25;
//    _weatherControlInner.backgroundColor = RgbHex2UIColor(84, 183, 251);
//    
//    _insuranceControl.backgroundColor = RgbHex2UIColor(191, 231, 236);
//    _insuranceControl.layer.cornerRadius = 30;
//    _insuranceControlInner.layer.cornerRadius = 25;
//    _insuranceControlInner.backgroundColor = RgbHex2UIColor(67, 194, 230);
//    
//    _trafficControl.backgroundColor = RgbHex2UIColor(213, 231, 188);
//    _trafficControl.layer.cornerRadius = 30;
//    _trafficControlInner.layer.cornerRadius = 25;
//    _trafficControlInner.backgroundColor = RgbHex2UIColor(137, 192, 58);
    
    
}

#pragma mark -
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSLog(@"%@ tapped", item.title);
    if (item.tag == 0) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WashEditViewController *washController = [storyBoard instantiateViewControllerWithIdentifier:@"WashEditViewController"];
        [self.navigationController pushViewController:washController animated:YES];
    }
    else if (item.tag == 1) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ReChargeViewController *rechargeViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ReChargeViewController"];
        [self.navigationController pushViewController:rechargeViewController animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 点击事件
- (IBAction)searchControlClick:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *webController = [storyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
    [webController setTitle:@"违章查询" andUrl:@"http://chaxun.weizhang8.cn/"];
    [self.navigationController pushViewController:webController animated:YES];
}

- (IBAction)washControlClick:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WashEditViewController *washController = [storyBoard instantiateViewControllerWithIdentifier:@"WashEditViewController"];
    [self.navigationController pushViewController:washController animated:YES];
}

- (IBAction)weatherControlClick:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *webController = [storyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
    [webController setTitle:@"天气查询" andUrl:@"http://weather.news.sina.com.cn/"];
    [self.navigationController pushViewController:webController animated:YES];
}

- (IBAction)InsuranceControlClick:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *webController = [storyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
    [webController setTitle:@"保险理赔" andUrl:@"http://www.pingan.com/cpchexian/sem/duosheng.shtml"];
    [self.navigationController pushViewController:webController animated:YES];
}

- (IBAction)trafficControlClick:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *webController = [storyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
    [webController setTitle:@"交通查询" andUrl:@"http://bus.mapbar.com/"];
    [self.navigationController pushViewController:webController animated:YES];
}

@end
