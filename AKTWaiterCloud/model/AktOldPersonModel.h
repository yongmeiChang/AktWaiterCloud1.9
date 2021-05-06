//
//  AktOldPersonModel.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2021/4/28.
//  Copyright © 2021 常永梅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol AktOldPersonDetailsModel
@end

@interface AktOldPersonModel : JSONModel
@property(nonatomic,strong) NSArray <AktOldPersonDetailsModel>* list; // 服务项目id
@end

@interface AktOldPersonDetailsModel : JSONModel
@property (strong, nonatomic) NSString<Optional>* id;
@property (strong, nonatomic) NSString<Optional>* customerId;   // 用户ID
@property (strong, nonatomic) NSString<Optional>* customerName; // 用户名称
@property (strong, nonatomic) NSString<Optional>* identifyNo;   // 用户身份证
@property (strong, nonatomic) NSString<Optional>* customerMobile;  // 用户手机
@property (strong, nonatomic) NSString<Optional>* customerAddress; // 用户地址
@property (strong, nonatomic) NSString<Optional>* customerNo;   // 用户档案号
@property (strong, nonatomic) NSString<Optional>* customerUkey;   // 老人唯一码

@end

NS_ASSUME_NONNULL_END
