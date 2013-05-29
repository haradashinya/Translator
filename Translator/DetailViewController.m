//
//  DetailViewController.m
//  Translator
//
//  Created by MASAKO HARADA on 12/07/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end


@implementation DetailViewController
{
    NSString *state;
    Data *data;
    CGPoint *startPoint;
    Paint *paint;
    
    PSYouTubeView *youTubeView ;
    UILabel *titleLabel;
    
}
@synthesize jaButton;
@synthesize enButton;
@synthesize closeButton;
@synthesize obj;
@synthesize videoWebView;
@synthesize textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self renderTitleOfVideo];
    

    [jaButton setHidden:YES];
    [enButton setHidden:YES];
    self.textView.editable = NO;
    
    self.closeButton.layer.cornerRadius = 15.0f;
    self.closeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.closeButton.layer.borderWidth = 3.0f;
    [self.closeButton setBackgroundColor:[UIColor blackColor]];
    
    
    [self.textView setBackgroundColor:[UIColor clearColor]];
    data = [Data shared];
    data.delegate = self;
    data.done = nil;
    
    [self renderVideo];

    [data translateWith:[self.obj valueForKey:@"id"]];
    
    
    UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftGesture:)];  
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;  
    [self.view addGestureRecognizer:swipeLeftGesture];  
    // 右へスワイプ  
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightGesture:)];  
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;  
    [self.view addGestureRecognizer:swipeRightGesture];  
    
    
    
}
// cache data include id, and ja , en description.
// return uniq  cache by video id
-(NSMutableDictionary *) cachedObj
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.id == %@",[self.obj valueForKey:@"id"]];
    return [[data.cache filteredArrayUsingPredicate:predicate] objectAtIndex:0];
    
}


-(void)renderTitleOfVideo
{
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290,30)];
    titleLabel.layer.opacity = 0.7;
    closeButton.alpha = 0.7;
    
    [titleLabel setBackgroundColor:[UIColor blackColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.tag = 10;
    [titleLabel setText:[NSString stringWithFormat:@"\t %@",[obj valueForKey:@"title"]]];
    [self.view addSubview:titleLabel];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint point = [touch locationInView:self.view];


    if (point.y <= 30){
        [youTubeView.moviePlayerController stop];
        [self dismissModalViewControllerAnimated:NO];
    }

}

-(void)setCacheToDescription
{
    [[self cachedObj] setValue:[data ja] forKey:@"ja"];
    [[self cachedObj] setValue:[data en] forKey:@"en"];
    
}

-(void)renderDescWhenDataReceived
{
    
    [self setCacheToDescription];
    
    [[self cachedObj] setValue:[data ja] forKey:@"ja"];
     
    self.textView.text = [data ja];
}

- (void) handleSwipeLeftGesture:(UISwipeGestureRecognizer *)sender {  
    if (data.video){
        [self.textView setText:[data toggleDescription]];
    }
}  
- (void) handleSwipeRightGesture:(UISwipeGestureRecognizer *)sender {  
    
    if (data.video){
        [self.textView setText:[data toggleDescription]];
    }
}  



-(void)renderVideo
{
    
    NSURL *youtubeURL = [NSURL URLWithString:[obj valueForKey:@"url"]];
    
    
    if (self.view.frame.size.height == 548){
        NSLog(@"lflflflflfflflflfl");
        
    youTubeView = [[PSYouTubeView alloc] initWithYouTubeURL:youtubeURL
                                                      frame:CGRectMake(0,30,320,320)
                   
                                                           showNativeFirst:YES];
    }else{
        
    youTubeView = [[PSYouTubeView alloc] initWithYouTubeURL:youtubeURL
                                                                     frame:CGRectMake(0,30,320,220)
                   
                                                           showNativeFirst:YES];
        
    }
    
    
    youTubeView.layer.opacity =0.0f;
    [PSYouTubeView animateWithDuration:1.0f animations:^{
        youTubeView.layer.opacity = 1.0f;
    }];
    [self.view addSubview:youTubeView];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"done"]){
        self.textView.text = [data ja];
        
    }
}

- (void)viewDidUnload
{

    [self setVideoWebView:nil];
    [self setTextView:nil];
    [self setCloseButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)tappedCloseButton:(id)sender {
    
    [youTubeView.moviePlayerController stop];
    [self dismissModalViewControllerAnimated:NO];

}


@end
