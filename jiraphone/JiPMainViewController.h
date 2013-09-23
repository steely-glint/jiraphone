//
//  JiPMainViewController.h
//  jiraphone
//
//  Created by Tim Panton on 16/09/2013.
//  Copyright (c) 2013 Tim Panton. All rights reserved.
//

#import "JiPFlipsideViewController.h"

@interface JiPMainViewController : UIViewController <JiPFlipsideViewControllerDelegate, UIWebViewDelegate>
{
    NSString *me ; // name found in the jira page
}
@property (nonatomic,retain) IBOutlet UIWebView *jira;
@property (nonatomic,retain) NSString  *me;


@end
