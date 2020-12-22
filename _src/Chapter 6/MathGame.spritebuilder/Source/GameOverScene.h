//
//  GameOverScene.h
//  MathGame
//
//  Created by Alex Ogorek on 12/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCScene.h"

@interface GameOverScene : CCScene <CCTableViewDataSource>
{
	CGSize winSize;
	NSArray *arrScores;
	NSInteger highScoreIndex;
}

+(CCScene*)scene;
+(CCScene*)sceneWithScoreData:(NSDictionary*)dict;
@end
