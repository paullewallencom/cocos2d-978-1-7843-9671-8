//
//  ParticleExampleScene.h
//  Ghosts
//
//  Created by Alex Ogorek on 1/18/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCScene.h"

@interface ParticleExampleScene : CCScene
{
	CGSize winSize;
	CGPoint startPosition;
	BOOL isStreaming;
}
+(CCScene*) scene;
@end
