//
//  g5WeatherTypeConditionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5WeatherTypeConditionViewController.h"
#import "g5WeatherTypeConditionTableViewCell.h"
#import "MDRWeatherTypeCondition.h"

@interface g5WeatherTypeConditionViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSArray *weatherTypes;
@property(nonatomic, strong) NSMutableArray *selectedWeatherTypes;

@property(nonatomic, strong) IBOutlet UITableView *weatherTypeTableView;

@end

@implementation g5WeatherTypeConditionViewController

#pragma mark - Init

- (instancetype)initWithCondition:(MDRCondition *)condition {
    self = [super initWithCondition:condition];
    if (self != nil) {
        if (condition == nil) {
            self.condition = [[MDRWeatherTypeCondition alloc] init];
        }
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Weather";
    self.navigationItem.hidesBackButton = YES;

    self.weatherTypes = [NSArray arrayWithObjects:g5WeatherSunny, g5WeatherPartlyCloudy, g5WeatherMostlyCloudy, g5WeatherLightRain, g5WeatherHeavyRain, g5WeatherSeverThunderstorm, g5WeatherFoggy, g5WeatherWindy, g5WeatherSnowy, nil];    
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.weatherTypes.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.weatherTypes.count > indexPath.row) {
        g5WeatherTypeConditionTableViewCell *cell = [self.weatherTypeTableView dequeueReusableCellWithIdentifier:@"weather_cell"];
        if (!cell) {
            NSBundle *resourcesBundle = [NSBundle mainBundle];
            UINib *tableCell = [UINib nibWithNibName:@"g5WeatherTypeConditionTableViewCell" bundle:resourcesBundle] ;
            [self.weatherTypeTableView registerNib:tableCell forCellReuseIdentifier:@"weather_cell"];
            cell = [self.weatherTypeTableView dequeueReusableCellWithIdentifier:@"weather_cell"];
        }
        
        NSString *weatherTypeForRow = [self.weatherTypes objectAtIndex:indexPath.row];
        cell.weatherConditionType = weatherTypeForRow;
        
        [cell setSelected:[((MDRWeatherTypeCondition *)self.condition) containsWeatherType:weatherTypeForRow]];

        return cell;
    }
    else {
        UITableViewCell *blankCell = [[UITableViewCell alloc] init];
        blankCell.backgroundColor = [UIColor clearColor];
        blankCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return blankCell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.weatherTypes.count)
        return;
    
    NSString *weatherTypeForRow = [self.weatherTypes objectAtIndex:indexPath.row];
    if ( [((MDRWeatherTypeCondition *)self.condition) containsWeatherType:weatherTypeForRow] ) {
        [((MDRWeatherTypeCondition *)self.condition) removeWeatherType:weatherTypeForRow];
    }
    else {
        [((MDRWeatherTypeCondition *)self.condition) addWeatherType:weatherTypeForRow];
    }
    [self.weatherTypeTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.weatherTypes.count) {
        return 200;
    }
    return 100;
}

@end
