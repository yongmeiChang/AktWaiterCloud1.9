//
//  NSString+JSONToDictionary.m
//  HomeDo
//
//  Created by Lynn on 15/12/8.
//  Copyright © 2015年 Lynn. All rights reserved.
//

#import "NSString+JSONToDictionary.h"

@implementation NSString (JSONToDictionary)

- (NSDictionary *)toDictionaryWithError:(NSError **)_error {
    
    if (self == nil)
        return nil;
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error && _error) *_error = error;
    
    return dic;
}

+ (NSString*)jsonStringWithData:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];//NSJSONWritingPrettyPrinted  会有\n  0 没有
    if (error){
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
@end
