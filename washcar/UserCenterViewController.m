//
//  UserCenterViewController.m
//  MayiCar
//
//  Created by xiejingya on 9/26/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import "UserCenterViewController.h"

#import "Constant.h"
#import "GlobalVar.h"
#import "MayiHttpRequestManager.h"
#import "ReChargeViewController.h"
#import "StoryboadUtil.h"
#import "StringUtil.h"
#import "PSTAlertController.h"
#import "ComplaintListViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIImageView+WebCache.h>

@interface UserCenterViewController ()

{
  
    VouchersThreeViewController *vvc;
    MyMsgViewController *mmvc;
    ComplaintViewController *clvc;
    CommonProblemViewController *cpvc;
    UIStoryboard *board ;
    NSArray *titles;
    NSArray *icons;
    UILabel *voucherNum;
    UILabel *msgNum;
    NSString *icon_url;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIView *userBalanceView;

@end

@implementation UserCenterViewController
//充值
- (IBAction)recharge:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReChargeViewController *rechargeViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ReChargeViewController"];
    rechargeViewController.checkInMoney = 50;
    [self.navigationController pushViewController:rechargeViewController animated:YES];
    
}

- (void)viewDidLoad {
//     [ProgressHUD show:@"加载中..."];
    [super viewDidLoad];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([_tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableview setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([_tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableview setLayoutMargins: UIEdgeInsetsZero];
    }
    board = [UIStoryboard storyboardWithName:@"UserCenter" bundle:nil];
    titles = [NSArray arrayWithObjects:@"个人信息",@"洗车券",@"我的消息",@"投诉建议",@"常见问题解答",nil];
    icons = [NSArray arrayWithObjects:@"user_info_icon",@"vouchers_icon",@"user_msg_icon",@"complaint_icon",@"common_problem_icon",nil];
    // Do any additional setup after loading the view.
    _userIcon.layer.masksToBounds = YES; //没这句话它圆不起来
    _userIcon.layer.cornerRadius = _userIcon.frame.size.width/2; //设置图片圆角的尺度
    _surplusMoney.layer.borderWidth = 0.5;
    _surplusMoney.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:204/255.0 green:204/255.0  blue:255/255.0  alpha:1.0]);
    _surplusMoney.attributedText = [StringUtil getMenoyText:@"余额" :@"0.00" :@"元"];
    [self loadData:YES];
   
    [self initBtnLayout];
    
    
    
    float deviceNum = [StoryboadUtil getDeviceNum];
    
    int magin_left = -8;
    if (deviceNum == 4.0) {
        magin_left = -20;
    }
    if(deviceNum == 5.0){
        magin_left = -20;
    }
    if (deviceNum == 6.0) {
        magin_left = -30;
    }
    
    if (deviceNum == 6.5) {
        magin_left = -38;
    }
    
    [_yeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_yeBody.mas_left).offset(-magin_left);
        //别的
    }];

}
-(void)viewWillAppear:(BOOL)animated{
    [self loadData:NO];
    
    self.parentViewController.title = @"个人中心";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置剩余钱数

-(void) setMoney:(NSString *) num{
    if (num==nil) {
        num = @"0.0";
    }
//    NSMutableString *money = [[NSMutableString alloc]init];
//   [money appendFormat:@"余额"];
//        [money appendFormat:num];
//        [money appendFormat:@"元"]
    
    
     _surplusMoney.attributedText = [StringUtil getMenoyText:@"余额" :num :@"元"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *identifier = @"user_center_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
    }
    
    UIImageView *icon = (UIImageView*)[cell viewWithTag:1];
    UILabel *title = (UILabel*)[cell viewWithTag:2];
    
    UILabel *num = (UILabel*)[cell viewWithTag:3];
    num.layer.masksToBounds = YES; //没这句话它圆不起来
    num.layer.cornerRadius = num.frame.size.width/2; //设置图片圆角的尺度
    num.hidden = YES;
    if ([@"洗车券" isEqualToString:[titles objectAtIndex:indexPath.row]]) {
        voucherNum = num;
    }
    if ([@"我的消息" isEqualToString:[titles objectAtIndex:indexPath.row]]) {
        msgNum = num;
    }
    title.text = [titles objectAtIndex:indexPath.row];
    icon.image = [UIImage imageNamed:[icons objectAtIndex:indexPath.row]];
    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return  60.0f;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
//            if (SCREEN_HEIGHT==960) {
//                
//            }else{
//                 uivc = [board instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
//            }
//            
//            uivc = [StoryboadUtil getViewController:@"UserInfo" :@"UserInfoViewController"];
//            [self.navigationController pushViewController:uivc animated:YES];
            break;
        case 1:
            vvc = [[VouchersThreeViewController alloc]init];
            [self.navigationController pushViewController:vvc animated:YES];
            break;
        case 2:
            mmvc = [board instantiateViewControllerWithIdentifier:@"MyMsgViewController"];
            [ self.navigationController pushViewController:mmvc animated:YES];
            break;
        case 3:
            clvc = [board instantiateViewControllerWithIdentifier:@"ComplaintViewController"];
            [ self.navigationController pushViewController:clvc animated:YES];
            break;
        case 4:
            cpvc = [[CommonProblemViewController alloc]init];
            [ self.navigationController pushViewController:cpvc animated:YES];
            break;
        default:
            break;
    }
}
//{
//    grzx =     {
//        countxcj = 0;
//        countxx = 3;
//        money = "9962.20";
//        uname = "";
//        upicture = "/Home/images/dpxq/pro_pic.png";
//    };
//    res = 1;
//}

-(void)loadData:(BOOL) isShowLoading{
    
    UIView *loadingView;
    if (isShowLoading) {
        loadingView =self.view;
    }
    
    NSDictionary *parameters = [NSMutableDictionary dictionary];
     [[MayiHttpRequestManager sharedInstance] POST:UserCenter parameters:parameters showLoadingView:loadingView success:^(id responseObject) {
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            NSDictionary *dir = [responseObject objectForKey:@"grzx"];
            NSString *countxcj =[dir objectForKey:@"countxcj"];
            NSString *countxx =[dir objectForKey:@"countxx"];
            NSString *money =(NSString*)[dir objectForKey:@"money"];
            NSString *uname =(NSString*)[dir objectForKey:@"uname"];
            NSString *upicture =(NSString*)[dir objectForKey:@"upicture"];
            if([countxcj integerValue]>0){
//                voucherNum.hidden = NO;
                 [self initBtn:_btn2 :@"user_coupon_icon" :_btn2.titleLabel.text];
            }else{
//                 voucherNum.hidden = YES;
                [self initBtn:_btn2 :@"user_coupon_icon_new" :_btn2.titleLabel.text];
               
            }
            if([countxx integerValue]>0){
//                msgNum.hidden = NO;
                 [self initBtn:_btn4 :@"user_msg_icon_new" :_btn4.titleLabel.text];
            }else{
//                msgNum.hidden = YES;
                 [self initBtn:_btn4 :@"user_msg_icon" :_btn4.titleLabel.text];
            }
            if([@"" isEqualToString:uname]||uname==nil){
                uname = [GlobalVar sharedSingleton].uid ;
            }
            _userPhone.text = uname;
            [self setMoney:money];
            icon_url =[IMGURL stringByAppendingString:upicture];
            [_userIcon sd_setImageWithURL:[NSURL URLWithString:icon_url] placeholderImage:[UIImage imageNamed:@"icon.png"]];
//            [self performSelectorInBackground:@selector(download) withObject:nil];
        }
    } failture:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"获取用户信息失败"];
    }];

    
   }


-(void)download
{
    //1.根据URL下载图片
    //从网络中下载图片
    if (icon_url!=nil) {
        NSURL *urlstr=[NSURL URLWithString:icon_url];
        //把图片转换为二进制的数据
        NSData *data=[NSData dataWithContentsOfURL:urlstr];//这一行操作会比较耗时
        //把数据转换成图片
        UIImage *image=[UIImage imageWithData:data];
        if (image!=nil) {
            //2.回到主线程中设置图片
            [self performSelectorOnMainThread:@selector(settingImage:) withObject:image waitUntilDone:NO];
        }
       
    }

}



//设置显示图片
-(void)settingImage:(UIImage *)image
{
//    self.userIcon.image=image;
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
    
    if (editedImage != nil) {
//        [SVProgressHUD showWithStatus:@"上传中，请稍后"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
         NSData *data = UIImageJPEGRepresentation(editedImage, 1);

        
        [[MayiHttpRequestManager sharedInstance] POSTFile:UserAvatarEdit parameters:parameters data:data forKey:@"tx" showLoadingView:self.view
         success:^(id responseObject) {
           
                DLog(@"开始,上传头像成功");
//             [SVProgressHUD dismiss];
                //                _user.avatar = @"https://linkup.wondersgroup.com/newavatar.jpg";
                //                _user.avatar100 = _user.avatar;
                //                _user.avatar300 = _user.avatar;
                //                //            [self loadData:[GlobalVar sharedSingleton].myId];
                //                [[SDImageCache sharedImageCache] storeImage:editedImage forKey:_user.avatar];
                //                [[SDImageCache sharedImageCache] storeImage:editedImage forKey:_user.avatar100];
                //                [[SDImageCache sharedImageCache] storeImage:editedImage forKey:_user.avatar300];
                //                [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_user.avatar100]];
                //                [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_user.avatar100] placeholderImage:nil options:SDWebImageRefreshCached];
                //                sleep(5);
                //                [self loadData:[GlobalVar sharedSingleton].myId showProgress:NO];
             
             _userIcon.image = editedImage;
            
        } failture:^(NSError *error) {
            DLog(@"error:%@",error);
        }];
    }
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


- (IBAction)userButtonClicked:(id)sender {
    PSTAlertController *alertController = [PSTAlertController alertControllerWithTitle:nil message:nil preferredStyle:PSTAlertControllerStyleActionSheet];
    [alertController addAction:[PSTAlertAction actionWithTitle:@"拍摄新照片" style:PSTAlertActionStyleDefault handler:^(PSTAlertAction *action) {
        DLog(@"拍摄新照片");
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }]];
    
    [alertController addAction:[PSTAlertAction actionWithTitle:@"从相册选择" style:PSTAlertActionStyleDefault handler:^(PSTAlertAction *action) {
        DLog(@"从相册选择");
        
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    }]];
    
    [alertController addAction:[PSTAlertAction actionWithTitle:@"取消" style:PSTAlertActionStyleCancel handler:^(PSTAlertAction *action) {
        DLog(@"取消");
    }]];
    
    [alertController showWithSender:self.view controller:self animated:YES completion:nil];
    
}

-(void)initBtnLayout{
    [self initBtn:_btn1 :@"user_car_manager_icon" :_btn1.titleLabel.text];
    [self initBtn:_btn2 :@"user_coupon_icon" :_btn2.titleLabel.text];
    [self initBtn:_btn3 :@"user_invitation_icon" :_btn3.titleLabel.text];
    [self initBtn:_btn4 :@"user_msg_icon" :_btn4.titleLabel.text];
    [self initBtn:_btn5 :@"user_complaint_icon" :_btn5.titleLabel.text];
    [self initBtn:_btn6 :@"user_update_icon" :_btn6.titleLabel.text];
    [self initBtn:_btn7 :@"user_common_problem_icon" :_btn7.titleLabel.text];
    [self initBtn:_btn8 :@"user_exit_icon" :_btn8.titleLabel.text];
    float deviceNum = [StoryboadUtil getDeviceNum];
    
    _userBalanceView.layer.borderColor = GeneralLineCGColor;
    _userBalanceView.layer.borderWidth = 0.5;
    
    int magin_bottom = 10;
    if (deviceNum == 4.0) {
        magin_bottom = 5;
    }
    if(deviceNum == 5.0){
        magin_bottom = 80;
    }
    if (deviceNum == 6.0) {
        magin_bottom = 100;
    }
    
    if (deviceNum == 6.5) {
        magin_bottom = 120;
    }

    [_btn8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_btnbody.mas_bottom).offset(-magin_bottom);
        //别的
    }];
}

-(void) initBtn:(UIButton*)btn:(NSString*)iconName :(NSString*)btnTitle{
    //UIImage *image =[self reSizeImage:[UIImage imageNamed:iconName] toSize:CGSizeMake(40, 40)];
   UIImage *image =[UIImage imageNamed:iconName] ;
    NSString *title = btnTitle;
    [btn setTitle:title forState:UIControlStateNormal];

    [btn setImage:image forState:UIControlStateNormal];
//    [btn setTintColor:[UIColor whiteColor]];
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + 5);
    
    // raise the image and push it right to center it
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    // lower the text and push it left to center it
    btn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
    
    [[btn layer]setCornerRadius:8.0];
}


- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

- (IBAction)btn1Click:(id)sender {
    
   CarsManagerViewController *uivc = [StoryboadUtil getViewController:@"InvitationCode" :@"CarsManagerViewController"];
    [self.navigationController pushViewController:uivc animated:YES];
}
- (IBAction)btn2Click:(id)sender {
    vvc = [[VouchersThreeViewController alloc]init];
    [self.navigationController pushViewController:vvc animated:YES];
}
- (IBAction)btn3Click:(id)sender {
    
    InvitationCodesViewController *invitationCode =[StoryboadUtil getViewController:@"InvitationCode" :@"InvitationCodesViewController"];
    [self.navigationController pushViewController:invitationCode animated:YES];
}

- (IBAction)btn4Click:(id)sender {
    mmvc = [board instantiateViewControllerWithIdentifier:@"MyMsgViewController"];
    [ self.navigationController pushViewController:mmvc animated:YES];
}

- (IBAction)btn5Click:(id)sender {
    ComplaintListViewController  *cplist = [StoryboadUtil getViewController:@"complaint" :@"ComplaintListViewController"];
    [self.navigationController pushViewController:cplist animated:YES];
    
    

}

- (IBAction)btn6Click:(id)sender {
    [ self onCheckVersion];
}

- (IBAction)btn7Click:(id)sender {
    cpvc = [[CommonProblemViewController alloc]init];
    [ self.navigationController pushViewController:cpvc animated:YES];
}
- (IBAction)btn8Click:(id)sender {
    
    [self exitMayi];
}
//Res   1 退出成功  2退出失败
-(void) exitMayi{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    [[MayiHttpRequestManager sharedInstance] POST:Quitlogin parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            [SVProgressHUD showSuccessWithStatus:@"退出成功！"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:MayiUserIsSignIn];
            
            [GlobalVar sharedSingleton].uid = nil;
            
            [GlobalVar sharedSingleton].isloginid = nil;
            [GlobalVar sharedSingleton].signState = MayiSignStateUnSigned;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MayiIndexPageNotifiction object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
            
            //            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Sign" bundle:nil];
            //            UIViewController *loginViewController = [storyboard instantiateInitialViewController];
            //            loginViewController.modalTransitionStyle = UIModalPresentationFormSheet;//跳转效果
            //            [self presentModalViewController:loginViewController animated:YES];//在这里一跳就行了。
            //
            //            //[self dismissModalViewControllerAnimated:YES];
            //            [self removeFromParentViewController];
        }else{
            [SVProgressHUD showErrorWithStatus:@"退出失败！"];
        }
    } failture:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"退出失败！"];
    }];
    
}
-(void)onCheckVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDic));
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    NSString *URL = @"http://itunes.apple.com/lookup?id=1047519816";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    
    
//    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    
      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recervedData options:NSJSONReadingMutableLeaves error:nil];
//    NSDictionary *dic = [results JSONValue];
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count]) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        if (![lastVersion isEqualToString:currentVersion]) {
            //trackViewURL = [releaseInfo objectForKey:@"trackVireUrl"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
            alert.tag = 10000;
            alert.delegate = self;
            [alert show];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 10001;
             alert.delegate = self;
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa /wa/viewContentsUserReviews?type=Purple+Software&id=%d",
                        1047519816];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

    }
}
@end
