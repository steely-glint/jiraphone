//
//  JiPMainViewController.m
//  jiraphone
//
//  Created by Tim Panton on 16/09/2013.
//  Copyright (c) 2013 Tim Panton. All rights reserved.
//

#import "JiPMainViewController.h"

@interface JiPMainViewController ()

@end

@implementation JiPMainViewController
@synthesize jira,me;
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLRequest *jiraURL = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://voxeolabs.atlassian.net/plugins/servlet/mobile#myjirahome"]];
    [jira loadRequest:jiraURL];
	// Do any additonal setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(JiPFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *javaScript = @"document.getElementsByClassName('current-user-name')[0].innerHTML";
    me = [[[NSString alloc] initWithString:[webView stringByEvaluatingJavaScriptFromString:javaScript] ] retain];
    NSLog(@"I am %@\n", me);
    
}

@end
