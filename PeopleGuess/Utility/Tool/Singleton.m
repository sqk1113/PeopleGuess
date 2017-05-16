//
//  Singleton.m
//  vjifen
//
//  Created by zhanglinxu on 14-7-17.
//
//

#import "Singleton.h"

@implementation Singleton


+(Singleton *)sharedSingleton{
    static Singleton *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedSingleton) {
            sharedSingleton = [[Singleton alloc]init];
        }
        
    });
    
   return sharedSingleton;
}

@end
