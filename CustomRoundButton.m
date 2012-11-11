//
//  CustomRoundButton.m
//  Paint
//
//  Created by MASAKO HARADA on 12/07/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomRoundButton.h"



@implementation CustomRoundButton
{
    CGContextRef ctx;
    
    CGFloat w ;
    CGFloat h ;
    CGFloat r ;
    CGGradientRef grad;
}

//    static CGFloat HIGHLIGHTED_GRAD[] = {};
CGFloat GREEN[] = {0.0, 0.8, 0.01, 1,
    0.00, 0.4, 0.1, 1.0};


CGFloat BLUE[] = {0.3,0.8,0.8,1.0,
    0.0,0.4,0.5,1};


CGFloat RED[] = {1.0,0.1,0.1,1.0,
    0.3,0.1,0.1,1};


CGFloat BLACK[] = { 0.0,0.0,0.0,1.0,
                    0.0,0.0,0.0,1.0
};





@synthesize color = _color;


- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        self.titleLabel.textColor = [UIColor whiteColor];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addObserver:self forKeyPath:@"color" options:(NSKeyValueObservingOptionNew) context:ctx];

    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if ([[change valueForKey:@"new"] isEqual:@"green"]){

        
    }
    
//    [self drawRect:CGRectZero];
    
}


-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [super setNeedsDisplay];
    
}

// Example..

// CustomRoundButton *btn = [CustomButton buttonWithType:UIButtonCustom];
// [btn setTitle:@"hello" forState:UIControlStateNormal];
// btn.frame = CGRectMake(0,0,100,100);
// [btn addTarget:self action:@selector(tappedBtn:) forControlEvents:UIControlEventToTouchupInside];


-(void)drawRect:(CGRect)rect
{
    ctx = UIGraphicsGetCurrentContext();

    w = self.bounds.size.width;
    h = self.bounds.size.height;
    r = 0; 
    
    
    CGContextSaveGState(ctx);
    CGContextSetShouldAntialias(ctx, YES);
    CGRect rc = CGRectMake(0, 0, w, h);
    CGContextMoveToPoint(ctx, CGRectGetMinX(rc), CGRectGetMaxY(rc)-r);
    CGContextAddArcToPoint(ctx, CGRectGetMinX(rc), CGRectGetMinY(rc), CGRectGetMidX(rc), CGRectGetMinY(rc), r);
    CGContextAddArcToPoint(ctx, CGRectGetMaxX(rc), CGRectGetMinY(rc), CGRectGetMaxX(rc), CGRectGetMidY(rc), r);
    CGContextAddArcToPoint(ctx, CGRectGetMaxX(rc), CGRectGetMaxY(rc), CGRectGetMidX(rc), CGRectGetMaxY(rc), r);
    CGContextAddArcToPoint(ctx, CGRectGetMinX(rc), CGRectGetMaxY(rc), CGRectGetMinX(rc), CGRectGetMidY(rc), r);
    CGContextClip(ctx);

    
    [self renderColor:self.color];
    
    
}

-(void)renderColor:(NSString *)type
{
    self.color = @"black";
    
    
    CGFloat locations[2] = {0.0 , 1.0};
    size_t num_locations = 2;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // array is [R , G , B, Alpha, R, G , B, Alpha]
    if (self.state && (UIControlStateSelected || UIControlStateHighlighted)) {
    
    } else {
        // normal :r g b a -> r g b a
        
        if ([self.color isEqual:@"green"] || !self.color){
            grad = CGGradientCreateWithColorComponents(colorSpace,GREEN, locations, num_locations);
        }
        
        if ([self.color isEqual:@"blue"] ){
            grad = CGGradientCreateWithColorComponents(colorSpace,BLUE, locations, num_locations);
            
        }
        
        if ([self.color isEqual:@"red"]){
            grad = CGGradientCreateWithColorComponents(colorSpace,RED, locations, num_locations);
        }
        if ([self.color isEqual:@"black"]){
            grad = CGGradientCreateWithColorComponents(colorSpace, BLACK, locations, num_locations);
        }
        
        
    }
    
    CGPoint startPoint = CGPointMake(w/2.0, 0.0);
    CGPoint endPoint = CGPointMake(w/2, h);
    
    CGContextDrawLinearGradient(ctx, grad, startPoint, endPoint, 0);
    CGContextRestoreGState(ctx);
    
    
    CGColorSpaceRelease(colorSpace);
    
}


@end
