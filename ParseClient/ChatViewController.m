//
//  ChatViewController.m
//  ParseClient
//
//  Created by Devin Bhushan on 9/16/15.
//  Copyright © 2015 Yahoo. All rights reserved.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "MessageCell.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UIButton *sendButton;
@property(weak, nonatomic) IBOutlet UITextField *composeField;
@property(nonatomic, strong) NSArray *messages;
@property(weak, nonatomic) IBOutlet UITableView *messageTable;

@end

@implementation ChatViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [NSTimer scheduledTimerWithTimeInterval:5
                                   target:self
                                 selector:@selector(onTimer)
                                 userInfo:nil
                                  repeats:YES];
  self.messageTable.delegate = self;
  self.messageTable.dataSource = self;
  // Do any additional setup after loading the view.
}
- (IBAction)sendAction:(id)sender {
  self.sendButton = (UIButton *)sender;
  NSString *composedMessage = self.composeField.text;

  PFObject *newMessage = [PFObject objectWithClassName:@"Message"];
  NSString *objectID = newMessage.objectId;
  NSLog(@"Got object ID: %@", objectID);
  newMessage[@"text"] = composedMessage;
  newMessage[@"user"] = [PFUser currentUser];
  [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
      NSLog(@"Saved message!");
    } else {
      NSLog(@"Failed to save message: %@", [error userInfo][@"error"]);
    }
  }];
  [self.messageTable reloadData];
  self.composeField.text = @"";
}

- (void)onTimer {
  PFQuery *query = [PFQuery queryWithClassName:@"Message"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error) {
    NSLog(@"Got %d messages!", (int)[messages count]);
    self.messages = messages;
  }];
  [self.messageTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.messages count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MessageCell *messageCell = [self.messageTable
      dequeueReusableCellWithIdentifier:@"com.yahoo.messageCell"];
  PFObject *message = self.messages[indexPath.section];
  NSLog(@"Got message: %@", [message objectForKey:@"text"]);
  PFUser *user = [message objectForKey:@"user"];
  [user fetchIfNeeded];
  NSString *text = [message objectForKey:@"text"];
  messageCell.messageText.text =
      [NSString stringWithFormat:@"%@:%@", user.username, text];
  return messageCell;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
