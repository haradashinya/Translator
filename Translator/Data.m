//
//  Data.m
//  Translator
//
//  Created by MASAKO HARADA on 12/07/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Data.h"

@implementation Data
{
    int retryCount;
}
@synthesize url ;
@synthesize homeData ;
@synthesize isComplete;
@synthesize ja;
@synthesize en;
@synthesize video;
@synthesize done;
@synthesize delegate;
@synthesize type = _type;
@synthesize isAlreadyGetData;
@synthesize cache = _cache;
@synthesize videoCount;



-(NSString *)url
{
//    return @"http://www20402ue.sakura.ne.jp:9000/";
    return @"http://floating-ocean-1849.herokuapp.com/";
}


+(id)shared
{
    static Data *data = nil;
    
    if (!data){
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            data.isAlreadyGetData = NO;
            data = [[Data alloc] init];
            data.homeData = [NSMutableArray array];
            data.type = @"ja";
            
            // todo: 非同期処理で行いたい.

            NSSet *tmp = [NSSet setWithArray: [NSKeyedUnarchiver unarchiveObjectWithFile:[[self class] filePath]]];
            
            data.cache = [NSMutableArray array];
            data.cache = [NSMutableArray arrayWithArray:[tmp allObjects]];
            
            
        });
    }
    return data;
        
}

-(NSMutableDictionary *) cachedObjById:(id)obj
{
    int i = [[obj valueForKey:@"id"] intValue];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.id = %@",i];
    return [[self.cache filteredArrayUsingPredicate:predicate] objectAtIndex:0];
}

                                                                        
+(NSString *)filePath
{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [documentDirs objectAtIndex:0];
    return [dir stringByAppendingPathComponent:@"cache.archive"];
}


-(void)setHomeData
{
    // ３０秒以内でデータを取得できなかったら、エラーを表示させる
//    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timerExpired) userInfo:nil repeats:NO];
    
    NSURL *homeURL = [NSURL URLWithString:[[self url] stringByAppendingFormat:@"videos.json"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:homeURL];
    retryCount += 1;
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        int idx = 0;
        
        while(idx < [JSON count]){
            NSDictionary *obj = [JSON objectAtIndex:idx];

            NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
            
            [tmp setValue:[obj valueForKey:@"title"] forKey:@"title"];
            
            [tmp setValue:[obj valueForKey:@"published"] forKey:@"published"];
            
            
            [tmp setValue:[obj valueForKey:@"url"] forKey:@"url"];
            
            [tmp setValue:[obj valueForKey:@"video_id"] forKey:@"video_id"];
            
            // id is used for fetch translate en/ja.
            [tmp setValue:[obj valueForKey:@"_id"] forKey:@"id"];
            
            
//            [self.delegate renderRow:tmp at:idx];
            [self.homeData addObject:tmp];
            
            NSLog(@"self.homeDat is %@",self.homeData);
            
            idx++;
        }
        self.isComplete = @"hello";
        self.isAlreadyGetData = YES;


    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (retryCount < 2){
            [self setHomeData];
        }else{
            [self.delegate renderErrorMsg];
            retryCount = 0;
        }
    }];
    
    [operation start];
}




-(void)timerExpired
{
    if ([self.homeData count] > 0){
        NSLog(@"exist");
    }else{
        [self.delegate renderErrorMsg];
    }

}


+(NSString *)formatDate:(NSString *)published
{
    return [published stringByReplacingCharactersInRange:NSMakeRange(10,[published length] -10) withString:@""];
}



-(void)translateWith:(NSString *) video_id
{
    
    self.video = [[NSMutableDictionary alloc] init ];
    NSURL *tURL  = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json",[self url],video_id]];


    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.id = %@",video_id];
    
    NSDictionary *cacheObj = [NSDictionary dictionary];
    cacheObj  =  [[self.cache filteredArrayUsingPredicate:predicate] objectAtIndex:0] ;


    if (cacheObj  && [cacheObj valueForKey:@"en"]){
         [self.video setValue:[cacheObj valueForKey:@"en"] forKey:@"en"];
         [self.video setValue:[cacheObj valueForKey:@"ja"] forKey:@"ja"];

         self.done = [NSMutableString stringWithFormat:@"don"];
         
         [self.delegate renderDescWhenDataReceived];
        
        return;


    }
    

    
    

    
    NSURLRequest *request = [NSURLRequest requestWithURL:tURL];
    
    
    
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                             
                                             
                                             
                                             [self.video setValue:[JSON valueForKey:@"en"] forKey:@"en"];
                                             [self.video setValue:[JSON valueForKey:@"ja"] forKey:@"ja"];
                                             [self.video setValue:[JSON valueForKey:@"published"] forKey:@"published"];
                                              [self.video setValue:video_id forKey:@"id"];

                                             self.done = [NSMutableString stringWithFormat:@"don"];

                                             
                                             
                                             [self.delegate renderDescWhenDataReceived];
                                             
                                              
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                         }];
    [operation start];

    
}


-(NSString *)toggleDescription
{
    if ([self.type isEqualToString:@"ja"]){
        self.type = @"en";
        return [self ja];
    }else{
        self.type = @"ja";
        return [self en];
    }
    
}

-(NSString *)ja
{
    NSString *str = [[self.video valueForKey:@"ja"] stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n\n"];
    
    return str;
}

-(NSString *)en
{
    NSString *str = [[self.video valueForKey:@"en"] stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n\n"];
    return str;
}




@end
