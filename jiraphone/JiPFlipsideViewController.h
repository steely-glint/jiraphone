//
//  JiPFlipsideViewController.h
//  jiraphone
//
//  Created by Tim Panton on 16/09/2013.
//  Copyright (c) 2013 Tim Panton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhonoNative.h"

@class JiPFlipsideViewController;

@protocol JiPFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(JiPFlipsideViewController *)controller;
@end

@interface JiPFlipsideViewController : UIViewController <UIAlertViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate>{
    PhonoNative *phono;
    PhonoPhone *phone;
    PhonoCall *call;
    UIPickerView                *callPicker;
    NSDictionary                     *availableCallees;
}

@property (nonatomic,retain) IBOutlet UILabel *codec;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) id <JiPFlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPickerView *callPicker;
@property (nonatomic, retain) NSDictionary *availableCallees;
- (IBAction)call;
- (IBAction)hangup;
- (IBAction)mute:(id) sender;



- (IBAction)done:(id)sender;
- (IBAction)key:(id)sender;

@end
