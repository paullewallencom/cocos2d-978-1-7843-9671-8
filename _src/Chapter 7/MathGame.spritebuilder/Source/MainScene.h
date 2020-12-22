#import "Unit.h"

FOUNDATION_EXPORT NSString *const DataHighScores;
FOUNDATION_EXPORT NSString *const DictTotalScore;
FOUNDATION_EXPORT NSString *const DictTurnsSurvived;
FOUNDATION_EXPORT NSString *const DictUnitsKilled;
FOUNDATION_EXPORT NSString *const DictHighScoreIndex;

FOUNDATION_EXPORT NSString *const KeySound;
FOUNDATION_EXPORT NSString *const KeyMusic;

FOUNDATION_EXPORT NSString *const KeyFinishedTutorial;

NS_ENUM(NSInteger, kMoveDirection)
{
	kMoveDirectionUp,
	kMoveDirectionDown,
	kMoveDirectionLeft,
	kMoveDirectionRight
};

@interface MainScene : CCScene
{
	CGSize winSize;
	//the labels used for displaying the game info
	CCLabelBMFont *lblTurnsSurvived, *lblUnitsKilled, *lblTotalScore;
	NSInteger numTurnSurvived, numUnitsKilled, numTotalScore;
	NSMutableArray *arrEnemies, *arrFriendlies;
	
	BOOL isSoundOn;
	
}
+(CCScene*)scene;

+(CGPoint)getPositionForGridCoord:(CGPoint)pos;
-(void)slideAllUnitsWithDistance:(CGFloat)dist withDragDirection:(enum UnitDirection)dir;
+(void)rubberBandToScene:(CCNode*)scene fromParent:(CCNode*)parent withDuration:(CGFloat)duration withDirection:(enum kMoveDirection)direction;

//here:
@property (nonatomic, assign) NSInteger tutorialPhase;
@end
