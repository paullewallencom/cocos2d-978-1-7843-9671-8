//
//  MenuScene.h
//  MathGame
//
//  Created by Alex Ogorek on 12/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface MenuScene : CCScene
{
	CGSize winSize;
	BOOL isSoundOn, isMusicOn;
}
+(CCScene*)scene;
@end
