//
//  SoundPlayer.m
//  halloween
//
//  Created by Andrei Vidrasco on 9/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "SoundPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface SoundPlayer ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation SoundPlayer

+ (instancetype)sharedPlayer {
    static SoundPlayer *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}


- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        NSString *soundName = @"sounds/button_click.mp3";
        if (!soundName) return nil;
        
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundName ofType:nil];
        if (!soundFilePath) return nil;
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        [_audioPlayer prepareToPlay];
    }
    
    return _audioPlayer;

}


- (void)playClick {
    [self.audioPlayer play];
}

@end
