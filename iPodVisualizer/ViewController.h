//
//  ViewController.h
//  iPodVisualizer
//
//  Created by Xinrong Guo on 13-3-23.
//  Copyright (c) 2013年 Xinrong Guo. All rights reserved.
//

#import "VisualizerView.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController <MPMediaPickerControllerDelegate>

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UINavigationBar *navBar;
@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) NSArray *playItems;
@property (strong, nonatomic) NSArray *pauseItems;
@property (strong, nonatomic) UIBarButtonItem *playBBI;
@property (strong, nonatomic) UIBarButtonItem *pauseBBI;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) VisualizerView *visualizer;

@end
