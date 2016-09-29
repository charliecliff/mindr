//
//  g5ConfigAndMacros.h
//  g5Mindr
//
//  Created by Charles Cliff on 6/25/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

// Colors
#define PRIMARY_FILL_COLOR   [UIColor colorWithRed:41.0/255.0 green:204.0/255.0 blue:163.0/255.0 alpha:1]
#define SECONDARY_FILL_COLOR [UIColor colorWithRed:92.0/255.0 green:122.0/255.0 blue:153.0/255.0 alpha:1]
#define DELETE_FILL_COLOR [UIColor colorWithRed:255.0/255.0 green:87.0/255.0 blue:84.0/255.0 alpha:1]
#define PRIMARY_STROKE_COLOR [UIColor colorWithRed:41.0/255.0 green:61.0/255.0 blue:82.0/255.0 alpha:1]

#define GOLD_COLOR [UIColor colorWithRed:255.0/255.0 green:208.0/255.0 blue:89.0/255.0 alpha:1]
#define PERIWINKE_BLUE_COLOR [UIColor colorWithRed:138.0/255.0 green:183.0/255.0 blue:230.0/255.0 alpha:1]
#define SLATE_BLUE_COLOR [UIColor colorWithRed:92.0/255.0 green:122.0/255.0 blue:153.0/255.0 alpha:1]

// Message and Copy
#define CONDITION_TITLE_FOR_DAY_OF_THE_WEEK @"DAY OF THE WEEK";
#define REMINDER_VIEW_CONTROLLER_SOUND @"Select Notification Sound";
#define CONDITION_VIEW_CONTROLLER_NAVIGATION_TITLE_FOR_DAY_OF_THE_WEEK @"DAY";

// Dimensions
#define REMINDERS_VC_ROW_HEIGHT 100

// Images
#define BUTTON_DELETE [UIImage imageNamed:@"button_delete"]
#define BUTTON_BACK [UIImage imageNamed:@"button_back"]
#define BUTTON_NEXT [UIImage imageNamed:@"button_next"]
#define BUTTON_CANCEL [UIImage imageNamed:@"button_cancel"]
#define BUTTON_NEW [UIImage imageNamed:@"button_new"]
#define BUTTON_CHECK [UIImage imageNamed:@"button_check"]

// Sounds
#define SOUND_FAST_ACTION   @"Fast Action"
#define SOUND_RAINDROP      @"Raindrop"
#define SOUND_STAR_FALL     @"Star Fall"
#define SOUND_WONDER        @"Wonder"
#define SOUND_BOUNCE        @"Bounce"
#define SOUND_GREETING      @"Greeting"
#define SOUND_FLOAT         @"Float"
#define SOUND_PING_PONG     @"Ping Pong"
#define SOUND_BELLS         @"Bells"
#define REMINDER_SOUNDS [NSArray arrayWithObjects:SOUND_FAST_ACTION, SOUND_RAINDROP, SOUND_STAR_FALL, SOUND_WONDER, SOUND_BOUNCE, SOUND_GREETING, SOUND_FLOAT, SOUND_PING_PONG, SOUND_BELLS, nil]
