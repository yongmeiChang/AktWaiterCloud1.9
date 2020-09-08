//
//  NSString+JSONToDictionary.h
//  HomeDo
//
//  Created by Lynn on 15/12/8.
//  Copyright © 2015年 Lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSONToDictionary)

/**解析json to dictionary
 * _error 解析失败时返回错误码
 **/
- (NSDictionary *)toDictionaryWithError:(NSError **)_error;

+ (NSString*)jsonStringWithData:(id)object;
@end
