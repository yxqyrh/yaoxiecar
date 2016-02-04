//
//  HomeViewController2.m
//  washcar
//
//  Created by xiejingya on 10/4/15.
//  Copyright © 2015 CSB. All rights reserved.
//
#import "HomeViewController2.h"
#import "WebViewController.h"
#import "WashEditViewController.h"
#import "ReChargeViewController.h"
#import "MayiHttpRequestManager.h"
#import "PSTAlertController.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "YYCycleScrollView.h"
#import "StoryboadUtil.h"
@interface HomeViewController2 (){
    NSInteger totalCount;
    
    NSArray *array;
    YYCycleScrollView *cycleScrollView;
    BOOL isLoaded;
}


@property (nonatomic, strong) NSTimer *timer;
@end

@implementation HomeViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parentViewController.title = @"蚂蚁洗车";
     float deviceNum = [StoryboadUtil getDeviceNum];
 
    if (deviceNum == 4.0) {
      self.lunboBody.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH/320)*192);
    }else if(deviceNum == 5.0){
     self.lunboBody.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH/320)*192);
    }
    else if (deviceNum == 6.0) {
       self.lunboBody.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH/375)*227);
    }
    else if (deviceNum == 6.5) {
       self.lunboBody.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH/414)*289);
    }else{
        self.lunboBody.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH/320)*192);
    }
    
    [self showNotifiction];
    isLoaded = NO;
}
-(void)viewWillAppear:(BOOL)animated{
      self.parentViewController.title = @"蚂蚁洗车";
    if (!isLoaded) {
        [self loadImages:YES];
        isLoaded = YES;
    }else{
        [self loadImages:NO];
    }
    
}
-(void)showNotifiction
{
    [[MayiHttpRequestManager sharedInstance] POST:@"ggts" parameters:nil showLoadingView:nil success:^(id responseObject) {
        
        DLog(@"responseObject:%@",responseObject);
        
        if ([WDSystemUtils isEqualsInt:1 andJsonData:[responseObject objectForKey:@"res"]]) {
            int isShowNotifiction = [[[NSUserDefaults standardUserDefaults] valueForKey:MayiIsShowNotifiction] intValue];//0或者1显示，2不显示
            int notifictionId = [[[NSUserDefaults standardUserDefaults] valueForKey:MayiLastNotifictionId] intValue];
            
            if ((isShowNotifiction == 1 ||  isShowNotifiction == 0) || ![WDSystemUtils isEqualsInt:notifictionId andJsonData:[responseObject objectForKey:@"id"]]) {
                PSTAlertController *alertController = [PSTAlertController alertControllerWithTitle:@"提示" message:[responseObject objectForKey:@"mes"] preferredStyle:PSTAlertControllerStyleAlert];
                [alertController addAction:[PSTAlertAction actionWithTitle:@"不再提醒" handler:^(PSTAlertAction *action) {
                    [[NSUserDefaults standardUserDefaults] setValue:@(2) forKey:MayiIsShowNotifiction];
                    int nId = [[responseObject objectForKey:@"id"] intValue];
                    [[NSUserDefaults standardUserDefaults] setValue:@(nId) forKey:MayiLastNotifictionId];

                    [[NSUserDefaults standardUserDefaults] synchronize];
                }]];
                [alertController addAction:[PSTAlertAction actionWithTitle:@"确认" handler:^(PSTAlertAction *action) {
                    
                }]];
                [alertController showWithSender:self.view controller:self animated:YES completion:nil];
            }
        }
        
        
    } failture:^(NSError *error) {
        
    }];
}

-(void)initGallery{
    if (array==nil|| ![array isKindOfClass:[NSArray class]] ||  array.count==0) {
        return;
    }
    //    图片的宽
    CGFloat imageW = self.lunboBody.frame.size.width;
    //    CGFloat imageW = 300;
    //    图片高
    CGFloat imageH = self.lunboBody.frame.size.height;
    //    图片的Y
    CGFloat imageY = 0;
    //    图片中数
    totalCount = array.count;
    if(totalCount==1){
        NSDictionary *dic = array[0];
        NSString *pic = [dic objectForKey:@"tpurl"];
        if ([StringUtil isEmty:pic]) {
            return;
        }
        UIButton *tempImageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imageW, imageH)];
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",IMGURL, pic]]]];
                [tempImageView setBackgroundImage:image forState:UIControlStateNormal];
        tempImageView.contentMode = UIViewContentModeScaleAspectFill;
        tempImageView.clipsToBounds = true;
        tempImageView.tag = 0;
        [tempImageView addTarget:self action:@selector(goDetailPic:) forControlEvents:UIControlEventTouchUpInside];
        [self.lunboBody addSubview:tempImageView];

    }else{
        if (cycleScrollView!=nil) {
            [cycleScrollView removeFromSuperview];
         }
        cycleScrollView = [[YYCycleScrollView alloc] initWithFrame:CGRectMake(0, imageY, imageW, imageH) animationDuration:6.0];
        NSMutableArray *viewArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < totalCount; i++) {
            NSDictionary *dic = array[i];
            NSString *pic = [dic objectForKey:@"tpurl"];
            if ([StringUtil isEmty:pic]) {
                continue;
            }
            CGFloat imageX = i * imageW;
            UIButton *tempImageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imageW, imageH)];
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",IMGURL, pic]]]];
            [tempImageView setBackgroundImage:image forState:UIControlStateNormal];
            tempImageView.tag = i;
            tempImageView.contentMode = UIViewContentModeScaleAspectFill;
            tempImageView.clipsToBounds = true;
             [tempImageView addTarget:self action:@selector(goDetailPic:) forControlEvents:UIControlEventTouchUpInside];
            [viewArray addObject:tempImageView];
        }
        [cycleScrollView setFetchContentViewAtIndex:^UIView *(NSInteger(pageIndex)) {
            return [viewArray objectAtIndex:pageIndex];
        }];
        [cycleScrollView setTotalPagesCount:^NSInteger{
            return totalCount;
        }];
        [self.lunboBody addSubview:cycleScrollView];
    }
}
-(void)goDetailPic:(id)sender{
    //这个sender其实就是UIButton，因此通过sender.tag就可以拿到刚才的参数
    int index = [sender tag];
    NSDictionary *dic = array[index];
    NSString *access_url = [dic objectForKey:@"access_url"];
    access_url = [access_url stringByAppendingString:[dic objectForKey:@"id"]];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *webController = [storyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
    [webController setTitle:@"活动详情" andUrl:access_url  isUrl:NO];
    [self.navigationController pushViewController:webController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage*)  scaleImage:(UIImage *)image   scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;  
}

-(void)loadImages:(BOOL)isShowLoading
{
    UIView *loadingView ;
    if (isShowLoading) {
        loadingView = self.view;
    }
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    [[MayiHttpRequestManager sharedInstance] POST:Index parameters:parameters showLoadingView:loadingView success:^(id responseObject) {
        if ([WDSystemUtils isEqualsInt:1 andJsonData:[responseObject objectForKey:@"res"]]) {

            array  = [responseObject objectForKey:@"pc"];
            
            NSLog(@"array=%@",array);
            [self initGallery];
        }
        
        
    } failture:^(NSError *error) {
        
    }];
}

-(void)action:(id)sender{
    //这个sender其实就是UIButton，因此通过sender.tag就可以拿到刚才的参数
    int tag = [sender tag];
    if (tag == 0) {
        [self jumpPageWithJudge:YES andSignedBlock:^{
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WashEditViewController *washController = [storyBoard instantiateViewControllerWithIdentifier:@"WashEditViewController"];
            [self.navigationController pushViewController:washController animated:YES];
        }];
        
        
    }
    else if (tag == 1) {
        [self jumpPageWithJudge:YES andSignedBlock:^{
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ReChargeViewController *rechargeViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ReChargeViewController"];
            rechargeViewController.checkInMoney = 50;
            [self.navigationController pushViewController:rechargeViewController animated:YES];
        }];
        
    }
}





-(void)jumpPageWithJudge:(bool)isJudgeSignState andSignedBlock:(signCompleteBlock)completeBlock
{
    if (completeBlock == nil) {
        DLog(@"completeBlock is nil");
        return;
    }
    
    if (!isJudgeSignState) {
        completeBlock();
    }
    else {
        if ([GlobalVar sharedSingleton].signState == MayiSignStateSigned) {
             completeBlock();
        }
        else if ([GlobalVar sharedSingleton].signState == MayiSignStateUnSigned) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Sign" bundle:nil];
            UIViewController *viewController = [storyBoard instantiateInitialViewController];
            [self presentViewController:viewController animated:YES completion:nil];
            [GlobalVar sharedSingleton].signState = MayiSignStateSigning;
            
            while ([GlobalVar sharedSingleton].signState == MayiSignStateSigning) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            
            if ([GlobalVar sharedSingleton].signState == MayiSignStateSigned) {
                completeBlock();

            }
        }
    }
        
}

//#pragma mark - 点击事件
//- (IBAction)searchControlClick:(id)sender {
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    WebViewController *webController = [storyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
//    [webController setTitle:@"违章查询" andUrl:@"http://m.weizhang8.cn/"];
//    [self.navigationController pushViewController:webController animated:YES];
//}



- (IBAction)washControlClick:(id)sender {
//    PSTAlertController *alertController = [PSTAlertController alertControllerWithTitle:@"下单洗车需要您登录小蚂蚁" message:nil preferredStyle:PSTAlertControllerStyleActionSheet];
//    
//    [alertController addAction:[PSTAlertAction actionWithTitle:@"立即登录" handler:^(PSTAlertAction *action) {
//        
//    }]];
//    [alertController addAction:[PSTAlertAction actionWithTitle:@"马上注册" handler:^(PSTAlertAction *action) {
//        
//    }]];
//    [alertController addAction:[PSTAlertAction actionWithTitle:@"取消" style:PSTAlertActionStyleCancel handler:nil]];
//    [alertController showWithSender:self.view controller:self animated:YES completion:nil];
//    return;
    
//    [self jumpPageWithJudge:YES andSignedBlock:^{
//        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        WashEditViewController *washController = [storyBoard instantiateViewControllerWithIdentifier:@"WashEditViewController"];
//        [self.navigationController pushViewController:washController animated:YES];
//    }];
    
    [self jumpPageWithJudge:YES andSignedBlock:^{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WashEditViewController *washController = [storyBoard instantiateViewControllerWithIdentifier:@"WashEditViewController"];
        [self.navigationController pushViewController:washController animated:YES];
    }];
    
}
- (IBAction)recharge:(id)sender {
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ReChargeViewController *rechargeViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ReChargeViewController"];
//    rechargeViewController.checkInMoney = 50;
//    [self.navigationController pushViewController:rechargeViewController animated:YES];
    
    [self jumpPageWithJudge:YES andSignedBlock:^{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ReChargeViewController *rechargeViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ReChargeViewController"];
        rechargeViewController.checkInMoney = 50;
        [self.navigationController pushViewController:rechargeViewController animated:YES];
    }];

}

//- (IBAction)weatherControlClick:(id)sender {
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    WebViewController *webController = [storyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
//    [webController setTitle:@"天气查询" andUrl:@"http://weather1.sina.cn/?vt=4"];
//    [self.navigationController pushViewController:webController animated:YES];
//}
//
//- (IBAction)InsuranceControlClick:(id)sender {
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    WebViewController *webController = [storyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
//    [webController setTitle:@"保险理赔" andUrl:@"http://caifu.baidu.com/m#/carinsurance/index~city=%E4%B8%8A%E6%B5%B7&zt=pswise&qid=13064072473599934086"];
//    [self.navigationController pushViewController:webController animated:YES];
//}
//
//- (IBAction)trafficControlClick:(id)sender {
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    WebViewController *webController = [storyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
//    [webController setTitle:@"交通查询" andUrl:@"http://m.ctrip.com/html5"];
//    [self.navigationController pushViewController:webController animated:YES];
//}

//-(void) initBtn:(UIButton*)btn:(NSString*)iconName :(NSString*)btnTitle{
//    //UIImage *image =[self reSizeImage:[UIImage imageNamed:iconName] toSize:CGSizeMake(40, 40)];
//    UIImage *image =[UIImage imageNamed:iconName] ;
//    NSString *title = btnTitle;
//    [btn setTitle:title forState:UIControlStateNormal];
//    
//    [btn setImage:image forState:UIControlStateNormal];
//    [btn setTintColor:[UIColor whiteColor]];
//    CGSize imageSize = btn.imageView.frame.size;
//    CGSize titleSize = btn.titleLabel.frame.size;
//    
//    // get the height they will take up as a unit
//    CGFloat totalHeight = (imageSize.height + titleSize.height + 5);
//    
//    // raise the image and push it right to center it
//    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
//    
//    // lower the text and push it left to center it
//    btn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
//    
////    [[btn layer]setCornerRadius:8.0];
//}


@end

