//
//  Constant.h
//  WDLinkUp
//
//  Created by CSB on 15-3-2.
//  Copyright (c) 2015年 Wonders information Co., LTD. All rights reserved.
//
 #import <Foundation/Foundation.h>
#ifndef WDLinkUp_Constant_h
#define WDLinkUp_Constant_h
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)
#define POP_WIDTH                        SCREEN_WIDTH*9/10
#define UIColorFromRGB(rgbValue)        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.0f]
#define UIColorWithRGBA(r,g,b,a)        [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define menoyTextColor                  UIColorWithRGBA(255,126,0,1)

FOUNDATION_EXPORT NSString * const MayiUserIsNotFirstEnter;

FOUNDATION_EXPORT NSString * const MayiUserIsSignIn;

FOUNDATION_EXPORT NSString * const MayiConnectionKey;

FOUNDATION_EXPORT NSString * const MayiUidKey;



FOUNDATION_EXPORT NSString * const MayiIsLoginId;

/************************
 *notifiction 定义
 *
 ************************/
FOUNDATION_EXPORT NSString * const MayiPaySuccess;

FOUNDATION_EXPORT NSString * const MayiOrderNotifictionPageType;
FOUNDATION_EXPORT NSString * const MayiOrderNotifiction;

FOUNDATION_EXPORT NSString * const MayiOrderCanceledNotifiction;

/************************
 *接口定义
 *
 ************************/

//获取图片域名
FOUNDATION_EXPORT NSString * const IMGURL;

//发送短信验证码
FOUNDATION_EXPORT NSString * const MayiSendMsg;

//登录
FOUNDATION_EXPORT NSString * const MayiUserLogin;
//注册
FOUNDATION_EXPORT NSString * const MayiUserRegister;

//推送注册唯一码
FOUNDATION_EXPORT NSString * const MayiBDWYM;

//首页图片
FOUNDATION_EXPORT NSString * const MayiSYTP;

//获取个人信息
FOUNDATION_EXPORT NSString * const MayiUserDetail;



//我要洗车
FOUNDATION_EXPORT NSString * const MayiWYXC;

//充值中心
FOUNDATION_EXPORT NSString * const MayiCZZX;

//充值中心提交
FOUNDATION_EXPORT NSString * const MayiCZZXTJ;

//提交洗车订单
FOUNDATION_EXPORT NSString * const MayiWYXCing;

//余额支付
FOUNDATION_EXPORT NSString * const MayiYEZF;

//刮刮卡充值
FOUNDATION_EXPORT NSString * const MayiGGKCZ;

//当前订单
FOUNDATION_EXPORT NSString * const MayiRunningOrder;

//已完成的订单
FOUNDATION_EXPORT NSString * const MayiFinishedOrder;

//已取消的订单
FOUNDATION_EXPORT NSString * const MayiCanceledOrder;

//取消订单
FOUNDATION_EXPORT NSString * const MayiQXDD;


//常见问题
FOUNDATION_EXPORT NSString * const problemApi;
//我的信息


//获取省份列表
FOUNDATION_EXPORT NSString * const ProvinceApi;

//获取市列表
FOUNDATION_EXPORT NSString * const CityApi;

//获取区列表
FOUNDATION_EXPORT NSString * const AreaApi;

//获取小区列表
FOUNDATION_EXPORT NSString * const SmallAreaApi;

//个人中心
FOUNDATION_EXPORT NSString * const UserCenter;

//提交建议
FOUNDATION_EXPORT NSString * const Complaint;
//个人信息编辑
FOUNDATION_EXPORT NSString * const UserInfoEdit;



//用户推出
FOUNDATION_EXPORT NSString * const Quitlogin;



//未领取洗车券
FOUNDATION_EXPORT NSString * const NotReceivingVoucher;


//已领取洗车券
FOUNDATION_EXPORT NSString * const HasReceivingVoucher;


//未使用洗车券
FOUNDATION_EXPORT NSString * const NoUseVoucher;
//我的消息
FOUNDATION_EXPORT NSString * const MyMsg;

//我的消息详情
FOUNDATION_EXPORT NSString * const MyMsgDetail;
/************************
 *支付的参数常量定义
 *
 ************************/

FOUNDATION_EXPORT NSString *const kOrderID;
FOUNDATION_EXPORT NSString *const kTotalAmount;
FOUNDATION_EXPORT NSString *const kProductDescription;
FOUNDATION_EXPORT NSString *const kProductName;
FOUNDATION_EXPORT NSString *const kNotifyURL;


//合作身份者id，以2088开头的16位纯数字
FOUNDATION_EXPORT NSString *const PartnerID;
//收款支付宝账号
FOUNDATION_EXPORT NSString *const SellerID;

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
FOUNDATION_EXPORT NSString *const MD5_KEY;

//商户私钥，自助生成
FOUNDATION_EXPORT NSString *const PartnerPrivKey;


//支付宝公钥
FOUNDATION_EXPORT NSString *const AlipayPubKey;



#endif
