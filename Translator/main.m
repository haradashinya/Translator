//
//  main.m
//  Translator
//
//  Created by MASAKO HARADA on 12/07/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [NUISettings loadStylesheet:@"Blue.NUIStyle"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([MainAppDelegate class]));
    }
}
