//
//  Paint.m
//  ScoreRecord
//
//  Created by MASAKO HARADA on 12/07/12.

//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Paint.h"

@implementation Paint
{
    CAGradientLayer *grad;
}

//CGFloat GREEN_GRAD[] = {0.0, 0.627, 0.01, 1,
//    0.00, 0.369, 0.1, 1.0};


-(id)init
{
    self = [super init];
    grad = [CAGradientLayer layer];
    return self;
    
    
}


-(void)gradWith:(UIView *)target from:(UIColor *)c1 to:(UIColor *)c2
{
    // if grad already exist then remove this. 
    if (grad){ 
        [grad removeFromSuperlayer];
    }
    
    
    grad.frame = target.bounds;
    
    grad.colors = [NSArray arrayWithObjects:
                       (id)c1.CGColor,
                       (id)c2.CGColor,
                       nil];
    [target.layer insertSublayer:grad atIndex:0];
    
}

-(void)gradWith:(UIView *)target by:(NSMutableArray *)colors
{
    if (grad){
        [grad removeFromSuperlayer];
    }
    
    grad.frame = target.bounds;
    
    NSMutableArray *res = [NSMutableArray array];
    for (id color in (NSMutableArray *)colors){
        [res addObject:(id)[color CGColor]];
    }
    
    grad.colors = [NSArray arrayWithArray:res];
    [target.layer insertSublayer:grad atIndex:0];
    
}




@end
