//
//  Visualizer View.h
//  iPodVisualizer
//
//  Created by Mark Klara on 12/19/14.
//  Copyright (c) 2014 Xinrong Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface VisualizerView : UIView

@property (strong, nonatomic) AVAudioPlayer *audioPlayer; //Gives the visualizer access to the audio player

@end
