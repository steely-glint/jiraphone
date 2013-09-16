//
//  JiPFlipsideViewController.h
//  jiraphone
//
//  Created by Tim Panton on 16/09/2013.
//  Copyright (c) 2013 Tim Panton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JiPFlipsideViewController;

@protocol JiPFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(JiPFlipsideViewController *)controller;
@end

@interface JiPFlipsideViewController : UIViewController

@property (assign, nonatomic) id <JiPFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
