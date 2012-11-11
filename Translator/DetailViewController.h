//
//  DetailViewController.h
//  Translator
//
//  Created by MASAKO HARADA on 12/07/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSYouTubeView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Data.h"
#import <QuartzCore/QuartzCore.h>
#import "Paint.h"

@interface DetailViewController : UIViewController 
@property (nonatomic,strong) NSDictionary *obj;
@property (weak, nonatomic) IBOutlet UIWebView *videoWebView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)tappedCloseButton:(id)sender;
- (IBAction)tappedJaButton:(id)sender;
- (IBAction)tappedEnButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *jaButton;
@property (weak, nonatomic) IBOutlet UIButton *enButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;


@end
