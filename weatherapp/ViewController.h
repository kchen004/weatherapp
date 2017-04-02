//
//  ViewController.h
//  Weather App
//
//  Created by Kyle Chen on 3/4/17.
//  Copyright © 2017 Kyle Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate> {
    
}

//@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *myLocationManager;
- (IBAction)userOn:(id)sender;

@property (strong, nonatomic) NSDictionary* weatherData;
@property (strong, nonatomic) NSDictionary* forecastData;

@property (strong, nonatomic) IBOutlet UIImageView *weatherIcon;
- (IBAction)unitSwitch:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *unitSwitcher;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UILabel *tempDisplay;
@property (strong, nonatomic) IBOutlet UILabel *highlowDisplay;
@property (strong, nonatomic) IBOutlet UILabel *descriptionDisplay;
@property (strong, nonatomic) IBOutlet UILabel *dateDisplay;
@property (strong, nonatomic) IBOutlet UILabel *locationDisplay;

- (IBAction)locationEditingBegin:(id)sender;
@property (strong, nonatomic) NSString* unit;
@property (strong, nonatomic) CLLocation* location;

@property (strong, nonatomic) IBOutlet UILabel *dateDisplay1;
@property (strong, nonatomic) IBOutlet UIImageView *weatherIcon1;
@property (strong, nonatomic) IBOutlet UILabel *highlowDisplay1;
@property (strong, nonatomic) IBOutlet UILabel *dateDisplay2;
@property (strong, nonatomic) IBOutlet UIImageView *weatherIcon2;
@property (strong, nonatomic) IBOutlet UILabel *highlowDisplay2;
@property (strong, nonatomic) IBOutlet UILabel *dateDisplay3;
@property (strong, nonatomic) IBOutlet UIImageView *weatherIcon3;
@property (strong, nonatomic) IBOutlet UILabel *highlowDisplay3;
@property (strong, nonatomic) IBOutlet UILabel *dateDisplay4;
@property (strong, nonatomic) IBOutlet UIImageView *weatherIcon4;
@property (strong, nonatomic) IBOutlet UILabel *highlowDisplay4;
@property (strong, nonatomic) IBOutlet UILabel *dateDisplay5;
@property (strong, nonatomic) IBOutlet UIImageView *weatherIcon5;
@property (strong, nonatomic) IBOutlet UILabel *highlowDisplay5;



@end

