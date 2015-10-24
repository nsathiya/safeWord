//
//  SignInViewController.m
//  safeWord
//
//  Created by Naren Sathiya on 10/24/15.
//  Copyright (c) 2015 Naren Sathiya. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([PFUser currentUser]) {
        NSLog(@"User %@ is signed in", [PFUser currentUser]);
        [self performSegueWithIdentifier:@"goToMap" sender:nil];
    }
    
    self.signInPassword.delegate = self;
    self.signInUsername.delegate = self;
    self.signUpPassword.delegate = self;
    self.signUpEmail.delegate = self;
    self.signUpUsername.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)signInButton:(id)sender {
    
    if([self.signInUsername.text length] == 0) {
        NSLog(@"Please input username");
        return;
    }
    if([self.signInPassword.text length] == 0) {
        NSLog(@"Please input password");
        return;
    }
    
    [PFUser logInWithUsernameInBackground:self.signInUsername.text password:self.signInPassword.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            
                                            NSLog(@"User Logged In");
                                            [self performSegueWithIdentifier:@"goToMap" sender:nil];

                                        } else {
                                            
                                            NSLog(@"User Login failed because %@", error);
                                        }
                                    }];
    }

- (IBAction)signUpButton:(id)sender {
   
    if([self.signUpUsername.text length] == 0) {
        NSLog(@"Please input username");
        return;
    }
    if([self.signUpPassword.text length] == 0) {
        NSLog(@"Please input password");
        return;
    }
    if([self.signUpEmail.text length] == 0) {
        NSLog(@"Please input email");
        return;
    }
    
    
    PFUser *user = [PFUser user];
    user.username = self.signUpUsername.text;
    user.password = self.signUpPassword.text;
    user.email = self.signUpEmail.text;
    user[@"locationHistory"] = [[NSMutableArray alloc] init];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (!error)
         {
             NSLog(@"Signup Success");
             [self performSegueWithIdentifier:@"goToMap" sender:nil];
         }
         else{
             NSLog(@"Signup Error : %@ ", error);
         }
     }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"goToMap"])
    {
        SWMapView *SMV = [segue destinationViewController];
    }
}
@end
