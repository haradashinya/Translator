//
//  CustomAlertView.m
//  Translator
//
//  Created by MASAKO HARADA on 12/07/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews
{

    for (UIView *subView in self.subviews){
        if ([subView isMemberOfClass:[UIImageView class]]){
            [subView removeFromSuperview];
        }


        if ([subView isMemberOfClass:[UILabel class]]){
            UILabel *label = (UILabel *)subView;
            label.textColor = [UIColor whiteColor];
            
        }
    }
}


-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect activeBounds = self.bounds;
    CGFloat inset = 7.0f;
    CGFloat cornerRadius = 10.0f;
    CGFloat originX = activeBounds.origin.x + inset;
    CGFloat originY = activeBounds.origin.y + inset;
    CGFloat width = activeBounds.size.width - (inset *2.0f);
    CGFloat height = activeBounds.size.height - (inset *2.0f);
    
    CGRect pathFrame = CGRectMake(originX, originY, width, height);
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:cornerRadius].CGPath;
    
    CGContextAddPath(ctx, path);
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6].CGColor);
    
    CGContextSetShadowWithColor(ctx, CGSizeMake(0.0f, 1.0f), 6.0f, [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f].CGColor);
    
    CGContextDrawPath(ctx, kCGPathFill);
    
    CGContextAddPath(ctx,path);
    CGContextClip(ctx);
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	size_t count = 3;
	CGFloat locations[3] = {0.0f, 0.57f, 1.0f}; 
	CGFloat components[12] = 
	{	70.0f/255.0f, 70.0f/255.0f, 70.0f/255.0f, 1.0f,     //1
		55.0f/255.0f, 55.0f/255.0f, 55.0f/255.0f, 1.0f,     //2
		40.0f/255.0f, 40.0f/255.0f, 40.0f/255.0f, 1.0f};	//3
	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, count);
    
	CGPoint startPoint = CGPointMake(activeBounds.size.width * 0.5f, 0.0f);
	CGPoint endPoint = CGPointMake(activeBounds.size.width * 0.5f, activeBounds.size.height);
    
	CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
	CGColorSpaceRelease(colorSpace);
	CGGradientRelease(gradient);
    
    
    
    
    
    
}

@end
