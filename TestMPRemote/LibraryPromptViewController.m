//
//  LibraryPromptViewController.m
//  TestMPRemote
//
//  Created by Rob MacEachern on 2016-08-15.
//  Copyright © 2016 Rob MacEachern. All rights reserved.
//

#import "LibraryPromptViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface LibraryPromptViewController ()

@end

@implementation LibraryPromptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
        NSLog(@"MPMediaLibraryAuthorizationStatus: %zd", status);
    }];
}

@end
