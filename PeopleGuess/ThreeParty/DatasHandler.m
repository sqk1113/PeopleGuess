//
//  ProvincesHandle.m
//  WaSai
//
//  Created by Hasson on 15-1-15.
//  Copyright (c) 2015年 Hasson. All rights reserved.
//

#import "DatasHandler.h"
#import "ProvinceModel.h"
//#import "YTemplateCtrl.h"
#import "CityModel.h"
//#import "ZipArchive.h"
//#import "YCacheUtil.h"
//#import "Filters.h"
//#import "ImageFilters.h"
//#import "YTemplateModel.h"
#define DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0]

#define TEMP_PIC_PLIST @"tempPicture.plist"
#define PREVIEW_PIC_PLIST @"previewTempPicture.plist"
#define RESDATA_JS_PATH @"h5/v1/pdata/resdata-%lf.js"
#define PREVIEW_RESMAP_DATA_JS_PATH @"h5/v1/pdata/preview_resmap_data-%lf.js"
#define PDATA_PATH      @"h5/v1/pdata"
#define UPLOAD_DATA_JS_PATH @"h5/v1/pdata/upload_data-%lf.js"
#define UPLOAD_DESCDATA_JS_PATH @"h5/v1/pdata/upload_descdata-%lf.js"
#define SUMMARY_JS_PATH @"h5/v1/themes/%lld/summary.js"

@implementation DatasHandler
{
    NSString *resdataHeadStr;
    NSString *resdataTailStr;
    
    NSString *previewHeader;
    NSString *previewTailStr;
}

static DatasHandler *handle = nil;

+ (instancetype)defaultProvincesHandle
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        handle = [[DatasHandler alloc] init];
        [handle loadCitysArray];
//        [handle loadPicturePlist];
    });
    return handle;
}

//- (instancetype)init
//{
//    if (self = [super init]) {
//        self.resdataJsDic = [[NSMutableDictionary alloc] init];
//        self.provincesArray = [[NSMutableArray alloc] init];
//        self.previewJSDic = [[NSMutableDictionary alloc] init];
//        self.previewPicArray = [[NSMutableArray alloc] init];
//        self.uploadDataJSDic = [[NSMutableDictionary alloc] init];
//        self.activeId = -1;
//    }
//    return self;
//}
//
- (void)loadCitysArray
{
    self.provincesArray = [ProvinceModel getProvinces];
}
//
//- (NSString *)getProAndCityWith:(NSInteger)proId cityId:(NSInteger)cityId
//{
//    NSString *returnStr;
//    for (ProvinceModel *pro in self.provincesArray) {
//        if (pro.provinceId == proId) {
//            returnStr = pro.name;
//            for (CityModel *city in pro.citys) {
//                if (city.cityId == cityId) {
//                    returnStr = [returnStr stringByAppendingString:[NSString stringWithFormat:@"  %@", city.name]];
//                }
//                break;
//            }
//            break;
//        }
//    }
//    
//    return returnStr;
//}

//- (void)loadPicturePlist
//{
//    NSString *imagePath = [DOCUMENT_PATH stringByAppendingPathComponent:TEMP_PIC_PLIST];
//    self.tempPicArray = [NSMutableArray arrayWithContentsOfFile:imagePath];
//    if (!self.tempPicArray) {
//        self.tempPicArray = [[NSMutableArray alloc] init];
//    }
//    NSString *previewPicPath = [DOCUMENT_PATH stringByAppendingPathComponent:PREVIEW_PIC_PLIST];
//    self.previewPicArray = [NSMutableArray arrayWithContentsOfFile:previewPicPath];
//    if ((!self.previewPicArray)) {
//        self.previewPicArray = [[NSMutableArray alloc] init];
//    }
//    
//}
//
//-(void)setSelectedTempId:(NSInteger)selectedTempId
//{
//    _selectedTempId = selectedTempId;
//}
//
////json字符串转换成字典
//- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
//{
//    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSError *error = nil;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//    DLog(@"dic is %@", dic);
//    if (!error) {
//        return dic;
//    }
//    DLog(@"error is %@", error.description);
//    
//    return nil;
//}
//
////resdata.js 相关
//- (NSMutableDictionary *)getResdataFromLocal
//{
//    NSString *resdataPath = [[NSBundle mainBundle] pathForResource:@"resdata" ofType:@"js"];
//    
////    NSString *resdataPath = [DOCUMENT_PATH stringByAppendingPathComponent:RESDATA_JS_PATH];
//    
//    NSMutableString *string = [[NSMutableString alloc] initWithContentsOfFile:resdataPath encoding:NSUTF8StringEncoding error:nil];
//    
////    NSLog(@"%@", string);
//    NSRange returnRange = [string rangeOfString:@"window.wi_resdata = "];
//    resdataHeadStr = [string substringToIndex:returnRange.location+returnRange.length];
//    resdataTailStr = [string substringFromIndex:string.length-2];
//    
//    NSString *subString = [string stringByReplacingOccurrencesOfString:resdataHeadStr withString:@""];
//    subString = [subString stringByReplacingOccurrencesOfString:resdataTailStr withString:@""];
//    
//    DLog(@"sub is %@", subString);
//    
//    NSData *data = [subString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    DLog(@"dic is %@", dic);
//    
//    NSArray *keyAry = [dic allKeys];
//    for (NSString *key in keyAry) {
//        NSMutableArray *mAry = [[dic objectForKey:key] mutableCopy];
//        [self.resdataJsDic setObject:mAry forKey:key];
//    }
//    
//    return self.resdataJsDic;
//}
////用户添加的照片到resdata文件
//- (NSMutableArray *)setOriginalPhotos:(NSArray *)photos
//{
////    self.originalAry = [NSMutableArray array];
//    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//    NSMutableArray *OriPhotos = [self.resdataJsDic objectForKey:@"photos"];
////    [OriPhotos removeAllObjects];
//    NSMutableArray *newPhotos = [NSMutableArray array];
//    
//    int i = 0;
//    for (NSString *imageName in photos) {
//        
//        NSDictionary *dic = [OriPhotos objectAtIndex:i];
//        NSInteger index = [[dic objectForKey:@"photoid"] intValue];
//        
//        NSString *newImagepath = [@"../../../pdata/" stringByAppendingString:imageName];
//        
//        NSDictionary *imagedic = @{@"lurl":newImagepath, @"photoid":@(index)};
//        NSDictionary *imageTdic = @{@"name":imageName, @"photoid":@(index)};
//        [newPhotos addObject:imagedic];
//        [tempArray addObject:imageTdic];
////        [self.originalAry addObject:imageTdic];
//        i++;
//    }
//    [self.resdataJsDic setObject:newPhotos forKey:@"photos"];
//    [self.tempPicArray addObjectsFromArray:tempArray];
//    //    NSLog(@"self.resdataDic is %@", self.resdataJsDic);
//    return tempArray;
//}
////用户添加的照片到resdata文件
//- (NSMutableArray *)setPhotos:(NSArray *)photos
//{
//    self.originalAry = [NSMutableArray array];
//    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//    NSMutableArray *OriPhotos = [self.resdataJsDic objectForKey:@"photos"];
//    [OriPhotos removeAllObjects];
//    
//    int i = (int)[self.tempPicArray count];
//    for (NSString *imageName in photos) {
//        NSString *newImagepath = [@"../../../pdata/" stringByAppendingString:imageName];
//        
//        NSDictionary *imagedic = @{@"lurl":newImagepath, @"photoid":@(i)};
//        NSDictionary *imageTdic = @{@"name":imageName, @"photoid":@(i++)};
//        [OriPhotos addObject:imagedic];
//        [tempArray addObject:imageTdic];
//        [self.originalAry addObject:imageTdic];
//    }
//    [self.resdataJsDic setObject:OriPhotos forKey:@"photos"];
//    [self.tempPicArray addObjectsFromArray:tempArray];
//    
//    //添加preview_path/resmap_path到resdata
//    [self.resdataJsDic setObject:@"../preview_tpl/preview.js" forKey:@"preview_path"];
//    
////    NSLog(@"self.resdataDic is %@", self.resdataJsDic);
//    return tempArray;
//}
//
//- (void)setObjectToResdataJs:(id)o key:(NSString *)key
//{
//    [self.resdataJsDic setObject:o forKey:key];
//}
//
////获取当前resdata里保存的图片
//- (NSArray *)getPhotosFromResdata
//{
//    NSArray *ary = [self.resdataJsDic objectForKey:@"photos"];
//    
//    return ary;
//}
//
////替换resdata里面的图片
//- (void)replacePhotoWith:(int)photoId photoName:(NSString *)newName photoId:(int)newId
//{
//    NSMutableArray *OriPhotos = [self.resdataJsDic objectForKey:@"photos"];
//    
//    DLog(@"-= is %@", OriPhotos);
//    for (NSDictionary *imageDic in OriPhotos) {
//        DLog(@"%@", imageDic);
//        /*
//        NSString *newImagepath = [@"../../../pdata/" stringByAppendingString:imageName];
//        
//        NSDictionary *imagedic = @{@"lurl":newImagepath, @"photoid":@(i)};
//        NSDictionary *imageTdic = @{@"name":imageName, @"photoid":@(i++)};
//        [OriPhotos addObject:imagedic];
//        [tempArray addObject:imageTdic];
//         */
//        if ([[imageDic objectForKey:@"photoid"] intValue] == photoId) {
//            NSInteger index = [OriPhotos indexOfObject:imageDic];
//            
//            NSString *newImagepath = [@"../../../pdata/" stringByAppendingString:newName];
//            NSDictionary *imaged = @{@"lurl":newImagepath, @"photoid":@(newId)};
//            
//            [OriPhotos insertObject:imaged atIndex:index];
//            
//            [self removePhotoWith:[[imageDic objectForKey:@"lurl"] lastPathComponent]];
//            [OriPhotos removeObject:imageDic];
//            
//            break;
//        }
//    }
//    
//    DLog(@"-= 后 is %@", OriPhotos);
//    [self.resdataJsDic setObject:OriPhotos forKey:@"photos"];
////    [self.tempPicArray addObjectsFromArray:tempArray];
//    DLog(@"原图片 is %@", self.originalAry);
//    for (NSDictionary *imageDic in self.originalAry) {
//        if ([[imageDic objectForKey:@"photoid"] intValue] == photoId) {
//            NSInteger index = [self.originalAry indexOfObject:imageDic];
//            
////            [self removePhotoWith:[[imageDic objectForKey:@"lurl"] lastPathComponent]];
//            NSString *oldName = [imageDic objectForKey:@"name"];
//            NSString *pdataPath = [DOCUMENT_PATH stringByAppendingPathComponent:PDATA_PATH];
//            NSString *originalPath = [pdataPath stringByAppendingPathComponent:@"original"];
//            NSString *imagePath = [originalPath stringByAppendingPathComponent:oldName];
//            [[YCacheUtil CacheUtil] deleteFilePath:imagePath];
//            
////            NSString *newImagepath = [@"../../../pdata/" stringByAppendingString:newName];
//            NSDictionary *imaged = @{@"name":newName, @"photoid":@(newId)};
//            
//            [self.originalAry insertObject:imaged atIndex:index];
//            [self.originalAry removeObject:imageDic];
//            
//            NSString *souImagePath = [pdataPath stringByAppendingPathComponent:newName];
//            NSString *desImagePath = [originalPath stringByAppendingPathComponent:newName];
//            [[YCacheUtil CacheUtil] copyFilePath:souImagePath toPath:desImagePath];
//            
//            break;
//        }
//    }
//    DLog(@"换图片后 is %@", self.originalAry);
//}
//
////preview_resmap_data.js 相关
//- (void)setPreviewResmapData
//{
////    NSString *resdataPath = [DOCUMENT_PATH stringByAppendingPathComponent:PREVIEW_RESMAP_DATA_JS_PATH];
//    
//    NSString *resdataPath = [[NSBundle mainBundle] pathForResource:@"preview_resmap_data" ofType:@"js"];
//    
//    NSMutableString *string = [[NSMutableString alloc] initWithContentsOfFile:resdataPath encoding:NSUTF8StringEncoding error:nil];
//    
//    //    NSLog(@"%@", string);
//    NSRange returnRange = [string rangeOfString:@"window.wi_resmap_data = "];
//    previewHeader = [string substringToIndex:returnRange.location+returnRange.length];
//    previewTailStr = [string substringFromIndex:string.length-1];
//    
//    NSString *subString = [string stringByReplacingOccurrencesOfString:previewHeader withString:@""];
//    subString = [subString stringByReplacingOccurrencesOfString:previewTailStr withString:@""];
//    
////    NSLog(@"----------%@", subString);
//    
//    NSData *data = [subString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
////        NSLog(@"dic is %@", dic);
//    
//    NSArray *keyAry = [dic allKeys];
//    for (NSString *key in keyAry) {
//        NSMutableArray *mAry = [[dic objectForKey:key] mutableCopy];
//        
////        NSLog(@"mary is %@", mAry);
//        [self.previewJSDic setObject:mAry forKey:key];
//        
//    }
////    NSLog(@"取到的 previewJS %@", self.previewJSDic);
////    return self.resdataJsDic;
//}
////根据需求重写preview_resmap_data.js文件
//- (void)rewritePreviewResmapJS:(NSDictionary *)resdata
//{
//    //音乐
//    NSMutableArray *musics = [NSMutableArray array];
//    for (NSDictionary *resdataAudio in [resdata objectForKey:@"audios"]) {
//        [musics addObject:resdataAudio];
//    }
//    //录音
//    NSMutableArray *audios = [NSMutableArray array];
//    for (NSDictionary *audio in [resdata objectForKey:@"custom_audios"]) {
//        [audios addObject:audio];
//    }
//    //贴图
//    NSMutableArray *chertlates = [NSMutableArray array];
//    for (NSDictionary *chertlate in [resdata objectForKey:@"dynamic_elements"]) {
//        [chertlates addObject:chertlate];
//    }
//    //字体
//    NSMutableArray *fonts = [NSMutableArray array];
//    for (NSDictionary *font in [resdata objectForKey:@"fonts"]) {
//        [fonts addObject:font];
//    }
//    //预览照片
//    NSMutableArray *previewPhotos = [NSMutableArray array];
//    NSArray *resDataPhotos = [resdata objectForKey:@"photos"];
//    for (NSDictionary *resdataPhoto in resDataPhotos) {
//        int redataPid = [[resdataPhoto objectForKey:@"photoid"] intValue];
//        NSString *imageName = [self getImageNameWith:redataPid];
//        
//        NSDictionary *previewPhoto = @{@"photoid":@(redataPid), @"lurl":[NSString stringWithFormat:@"./%@", imageName]};
//        [previewPhotos addObject:previewPhoto];
//    }
//    
//    [self.previewJSDic setObject:musics forKey:@"audios"];
//    [self.previewJSDic setObject:audios forKey:@"custom_audios"];
//    [self.previewJSDic setObject:chertlates forKey:@"dynamic_elements"];
//    [self.previewJSDic setObject:fonts forKey:@"fonts"];
//    [self.previewJSDic setObject:previewPhotos forKey:@"photos"];
//    
////    NSLog(@"新的 previewJS %@", self.previewJSDic);
//}
////一键制作预览所需的resmap.js
//- (void)rewritePreviewResmapJSForOneKey:(NSDictionary *)resdata
//{
//    
//}
//
////将preview_resmap_data.js 写回本地
//- (void)writePreviewdataToLocal
//{
//    [self deleteTempPreviewResmapDataJS];
//    
//    NSData *data = [NSJSONSerialization dataWithJSONObject:self.previewJSDic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *resStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    resStr = [previewHeader stringByAppendingString:resStr];
//    resStr = [resStr stringByAppendingString:previewTailStr];
//    
//    DLog(@"-=-=-resStr %@", resStr);
//    
//    NSString *resdataPath = [DOCUMENT_PATH stringByAppendingPathComponent:[NSString stringWithFormat:PREVIEW_RESMAP_DATA_JS_PATH, TIMESTAMP]];
//    
//    self.previewResmapName = [resdataPath lastPathComponent];
//    
//    [resStr writeToFile:resdataPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//}
//
////添加图片到缓存
//- (int)setPhotosToTemp:(NSString *)photoName
//{
//    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//    
//    int i = (int)[self.tempPicArray count];
//    
//    NSDictionary *imageTdic = @{@"name":photoName, @"photoid":@(i)};
//    [tempArray addObject:imageTdic];
//    
//    [self.tempPicArray addObjectsFromArray:tempArray];
//    
//    return i;
//}
//
////添加图片到缓存
//- (int)setPhotoToTemp:(NSString *)photoName
//{
//    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//    
//    int maxId = 0;
//    for (int i = 0; i<self.tempPicArray.count; i++) {
//        NSDictionary *dic = [_tempPicArray objectAtIndex:i];
//        int temId = [[dic objectForKey:@"photoid"] intValue];
//        if (temId > maxId) {
//            maxId = temId;
//        }
//    }
//    
//    int pId = maxId+1;
//    NSDictionary *imageTdic = @{@"name":photoName, @"photoid":@(pId)};
//    [tempArray addObject:imageTdic];
//    
//    [self.tempPicArray addObjectsFromArray:tempArray];
//    
//    return pId;
//}
//
////重写resdata.js文件到本地
//- (void)writeResdataToLocal
//{
//    [self deleteTempResdataJS];
//    
//    DLog(@"%@", self.resdataJsDic);
//    
//    NSData *data = [NSJSONSerialization dataWithJSONObject:self.resdataJsDic options:NSJSONWritingPrettyPrinted error:nil];
//    
//    NSString *resStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//    resStr = [resdataHeadStr stringByAppendingString:resStr];
//    resStr = [resStr stringByAppendingString:resdataTailStr];
//    
//    NSString *resdataPath = [DOCUMENT_PATH stringByAppendingPathComponent:[NSString stringWithFormat:RESDATA_JS_PATH, TIMESTAMP]];
////    NSString *resdataPath = [DOCUMENT_PATH stringByAppendingFormat:@""]
//    self.resdataName = [resdataPath lastPathComponent];
//    
//    [resStr writeToFile:resdataPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//}
//
////保存缓存图片信息
//- (void)saveTempPic
//{
//    NSString *tempPath = [DOCUMENT_PATH stringByAppendingPathComponent:TEMP_PIC_PLIST];
//    NSString *previewPicPath = [DOCUMENT_PATH stringByAppendingPathComponent:PREVIEW_PIC_PLIST];
//    
//    [self.tempPicArray writeToFile:tempPath atomically:NO];
//    [self.previewPicArray writeToFile:previewPicPath atomically:NO];
//}
//
////清除缓存图片
//- (void)deleteTempPic
//{
//    NSString *tempPath = [DOCUMENT_PATH stringByAppendingPathComponent:PDATA_PATH];
//    for (NSDictionary *imageDic in self.tempPicArray) {
//        NSString *imageName = [imageDic objectForKey:@"name"];
//        NSString *imagePath = [tempPath stringByAppendingPathComponent:imageName];
////        NSLog(@"imagePath is %@", imagePath);
//        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
//    }
//    [self.tempPicArray removeAllObjects];
//    
//    for (NSDictionary *prePic in self.previewPicArray) {
//        NSString *imagePath = [DOCUMENT_PATH stringByAppendingPathComponent:[prePic objectForKey:@"imagePath"]];
//        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
//    }
//    [self.previewPicArray removeAllObjects];
//    
//    [self saveTempPic];
//
//}
//
////清除某一张图片
//- (void)removePhotoWith:(NSString *)imageName
//{
//    NSString *padataPath = [DOCUMENT_PATH stringByAppendingPathComponent:PDATA_PATH];
//    NSString *imagePath = [padataPath stringByAppendingPathComponent:imageName];
//    
//    [[YCacheUtil CacheUtil] deleteFilePath:imagePath];
//}
//
////清除original图片
//- (void)deleteOriginalImage
//{
//    YCacheUtil *cache = [YCacheUtil CacheUtil];
//    NSString *pdataPath = [DOCUMENT_PATH stringByAppendingPathComponent:PDATA_PATH];
//    NSString *originalPath = [pdataPath stringByAppendingPathComponent:@"original"];
//    if ([cache checkFolderExists:originalPath]) {
//        [cache deleteFilePath:originalPath];
//    }
//}
//
////清除resdata缓存文件
//- (void)deleteTempResdataJS
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    YCacheUtil *cache = [YCacheUtil CacheUtil];
//    NSString *pdataPath = [DOCUMENT_PATH stringByAppendingPathComponent:PDATA_PATH];
//    NSArray *fileLists = [fileManager contentsOfDirectoryAtPath:pdataPath error:nil];
//    for(NSString *filePath in fileLists){
//        
//        //        DLog(@"filePath is %@", filePath);
//        NSString *fileName = [filePath lastPathComponent];//取得文件名
//        
//        if ([fileName hasPrefix:@"resdata"] && [fileName hasSuffix:@".js"]) {
//            
//            NSString *souPath = [pdataPath stringByAppendingPathComponent:fileName];
//            
//            if ([cache checkFileExists:souPath]) {
//                
//                BOOL success = [cache deleteFilePath:souPath];
//                
//            }
//        }
//    }
//}
//
////清除preview_resmap_data缓存文件
//- (void)deleteTempPreviewResmapDataJS
//{
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    YCacheUtil *cache = [YCacheUtil CacheUtil];
//    NSString *pdataPath = [DOCUMENT_PATH stringByAppendingPathComponent:PDATA_PATH];
//    NSArray *fileLists = [fileManager contentsOfDirectoryAtPath:pdataPath error:nil];
//    for(NSString *filePath in fileLists){
//        
//        //        DLog(@"filePath is %@", filePath);
//        NSString *fileName = [filePath lastPathComponent];//取得文件名
//        
//        if ([fileName hasPrefix:@"preview_resmap_data"] && [fileName hasSuffix:@".js"]) {
//            
//            NSString *souPath = [pdataPath stringByAppendingPathComponent:fileName];
//            
//            if ([cache checkFileExists:souPath]) {
//                
//                BOOL success = [cache deleteFilePath:souPath];
//                
//            }
//        }
//    }
//}
//
////清除upload_descdata缓存文件
//- (void)deleteUploadDescdataJS
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    YCacheUtil *cache = [YCacheUtil CacheUtil];
//    NSString *pdataPath = [DOCUMENT_PATH stringByAppendingPathComponent:PDATA_PATH];
//    NSArray *fileLists = [fileManager contentsOfDirectoryAtPath:pdataPath error:nil];
//    for(NSString *filePath in fileLists){
//        
//        //        DLog(@"filePath is %@", filePath);
//        NSString *fileName = [filePath lastPathComponent];//取得文件名
//        
//        if ([fileName hasPrefix:@"upload_descdata"] && [fileName hasSuffix:@".js"]) {
//            
//            NSString *souPath = [pdataPath stringByAppendingPathComponent:fileName];
//            
//            if ([cache checkFileExists:souPath]) {
//                
//                BOOL success = [cache deleteFilePath:souPath];
//                
//            }
//        }
//    }
//}
//
////清除upload_data缓存文件
//- (void)deleteUploadDataJS
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    YCacheUtil *cache = [YCacheUtil CacheUtil];
//    NSString *pdataPath = [DOCUMENT_PATH stringByAppendingPathComponent:PDATA_PATH];
//    NSArray *fileLists = [fileManager contentsOfDirectoryAtPath:pdataPath error:nil];
//    for(NSString *filePath in fileLists){
//        
//        //        DLog(@"filePath is %@", filePath);
//        NSString *fileName = [filePath lastPathComponent];//取得文件名
//        
//        if ([fileName hasPrefix:@"upload_data"] && [fileName hasSuffix:@".js"]) {
//            
//            NSString *souPath = [pdataPath stringByAppendingPathComponent:fileName];
//            
//            if ([cache checkFileExists:souPath]) {
//                
//                BOOL success = [cache deleteFilePath:souPath];
//                
//            }
//        }
//    }
//}
//
//
////根据id返回图片路径
//- (NSString *)getfilePathWith:(NSInteger)pId
//{
//    NSString *path;
//    for (NSDictionary *dic in self.tempPicArray) {
//        if (pId == [[dic objectForKey:@"photoid"] integerValue]) {
//            path = [[DOCUMENT_PATH stringByAppendingPathComponent:PDATA_PATH] stringByAppendingPathComponent:[dic objectForKey:@"name"]];
//            break;
//        }
//    }
//    return path;
//}
////根据id返回图片的name
//- (NSString *)getImageNameWith:(int)pId
//{
//    NSString *imageName;
//    for (NSDictionary *dic in self.tempPicArray) {
//        if (pId == [[dic objectForKey:@"photoid"] integerValue]) {
//            imageName = [dic objectForKey:@"name"];
//            break;
//        }
//    }
//    return imageName;
//}
//
////根据id拷贝照片到指定目录
//- (void)copyPhotoId:(int)photoId ToPath:(NSString *)path
//{
//    NSString *name = [self getImageNameWith:photoId];
//    path = [path stringByAppendingPathComponent:name];
//    
//    NSDictionary *prePic = @{@"imagePath":path, @"photoId": @(photoId)};
//    [self.previewPicArray addObject:prePic];
//    
//    NSString *imagePath = [self getfilePathWith:photoId];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:imagePath]) {
//        NSError *error = nil;
//        [fileManager copyItemAtPath:imagePath toPath:[DOCUMENT_PATH stringByAppendingPathComponent:path] error:&error];
//        
//        if (error) {
////            DLog(@"拷贝图片失败 id is %d, %@", photoId, name);
//        }
//    }
//}
////获取previewjs中的字体id
//- (NSArray *)getFontIdsFromPreviewJS
//{
//    NSMutableArray *array = [NSMutableArray array];
//    NSArray *fonts = [self.previewJSDic objectForKey:@"fonts"];
//    for (NSDictionary *font in fonts) {
//        [array addObject:[font objectForKey:@"id"]];
//    }
//    return array;
//}
//
////将upload_data.js写在upload文件夹
//- (void)writeUpload_data_jsToUploadWith:(NSDictionary *)Dics
//{
//    [self deleteUploadDataJS];
//    
//    /*
//     @"audios":@[musicDic],
//     @"dynamic_elements":chartlets,
//     @"custom_audios":recorder,
//     @"fonts":fonts
//     */
//    
//    NSArray *allkeys = [self.previewJSDic allKeys];
//    
//    for (NSString *keyDic in allkeys) {
//        if ([keyDic isEqualToString:@"audios"]) {
//            [self.uploadDataJSDic setObject:[Dics objectForKey:@"audios"] forKey:keyDic];
//            continue;
//        }
//        
//        if ([keyDic isEqualToString:@"photos"]) {
//            NSMutableArray *newPhotos = [[NSMutableArray alloc] init];
//            NSMutableArray *photos = [self.previewJSDic objectForKey:keyDic];
//            for (NSDictionary *photo in photos) {
//                
//                NSString *photoUrl = [[photo objectForKey:@"lurl"] stringByReplacingOccurrencesOfString:@"./" withString:@"./diy/"];
//                NSDictionary *dic = @{@"photoid":[photo objectForKey:@"photoid"], @"rurl":photoUrl};
//                [newPhotos addObject:dic];
//            }
//            [self.uploadDataJSDic setObject:newPhotos forKey:keyDic];
//            continue;
//        }
//        
//        [self.uploadDataJSDic setObject:[self.previewJSDic objectForKey:keyDic] forKey:keyDic];
//    }
//    
//    NSArray *dicsAllKeys = [Dics allKeys];
//    for (NSString *key in dicsAllKeys) {
//        id value = [Dics objectForKey:key];
//        [self.uploadDataJSDic setObject:value forKey:key];
//    }
//    
////    [self.uploadDataJSDic setObject:[Dics objectForKey:@"dynamic_elements"] forKey:@"dynamic_elements"];
////    if ([[self.uploadDataJSDic objectForKey:@"custom_audios"] count]>0) {
////        [self.uploadDataJSDic setObject:[Dics objectForKey:@"custom_audios"] forKey:@"custom_audios"];
////    }
////    
////    [self.uploadDataJSDic setObject:[Dics objectForKey:@"fonts"] forKey:@"fonts"];
//    
//    NSData *data = [NSJSONSerialization dataWithJSONObject:self.uploadDataJSDic options:NSJSONWritingPrettyPrinted error:nil];
//    
//    NSString *resStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    resStr = [previewHeader stringByAppendingString:resStr];
//    resStr = [resStr stringByAppendingString:previewTailStr];
//    
//    //    NSLog(@"-=-=-resStr %@", resStr);
//    
//    NSString *resdataPath = [DOCUMENT_PATH stringByAppendingPathComponent:[NSString stringWithFormat:UPLOAD_DATA_JS_PATH, TIMESTAMP]];
//    self.uploadDataName = [resdataPath lastPathComponent];
//    [resStr writeToFile:resdataPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    
//    
//}
//
///*
// window.wi_desc_data = {
//	project : {
// title : '',
// headPhoto : '',
//	}
// };
// */
////写upload_descdata_js到本地
//- (void)writeUpload_desdataWith:(NSDictionary *)dic
//{
//    [self deleteUploadDescdataJS];
//    
//    NSDictionary *updataDic = @{@"project": dic};
//    
//    NSData *data = [NSJSONSerialization dataWithJSONObject:updataDic options:NSJSONWritingPrettyPrinted error:nil];
//    
//    NSString *resStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    resStr = [@"window.wi_desc_data = " stringByAppendingString:resStr];
//    resStr = [resStr stringByAppendingString:@";"];
//    
//    //    NSLog(@"-=-=-resStr %@", resStr);
//    
//    NSString *resdataPath = [DOCUMENT_PATH stringByAppendingPathComponent:[NSString stringWithFormat:UPLOAD_DESCDATA_JS_PATH, TIMESTAMP]];
//    self.uploadDescdataName = [resdataPath lastPathComponent];
//    [resStr writeToFile:resdataPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    
//}
//
////解压文件
//- (void)UnZipWithPath:(NSString *)souPath toPath:(NSString *)desPath
//{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    dispatch_async(queue, ^{
//        
//        ZipArchive *za = [[ZipArchive alloc] init];
//        if ([za UnzipOpenFile:souPath]) {
//            BOOL ret = [za UnzipFileTo: desPath overWrite: YES];
//            if (NO == ret){} [za UnzipCloseFile];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//            });
//        }
//    });
//}
//
////解压文件block
//- (void)UnZipWithPath:(NSString *)souPath toPath:(NSString *)desPath callBack:(void (^)(BOOL))callBack
//{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    dispatch_async(queue, ^{
//        
//        ZipArchive *za = [[ZipArchive alloc] init];
//        if ([za UnzipOpenFile:souPath]) {
//            BOOL ret = [za UnzipFileTo: desPath overWrite: YES];
//            if (NO == ret){} [za UnzipCloseFile];
//            
//            callBack(ret);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//            });
//        }
//    });
//}
//
//- (BOOL)isExistFileInOriginal:(NSString *)fileName
//{
//    NSString *pdataPath = [DOCUMENT_PATH stringByAppendingPathComponent:PDATA_PATH];
//    NSString *originalPath = [pdataPath stringByAppendingPathComponent:@"original"];
//    
//    NSString *filePath = [originalPath stringByAppendingPathComponent:fileName];
//    if ([[YCacheUtil CacheUtil] checkFileExists:filePath]) {
//        return YES;
//    }
//    return NO;
//}
//
////滤镜相关
//- (void)imageFilterOperationCallBack:(void (^)(BOOL))callBack
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    NSString *pdataPath = [DOCUMENT_PATH stringByAppendingPathComponent:PDATA_PATH];
//    NSString *originalPath = [pdataPath stringByAppendingPathComponent:@"original"];
//    YCacheUtil *cache = [YCacheUtil CacheUtil];
//    BOOL exist = [cache checkFolderExists:originalPath];
//    if (exist) {
//        
//        callBack(YES);
//    }else{
//        BOOL isCreate = [cache createFolderPath:originalPath];
//        if (isCreate) {
//            NSArray *fileList = [fileManager contentsOfDirectoryAtPath:pdataPath error:nil];//文件列表
//            for(NSString *filePath in fileList){
//                
//                //        DLog(@"filePath is %@", filePath);
//                NSString *fileName = [filePath lastPathComponent];//取得文件名
//                
//                if ([fileName hasPrefix:@"image"] && [fileName hasSuffix:@".jpeg"]) {
//                    
//                    NSString *souPath = [pdataPath stringByAppendingPathComponent:fileName];
//                    NSString *desPath = [originalPath stringByAppendingPathComponent:fileName];
//                    DLog(@"newPathRemove is %@", fileName);
//                    
////                    [cache copyFilePath:souPath toPath:desPath];
//                    BOOL success = [cache moveFilePath:souPath toPath:desPath];
//                    DLog(@"13213");
//                }
//            }
//        }
//        callBack(YES);
//    }
////    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//}
//
//- (void)setFilterImage:(ImageFilterType)imageFilter
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
////    YCacheUtil *cache = [YCacheUtil CacheUtil];
//    
//    NSString *pdataPath = [DOCUMENT_PATH stringByAppendingPathComponent:PDATA_PATH];
//    NSString *originalPath = [pdataPath stringByAppendingPathComponent:@"original"];
//
//    NSMutableArray *imageNames = [[NSMutableArray alloc] init];
//    
//    NSMutableArray *OriPhotos = self.originalAry;
//    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:originalPath error:nil];//文件列表
//    
//    for (NSDictionary *imageDic in OriPhotos) {
//        NSString *imageName = [imageDic objectForKey:@"name"];
//        
//        for(NSString *filePath in fileList){
//            
//            //        DLog(@"filePath is %@", filePath);
//            NSString *fileName = [filePath lastPathComponent];//取得文件名
//            
//            if ([fileName hasPrefix:@"image"] && [fileName hasSuffix:@".jpeg"] && [fileName isEqualToString:imageName]  ) {
//                
//                //            NSString *desPath = [pdataPath stringByAppendingPathComponent:fileName];
//                NSString *desPath = [pdataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image-%lf.jpeg", TIMESTAMP]];
//                NSString *souPath = [originalPath stringByAppendingPathComponent:fileName];
//                
//                UIImage *souImage = [UIImage imageWithContentsOfFile:souPath];
//                UIImage *operateImage = nil;
//                
//                switch (imageFilter) {
//                    case FilterOriginal://原图
//                    {
//                        operateImage = souImage;
//                    }
//                        break;
//                    case FilterFresh://清新
//                    {
//                        operateImage = [self getFreshImage:souImage];
//                    }
//                        break;
//                    case FilterMonochrome://黑白
//                    {
//                        operateImage = [self getMonochromeImage:souImage];
//                    }
//                        break;
//                    case FilterWarm://暖暖
//                    {
//                        operateImage = [self getWarmImage:souImage];
//                    }
//                        break;
//                    case FilterDHR://DHR
//                    {
//                        operateImage = [self getDHRImage:souImage];
//                    }
//                        break;
//                    case FilterFilm://胶片
//                    {
//                        operateImage = [self getFilmImage:souImage];
//                    }
//                        break;
//                    case FilterElegant://淡雅
//                    {
//                        operateImage = [self getElegantImage:souImage];
//                    }
//                        break;
//                    
//                    default:
//                        break;
//                }
//                
//                NSData *souData = UIImageJPEGRepresentation(operateImage, 1.0);
//                [souData writeToFile:desPath atomically:YES];
//                
//                [imageNames addObject:[desPath lastPathComponent]];
//                
//            }
//        }
//
//        
//    }
//    
//    [self deleteTempPic];
//    
//    [self setOriginalPhotos:imageNames];
//    
//    [self writeResdataToLocal];
//    
//    [self saveTempPic];
//}
//
////清新
//- (UIImage *)getFreshImage:(UIImage *)souImage
//{
//    ImageFilters *imageFilter = [ImageFilters new];
//    
//    SaturationFilter *filter1 = [SaturationFilter new];
//    filter1.saturation = 1.52;
//    [imageFilter addImageFilter:filter1];
//    
//    BrightnessFilter *filter2 = [BrightnessFilter new];
//    filter2.brightness = 0.81;
//    [imageFilter addImageFilter:filter2];
//    
//    ContrastFilter *filter3 = [ContrastFilter new];
//    filter3.contrast = 0.88;
//    [imageFilter addImageFilter:filter3];
//    
//    ColorBalanceFilter * filter4 = [ColorBalanceFilter new];
//    filter4.red = 0.40;
//    filter4.green = 0.53;
//    filter4.blue = 0.88;
//    [imageFilter addImageFilter:filter4];
//    
//    UIImage *image = [imageFilter processImage:souImage];
//    return image;
//}
////黑白
//- (UIImage *)getMonochromeImage:(UIImage *)souImage
//{
//    ImageFilters *imageFilter = [ImageFilters new];
//    
//    SaturationFilter *filter1 = [SaturationFilter new];
//    filter1.saturation = 0.00;
//    [imageFilter addImageFilter:filter1];
//    
//    BrightnessFilter *filter2 = [BrightnessFilter new];
//    filter2.brightness = 0.66;
//    [imageFilter addImageFilter:filter2];
//    
//    ContrastFilter *filter3 = [ContrastFilter new];
//    filter3.contrast = 1.05;
//    [imageFilter addImageFilter:filter3];
//    
//    ColorBalanceFilter * filter4 = [ColorBalanceFilter new];
//    filter4.red = 1.00;
//    filter4.green = 1.00;
//    filter4.blue = 1.00;
//    [imageFilter addImageFilter:filter4];
//    
//    UIImage *image = [imageFilter processImage:souImage];
//    return image;
//}
////暖暖
//- (UIImage *)getWarmImage:(UIImage *)souImage
//{
//    ImageFilters *imageFilter = [ImageFilters new];
//    
//    SaturationFilter *filter1 = [SaturationFilter new];
//    filter1.saturation = 1.34;
//    [imageFilter addImageFilter:filter1];
//    
//    BrightnessFilter *filter2 = [BrightnessFilter new];
//    filter2.brightness = 0.87;
//    [imageFilter addImageFilter:filter2];
//    
//    ContrastFilter *filter3 = [ContrastFilter new];
//    filter3.contrast = 1.02;
//    [imageFilter addImageFilter:filter3];
//    
//    ColorBalanceFilter * filter4 = [ColorBalanceFilter new];
//    filter4.red = 0.62;
//    filter4.green = 0.52;
//    filter4.blue = 0.11;
//    [imageFilter addImageFilter:filter4];
//    
//    UIImage *image = [imageFilter processImage:souImage];
//    return image;
//}
////DHR
//- (UIImage *)getDHRImage:(UIImage *)souImage
//{
//    ImageFilters *imageFilter = [ImageFilters new];
//    
//    SaturationFilter *filter1 = [SaturationFilter new];
//    filter1.saturation = 0.74;
//    [imageFilter addImageFilter:filter1];
//    
//    BrightnessFilter *filter2 = [BrightnessFilter new];
//    filter2.brightness = 0.68;
//    [imageFilter addImageFilter:filter2];
//    
//    ContrastFilter *filter3 = [ContrastFilter new];
//    filter3.contrast = 1.27;
//    [imageFilter addImageFilter:filter3];
//    
//    ColorBalanceFilter * filter4 = [ColorBalanceFilter new];
//    filter4.red = 0.89;
//    filter4.green = 0.88;
//    filter4.blue = 0.80;
//    [imageFilter addImageFilter:filter4];
//    
////    [imageFilter addImageFilter:[BloomFilter new]];
//    
//    UIImage *image = [imageFilter processImage:souImage];
//    return image;
//}
////怀旧
//- (UIImage *)getReminiscenceImage:(UIImage *)souImage
//{
//    ImageFilters *imageFilter = [ImageFilters new];
//    
//    SaturationFilter *filter1 = [SaturationFilter new];
//    filter1.saturation = 1.13;
//    [imageFilter addImageFilter:filter1];
//    
//    BrightnessFilter *filter2 = [BrightnessFilter new];
//    filter2.brightness = 0.59;
//    [imageFilter addImageFilter:filter2];
//    
//    ContrastFilter *filter3 = [ContrastFilter new];
//    filter3.contrast = 0.92;
//    [imageFilter addImageFilter:filter3];
//    
//    ColorBalanceFilter * filter4 = [ColorBalanceFilter new];
//    filter4.red = 0.69;
//    filter4.green = 0.59;
//    filter4.blue = 0.59;
//    [imageFilter addImageFilter:filter4];
//    
//    UIImage *image = [imageFilter processImage:souImage];
//    return image;
//}
////胶片
//- (UIImage *)getFilmImage:(UIImage *)souImage
//{
//    ImageFilters *imageFilter = [ImageFilters new];
//    
//    SaturationFilter *filter1 = [SaturationFilter new];
//    filter1.saturation = 0.63;
//    [imageFilter addImageFilter:filter1];
//    
//    BrightnessFilter *filter2 = [BrightnessFilter new];
//    filter2.brightness = 0.59;
//    [imageFilter addImageFilter:filter2];
//    
//    ContrastFilter *filter3 = [ContrastFilter new];
//    filter3.contrast = 0.98;
//    [imageFilter addImageFilter:filter3];
//    
//    ColorBalanceFilter * filter4 = [ColorBalanceFilter new];
//    filter4.red = 1.00;
//    filter4.green = 1.00;
//    filter4.blue = 0.68;
//    [imageFilter addImageFilter:filter4];
//    
//    UIImage *image = [imageFilter processImage:souImage];
//    return image;
//}
////蓝调
//- (UIImage *)getBluesImage:(UIImage *)souImage
//{
//    ImageFilters *imageFilter = [ImageFilters new];
//    
//    SaturationFilter *filter1 = [SaturationFilter new];
//    filter1.saturation = 1.12;
//    [imageFilter addImageFilter:filter1];
//    
//    BrightnessFilter *filter2 = [BrightnessFilter new];
//    filter2.brightness = 0.69;
//    [imageFilter addImageFilter:filter2];
//    
//    ContrastFilter *filter3 = [ContrastFilter new];
//    filter3.contrast = 1.38;
//    [imageFilter addImageFilter:filter3];
//    
//    ColorBalanceFilter * filter4 = [ColorBalanceFilter new];
//    filter4.red = 0.60;
//    filter4.green = 0.71;
//    filter4.blue = 1.00;
//    [imageFilter addImageFilter:filter4];
//    
//    UIImage *image = [imageFilter processImage:souImage];
//    return image;
//}
////淡雅
//- (UIImage *)getElegantImage:(UIImage *)souImage
//{
//    ImageFilters *imageFilter = [ImageFilters new];
//    
//    SaturationFilter *filter1 = [SaturationFilter new];
//    filter1.saturation = 1.44;
//    [imageFilter addImageFilter:filter1];
//    
//    BrightnessFilter *filter2 = [BrightnessFilter new];
//    filter2.brightness = 0.70;
//    [imageFilter addImageFilter:filter2];
//    
//    ContrastFilter *filter3 = [ContrastFilter new];
//    filter3.contrast = 0.90;
//    [imageFilter addImageFilter:filter3];
//    
//    ColorBalanceFilter * filter4 = [ColorBalanceFilter new];
//    filter4.red = 0.79;
//    filter4.green = 0.79;
//    filter4.blue = 0.82;
//    [imageFilter addImageFilter:filter4];
//    
//    UIImage *image = [imageFilter processImage:souImage];
//    return image;
//}
//
//#pragma mark - 模板升级相关
//
////加载本地summary.js文件
//- (id)loadLocalSummaryJSWith:(long long)tId
//{
//    YCacheUtil *ca = [YCacheUtil CacheUtil];
//    
//    NSString *summaryPath = [DOCUMENT_PATH stringByAppendingPathComponent:[NSString stringWithFormat:SUMMARY_JS_PATH, tId]];
//    
//    BOOL exist = [ca checkFileExists:summaryPath];
//    
//    if (!exist) {
//        return nil;
//    }
//    
//    NSError *error = nil;
////    NSString *s = [NSString stringWithContentsOfFile:summaryPath encoding:NSUTF8StringEncoding error:&error];
//    
//    NSMutableString *string = [[NSMutableString alloc] initWithContentsOfFile:summaryPath encoding:NSUTF8StringEncoding error:&error];
//    
//    if (!error) {
//        return string;
//    }
//    
//    return nil;
//}
//



@end
