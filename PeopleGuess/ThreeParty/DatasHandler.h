//
//  ProvincesHandle.h
//  WaSai
//
//  Created by Hasson on 15-1-15.
//  Copyright (c) 2015年 Hasson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class YTemplateModel;

@interface DatasHandler : NSObject

@property (nonatomic, strong) NSArray *provincesArray;//全国省市
//
//@property (nonatomic, strong) NSMutableDictionary *resdataJsDic;//js文件
//
//@property (nonatomic, strong) NSMutableArray *originalAry;//最初始的图片名和id
//
@property (nonatomic, strong) NSMutableArray *tempPicArray;//pdata先缓存图片
//
//@property (nonatomic, strong) NSMutableDictionary *previewJSDic;//previewJS文件
//
//@property (nonatomic, strong) NSMutableArray *previewPicArray;//预览目录下图片信息
//
//@property (nonatomic, strong) NSMutableDictionary *uploadDataJSDic;//上传所用upload_data.js文件
//
//@property (nonatomic, strong) UIImage *backImage;//模板封面图片
//
//@property (nonatomic, assign) NSInteger selectedTempId;
//
////@property (nonatomic, assign) TemplateType templateType;
//
//@property (nonatomic, assign) long long activeId;
//
//@property (nonatomic, strong) NSString *resdataName;
//
//@property (nonatomic, strong) NSString *previewResmapName;
//
//@property (nonatomic, strong) NSString *uploadDescdataName;
//
//@property (nonatomic, strong) NSString *uploadDataName;
//
//@property (nonatomic, assign) BOOL isDidShowMakeVC;//是否已经展示了制作页面
//
//@property (nonatomic, assign) BOOL isOneKeyMake;//是否是一键制作预览
//
//@property (nonatomic, assign) BOOL isSpecifyTakePartInActivity;//是否话题指定模板参与话题
//@property (nonatomic, strong) YTemplateModel *aTemplate;//话题指定的模板
//
//@property (nonatomic, strong) NSDate *startCreateTime;

//经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate2D;

//deviceToken
@property (nonatomic, strong) NSString *deviceToken;

+ (instancetype)defaultProvincesHandle;

//- (NSString *)getProAndCityWith:(NSInteger)proId cityId:(NSInteger)cityId;
//
//- (NSString *)provinceNameWith:(NSInteger)proId;
//
////resdata.js 相关
//- (NSMutableDictionary *)getResdataFromLocal;
////用户添加的照片到js文件
//- (NSMutableArray *)setPhotos:(NSArray *)photos;
////添加键值到resdata
//- (void)setObjectToResdataJs:(id)o key:(NSString *)key;
////替换resdata里面的图片
//- (void)replacePhotoWith:(int)photoId photoName:(NSString *)newName photoId:(int)newId;
////获取当前resdata里保存的图片
//- (NSArray *)getPhotosFromResdata;
//
////preview_resmap_data.js 相关
//- (void)setPreviewResmapData;
////根据需求重写preview_resmap_data.js文件
//- (void)rewritePreviewResmapJS:(NSDictionary *)resdata;
////一键制作预览所需的resmap.js
////- (void)rewritePreviewResmapJSForOneKey:(NSDictionary *)resdata;
////将preview_resmap_data.js 写回本地
//- (void)writePreviewdataToLocal;
//
////添加图片到缓存
//- (int)setPhotosToTemp:(NSString *)photoName;
////添加图片到缓存
//- (int)setPhotoToTemp:(NSString *)photoName;
////重写js文件到本地
//- (void)writeResdataToLocal;
//
////保存缓存图片信息
//- (void)saveTempPic;
////清除缓存图片
//- (void)deleteTempPic;
////清除original图片
//- (void)deleteOriginalImage;
////清除resdata缓存文件
//- (void)deleteTempResdataJS;
////清除preview_resmap_data缓存文件
//- (void)deleteTempPreviewResmapDataJS;
//
////根据id返回图片路径
//- (NSString *)getfilePathWith:(NSInteger)pId;
////根据id返回图片的name
//- (NSString *)getImageNameWith:(int)pId;
//
////根据id拷贝照片到指定目录
//- (void)copyPhotoId:(int)photoId ToPath:(NSString *)path;
////获取previewjs中的字体id
//- (NSArray *)getFontIdsFromPreviewJS;
////将upload_data.js写在upload文件夹
//- (void)writeUpload_data_jsToUploadWith:(NSDictionary *)Dics;
////写upload_descdata_js到本地
//- (void)writeUpload_desdataWith:(NSDictionary *)dic;
//
////解压文件
//- (void)UnZipWithPath:(NSString *)souPath toPath:(NSString *)desPath;
////解压文件block
//- (void)UnZipWithPath:(NSString *)souPath toPath:(NSString *)desPath callBack:(void (^)(BOOL))callBack;
//
////滤镜相关
//- (void)imageFilterOperationCallBack:(void (^)(BOOL))callBack;
////设置滤镜
////- (void)setFilterImage:(ImageFilterType)imageFilter;
//
////加载本地summary.js文件
//- (id)loadLocalSummaryJSWith:(long long)tId;
////json字符串转换成字典
//- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


@end
