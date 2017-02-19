//
//  Game.m
//  BallJump
//
//  Created by Dipankar Ghosh on 2/18/17.
//  Copyright © 2017 Dipankar Ghosh. All rights reserved.
//

#import "Game.h"
float up;
float side;
int randomPosition;
int moveplatform;//The platform that I tried to move(platform 3)
int moveplatform2;//The second platform that is moving(platform 5)

BOOL ballmoveleft;
BOOL ballmoveright;
BOOL stopside;

float platformMoveDown;

int scoreNumber;
int highScoreNumber1;
int addedScore;
int levelNumber;
/*
 currently testing with 5 platforms
 */
BOOL platform1Used;
BOOL platform2Used;
BOOL platform3Used;
BOOL platform4Used;
BOOL platform5Used;

@interface Game ()
{
    NSTimer *movement;
}
@property (weak, nonatomic) IBOutlet UIImageView *ball;
@property (weak, nonatomic) IBOutlet UIButton *start;
@property (weak, nonatomic) IBOutlet UIButton *restart;
@property (weak, nonatomic) IBOutlet UIImageView *platform1;
@property (weak, nonatomic) IBOutlet UIImageView *platform2;
@property (weak, nonatomic) IBOutlet UIImageView *platform3;
@property (weak, nonatomic) IBOutlet UIImageView *platform4;
@property (weak, nonatomic) IBOutlet UIImageView *platform5;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *gameOver;
@property (weak, nonatomic) IBOutlet UILabel *finalScore;
@property (weak, nonatomic) IBOutlet UILabel *highScore;
@property (weak, nonatomic) IBOutlet UIButton *exit;
@end

@implementation Game

//variable screenHeight calculates the height of the screen.
-(CGFloat)screenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}
//variable screenWidth calculates the width of the screen.
-(CGFloat)screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}
//method scoring keeps a tab on the score.
-(void)scoring
{
    scoreNumber = scoreNumber + addedScore;
    addedScore -= 1;
    if(addedScore < 0)
    {
        addedScore = 0;
    }
    _score.text = [NSString stringWithFormat:@"%i",scoreNumber];
    // was trying to create levels after a certain score but facing difficulty with the platform
    if(scoreNumber > 100 && scoreNumber < 400)
    {
        levelNumber = 2; // entering the next level.
    }
    if(scoreNumber > 400 && scoreNumber < 700)
    {
        levelNumber = 3;
    }
    if(scoreNumber > 700 && scoreNumber < 1000)
    {
        levelNumber = 4;
     }
    }

/*
 method gameOv this method after the ball goes out of the screen bounds exits and calls restart.hidden = YES
 */
-(void)gameOv
{
    _ball.hidden = YES;
    _score.hidden = YES;
    _gameOver.hidden = YES;
    _exit.hidden = NO;
    _finalScore.hidden = NO;
    _restart.hidden=NO;
    _finalScore.text = [NSString stringWithFormat:@"Final Score",scoreNumber];
    [movement invalidate];
    
    //not working right now,havent added the highscore feature to function.
    if(scoreNumber > highScoreNumber1)
    {
        highScoreNumber1 = scoreNumber;
        [[NSUserDefaults standardUserDefaults]setInteger:highScoreNumber1 forKey:@"highScoreNumber"];
    }
}

/*
 method platform fall this method checks how down the platform is and if the ball's y co - ordinate is greater than particular screen hegiht it adjusts the platform accordingly
 */
    -(void)platformFall
    {
    if(_ball.center.y > self.screenHeight*5/6)
    {
        platformMoveDown = 1;
    }
    else if(_ball.center.y > self.screenHeight*4/6)
    {
        platformMoveDown = 2;
    }
    else if(_ball.center.y > self.screenHeight*3/6)
    {
        platformMoveDown = 4;
    }
    else if(_ball.center.y > self.screenHeight*2/6)
    {
        platformMoveDown = 5;
    }
    else if(_ball.center.y >self.screenHeight*1/6)
    {
        platformMoveDown = 6;
    }
}
/*method touchesEnded this method initialises the variables to YES & NO */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    ballmoveleft = YES;
    ballmoveright = YES;
    stopside = YES;
}

/*
 method to check which side the touch is being carried out whether left or right.
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if(point.x < self.screenWidth/2)
    {
        ballmoveleft = YES;
    }
    else
    {
        ballmoveright = YES;
    }
}

/*
 method platform movement
 */
-(void)platformMovement
{
    /*each platform's center is calculated by CGPointMake(center.x,center.y + platformMoveDown )
     in case of 3rd and 5th paltform I tried to make them move so that it becomes harder for user to jump on th platform
     */
    _platform1.center = CGPointMake(_platform1.center.x, _platform1.center.y + platformMoveDown);
    _platform2.center = CGPointMake(_platform2.center.x, _platform2.center.y + platformMoveDown);
    _platform3.center = CGPointMake(_platform3.center.x + moveplatform, _platform3.center.y+platformMoveDown);
    _platform4.center = CGPointMake(_platform4.center.x, _platform4.center.y + platformMoveDown);
    _platform5.center = CGPointMake(_platform5.center.x + moveplatform2, _platform5.center.y+platformMoveDown);

    CGFloat platWidth = _platform1.frame.size.width;

    /*
     move platform3 & platform 5 which are being moved are being checked.
     */
    if(_platform3.center.x < platWidth/2)
    {
        switch (levelNumber)
        {
            case 1:
                moveplatform = 2;
                break;
            case 2:
                moveplatform = 3;
                break;
            case 3:
                moveplatform = 4;
                break;
            case 4:
                moveplatform = 5;
                break;
            case 5:
                moveplatform = 6;
                break;
            case 6:
                moveplatform = 7;
                break;
            default:
                break;
        }
    }
    if(_platform3.center.x > self.screenWidth-platWidth/2)
    {
        switch (levelNumber)
        {
            case 1:
                moveplatform = -2;
                break;
            case 2:
                moveplatform = -3;
                break;
            case 3:
                moveplatform = -4;
                break;
            case 4:
                moveplatform = -5;
                break;
            case 5:
                moveplatform = -6;
                break;
            case 6:
                moveplatform = -7;
                break;
            default:
                break;
        }
    }
    
    /*platform5 check */
    
    if(_platform5.center.x < platWidth/2)
    {
        
        switch (levelNumber)
        {
            case 1:
                moveplatform2 = 2;
                break;
            case 2:
                moveplatform2 = 3;
                break;
            case 3:
                moveplatform2 = 4;
                break;
            case 4:
                moveplatform2 = 5;
                break;
            case 5:
                moveplatform2 = 6;
                break;
            case 6:
                moveplatform2 = 7;
                break;
            default:
                break;
        }
    }
    if(_platform5.center.x > self.screenWidth-platWidth/2)
    {
        switch (levelNumber)
        {
            case 1:
                moveplatform2 = -2;
                break;
            case 2:
                moveplatform2 = -3;
                break;
            case 3:
                moveplatform2 = -4;
                break;
            case 4:
                moveplatform2 = -5;
                break;
            case 5:
                moveplatform2 = -6;
                break;
            case 6:
                moveplatform2 = -7;
                break;
            default:
                break;
        }
    }
    
    //platformMoveDown this portion is done to make the platforms re initialzed to center and randomly positioning the platofrms everytime,
    // If the platform center > screenheight - platform height/2 then move platform down.
 
    platformMoveDown -= 0.1;
    
    if(platformMoveDown < 0)
    {
        platformMoveDown = 0;
    }

    CGFloat platHeight = _platform1.frame.size.height;
    int platWidthBounds = lrintf(self.screenWidth-platWidth/2);
/*
 platform centers are checked withing screenheight-platform/2
 then randomly positioning the platforms 
 setting the paltforms used as NO
 */
    
    if(_platform1.center.y > self.screenHeight-platHeight/2)
    {
        randomPosition = arc4random() % platWidthBounds; // random position is generated
        randomPosition += (platWidth/2);
        _platform1.center = CGPointMake(randomPosition, -platHeight/2);
        platform1Used = NO;
    }
    if(_platform2.center.y > self.screenHeight-platHeight/2)
    {
        randomPosition = arc4random() % platWidthBounds;
        randomPosition += (platWidth/2);
        _platform2.center = CGPointMake(randomPosition, -platHeight/2);
        platform2Used = NO;
    }
    if(_platform3.center.y > self.screenHeight-platHeight/2)
    {
        randomPosition = arc4random() % platWidthBounds;
        randomPosition += (platWidth/2);
        _platform3.center = CGPointMake(randomPosition, -platHeight/2);
        platform3Used = NO;
    }
    if(_platform4.center.y > self.screenHeight-platHeight/2)
    {
        randomPosition = arc4random() % platWidthBounds;
        randomPosition += (platWidth/2);
        _platform4.center = CGPointMake(randomPosition, -platHeight/2);
        platform4Used = NO;
    }
    if(_platform5.center.y > self.screenHeight-platHeight/2)
    {
        randomPosition = arc4random() % platWidthBounds;
        randomPosition += (platWidth/2);
        _platform5.center = CGPointMake(randomPosition, -platHeight/2);
        platform5Used = NO;
    }
    
    
}

/*
 Method moving is making the ball move left & right and invoking methods bounce & platformFall
 */
-(void)moving
{
    if(_ball.center.y > self.screenHeight)
    {
        [self gameOv];
    }
    
    [self scoring]; // calling method scoring
    
    if(_ball.center.y < 250)
    {
        _ball.center = CGPointMake(_ball.center.x, 250);
    }
    
    [self platformMovement]; // calling platformMovement
    
    /* 
     This ball center part is for each individual paltform should be jumped upon once
     once bounce and selfplatformfall is called then if still platform used == NO then set it to YES & increment the added score value.
     */
    _ball.center = CGPointMake(_ball.center.x + side, _ball.center.y - up);
    if(CGRectIntersectsRect(_ball.frame, _platform1.frame) && up < -2) //using CGRectIntersectRect method
    {
        [self bounce];
        [self platformFall];
        if(platform1Used == NO)
        {
            addedScore = 10;
            platform1Used = YES;
        }
    }
    if (CGRectIntersectsRect(_ball.frame, _platform2.frame) && up < -2)
    {
        [self bounce];
        [self platformFall];
        if(platform2Used == NO)
        {
            addedScore = 5;
            platform2Used = YES;
        }
    }
    if(CGRectIntersectsRect(_ball.frame, _platform3.frame) && up < -2)
    {
        [self bounce];
        [self platformFall];
        if(platform3Used == NO)
        {
            addedScore = 5;
            platform3Used = YES;
        }
    }
    if(CGRectIntersectsRect(_ball.frame, _platform4.frame) && up < -2){
        [self bounce];
        [self platformFall];
        if(platform4Used == NO){
            addedScore = 5;
            platform4Used = YES;
        }
    }
    if(CGRectIntersectsRect(_ball.frame, _platform5.frame) && up < -2)
    {
        [self bounce];
        [self platformFall];
        if(platform5Used == NO)
        {
            addedScore = 5;
            platform5Used = YES;
        }
    }
    
    up -= 0.1;
    
    if(ballmoveleft == YES)
    {
        side -= 0.3;
        if(side < -5)
        {
            side = -5;
        }
    }
    if(ballmoveright == YES)
    {
        side += 0.3;
        if(side > 5)
        {
            side = 5;
        }
    }
    
    if(stopside == YES && side > 0)
    {
        side -= 0.1;
        if(side < 0)
        {
            side = 0;
            stopside = NO;
        }
    }
    if(stopside == YES && side < 0)
    {
        side += 0.1;
        if(side > 0)
        {
            side = 0;
            stopside = NO;
        }
    }
    
    CGFloat ballWidth = _ball.frame.size.width;
    if(_ball.center.x < -ballWidth/2)
    {
        _ball.center = CGPointMake(self.screenWidth+ballWidth/2, _ball.center.y);
    }
    
    if(_ball.center.x > self.screenWidth+ballWidth/2)
    {
        _ball.center = CGPointMake(-ballWidth/2, _ball.center.y);
    }
}

/* Method bounce this functions to make the ball bounce*/
-(void)bounce
{
    _ball.animationImages = [NSArray arrayWithObjects:
                             [UIImage imageNamed:@"ballBounce1.png"],
                             [UIImage imageNamed:@"ballBounce2.png"],
                             [UIImage imageNamed:@"ballBounce1.png"],
                             [UIImage imageNamed:@"ball.png"],nil];
    /*images have been addded to the images.xcassets folder*/
     
    [_ball setAnimationRepeatCount:1];
    _ball.animationDuration = 0.2;
    [_ball startAnimating];
    
    if(_ball.center.y > self.screenHeight*0.75)
    {
        up = 6;
    }
    else if(_ball.center.y > self.screenHeight*0.5)
    {
        up = 5;
    }
    else if(_ball.center.y > self.screenHeight*0.25)
    {
        up = 4;
    }
}

//Main startGame method once IBAction start is called this portion gets invoked.
- (IBAction)startGame:(id)sender
{
    _start.hidden = YES;

    up = -5;
    
    movement =[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(moving) userInfo:nil repeats:YES];
    _platform1.hidden = NO;
    _platform2.hidden = NO;
    _platform3.hidden = NO;
    _platform4.hidden = NO;
    _platform5.hidden = NO;

    CGFloat platWidth = _platform2.frame.size.width;
    int platWidthBounds = lrintf(self.screenWidth-platWidth/2);
    
    /*
     same functionality used in method moveplatform randomly generating the platform postions.
     using the arc4random % plarwidthBounds
     */
    randomPosition = arc4random() % platWidthBounds;
    randomPosition += (platWidth/2);
    _platform2.center = CGPointMake(randomPosition, self.screenHeight*4/5);
    
    randomPosition = arc4random() % platWidthBounds;
    randomPosition += (platWidth/2);
    _platform3.center = CGPointMake(randomPosition, self.screenHeight*3/5);
    
    randomPosition = arc4random() % platWidthBounds;
    randomPosition += (platWidth/2);
    _platform4.center = CGPointMake(randomPosition, self.screenHeight*2/5);
    
    randomPosition = arc4random() % platWidthBounds;
    randomPosition += (platWidth/2);
    _platform5.center = CGPointMake(randomPosition, self.screenHeight*1/5);

    moveplatform = -2;
    moveplatform2 = 2;
}
/*button restart game method is specified here*/
- (IBAction)restartGame:(id)sender
{
  _restart.hidden = YES;
    scoreNumber=0; // setting the score back to 0
    _start.hidden = NO; // pressign start will re initialise the game.
  
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
/*
 Method viewDidLoad initialises all variables. 
 platform visibility and whether they have been used or not.
 */

- (void)viewDidLoad
{
    _gameOver.hidden = YES;
    _finalScore.hidden = YES;
    _highScore.hidden = YES;
    _exit.hidden = YES;
    _platform2.hidden = YES;
    _platform3.hidden = YES;
    _platform4.hidden = YES;
    _platform5.hidden = YES;
     scoreNumber = 0;
     addedScore = 0;
     levelNumber = 1;
     platform1Used = NO;
     platform2Used = NO;
     platform3Used = NO;
     platform4Used = NO;
     platform5Used = NO;
    
    highScoreNumber1 = [[NSUserDefaults standardUserDefaults]integerForKey:@"highScoreNumber"];
    up = 0;
    side = 0;
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

// method speedChange trying to get a slider to work but it's not functioning as expected.
 
/*-(IBAction)speedChange:(id)sender
{
    UISlider *s = (UISlider *)sender;
    // NSLog(@"tilt %f", (float)[s value]);
   // [_gameView setTilt:(float)[s value]];
}
*/



@end
