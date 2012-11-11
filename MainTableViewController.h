//
//  MainTableViewController.h
//  Translator
//
//  Created by MASAKO HARADA on 12/07/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"
#import "DetailViewController.h"
#import "CustomAlertView.h"

@interface MainTableViewController : UITableViewController <DataDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

@end
