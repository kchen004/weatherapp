//
//  ViewController.m
//  Weather App
//
//  Created by Kyle Chen on 3/4/17.
//  Copyright © 2017 Kyle Chen. All rights reserved.
//

#import "ViewController.h"

#define QUERY_PREFIX @"http://api.openweathermap.org/data/2.5/weather?" //lat= &lon=
#define FORECAST_PREFIX @"http://api.openweathermap.org/data/2.5/forecast?" //lat= &lon=
#define IMAGE_URL @"https://openweathermap.org/img/w/"
#define API_KEY @"&appid=cec8bfebf5b198853485b049e6074105"

#define UNIT_QUERY @"&units="
#define KEYBOARDS_SIZE 220

@interface ViewController ()

@end

@implementation ViewController

@synthesize weatherIcon;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.locationTextField.delegate = self;
    self.locationTextField.placeholder = @"zip code or city name";
    
    self.myLocationManager = [[CLLocationManager alloc] init];
    [self.myLocationManager requestWhenInUseAuthorization];
    self.location = self.myLocationManager.location;
    
    self.unit = @"metric";
    
    [self loadWeatherData];
    [self displayReport:self.weatherData];
    [self displayImage:self.weatherData];
    
    [self displayForecastReport:self.forecastData];
    [self displayForecastImage:self.forecastData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Use user location
- (IBAction)userOn:(id)sender {
    [self.myLocationManager requestWhenInUseAuthorization];
    self.location = self.myLocationManager.location;
    
    [self loadWeatherData];
    [self displayReport:self.weatherData];
    [self displayImage:self.weatherData];
    [self displayForecastReport:self.forecastData];
    [self displayForecastImage:self.forecastData];
}


-(void) loadWeatherData {
    self.weatherData = [self query:self.location];
    self.forecastData = [self forecastQuery:self.location];
}

//Aquire data using location
- (NSDictionary *) query: (CLLocation *)location {
    NSString *query = [NSString stringWithFormat:@"%@lat=%f&lon=%f%@%@%@", QUERY_PREFIX, location.coordinate.latitude, location.coordinate.longitude,UNIT_QUERY, self.unit, API_KEY];
    
    NSLog (@"%@", query);
    
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] : nil;
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    return results;
}

//Aquire forecast data using location
- (NSDictionary *) forecastQuery: (CLLocation *)location {
    NSString *query = [NSString stringWithFormat:@"%@lat=%f&lon=%f%@%@%@", FORECAST_PREFIX, location.coordinate.latitude, location.coordinate.longitude, UNIT_QUERY, self.unit, API_KEY];
    
    NSLog (@"%@", query);
    
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] : nil;
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    return results;
}


//translate and update textfields
-(void)displayReport:(NSDictionary*)results{
    //translate data
    NSString *temp = [NSString stringWithFormat: @"%g", roundf ([results[@"main"][@"temp"] floatValue])];
    NSString *high = [NSString stringWithFormat: @"%g", roundf ([results[@"main"][@"temp_max"] floatValue])];
    NSString *low = [NSString stringWithFormat: @"%g", roundf ([results[@"main"][@"temp_min"] floatValue])];
    NSString *description = results[@"weather"][0][@"description"];
    NSString *city = results[@"name"];
    NSString *country = results[@"sys"][@"country"];
    NSString *unit = @"C";
    if ([self.unit isEqual: @"imperial"]){
        unit = @"F";
    }
    
    
    NSLog (@"%@", temp);
    NSLog (@"%@", high);
    NSLog (@"%@", low);
    NSLog (@"%@", description);
    NSLog (@"%@", city);
    NSLog (@"%@", country);
    NSLog (@"%@", unit);
    
    //Date conversion
    double unixTimeStamp = [results[@"dt"] doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"hh:mm a MM.dd.yyyy"];
    NSString *stringDate = [formatter stringFromDate:date];
    NSLog (@"%@", date);
    
    
    
    //display data
    self.tempDisplay.text =[NSString stringWithFormat:@"%@°%@",temp, unit];
    self.highlowDisplay.text = [NSString stringWithFormat:@"%@°%@ / %@°%@",high, unit, low, unit];
    self.descriptionDisplay.text = description;
    self.dateDisplay.text = stringDate;
    self.locationDisplay.text = [NSString stringWithFormat:@"%@, %@",city, country];
    
}

//translate and update textfield for forecasts
-(void)displayForecastReport:(NSDictionary*)results{
    //translate data
    
    NSString *unit = @"C";
    if ([self.unit isEqual: @"imperial"]){
        unit = @"F";
    }
    
    NSString *high1 = [NSString stringWithFormat: @"%g", roundf ([results[@"list"][0][@"main"][@"temp_max"] floatValue])];
    NSString *low1 = [NSString stringWithFormat: @"%g", roundf ([results[@"list"][0][@"main"][@"temp_min"] floatValue])];
    NSString *high2 = [NSString stringWithFormat: @"%g", roundf ([results[@"list"][1][@"main"][@"temp_max"] floatValue])];
    NSString *low2 = [NSString stringWithFormat: @"%g", roundf ([results[@"list"][1][@"main"][@"temp_min"] floatValue])];
    NSString *high3 = [NSString stringWithFormat: @"%g", roundf ([results[@"list"][2][@"main"][@"temp_max"] floatValue])];
    NSString *low3 = [NSString stringWithFormat: @"%g", roundf ([results[@"list"][2][@"main"][@"temp_min"] floatValue])];
    NSString *high4 = [NSString stringWithFormat: @"%g", roundf ([results[@"list"][3][@"main"][@"temp_max"] floatValue])];
    NSString *low4 = [NSString stringWithFormat: @"%g", roundf ([results[@"list"][3][@"main"][@"temp_min"] floatValue])];
    NSString *high5 = [NSString stringWithFormat: @"%g", roundf ([results[@"list"][4][@"main"][@"temp_max"] floatValue])];
    NSString *low5 = [NSString stringWithFormat: @"%g", roundf ([results[@"list"][4][@"main"][@"temp_min"] floatValue])];
    
    //Date conversion
    double unixTimeStamp = [results[@"list"][0][@"dt"] doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"ha M/d"];
    NSString *stringDate1 = [formatter stringFromDate:date];
    
    unixTimeStamp = [results[@"list"][1][@"dt"] doubleValue];
    NSLog(@"%@", [NSString stringWithFormat: @"%f",unixTimeStamp]);
    _interval=unixTimeStamp;
    date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSLog(@"%@", [NSString stringWithFormat: @"%@",date]);
    NSString *stringDate2 = [formatter stringFromDate:date];
    NSLog(@"%@", stringDate2);
    
    unixTimeStamp = [results[@"list"][2][@"dt"] doubleValue];
    _interval=unixTimeStamp;
    date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSLog(@"%@", [NSString stringWithFormat: @"%@",date]);
    NSString *stringDate3 = [formatter stringFromDate:date];
    NSLog(@"%@", stringDate3);
    
    unixTimeStamp = [results[@"list"][3][@"dt"] doubleValue];
    _interval=unixTimeStamp;
    date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSLog(@"%@", [NSString stringWithFormat: @"%@",date]);
    NSString *stringDate4 = [formatter stringFromDate:date];
    NSLog(@"%@", stringDate4);
    
    unixTimeStamp = [results[@"list"][4][@"dt"] doubleValue];
    _interval=unixTimeStamp;
    date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSLog(@"%@", [NSString stringWithFormat: @"%@",date]);
    NSString *stringDate5 = [formatter stringFromDate:date];
    NSLog(@"%@", stringDate5);
    
    
    //display data
    self.dateDisplay1.text = stringDate1;
    self.highlowDisplay1.text = [NSString stringWithFormat:@"%@°%@ / %@°%@",high1, unit, low1, unit];
    self.dateDisplay2.text = stringDate2;
    self.highlowDisplay2.text = [NSString stringWithFormat:@"%@°%@ / %@°%@",high2, unit, low2, unit];
    self.dateDisplay3.text = stringDate3;
    self.highlowDisplay3.text = [NSString stringWithFormat:@"%@°%@ / %@°%@",high3, unit, low3, unit];
    self.dateDisplay4.text = stringDate4;
    self.highlowDisplay4.text = [NSString stringWithFormat:@"%@°%@ / %@°%@",high4, unit, low4, unit];
    self.dateDisplay5.text = stringDate5;
    self.highlowDisplay5.text = [NSString stringWithFormat:@"%@°%@ / %@°%@",high5, unit, low5, unit];
}



-(void)displayImage:(NSDictionary*)results{
    //translate data
    NSString *condition = results[@"weather"][0][@"icon"];
    NSLog(@"condition code: %@", condition);
    //display image
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@.png", IMAGE_URL, condition]];
    NSLog(@"%@", url);
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *icon = [UIImage imageWithData:data];
    
    [self.weatherIcon setImage:icon];
}

-(void)displayForecastImage:(NSDictionary*)results{
    //translate data
    NSString *condition1 = results[@"list"][0][@"weather"][0][@"icon"];
    NSString *condition2 = results[@"list"][1][@"weather"][0][@"icon"];
    NSString *condition3 = results[@"list"][2][@"weather"][0][@"icon"];
    NSString *condition4 = results[@"list"][3][@"weather"][0][@"icon"];
    NSString *condition5 = results[@"list"][4][@"weather"][0][@"icon"];
    
    
    //display image
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@.png", IMAGE_URL, condition1]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *icon = [UIImage imageWithData:data];
    [self.weatherIcon1 setImage:icon];
    
    url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@.png", IMAGE_URL, condition2]];
    data = [NSData dataWithContentsOfURL:url];
    icon = [UIImage imageWithData:data];
    [self.weatherIcon2 setImage:icon];
    
    url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@.png", IMAGE_URL, condition3]];
    data = [NSData dataWithContentsOfURL:url];
    icon = [UIImage imageWithData:data];
    [self.weatherIcon3 setImage:icon];
    
    url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@.png", IMAGE_URL, condition4]];
    data = [NSData dataWithContentsOfURL:url];
    icon = [UIImage imageWithData:data];
    [self.weatherIcon4 setImage:icon];
    
    url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@.png", IMAGE_URL, condition5]];
    data = [NSData dataWithContentsOfURL:url];
    icon = [UIImage imageWithData:data];
    [self.weatherIcon5 setImage:icon];
    
}

- (IBAction)unitSwitch:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex == 0){
        self.unit = @"metric";
    }
    else {
        self.unit = @"imperial";
    }
    
    //refesh with new units
    [self loadWeatherData];
    [self displayReport:self.weatherData];
    [self displayForecastReport:self.forecastData];
}


- (IBAction)locationEditingBegin:(id)sender {
    [self.locationTextField becomeFirstResponder];  //enable keyboard
    
    //move view up
    if (self.view.frame.origin.y >= 0){
        NSLog(@"%f", self.view.frame.origin.y);
        [self setViewMovedUp:YES];
    }
}


-(BOOL) textFieldShouldReturn:(UITextField *)locationTextField {
    //search location in locationTextField
    [self searchFrom:self.locationTextField.text];
    [self.locationTextField resignFirstResponder]; //disable keyboard
    if (self.view.frame.origin.y < 0){    //move view back down
        [self setViewMovedUp:NO];
    }
    
    return YES;
}

//disable keyboard when touch screen
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.locationTextField resignFirstResponder];
    if (self.view.frame.origin.y < 0){
        [self setViewMovedUp:NO];
    }
}


//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; //slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // move the view so that the text field that will be hidden come above the keyboard
        rect.origin.y -= KEYBOARDS_SIZE;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += KEYBOARDS_SIZE;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


//Using Geocoder to search the address
-(void) searchFrom:(NSString*) address {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError * error) {
        if (placemarks.count > 0){
            CLPlacemark *placemark = [placemarks firstObject];
            self.location = placemark.location;
            
            //update base on the new found location
            [self loadWeatherData];
            [self displayReport:self.weatherData];
            [self displayImage:self.weatherData];
            [self displayForecastReport:self.forecastData];
            [self displayForecastImage:self.forecastData];
        }
        if (error != NULL) {
            NSLog(@"Error");
            self.locationTextField.text = @"Unable to find or error";
        }
    }];
}




@end

