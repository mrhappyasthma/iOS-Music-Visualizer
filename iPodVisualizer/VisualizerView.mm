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
#import <QuartzCore/QuartzCore.h>

@implementation VisualizerView {
    CAEmitterLayer *emitterLayer;
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
        cell.contents = (id)[[UIImage imageNamed:@"particleTexture.png"] CGImage];
        
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
    }
    return self;
}

@end