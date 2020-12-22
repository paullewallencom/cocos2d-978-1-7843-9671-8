#import "MainScene.h"
#import "GameScene.h"

@implementation MainScene

+(CCScene*)scene
{
	return [[self alloc] init];
}

-(id)init
{
	if ((self=[super init]))
	{
		winSize = [[CCDirector sharedDirector] viewSize];
		
		CCSprite *bg = [CCSprite spriteWithImageNamed:@"background.png"];
		bg.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:bg];
		
		CCButton *btnPlay = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"btnPlay.png"]];
		[btnPlay setTarget:self selector:@selector(buttonPressed)];
		
		CCButton *btnExtras = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"btnExtras.png"]];
		[btnExtras setTarget:self selector:@selector(buttonPressed)];
		
		CCButton *btnSettings = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"btnSettings.png"]];
		[btnSettings setTarget:self selector:@selector(buttonPressed)];
		
		
		CCLayoutBox *layout = [CCLayoutBox node];
		[layout addChild:btnSettings];
		[layout addChild:btnExtras];
		[layout addChild:btnPlay];
		
		layout.position = ccp(winSize.width/2, winSize.height/2);
		layout.anchorPoint = ccp(0.5,0.5);
		[layout setDirection:CCLayoutBoxDirectionVertical];
		[layout setSpacing:10];
		layout.scale = 2;
		[self addChild:layout];
	}
	return self;
}

-(void)buttonPressed
{
	//nothing here.
}
@end
