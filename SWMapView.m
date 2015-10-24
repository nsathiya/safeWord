//
//  SWMapView.m
//  
//
//  Created by Naren Sathiya on 10/23/15.
//
//

#import "SWMapView.h"

@interface SWMapView ()

@end

@implementation SWMapView {

    CLLocationManager *locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(!self.updating)
        self.updatingLabel.text = @"";
    /*
    if(![PFUser currentUser])
    {
        NSLog(@"Setting current User");
        
        [PFUser logInWithUsernameInBackground:@"test123" password:@"test"
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                // Do stuff after successful login.
                                                NSLog(@"User Logged In");
                                                
                                            } else {
                                                // The login failed. Check error to see why.
                                                NSLog(@"User Login failed");
                                            }
                                        }];
        
        
    }
     */
    self.greetingsLabel.text = [@"Hello " stringByAppendingString:[PFUser currentUser][@"username"]];
    locationManager = [[CLLocationManager alloc] init];
    self.walk.hidden = YES;
    self.drive.hidden = YES;
    self.cab.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signOut:(id)sender {
    
    NSLog(@"User %@ is signing off", [PFUser currentUser]);
    [PFUser logOut];
    
    // Return to login page
    if (![PFUser currentUser]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void) getCurrentLocation {
    
    NSLog(@"current location is pressed");
   
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    
    [locationManager startUpdatingLocation];
   
}

- (void) saveAndUpdateCurrentLocation {
    
    NSLog(@"Saving current location");
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (self.currentLocation != nil)
    {
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        NSDictionary *locationObject = @{
                                     @"latitude" : [NSNumber numberWithDouble:self.currentLocation.coordinate.latitude],
                                     @"longitude" : [NSNumber numberWithDouble:self.currentLocation.coordinate.longitude],
                                     @"timeTaken" : timeStampObj,
                                     };
    
        if(currentUser[@"locationHistory"] == nil)
        {
    
            NSLog(@"Location History of User %@ is null", currentUser[@"username"]);
        
            NSMutableArray *locationHistory = [[NSMutableArray alloc] init];
            [locationHistory addObject:locationObject];
            currentUser[@"locationHistory"] = locationHistory;
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"User %@ is updated", currentUser[@"username"]);
                } else {
                    NSLog(@"There was an error updating user information: %@", error);
                }
            }];
    
        } else {
        
            NSLog(@"Location History of User %@ is available", currentUser[@"username"]);

            NSMutableArray *locationHistory = currentUser[@"locationHistory"];
            [locationHistory addObject:locationObject];
            currentUser[@"locationHistory"] = locationHistory;
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"User %@ is updated", currentUser[@"username"]);
                } else {
                    NSLog(@"There was an error updating user information: %@", error);
                }
            }];
        }
    } else {
        
        NSLog(@"Location is Null. Please enable location-tracking");
    }
        
}

- (void) resetCurrentLocation {
    
    
    NSLog(@"Resetting current location");
    
    PFUser *currentUser = [PFUser currentUser];
    
    NSMutableArray *locationHistory = [[NSMutableArray alloc] init];
    currentUser[@"locationHistory"] = locationHistory;
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
           
            NSLog(@"User %@ is updated", currentUser[@"username"]);
        
        } else {
            
            NSLog(@"There was an error updating user information: %@", error);
        }
    }];
}

- (IBAction)startUpdating:(id)sender {
    
    if (self.updating == false) {
        
        self.updating = true;
        self.updatingLabel.text = @"Updating";
        self.updatingUIRef = 1;
        [self getCurrentLocation];
        self.uiTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
        

        
    } else {
        
        self.updating = false;
        self.updatingLabel.text = @"";
        self.updatingUIRef = 1;
        [self.uiTimer invalidate];
        [locationManager stopUpdatingLocation];
        [self resetCurrentLocation];
    }
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    self.currentLocation = newLocation;
    
    if (self.currentLocation != nil) {
        self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", self.currentLocation.coordinate.longitude];
        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", self.currentLocation.coordinate.latitude];
    }
    
    //dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        
    [self saveAndUpdateCurrentLocation];
        
        //dispatch_async(dispatch_get_main_queue(), ^(void){
            
            //NSLog(@"UPDATING UI LABEL");
           //self.uiTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
            
            //self.updatingLabel.text = @"";
            
            //self.updatingLabel.text = @"Updating..";
            //self.updatingLabel.text = @"Updating...";
            //self.updatingLabel.text = @"Updating....";
            //self.updatingLabel.text = @"Updating.....";
            //self.updatingLabel.text = @"Updating......";
            //self.updatingLabel.text = @"Updating.";
            
        //});
    //});
    
}
- (void)timerTicked:(NSTimer*)timer {
    
    self.updatingUIRef++;
    
    if((self.updatingUIRef % 6) != 0)
        self.updatingLabel.text= [self.updatingLabel.text stringByAppendingString:@".."];
    else
        self.updatingLabel.text= @"Updating";
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)driveAction:(id)sender {
}

- (IBAction)walkAction:(id)sender {
}

- (IBAction)cabAction:(id)sender {
}
@end
