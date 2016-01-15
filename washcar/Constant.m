//
//  Constant.m
//  WDLinkUp
//
//  Created by CSB on 15-3-2.
//  Copyright (c) 2015年 Wonders information Co., LTD. All rights reserved.
//

#import "Constant.h"

NSString * const MayiUserIsNotFirstEnter = @"UserIsNotFirstEnter";

NSString * const MayiUserIsSignIn = @"UserDefaultsIsSignIn";

NSString * const MayiConnectionKey = @"ab1ffd1cbc6cdd121679e8f00e505311";

NSString * const MayiUidKey = @"uid";

NSString * const MayiIsLoginId = @"isloginid";


/************************
 *notifiction 定义
 *
 ************************/
NSString * const MayiPaySuccess = @"MayiPaySuccess";


NSString * const MayiOrderNotifictionPageType = @"PageType";
NSString * const MayiOrderNotifiction = @"OrderNofitiction";
NSString * const MayiOrderRunningNotifiction = @"OrderRunningNotifiction";
NSString * const MayiOrderFinishedNotifiction = @"OrderFinishedNotifiction";
NSString * const MayiOrderCanceledNotifiction = @"OrderCancelNofitiction";

NSString * const MayiBackgroundNotifiction = @"MayiBackgroundNotifiction";

NSString * const MayiIndexPageNotifiction = @"MayiIndexPageNotifiction";

/************************
 *接口定义
 *
 ************************/

//获取图片域名
//NSString * const IMGURL = @"http://o2o.ahxiaodian.com/myxc/Uploads";

NSString * const IMGURL = @"http://myxc.ahwdcz.com/Uploads/";


//发送短信验证码
NSString * const MayiSendMsg = @"sendMsg";
//登录
NSString * const MayiUserLogin = @"userlogin";

//注册
NSString * const MayiUserRegister = @"reging";

//推送注册唯一码
NSString * const MayiBDWYM = @"bdwym";

//首页图片
NSString * const MayiSYTP = @"sytp";

//当前订单
NSString * const MayiRunningOrder = @"dqdd";

//已完成的订单
NSString * const MayiFinishedOrder = @"ywcdd";

//已取消的订单
NSString * const MayiCanceledOrder = @"ytdd";

//取消订单
NSString * const MayiQXDD = @"qxdd";

//获取个人信息
NSString * const MayiUserDetail = @"gexx";

//我要洗车
NSString * const MayiWYXC = @"wyxc";

//充值中心
NSString * const MayiCZZX = @"czzx";

//充值中心提交
NSString * const MayiCZZXTJ = @"czzxtj";

//提交洗车订单
NSString * const MayiWYXCing = @"wyxcing";

//注册时根据定位获取地址信息
NSString * const MayiRegShow = @"regshow";

//余额支付
NSString * const MayiYEZF = @"yezf";

//刮刮卡充值
NSString * const MayiGGKCZ = @"ggkcz";

//常见问题
NSString * const problemApi = @"cjwt";

//获取省份列表

NSString * const ProvinceApi = @"regshow";

//获取市列表

NSString * const CityApi = @"province";
//获取区列表

NSString * const AreaApi = @"city";
//获取小区列表

NSString * const SmallAreaApi = @"area";

//个人中心
NSString * const UserCenter = @"grzx";

//提交建议

NSString * const Complaint =  @"ts";

//个人信息编辑
NSString * const UserInfoEdit =  @"gexxbj";
//上传头像
NSString * const UserAvatarEdit =  @"sctx";

//用户推出

NSString * const Quitlogin = @"quitlogin";

//未领取洗车券
NSString * const NotReceivingVoucher = @"xcjwlq";

//已领取洗车券
NSString * const HasReceivingVoucher = @"xcjysy";

//未使用洗车券
NSString * const NoUseVoucher = @"xcjwsy";


//我的消息

NSString * const MyMsg = @"wdxx";

//我的消息详情
NSString * const MyMsgDetail = @"wdxxxq";
//车辆管理
NSString * const CarManager = @"clgl";

//邀请码

NSString * const InvitationCode = @"yqm";

//添加车辆
NSString * const AddCarNum = @"tjcling";
//车辆编辑
NSString * const CarEdit = @"clbj";


//车辆编辑动作
NSString * const CarEditAction = @"clbjing";



//首页顶部图片
NSString * const Index = @"index";

/************************
 *支付的参数常量定义
 *
 ************************/

NSString *const kOrderID = @"OrderID";
NSString *const kTotalAmount = @"TotalAmount";
NSString *const kProductDescription = @"productDescription";
NSString *const kProductName = @"productName";
NSString *const kNotifyURL = @"NotifyURL";



NSString *const UMENG_APP_KEY = @"5695bfaae0f55ac07f0002ba";
//合作身份者id，以2088开头的16位纯数字
NSString *const PartnerID = @"2088021525285754";
//收款支付宝账号
NSString *const SellerID = @"1059094374@qq.com";

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
NSString *const MD5_KEY = @"";

//商户私钥，自助生成
NSString *const PartnerPrivKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAJ/jMHKJy00NrishoVHKSwf6xFQ2wG4RKmfvoHGOYpLuQjQddvArSUfSmMQyFKH9vxEjCziucv+Wlvfyvi4lYtA3Vyid+o/nIoA/NLEOfyUTe4SPSgfBUbxysKgYzwXDS0Qjk/ZmJrEAA2yJ1sGwB3NFppEtF9eO8Gk9Thuch9kFAgMBAAECgYBeYz95jpEfFuFoAv16DGNI/agjUwM8txOCsjrUbssQlGku3OoXFGa5aMDYqfv2OZcvJbH9LzciXaMYEwxkr5tqAv0uwnh5RwWpUJBsuFL+6sVDSnWbkxuIPJEySmxdtmc3u+r2MjDOirYA7FIvD3giKU0zvBDNAYvwPANzn5nsAQJBANLuMW7MrLnRY2ifO84ZUXXGifCxfE2k2PLHMYJ1inPD4eLQtSe9krAe/EcnGbQywAwCLqMakwqvgEyV4ftZkgUCQQDCDPdfMkGW/siJry65WXAxSdM0ZVR3spwn6wGCzjqSn9UMUcZatE7B4lY239TBeANx+Bg8h1rGAXgGFmsrdNsBAkBDntz2GmOdRoVJ+xJfJjq5OSbrpNqmwZxTaIx0uF3kcv2tix8oWFv4XlaeMOjKniJ3NxPgchqFqHHHG53QyIxJAkAbTkPI64N7QeLqLPKANmupI+BKcS/PoByFKXaO94Iae8846pDk1pZ2hejn09tWVhL2CJkwe0N0tWQ0RxdRiCIBAkEAutklbR0ro1abz0/iMsfJz6LwgPpzZ+iurSrz2x1V0l9GrEzFyQfss3EeQabOT2lPnI4WrOLxx1ntkeUHiRIH8A==";


//支付宝公钥
NSString *const AlipayPubKey = @"MIGfMA0GCoqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB";


