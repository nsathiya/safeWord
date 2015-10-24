//
//  SWMapView.h
//  
//
//  Created by Naren Sathiya on 10/23/15.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface SWMapView : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;
@property CLLocation *currentLocation;
@property (strong, nonatomic) IBOutlet UILabel *greetingsLabel;
@property (strong, nonatomic) IBOutlet UILabel *updatingLabel;
@property (strong, nonatomic) IBOutlet UIButton *drive;
@property (strong, nonatomic) IBOutlet UIButton *walk;
@property (strong, nonatomic) IBOutlet UIButton *cab;

- (IBAction)driveAction:(id)sender;
- (IBAction)walkAction:(id)sender;
- (IBAction)cabAction:(id)sender;


@property BOOL updating;
@property NSTimer *uiTimer;
@property int updatingUIRef;
@property NSString *ongoingAction;

- (void) getCurrentLocation;
- (void) saveAndUpdateCurrentLocation;
- (void) resetCurrentLocation;

- (IBAction)signOut:(id)sender;
- (IBAction)startUpdating:(id)sender;


@end
