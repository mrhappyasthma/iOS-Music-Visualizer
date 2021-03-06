//
//  ViewController.m
//  iPodVisualizer
//
//  Created by Xinrong Guo on 13-3-23.
//  Copyright (c) 2013年 Xinrong Guo. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController {
    BOOL _isBarHide;
    BOOL _isPlaying;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBars];
    [self configureAudioSession]; //Used to declare our playback (so we don't get muted when in the background)
    
    //Create a visualizer view and add it to the screen
    self.visualizer = [[VisualizerView alloc] initWithFrame:self.view.frame];
    [_visualizer setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_backgroundView addSubview:_visualizer]; //_background view is a view layered behind the audio player view
    
    [self configureAudioPlayer:@"DemoSong" withExtension:@"m4a"]; //Set the default song and prepare playback
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self toggleBars];
}

- (void)configureBars {
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    CGRect frame = self.view.frame;
    
    self.backgroundView = [[UIView alloc] initWithFrame:frame];
    [_backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_backgroundView setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:_backgroundView];
    
    // NavBar
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, -44, frame.size.width, 44)];
    [_navBar setBarStyle:UIBarStyleBlackTranslucent];
    [_navBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    UINavigationItem *navTitleItem = [[UINavigationItem alloc] initWithTitle:@"Music Visualizer"];
    [_navBar pushNavigationItem:navTitleItem animated:NO];
    
    [self.view addSubview:_navBar];
    
    // ToolBar
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 320, frame.size.width, 44)];
    [_toolBar setBarStyle:UIBarStyleBlackTranslucent];
    [_toolBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    UIBarButtonItem *pickBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(pickSong)];
    
    self.playBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playPause)];
    
    self.pauseBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(playPause)];
    
    UIBarButtonItem *leftFlexBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightFlexBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.playItems = [NSArray arrayWithObjects:pickBBI, leftFlexBBI, _playBBI, rightFlexBBI, nil];
    self.pauseItems = [NSArray arrayWithObjects:pickBBI, leftFlexBBI, _pauseBBI, rightFlexBBI, nil];
    
    [_toolBar setItems:_playItems];
    
    [self.view addSubview:_toolBar];
    
    _isBarHide = YES;
    _isPlaying = NO;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    [_backgroundView addGestureRecognizer:tapGR];
}

- (void)toggleBars {
    CGFloat navBarDis = -44;
    CGFloat toolBarDis = 44;
    if (_isBarHide ) {
        navBarDis = -navBarDis;
        toolBarDis = -toolBarDis;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint navBarCenter = _navBar.center;
        navBarCenter.y += navBarDis;
        [_navBar setCenter:navBarCenter];
        
        CGPoint toolBarCenter = _toolBar.center;
        toolBarCenter.y += toolBarDis;
        [_toolBar setCenter:toolBarCenter];
    }];
    
    _isBarHide = !_isBarHide;
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)tapGR {
    [self toggleBars];
}


#pragma mark - Music control

- (void)playPause {
    if (_isPlaying) {
        // Pause audio here
        [_audioPlayer stop];
        [_toolBar setItems:_playItems];  // toggle play/pause button
    }
    else {
        // Play audio here
        [_audioPlayer play];
        [_toolBar setItems:_pauseItems]; // toggle play/pause button
    }
    _isPlaying = !_isPlaying;
}

- (void)playURL:(NSURL *)url {
    if (_isPlaying) {
        [self playPause]; // Pause the previous audio player
    }

    // Add audioPlayer configurations here
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self configureAudioPlayer];
    [self playPause];   // Play 
}

#pragma mark - Media Picker

/*
 * This method is called when the user presses the magnifier button (because this selector was used 
 * to create the button in configureBars, defined earlier in this file). It displays a media picker 
 * screen to the user configured to show only audio files.
 */
- (void)pickSong {
#if TARGET_IPHONE_SIMULATOR
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Media picker doesn't work in the simulator, please run this app on a device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
#else
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    picker.showsCloudItems = NO;
    [picker setDelegate:self];
    [picker setAllowsPickingMultipleItems: NO];
    [self presentViewController:picker animated:YES completion:NULL];
#endif
}

#pragma mark - Media Picker Delegate

/*
 * This method is called when the user chooses something from the media picker screen. It dismisses the media picker screen
 * and plays the selected song.
 */
- (void)mediaPicker:(MPMediaPickerController *) mediaPicker didPickMediaItems:(MPMediaItemCollection *) collection {
  
    // remove the media picker screen
    [self dismissViewControllerAnimated:YES completion:NULL];

    // grab the first selection (media picker is capable of returning more than one selected item,
    // but this app only deals with one song at a time)
    MPMediaItem *item = [[collection items] objectAtIndex:0];
    NSString *title = [item valueForProperty:MPMediaItemPropertyTitle];
    [_navBar.topItem setTitle:title];
  
    // get a URL reference to the selected item
    NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];

    // pass the URL to playURL:, defined earlier in this file
    [self playURL:url];
}

/*
 * This method is called when the user cancels out of the media picker. It just dismisses the media picker screen.
 */
- (void)mediaPickerDidCancel:(MPMediaPickerController *) mediaPicker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//Establish audio session for music playback (as opposed to recording or processing)
-(void)configureAudioSession
{
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    if(error)
    {
        NSLog(@"Error setting category: %@", [error description]);
    }
}

-(void)configureAudioPlayer
{
    [_audioPlayer setNumberOfLoops:-1];
    [_audioPlayer setMeteringEnabled:YES];
    [_visualizer setAudioPlayer:_audioPlayer];
}

-(void)configureAudioPlayer: (NSString *)filename withExtension:(NSString *)extension
{
    NSURL *audioFileURL = [[NSBundle mainBundle] URLForResource:filename withExtension:extension];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL error:&error];
    if (error)
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    [self configureAudioPlayer];
}

@end
