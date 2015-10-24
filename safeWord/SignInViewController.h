//
//  SignInViewController.h
//  safeWord
//
//  Created by Naren Sathiya on 10/24/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SWMapView.h"

@interface SignInViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *signInUsername;
@property (strong, nonatomic) IBOutlet UITextField *signInPassword;
@property (strong, nonatomic) IBOutlet UITextField *signUpUsername;
@property (strong, nonatomic) IBOutlet UITextField *signUpPassword;
@property (strong, nonatomic) IBOutlet UITextField *signUpEmail;

- (IBAction)signInButton:(id)sender;
- (IBAction)signUpButton:(id)sender;


@end
