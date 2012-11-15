//
//  MainTableViewController.m
//  Translator
//
//  Created by MASAKO HARADA on 12/07/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainTableViewController.h"

@interface MainTableViewController ()

@end
@implementation MainTableViewController {
    NSArray *homeData;;
    UITableViewCell *cell;
    Data *data;
    int rowIndex;
    int rowNum;
    NSDictionary *obj;
    UIActivityIndicatorView *spinner;
}
@synthesize navigationBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{

    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.title = @"翻訳ニュース";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationController.navigationBarHidden = NO;
       UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"?" style:UIBarButtonItemStylePlain target:self action:@selector(showHelp)];          
       self.navigationItem.rightBarButtonItem = anotherButton;

    rowNum = 10;
    data = [Data shared];
    
    data.delegate = self;
    obj = [NSDictionary dictionary];
    [data setHomeData];
    
    [data addObserver:self forKeyPath:@"isComplete" options:NSKeyValueObservingOptionNew context:nil];
    

    
    // because duplicate indicator, so removed it.
    [[self.view.subviews objectAtIndex:0] removeFromSuperview];


    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.frame = CGRectMake(self.view.frame.size.width/2 - 12,self.view.frame.size.height/2, 24, 24);
        [spinner startAnimating];

        [self.view addSubview:spinner];
    });
    
    
    
}
-(void)showHelp
{
    


    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"" message:@"Swipe your finger  at the video page.\n If you do it , description language is changed.And Please wear on earphone.Because it may not hear sound." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil
     ];
    


    [alert show];

}


// if request failed then error msg.
-(void)renderErrorMsg
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"It happend Network Error.Please try launch this app later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    
    [spinner stopAnimating];
    [spinner setHidesWhenStopped:YES];
    [spinner removeFromSuperview];
    
    
    [alert show];
    
    
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        [data setHomeData];
    }
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isComplete"]){
        
        [self.tableView reloadData];
        
    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [spinner removeFromSuperview];
    
}


- (void)viewDidUnload
{
    [data removeObserver:self forKeyPath:@"isComplete"];

    [self setNavigationBar:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num = [[data homeData] count];
    
    
    [self performSelector:@selector(delayedRender:) withObject:nil  afterDelay:3.0];
    
    
    
    if (data.videoCount > 0){
        num = data.videoCount;
    }
    return num;
}


-(void)delayedRender:(id)sender
{
    NSLog(@"data.homeData is %i",[[data homeData] count]);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 90.0f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                              

    if ([data.homeData count] == 0){
        return cell;
    }else{
        
        [self renderTitleAt:indexPath];
        
    }
    
    // Configure the cell...
    
    return cell;
}


-(void)renderRow:(NSMutableDictionary *)obj at:(int)index
{



    
}



-(void)renderTitleAt:(NSIndexPath *)indexPath
{
    [spinner setHidden:YES];
    int row = indexPath.row ;
    
    cell.textLabel.numberOfLines = 7;

    NSDictionary *item = [data.homeData objectAtIndex:row];

    NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
   [tmp setValue:[item valueForKey:@"id"] forKey:@"id"];
    [tmp setValue:[item valueForKey:@"video_id"] forKey:@"video_id"];
    [data.cache addObject:tmp];
    

    NSString *title = [NSString stringWithFormat:@"%i. %@\n",row + 1,[item valueForKey:@"title"]];
    NSString *published = [NSString stringWithFormat:@"%@",[item valueForKey:@"published"]];
    
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ ",title];

    cell.detailTextLabel.text = [Data formatDate:published];
    [cell.detailTextLabel setTextAlignment:UITextAlignmentCenter];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0]];
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
    
}

-(NSString *)formatDate:(NSString *)published
{
    return [published stringByReplacingCharactersInRange:NSMakeRange(10,[published length] -10) withString:@""];
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (cell.textLabel.text == nil){
        NSLog(@"none");
        return;
    }
    
    int row = indexPath.row;
    
    NSDictionary *tmp = [NSDictionary dictionary];
    
    tmp = [data.homeData objectAtIndex:row];
    

    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    DetailViewController *dvc  = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    dvc.obj = [NSDictionary dictionary];
    dvc.obj = tmp;
    [self presentModalViewController:dvc animated:NO];

}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"called");

}



@end
