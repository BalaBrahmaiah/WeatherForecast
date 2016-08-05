//
//  ViewController.m
//  WeatherForecast
//
//  Created by Bala B. Animeti on 05/08/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cloudImage;

@property(nonatomic, strong) NSDictionary *weatherData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWeatherForecast];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadWeatherForecast{
   // {"_id":1277333,"name":"Bangalore","country":"IN","coord":{"lon":77.603287,"lat":12.97623}}
    NSURL *serviceURL = [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather?q=Bangalore,IN&appid=125b2ea7dd33493e4adca057e64379a1&lang=en-US"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:serviceURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSError *jsonError;
            self.weatherData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            if (!jsonError) {
                [self updateUserInterface];
            }
        }else{
            NSLog(@"Error while loading the Weather Forecats!");
        }
    }];
    [dataTask resume];
}

-(void)updateUserInterface{
    
    NSDictionary *main = self.weatherData[@"main"];
    NSString *temp = [[main valueForKey:@"temp"] stringValue];
    NSString *humidity = [[main valueForKey:@"humidity"] stringValue];
    NSDictionary *weather = self.weatherData[@"weather"][0];
    NSString *desc = [weather valueForKey:@"description"];
    NSDictionary *wind = self.weatherData[@"wind"];
    NSString *name = [NSString stringWithFormat:@"%@", self.weatherData[@"name"]];
    
    dispatch_async(dispatch_get_main_queue()
                   , ^{
                       self.nameLabel.text = name;
                       self.tempLabel.text = [NSString stringWithFormat:@"%@ °C|°F", [temp init]];
                       self.descriptionLabel.text = desc;
                       self.humidityLabel.text = [[NSString stringWithFormat:@"Humidity: %@", humidity] stringByAppendingString:@"%"];
                       self.windLabel.text = [NSString stringWithFormat:@"Wind: %@ km/h",[wind valueForKey:@"speed"]];
                       [self.cloudImage setImage:[UIImage imageNamed:@"little_rain_cloud_2.png"]];
                  });
}


@end
