//
//  g5WeatherTypeConditionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5WeatherTypeConditionViewController.h"
#import "g5WeatherTypeConditionTableViewCell.h"

@interface g5WeatherTypeConditionViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSArray *weatherTypes;
@property(nonatomic, strong) NSMutableArray *selectedWeatherTypes;

@property(nonatomic, strong) IBOutlet UITableView *weatherTypeTableView;

@end

@implementation g5WeatherTypeConditionViewController

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.selectedWeatherTypes = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.weatherTypes = [NSArray arrayWithObjects:g5WeatherSunny, g5WeatherPartlyCloudy, g5WeatherCloudy, g5WeatherLightRain, g5WeatherHeavyRain, g5WeatherSeverThunderstorm, nil];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.weatherTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    g5WeatherTypeConditionTableViewCell *cell = [self.weatherTypeTableView dequeueReusableCellWithIdentifier:@"weather_cell"];
    if (!cell) {
        NSBundle *resourcesBundle = [NSBundle mainBundle];
        UINib *tableCell = [UINib nibWithNibName:@"g5WeatherTypeConditionTableViewCell" bundle:resourcesBundle] ;
        [self.weatherTypeTableView registerNib:tableCell forCellReuseIdentifier:@"weather_cell"];
        cell = [self.weatherTypeTableView dequeueReusableCellWithIdentifier:@"weather_cell"];
    }
    
    NSString *weatherTypeForRow = [self.weatherTypes objectAtIndex:indexPath.row];
    cell.weatherConditionType = weatherTypeForRow;
    
    [cell setSelected:[self.selectedWeatherTypes containsObject:weatherTypeForRow]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *weatherTypeForRow = [self.weatherTypes objectAtIndex:indexPath.row];
    [self.selectedWeatherTypes addObject:weatherTypeForRow];
    [self.weatherTypeTableView reloadData];
}

@end