//
//  g5WeatherTypeConditionTableViewCell.m
//  g5Mindr
//
//  Created by Charles Cliff on 4/17/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5WeatherTypeConditionTableViewCell.h"
#import "g5WeatherManager.h"

@interface g5WeatherTypeConditionTableViewCell ()

@property(nonatomic, strong) IBOutlet UILabel *weatherLabel;
@property(nonatomic, strong) IBOutlet UIImageView *weatherImage;
@property(nonatomic, strong) IBOutlet UIImageView *background;

@end

@implementation g5WeatherTypeConditionTableViewCell

#pragma mark - Setters

- (void)setWeatherConditionType:(NSString *)weatherConditionType {
    NSString *labelText = [self labelTextForWeatherConditionType:weatherConditionType];
    [self.weatherLabel setText:labelText];
    
    UIImage *activeImage = [UIImage imageNamed:weatherConditionType];
    if (activeImage != nil) {
        [self.weatherImage setImage:activeImage];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self.background setHidden:!self.selected];
}

#pragma mark - Helpers

- (NSString *)labelTextForWeatherConditionType:(NSString *)weatherConditionType {
    
    if ( [weatherConditionType isEqualToString:g5WeatherSunny] ) {
        return @"Mostly Sunny";
    }
    else if ( [weatherConditionType isEqualToString:g5WeatherPartlyCloudy] ) {
        return @"Partly Cloudy";
    }
    else if ( [weatherConditionType isEqualToString:g5WeatherCloudy] ) {
        return @"Cloudy";
    }
    else if ( [weatherConditionType isEqualToString:g5WeatherLightRain] ) {
        return @"Light Rain";
    }
    else if ( [weatherConditionType isEqualToString:g5WeatherHeavyRain] ) {
        return @"Heavy Rain";
    }
    else if ( [weatherConditionType isEqualToString:g5WeatherSeverThunderstorm] ) {
        return @"Severe Thunderstorm";
    }
    return nil;
}

@end
