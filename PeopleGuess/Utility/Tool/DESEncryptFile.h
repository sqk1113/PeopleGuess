//
//  DESEncryptFile.h
//  DEScodeDemo
//
//  Created by qingyun on 10/9/13.
//  Copyright (c) 2013 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DESEncryptFile : NSObject

+(NSString*)md5Str:(NSString*)str;

+ (NSString *)getMd5ForDic:(NSDictionary *)dic;

//文本先进行DES加密。然后再转成base64
+ (NSString *)base64StringFromText:(NSString *)text withKey:(NSString*)key;

//先把base64转为文本。然后再DES解密
+ (NSString *)textFromBase64String:(NSString *)base64 withKey:(NSString*)key;

//文本数据进行DES加密
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key;
//文本数据进行DES解密
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;

//base64格式字符串转换为文本数据
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

//文本数据转换为base64格式字符串
+ (NSString *)base64EncodedStringFrom:(NSData *)data;

//字节数组转化16进制数
+(NSString *) parseByteArray2HexString:(Byte[]) bytes;
//将16进制数据转化成NSData 数组
+(NSData*) parseHexToByteArray:(NSString*) hexString;


+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;


@end
