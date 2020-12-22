#import "Unit.h"

FOUNDATION_EXPORT NSString *const DataHighScores;
FOUNDATION_EXPORT NSString *const DictTotalScore;
FOUNDATION_EXPORT NSString *const DictTurnsSurvived;
FOUNDATION_EXPORT NSString *const DictUnitsKilled;
FOUNDATION_EXPORT NSString *const DictHighScoreIndex;

@interface MainScene : CCScene
{
	CGSize winSize;
	//the labels used for displaying the game info
	CCLabelBMFont *lblTurnsSurvived, *lblUnitsKilled, *lblTotalScore;
	NSInteger numTurnSurvived, numUnitsKilled, numTotalScore;
	NSMutableArray *arrEnemies, *arrFriendlies;
}
+(CCScene*)scene;
+(CGPoint)getPositionForGridCoord:(CGPoint)pos;
@end
