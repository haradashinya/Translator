//
//  Paint.h
//  ScoreRecord
//
//  Created by MASAKO HARADA on 12/07/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface Paint : NSObject
-(void)gradWith:(UIView *)target from:(UIColor *)c1 to:(UIColor *)c2;
-(void)gradWith:(UIView *)target by:(NSMutableArray *)colors;


@end
