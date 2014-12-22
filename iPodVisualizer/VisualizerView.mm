//
//  Visualizer View.mm
//  iPodVisualizer
//
//  Created by Mark Klara on 12/19/14.
//  Copyright (c) 2014 Xinrong Guo. All rights reserved.
//

// Note:  This file is taken identically with comments from the Tutorial.
//        For my purposes, I did not worry much about the particle emitter.
//
//        You can read more about the particle emitter here: http://www.raywenderlich.com/6063/uikit-particle-systems-in-ios-5-tutorial

#import "VisualizerView.h"

@implementation VisualizerView {
    CAEmitterLayer *emitterLayer;
    MeterTable meterTable;
}

//Overrides layerClass to return CAEmitterLayer, which allows this view to act as a particle emitter.
+ (Class)layerClass {
    return [CAEmitterLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        emitterLayer = (CAEmitterLayer *)self.layer;
        
        //Shapes the emitter as a rectangle that extends across most of the center of the screen.
        //Particles are initially created within this area.
        CGFloat width = MAX(frame.size.width, frame.size.height);
        CGFloat height = MIN(frame.size.width, frame.size.height);
        emitterLayer.emitterPosition = CGPointMake(width/2, height/2);
        emitterLayer.emitterSize = CGSizeMake(width-80, 60);
        emitterLayer.emitterShape = kCAEmitterLayerRectangle;
        emitterLayer.renderMode = kCAEmitterLayerAdditive;
        
        //Creates a CAEmitterCell that renders particles using particleTexture.png, included in the starter project.
        CAEmitterCell *cell = [CAEmitterCell emitterCell];
        cell.name = @"cell";
        
        //Create children with a short lifetime for every frame refresh (about 1/60 secs)
        CAEmitterCell *childCell = [CAEmitterCell emitterCell];
        childCell.name = @"childCell";
        childCell.lifetime = 1.0f / 60.0f;
        childCell.birthRate = 60.0f;
        childCell.velocity = 0.0f;
        
        childCell.contents = (id)[[UIImage imageNamed:@"particleTexture.png"] CGImage];
        
        cell.emitterCells = @[childCell];
        
        //Sets the particle color, along with a range by which each of the red, green, and blue color components may vary.
        cell.color = [[UIColor colorWithRed:1.0f green:0.53f blue:0.0f alpha:0.8f] CGColor];
        cell.redRange = 0.46f;
        cell.greenRange = 0.49f;
        cell.blueRange = 0.67f;
        cell.alphaRange = 0.55f;
        
        //Sets the speed at which the color components change over the lifetime of the particle.
        cell.redSpeed = 0.11f;
        cell.greenSpeed = 0.07f;
        cell.blueSpeed = -0.25f;
        cell.alphaSpeed = 0.15f;
        
        //Sets the scale and the amount by which the scale can vary for the generated particles.
        cell.scale = 0.5f;
        cell.scaleRange = 0.5f;
        
        //Sets the amount of time each particle will exist to between .75 and 1.25 seconds, and sets it to create 80 particles per second.
        cell.lifetime = 1.0f;
        cell.lifetimeRange = .25f;
        cell.birthRate = 80;
        
        //Configures the emitter to create particles with a variable velocity, and to emit them in any direction.
        cell.velocity = 100.0f;
        cell.velocityRange = 300.0f;
        cell.emissionRange = M_PI * 2;
        
        //Adds the emitter cell to the emitter layer.
        emitterLayer.emitterCells = @[cell];
        
        //Create a display link (updates at the rate of the screen - usually around 1 sec / 60 frames)
        // Note:  This is related to threading.  For the scope of this tutorial, read more elsewhere: https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/Multithreading/RunLoopManagement/RunLoopManagement.html
        CADisplayLink *dpLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        [dpLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)update
{
    //You set scale to a default value of 0.5 and then check to see whether or not _audioPlayer is playing.
    float scale = 0.5;
    
    if (_audioPlayer.playing )
    {
        //If it is playing, you call updateMeters on _audioPlayer, which refreshes the AVAudioPlayer data based on the current audio.
        [_audioPlayer updateMeters];
        
        //Calculate the average decible level (power) over all channels (i.e. stereo = 2)
        float power = 0.0f;
        for (int i = 0; i < [_audioPlayer numberOfChannels]; i++) {
            power += [_audioPlayer averagePowerForChannel:i];
        }
        power /= [_audioPlayer numberOfChannels];
        
        //Calculate the meterTable value and scale it by 5 (to accenuate the scale)
        float level = meterTable.ValueAt(power); //We use meterTable to return a nice value from 0 to 1.  Instead of the complex decible values of -160-0 returned from the encapsulated methods
        scale = level * 5;
    }
    
    //Finally, the scale of the emitter’s particles is set to the new scale value. (If _audioPlayer was not playing, this will be the default scale of 0.5; otherwise, it will be some value based on the current audio levels.
    [emitterLayer setValue:@(scale) forKeyPath:@"emitterCells.cell.emitterCells.childCell.scale"];
}

@end