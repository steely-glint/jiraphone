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
@synthesize availableCallees, callPicker;
- (void) gotjId{
    NSLog(@"Phono session is %@\n",[phono sessionID]);
    //[phono setUseSpeaker:YES];
    NSString *me = [self.delegate me];
    me = [me stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *jid = [NSString stringWithFormat:@"sip:%@",[phono sessionID]];
    NSString *url = [NSString stringWithFormat:@"https://jiraconf.westhawk.co.uk:8443/prov/plistusers.html?name=%@&jid=%@",me,jid];
    NSLog(@"query is %@\n",url);

    availableCallees = [[NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:url]]retain];
    NSLog(@"available callee count is %d\n",[availableCallees count]);
    [callPicker reloadAllComponents];
    NSDictionary *cprefs = [phono hiBWPrefs ];
    if (cprefs != nil) {
        [phono setAudio:cprefs]; // or make up your own.
    }
}


-(void) popIncommingCallAlert:(PhonoCall *) incall{
    NSLog(@"popIncommingCallAlert ");

    call = incall;
    NSString *erom = [PhonoNative unescapeString:[incall from]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomming Call"
                          
                                                    message:erom
                          
                                                   delegate:self
                          
                                          cancelButtonTitle:@"Ignore"
                          
                                          otherButtonTitles:nil];
    [alert addButtonWithTitle:@"Accept"];
    
    [alert show];
    [alert release];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    phone = [[PhonoPhone alloc] init];
    phone.onIncommingCall = ^(PhonoCall * incall){
        [self popIncommingCallAlert:incall];
    };
    phone.ringTone= [[NSBundle mainBundle] pathForResource:@"ringback-uk" ofType:@"mp3"];
    phone.ringbackTone= [[NSBundle mainBundle] pathForResource:@"ringback-uk" ofType:@"mp3"];
    availableCallees = [[[NSDictionary alloc] init]retain];

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

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 140.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 46.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rows = [availableCallees count];
    return rows;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [ [availableCallees allKeys] objectAtIndex:row];
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
    NSLog(@"key pressed %@\n",kp);;
    if (call != nil){
        [call digit:kp];
    }
}
- (IBAction)call{
    NSInteger off = [callPicker selectedRowInComponent:0];
    NSString *callee = [[availableCallees allValues] objectAtIndex:off];
    NSLog(@"callee is  pressed %@\n",callee);;
    NSArray *bits = [callee componentsSeparatedByString:@":"];
    
    NSString *user = [bits objectAtIndex:1];
    
    NSString *dom = [bits objectAtIndex:0];
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

// delegate actions
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // don't actually care.
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        // ignore
        [call hangup];
    } else if (buttonIndex == 1){
        // accept incomming call
        [call answer];
    }
}

@end
