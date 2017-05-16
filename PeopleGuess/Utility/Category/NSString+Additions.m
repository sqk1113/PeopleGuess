//
//  NSString+MKNetworkKitAdditions.m
//  MKNetworkKitDemo
//
//  Created by Mugunth Kumar (@mugunthkumar) on 11/11/11.
//  Copyright (C) 2011-2020 by Steinlogic

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

//#import "NSString+MKNetworkKitAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MKNetworkKitAdditions)

- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];      
}

+ (NSString*) uniqueString
{
	CFUUIDRef	uuidObj = CFUUIDCreate(nil);
	NSString	*uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	return uuidString;
}

- (NSString*) urlEncodedString {
    
    CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
                                                                        (__bridge CFStringRef) self, 
                                                                        nil,
                                                                        CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\|~ "), 
                                                                        kCFStringEncodingUTF8);
    
    NSString *encodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) encodedCFString];    

    if(!encodedString)
        encodedString = @"";    
    
    return encodedString;
}

- (NSString*) urlDecodedString {

    CFStringRef decodedCFString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, 
                                                                                          (__bridge CFStringRef) self, 
                                                                                          CFSTR(""),
                                                                                          kCFStringEncodingUTF8);
    
    // We need to replace "+" with " " because the CF method above doesn't do it
    NSString *decodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) decodedCFString];    
    return (!decodedString) ? @"" : [decodedString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

- (NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"H"]];//H表示+0800.相应的I表示+0900.Z表示-0100.
    NSDate *nationalDate2 = [formatter dateFromString:self];
    
    return nationalDate2;
}

- (NSDate *)datetime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"H"]];//H表示+0800.相应的I表示+0900.Z表示-0100.
    NSDate *nationalDate2 = [formatter dateFromString:self];
    
    return nationalDate2;
}

- (NSDate *)datetime2 {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"H"]];//H表示+0800.相应的I表示+0900.Z表示-0100.
    NSDate *nationalDate2 = [formatter dateFromString:self];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: nationalDate2];
    nationalDate2 = [nationalDate2  dateByAddingTimeInterval: interval];
    
    return nationalDate2;
}

- (BOOL)isValidateEmail {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)checkPassword
{
//    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSString *pattern = @"^[a-zA-Z0-9]{6,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
    
}

- (BOOL)isValidatePhoneNumber
{
    /*
     通配
     */
    NSString *allMobile = @"^1([3-9])\\d{9}$";
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestallmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allMobile];
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    BOOL res1 = [regextestmobile evaluateWithObject:self];
    BOOL res2 = [regextestcm evaluateWithObject:self];
    BOOL res3 = [regextestcu evaluateWithObject:self];
    BOOL res4 = [regextestct evaluateWithObject:self];
    BOOL res5 = [regextestallmobile evaluateWithObject:self];
    
    if (res1 || res2 || res3 || res4 || res5)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (CGFloat)heightOfTextWithWidth:(float)width theFont:(UIFont*)aFont {
    CGFloat result;
    CGSize textSize = { width, 20000.0f };
    CGSize size = [self sizeWithFont:aFont constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    result = size.height + 1;
    return result;
}

- (CGFloat)heightOfTextWithWidth:(float)width height:(float)height theFont:(UIFont*)aFont {
    CGFloat result;
    CGSize textSize = { width, height };
    CGSize size = [self sizeWithFont:aFont constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    result = size.height + 1;
    return result;
}

- (CGFloat)heightOfTextWithHeight:(CGFloat)height theFont:(UIFont *)aFont
{
    CGFloat result;
    CGSize textSize = { 20000.0f, height };
//    boundingRectWithSize:options:attributes:context
    CGSize size = [self sizeWithFont:aFont constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
//    CGSize size = [self boundingRectWithSize:textSize options:NSStringDrawingTruncatesLastVisibleLine attributes:nil context:nil];
    result = size.width + 1;
    return result;
}



- (NSString *)getMiriadeString
{
    if (self.length>=5) {
        CGFloat num = [self floatValue];
        CGFloat numTemp = num/10000;
        NSString *numS = [NSString stringWithFormat:@"%0.1f万", numTemp];
        return numS;
    }

    return self;
}



+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

- (BOOL)isContainStr:(NSString *)subStr
{
    
    if ([self rangeOfString:subStr].location != NSNotFound) {
        
        return YES;
        
    }
    
    
    return NO;
}

//中英文混排字符串长度
- (NSUInteger)getToInt

{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self dataUsingEncoding:enc];
    return [da length];
}

@end
