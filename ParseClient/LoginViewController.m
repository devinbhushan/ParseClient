//
//  LoginViewController.m
//  ParseClient
//
//  Created by Devin Bhushan on 9/16/15.
//  Copyright © 2015 Yahoo. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property(strong, nonatomic) IBOutlet UIView *LoginView;
@property(weak, nonatomic) IBOutlet UITextField *usernameField;
@property(weak, nonatomic) IBOutlet UITextField *passwordField;
@property(weak, nonatomic) IBOutlet UITextField *emailField;
@property(weak, nonatomic) IBOutlet UIButton *loginButton;
@property(weak, nonatomic) IBOutlet UIButton *signupButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (IBAction)signupAction:(id)sender {
  self.loginButton = (UIButton *)sender;

  PFUser *user = [PFUser user];

  user.username = self.usernameField.text;
  user.password = self.passwordField.text;
  user.email = self.emailField.text;

  [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
      NSLog(@"Signed up!");
      [self performSegueWithIdentifier:@"com.yahoo.loginSegue" sender:self];
    } else {
      NSString *errorString = [error userInfo][@"error"];
      NSLog(@"Signup failed: %@", errorString);
    }
  }];
}

- (IBAction)loginAction:(id)sender {
  self.signupButton = (UIButton *)sender;

  NSString *username = self.usernameField.text;
  NSString *password = self.passwordField.text;

  [PFUser logInWithUsernameInBackground:username
                               password:password
                                  block:^(PFUser *user, NSError *error) {
                                    if (user) {
                                      NSLog(@"Succesfully logged in!");
                                      [self performSegueWithIdentifier:
                                                @"com.yahoo.loginSegue"
                                                                sender:self];
                                    } else {
                                      NSLog(@"Login failed: %@",
                                            [error userInfo][@"error"]);
                                    }
                                  }];
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
