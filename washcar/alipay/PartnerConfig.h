//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088021525285754"
//收款支付宝账号
#define SellerID  @"1059094374@qq.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @""

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAJ/jMHKJy00NrishoVHKSwf6xFQ2wG4RKmfvoHGOYpLuQjQddvArSUfSmMQyFKH9vxEjCziucv+Wlvfyvi4lYtA3Vyid+o/nIoA/NLEOfyUTe4SPSgfBUbxysKgYzwXDS0Qjk/ZmJrEAA2yJ1sGwB3NFppEtF9eO8Gk9Thuch9kFAgMBAAECgYBeYz95jpEfFuFoAv16DGNI/agjUwM8txOCsjrUbssQlGku3OoXFGa5aMDYqfv2OZcvJbH9LzciXaMYEwxkr5tqAv0uwnh5RwWpUJBsuFL+6sVDSnWbkxuIPJEySmxdtmc3u+r2MjDOirYA7FIvD3giKU0zvBDNAYvwPANzn5nsAQJBANLuMW7MrLnRY2ifO84ZUXXGifCxfE2k2PLHMYJ1inPD4eLQtSe9krAe/EcnGbQywAwCLqMakwqvgEyV4ftZkgUCQQDCDPdfMkGW/siJry65WXAxSdM0ZVR3spwn6wGCzjqSn9UMUcZatE7B4lY239TBeANx+Bg8h1rGAXgGFmsrdNsBAkBDntz2GmOdRoVJ+xJfJjq5OSbrpNqmwZxTaIx0uF3kcv2tix8oWFv4XlaeMOjKniJ3NxPgchqFqHHHG53QyIxJAkAbTkPI64N7QeLqLPKANmupI+BKcS/PoByFKXaO94Iae8846pDk1pZ2hejn09tWVhL2CJkwe0N0tWQ0RxdRiCIBAkEAutklbR0ro1abz0/iMsfJz6LwgPpzZ+iurSrz2x1V0l9GrEzFyQfss3EeQabOT2lPnI4WrOLxx1ntkeUHiRIH8A=="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCoqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
