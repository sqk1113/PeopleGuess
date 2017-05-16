//
//  NSString+Extension.m
//  黑马微博2期
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "NSString+Extension.h"
//#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

@implementation NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    // 获得系统版本
    if (iOS7) {
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    } else {
        return [self sizeWithFont:font constrainedToSize:maxSize];
    }
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}


//NSMutableArray * mutArray = [NSMutableArray array];
//for (int i = 0; i < 4; i++) {
//    
//    NSMutableArray * childArray = [NSMutableArray array];
//    for (int j = 0;  j < 4; j++) {
//        NSString * string = [NSString stringWithFormat:@"%d.Do any additional setup after loading the view, typically from a nib  Do any additional setup after loading the view, typically from a nib Do any additional setup after loading the view, typically from a nib ",j];
//        
//        NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:string,@"string", nil];
//        [childArray addObject:dic];
//    }
//    
//    NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:childArray,@"childArray", nil];
//    [mutArray addObject:dic];
//}
//
//NSLog(@"mutArray %@",mutArray);
//
//NSMutableArray * mainMutArray = [NSMutableArray array];
//for (NSDictionary * dict in mutArray) {
//    MyCellModel * model = [[MyCellModel alloc] init];
//    model.childArray = dict[@"childArray"];
//    [mainMutArray addObject:model];
//}
//_dataSourceArray = [self stausFramesWithStatuses:mainMutArray];
//NSLog(@"_dataSourceArray -- %@",_dataSourceArray);

@end
