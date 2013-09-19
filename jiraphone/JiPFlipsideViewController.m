//
//  JiPFlipsideViewController.m
//  jiraphone
//
//  Created by Tim Panton on 16/09/2013.
//  Copyright (c) 2013 Tim Panton. All rights reserved.
//

#import "JiPFlipsideViewController.h"

@interface JiPFlipsideViewController ()

@end

@implementation JiPFlipsideViewController

- (void) gotjId{
    NSLog(@"Phono session is %@\n",[phono sessionID]);
    //[phono setUseSpeaker:YES];
    
    NSDictionary *cprefs = [phono hiBWPrefs ];
    if (cprefs != nil) {
        [phono setAudio:cprefs]; // or make up your own.
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Do any additional setup after loading the view, typically from a nib.
    phone = [[PhonoPhone alloc] init];

    phone.ringbackTone= [[NSBundle mainBundle] pathForResource:@"ringback-uk" ofType:@"mp3"];
    
    phono = [[PhonoNative alloc] initWithPhone:phone ];
    [phono setGateway:@"jiraconf.westhawk.co.uk"];
    phono.onReady = ^{ [self gotjId];};
    phono.onUnready = ^{ [self gotjId];};
    phono.onError = ^{ NSLog(@"Error callback from phono !?");};
    [phono setApiKey:@"C17D167F-09C6-4E4C-A3DD-2025D48BA243"];

    [phono connect];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}
- (IBAction)key:(id)sender
{
    UISegmentedControl * seg = (UISegmentedControl *) sender;
    NSString *kp = [seg titleForSegmentAtIndex:[seg selectedSegmentIndex]];
    NSLog(@"key pressed %@\n",kp);
    if (call != nil){
        [call digit:kp];
    }
}
- (IBAction)call{
    NSString *user = @"2001";
    NSString *dom = @"app";
    if ([phono sessionID] != nil){
        call = [[[PhonoCall alloc] initOutbound:user domain:dom] retain];
        call.secure = NO;
        call.from = [NSString stringWithString:[phono sessionID]];
        [call setMute:YES];
        [phono.phone dial:call];
    } else {
        NSLog(@"Not connected");
    }
}
- (IBAction)hangup{
    [call hangup];
}
- (IBAction)mute:(id) sender {
    UISwitch *s = (UISwitch *) sender;
    BOOL d = [s isOn];
    NSLog(@"Mute %d",d);

    [call setMute:d];
}
@end
