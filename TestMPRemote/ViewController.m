//
//  ViewController.m
//  TestMPRemote
//
//  Created by Rob MacEachern on 2016-08-12.
//  Copyright © 2016 Rob MacEachern. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MPMusicPlayerController.h>
#import <MediaPlayer/MPRemoteCommandCenter.h>
#import <MediaPlayer/MPRemoteCommand.h>

@interface ViewController ()

@property MPMusicPlayerController *musicPlayerController;
@property (strong, nonatomic) IBOutlet UILabel *playbackStateLabel;
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;

@end

@implementation ViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.musicPlayerController = [MPMusicPlayerController applicationMusicPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMusicPlayerControllerPlaybackStateDidChangeNotification:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMusicPlayerControllerVolumeDidChangeNotification:) name:MPMusicPlayerControllerVolumeDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMusicPlayerControllerNowPlayingItemDidChangeNotification:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    [self.musicPlayerController beginGeneratingPlaybackNotifications];
    
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    NSAssert(query.items.count > 0, @"At least one song needs to be in the media library");
    [self.musicPlayerController setQueueWithQuery:query];
    
    [[MPRemoteCommandCenter sharedCommandCenter].nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"nextTrackCommand handler for event %@", event);
        [self.musicPlayerController skipToNextItem];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [MPRemoteCommandCenter sharedCommandCenter].nextTrackCommand.enabled = YES;
    
    [[MPRemoteCommandCenter sharedCommandCenter].previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"previousTrackCommand handler for event %@", event);
        [self.musicPlayerController skipToPreviousItem];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [MPRemoteCommandCenter sharedCommandCenter].previousTrackCommand.enabled = YES;
    
    [[MPRemoteCommandCenter sharedCommandCenter].playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"playCommand handler for event %@", event);
        [self.musicPlayerController play];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [MPRemoteCommandCenter sharedCommandCenter].playCommand.enabled = YES;
    
    
    [[MPRemoteCommandCenter sharedCommandCenter].pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"pauseCommand handler for event %@", event);
        [self.musicPlayerController pause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [MPRemoteCommandCenter sharedCommandCenter].pauseCommand.enabled = YES;
}

- (IBAction)playPauseButtonAction:(UIButton *)sender {
    if (self.musicPlayerController.playbackState == MPMusicPlaybackStatePlaying) {
        [self.musicPlayerController pause];
        [sender setTitle:@"Play" forState:UIControlStateNormal];
    } else if (self.musicPlayerController.playbackState == MPMusicPlaybackStatePaused || self.musicPlayerController.playbackState == MPMusicPlaybackStateStopped) {
        [self.musicPlayerController play];
        [sender setTitle:@"Pause" forState:UIControlStateNormal];
    } else {
        [self.musicPlayerController stop];
        [sender setTitle:@"Play" forState:UIControlStateNormal];
    }
}

// MARK: Notifications

- (void)handleMusicPlayerControllerPlaybackStateDidChangeNotification:(NSNotification*)notification {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, notification);
    switch (self.musicPlayerController.playbackState) {
        case MPMusicPlaybackStateStopped:
            self.playbackStateLabel.text = @"Playback state: Stopped";
            break;
        case MPMusicPlaybackStatePaused:
            self.playbackStateLabel.text = @"Playback state: Paused";
            break;
        case MPMusicPlaybackStatePlaying:
            self.playbackStateLabel.text = @"Playback state: Playing";
            break;
        case MPMusicPlaybackStateInterrupted:
            self.playbackStateLabel.text = @"Playback state: Interrupted";
            break;
        case MPMusicPlaybackStateSeekingForward:
            self.playbackStateLabel.text = @"Playback state: Seeking Forward";
            break;
        case MPMusicPlaybackStateSeekingBackward:
            self.playbackStateLabel.text = @"Playback state: Seeking Backward";
            break;
    }
    
}

- (void)handleMusicPlayerControllerVolumeDidChangeNotification:(NSNotification*)notification {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, notification);
}

- (void)handleMusicPlayerControllerNowPlayingItemDidChangeNotification:(NSNotification*)notification {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, notification);
}

@end
