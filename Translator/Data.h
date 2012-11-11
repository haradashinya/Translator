//
//  Data.h
//  Translator
//
//  Created by MASAKO HARADA on 12/07/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "Underscore.h"

@protocol DataDelegate <NSObject>

-(void)renderErrorMsg;
-(void)renderRow:(NSMutableDictionary *)obj at:(int)index;



@optional
-(void)hideSpinner;

@end

@interface Data : NSObject 
@property (nonatomic,strong) NSString* url;
@property (nonatomic,strong) NSMutableArray* homeData;
@property (nonatomic,strong) NSString *isComplete;
@property (nonatomic,strong ) NSString *ja;
@property (nonatomic,strong) NSString *en;
@property (nonatomic,strong) NSMutableDictionary *video;
@property (nonatomic,strong) NSMutableString *done;
@property (nonatomic,strong) id delegate;
@property (nonatomic) NSMutableArray *cache;
@property (nonatomic) NSString *type;
@property BOOL isAlreadyGetData;
@property  int videoCount;


+(NSString *)formatDate:(NSString *)published;

+(id)shared;
-(void)setHomeData;

-(void)translateWith:(NSString *) video_id;





// This method is implemented at DetailViewControllerDelegate
-(void)renderDescWhenDataReceived;

-(NSString *)ja;
-(NSString *)en;
-(NSString *)toggleDescription;
+(NSString *)filePath;

@end
