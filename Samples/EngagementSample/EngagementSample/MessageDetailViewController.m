//
//  MessageDetailViewController.m

//
//  Created on 4/7/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "PubUtils.h"

@interface MessageDetailViewController()

@end

@implementation MessageDetailViewController

#pragma mark - View controller

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // Prepare message content to display on a UIWebView
    NSString *content = [NSString stringWithFormat:@"%@</br></br><hr>CampaignID: %@</br>Title: %@</br>Body: %@</br>Promotion Title: %@</br>Type: %@</br>IsRead: %@</br>MetaData: %@",
                         self.message.promotionBody,
                         self.message.identifier,
                         self.message.alertTitle,
						 self.message.alertBody,
						 self.message.promotionTitle,
                         self.message.campaignType,
                         self.message.isRead?@"YES":@"NO",
                         [self.message.metaData description]];
    
    [self.webView loadHTMLString:content baseURL:nil];
    
    // Check if it needs to send read message
    [self readMessage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Actions

- (IBAction)deleteMessage:(UIBarButtonItem *)sender {
    [self.message remove];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)readMessage {
    [self.message read];
}

@end
