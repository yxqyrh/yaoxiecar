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


@interface HomeViewController2 (){
    NSInteger totalCount;
   
}


@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation HomeViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.parentViewController.title = @"蚂蚁洗车";
//    [self loadImages];
    self.scrollview.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH/640)*387);
//    图片的宽
       CGFloat imageW = self.scrollview.frame.size.width;
     //    CGFloat imageW = 300;
    //    图片高
         CGFloat imageH = self.scrollview.frame.size.height;
     //    图片的Y
        CGFloat imageY = 0;
     //    图片中数
        totalCount = 2;
     //   1.添加5张图片
         for (int i = 0; i < totalCount; i++) {
                 UIButton *page = [[UIButton alloc] init];
                     //        图片X
                 CGFloat imageX = i * imageW;
         //        设置frame
                 page.frame = CGRectMake(imageX, imageY, imageW, imageH);
        //        设置图片
             page.contentMode = UIViewContentModeScaleToFill;
                 NSString *name = [NSString stringWithFormat:@"home_tab_%d", i + 1];
             
             [page setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
         //        隐藏指示条
                 self.scrollview.showsHorizontalScrollIndicator = NO;
                 [self.scrollview addSubview:page];
             [page addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
               page.tag = i;
             }
  
    
     //    2.设置scrollview的滚动范围
         CGFloat contentW = totalCount *imageW;
        //不允许在垂直方向上进行滚动
        self.scrollview.contentSize = CGSizeMake(contentW, 0);
    
     //    3.设置分页
        self.scrollview.pagingEnabled = YES;
    
     //    4.监听scrollview的滚动
         self.scrollview.delegate = self;
    
         [self addTimer];}

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

-(void)viewWillAppear:(BOOL)animated{
     self.parentViewController.title = @"蚂蚁洗车";
}

-(void)loadImages
{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    [[MayiHttpRequestManager sharedInstance] POST:MayiSYTP parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        if ([WDSystemUtils isEqualsInt:1 andJsonData:[responseObject objectForKey:@"res"]]) {

            
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


- (void)nextImage
{
    int page = (int)self.pageControl.currentPage;
    if (page == totalCount-1) {
        page = 0;
    }else
    {
        page++;
    }
    
    //  滚动scrollview
    CGFloat x = page * self.scrollview.frame.size.width;
    
    
    [UIView animateWithDuration:1.0 animations:^
     {
         self.scrollview.contentOffset = CGPointMake(x, 0);
     } completion:^(BOOL finished)
     {
     }];
}

// scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    计算页码
    //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
    CGFloat scrollviewW =  scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    self.pageControl.currentPage = page;
}

// 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    关闭定时器(注意点; 定时器一旦被关闭,无法再开启)
    //    [self.timer invalidate];
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    开启定时器
    [self addTimer];
}

/**
 *  开启定时器
 */
- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}
/**
 *  关闭定时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
}



#pragma mark -
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
//    NSLog(@"%@ tapped", item.title);
//    if (item.tag == 0) {
//        
//        [self jumpPageWithJudge:YES andSignedBlock:^{
//            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            WashEditViewController *washController = [storyBoard instantiateViewControllerWithIdentifier:@"WashEditViewController"];
//            [self.navigationController pushViewController:washController animated:YES];
//        }];
//        
//    }
//    else if (item.tag == 1) {
//        [self jumpPageWithJudge:YES andSignedBlock:^{
//            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            ReChargeViewController *rechargeViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ReChargeViewController"];
//            [self.navigationController pushViewController:rechargeViewController animated:YES];
//        }];
//        
//        
//    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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



@end

