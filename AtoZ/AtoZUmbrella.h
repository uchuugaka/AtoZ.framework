



typedef enum {
	AZMenuN,
	AZMenuS,
	AZMenuE,
	AZMenuW,

	AZMenuPositionCount
}	AZMenuPosition;

extern NSString *const AZMenuPositionName[AZMenuPositionCount];

	// NSLog(@"%@", FormatTypeName[XML]);




typedef enum  {
    AZItemsAsBundleIDs,
    AZItemsAsPaths,
    AZItemsAsNames
}AZItemsViewFormat;


typedef enum
{
	ReadAccess = R_OK,
	WriteAccess = W_OK,
	ExecuteAccess = X_OK,
	PathExists = F_OK
} SandBox;


BOOL isPathAccessible(NSString *path, SandBox mode);

void trackMouse();


	// In a header file
typedef enum {
	JSON = 0,         // explicitly indicate starting index
	XML,
	Atom,
	RSS,

	FormatTypeCount,  // keep track of the enum size automatically
} FormatType;
extern NSString *const FormatTypeName[FormatTypeCount];

	//NSLog(@"%@", FormatTypeName[XML]);


	//	// In a source file
	//NSString *const FormatTypeName[FormatTypeCount] = {
	//	[JSON] = @"JSON",
	//	[XML] = @"XML",
	//	[Atom] = @"Atom",
	//	[RSS] = @"RSS",
	//};


typedef enum {
    IngredientType_text  = 0,
    IngredientType_audio = 1,
    IngredientType_video = 2,
    IngredientType_image = 3
} IngredientType;
	//write a method like this in class:
	//+ (NSString*)typeStringForType:(IngredientType)_type {
	//	NSString *key = [NSString stringWithFormat:@"IngredientType_%i", _type];
	//	return NSLocalizedString(key, nil);
	//}

	//have the strings inside Localizable.strings file:

	///* IngredientType_text */
	//"IngredientType_0" = "Text";
	///* IngredientType_audio */
	//"IngredientType_1" = "Audio";
	///* IngredientType_video */
	//"IngredientType_2" = "Video";
	///* IngredientType_image */
	//"IngredientType_3" = "Image";
	//

typedef enum {
	AZOrientTop = 0,  //explicit
	AZOrientLeft,
	AZOrientBottom,
	AZOrientRight,
	AZOrientGrid,
	AZOrientPerimeter,
	AZOrientFiesta,
	AZOrientVertical,
	AZOrientHorizontal,
	AZOrientCount,
} AZOrient;
extern NSString *const AZOrientName[AZOrientCount];


typedef enum  {
	AZInfiteScale0X,
	AZInfiteScale1X,
	AZInfiteScale2X,
	AZInfiteScale3X,
	AZInfiteScale10X
} AZInfiteScale;


typedef enum  {
    LeftOn,
    LeftOff,
    TopOn,
    TopOff,
	RightOn,
	RightOff,
	BottomOn,
	BottomOff
} AZTrackState;


typedef enum  {
	AZDockSortNatural,
	AZDockSortColor,
	AZDockSortPoint,
	AZDockSortPointNew,
}	AZDockSort;

typedef enum  {
	AZSearchByCategory,
	AZSearchByColor,
	AZSearchByName,
	AZSearchByRecent
} AZSearchBy;


typedef enum {
	AZIn,
	AZOut
} AZSlideState;


#ifndef ATOZTOUCH
typedef enum _AZWindowPosition {
		// The four primary sides are compatible with the preferredEdge of NSDrawer.
    AZPositionLeft          = NSMinXEdge, // 0
    AZPositionRight         = NSMaxXEdge, // 2
    AZPositionTop           = NSMaxYEdge, // 3
    AZPositionBottom        = NSMinYEdge, // 1
    AZPositionLeftTop       = 4,
    AZPositionLeftBottom    = 5,
    AZPositionRightTop      = 6,
    AZPositionRightBottom   = 7,
    AZPositionTopLeft       = 8,
    AZPositionTopRight      = 9,
    AZPositionBottomLeft    = 10,
    AZPositionBottomRight   = 11,
    AZPositionAutomatic     = 12
} AZWindowPosition;



#endif
/*

#import "AtoZ.h"







//  BaseModel.h
//  Version 2.3.1
//  ARC Helper
//  Version 1.3.1

#ifndef AZ_RETAIN
#if __has_feature(objc_arc)
#define AZ_RETAIN(x) (x)
#define AZ_RELEASE(x) (void)(x)
#define AZ_AUTORELEASE(x) (x)
#define AZ_SUPER_DEALLOC (void)(0)
#define __AZ_BRIDGE __bridge
#else
#define __AZ_WEAK
#define AZ_WEAK assign
#define AZ_RETAIN(x) [(x) retain]
#define AZ_RELEASE(x) [(x) release]
#define AZ_AUTORELEASE(x) [(x) autorelease]
#define AZ_SUPER_DEALLOC [super dealloc]
#define __AZ_BRIDGE
#endif
#endif

//  ARC Helper ends




#define AZRelease(value) \
if ( value ) { \
//[value release]; \
value = nil; \
}

#define AZAssign(oldValue,newValue) \
//[ newValue retain ]; \
AZRelease (oldValue); \
oldValue = newValue;



CGFloat DegreesToRadians(CGFloat degrees);
NSNumber* DegreesToNumber(CGFloat degrees);


//extern NSString *const AtoZSuperLayer;
#define AZSuperLayerSuper (@"superlayer")


#define AZConstraint(attr, rel) \
[CAConstraint constraintWithAttribute: attr relativeTo: rel attribute: attr]

//extern NSArray* AZConstraintEdgeExcept(AZCOn attr, rel, scale, off) \
//[NSArray arrayWithArray:@[
//AZConstRelSuper( kCAConstraintMaxX ),
//AZConstRelSuper( kCAConstraintMinX ),
//AZConstRelSuper( kCAConstraintWidth),
//AZConstRelSuper( kCAConstraintMinY ),
//AZConstRelSuperScaleOff(kCAConstraintHeight, .2, 0),

//#define AZConstraint(attr, rel) \
//[CAConstraint constraintWithAttribute: attr relativeTo: rel attribute: attr]

#define AZConst(attr, rel) \
[CAConstraint constraintWithAttribute:attr relativeTo: rel attribute: attr]

#define AZConstScaleOff(attr, rel, scl, off) \
[CAConstraint constraintWithAttribute:attr relativeTo:rel attribute:attr scale:scl offset:off]

#define AZConstRelSuper(attr) \
[CAConstraint constraintWithAttribute:attr relativeTo:AZSuperLayerSuper attribute:attr]

#define AZConstRelSuperScaleOff(attr, scl, off) \
[CAConstraint constraintWithAttribute:attr relativeTo:AZSuperLayerSuper attribute:attr scale:scl offset:off]



//#import "AtoZiTunes.h"

// Sweetness vs. longwindedness

#define $point(A)       	[NSValue valueWithPoint:A]

#define $points(A,B)       	[NSValue valueWithPoint:CGPointMake(A,B)]
#define $rect(A,B,C,D)    	[NSValue valueWithRect:CGRectMake(A,B,C,D)]

#define ptmake(A,B)			CGPointMake(A,B)
#define $(...)        		((NSString *)[NSString stringWithFormat:__VA_ARGS__,nil])
#define $array(...)  		((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])
#define $set(...)    	 	((NSSet *)[NSSet setWithObjects:__VA_ARGS__,nil])
#define $map(...)     		((NSDictionary *)[NSDictionary dictionaryWithObjectsAndKeys:__VA_ARGS__,nil])
#define $int(A)       		[NSNumber numberWithInt:(A)]
#define $ints(...)    		[NSArray arrayWithInts:__VA_ARGS__,NSNotFound]
#define $float(A)     		[NSNumber numberWithFloat:(A)]
#define $doubles(...) 		[NSArray arrayWithDoubles:__VA_ARGS__,MAXFLOAT]
#define $words(...)   		[[@#__VA_ARGS__ splitByComma] trimmedStrings]
#define $concat(A,...) { A = [A arrayByAddingObjectsFromArray:((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])]; }

#define nilease(A) [A release]; A = nil

#define $affectors(A,...) \
+(NSSet *)keyPathsForValuesAffecting##A { \
  static NSSet *re = nil; \
  if (!re) { \
    re = [[[@#__VA_ARGS__ splitByComma] trimmedStrings] set]; \
  } \
  return re;\
}

#define foreach(B,A) A.andExecuteEnumeratorBlock = \
  ^(B, NSUInteger A##Index, BOOL *A##StopBlock) 

//#define foreach(A,B,C) \
//A.andExecuteEnumeratorBlock = \
//  ^(B, NSUInteger C, BOOL *A##StopBlock)

#define SELFBONK @throw \
  [NSException \
  exceptionWithName:@"WriteThisMethod" \
  reason:@"You did not write this method, yet!" \
  userInfo:nil]

#define GENERATE_SINGLETON(SC) \
static SC * SC##_sharedInstance = nil; \
+(SC *)sharedInstance { \
  if (! SC##_sharedInstance) { \
    SC##_sharedInstance = [[SC alloc] init]; \
  } \
  return SC##_sharedInstance; \
}



#define rand() (arc4random() % ((unsigned)RAND_MAX + 1)) 


#define RED				[NSColor colorWithCalibratedRed:0.797 green:0.000 blue:0.043 alpha:1.000]
#define ORANGE			[NSColor colorWithCalibratedRed:0.888 green:0.492 blue:0.000 alpha:1.000]
#define YELLOw			[NSColor colorWithCalibratedRed:0.830 green:0.801 blue:0.277 alpha:1.000]
#define GREEN			[NSColor colorWithCalibratedRed:0.367 green:0.583 blue:0.179 alpha:1.000]
#define BLUE			[NSColor blueColor]
#define BLACK			[NSColor blackColor]
#define GREY			[NSColor grayColor]
#define WHITE			[NSColor whiteColor]
#define RANDOMCOLOR		[NSColor randomColor]
#define CLEAR			[NSColor clearColor]
#define PURPLE 			[NSColor colorWithCalibratedRed:0.317 green:0.125 blue:0.328 alpha:1.000]
#define LGRAY			[NSColor colorWithCalibratedWhite:.33 alpha:1]
#define GRAY1			[NSColor colorWithCalibratedWhite:.1 alpha:1]
#define GRAY2			[NSColor colorWithCalibratedWhite:.2 alpha:1]
#define GRAY3			[NSColor colorWithCalibratedWhite:.3 alpha:1]
#define GRAY4			[NSColor colorWithCalibratedWhite:.4 alpha:1]
#define GRAY5			[NSColor colorWithCalibratedWhite:.5 alpha:1]
#define GRAY6			[NSColor colorWithCalibratedWhite:.6 alpha:1]
#define GRAY7			[NSColor colorWithCalibratedWhite:.7 alpha:1]
#define GRAY8			[NSColor colorWithCalibratedWhite:.8 alpha:1]
#define GRAY9			[NSColor colorWithCalibratedWhite:.9 alpha:1]

#define cgRED			[RED 		CGColor]
#define cgORANGE		[ORANGE 	CGColor]
#define cgYELLOW		[YELLOW		CGColor]
#define cgGREEN			[GREEN		CGColor]
#define cgPURPLE		[PURPLE		CGColor]

#define cgBLUE			[[NSColor blueColor]	CGColor]
#define cgBLACK			[[NSColor blackColor]	CGColor]
#define cgGREY			[[NSColor grayColor]	CGColor]
#define cgWHITE			[[NSColor whiteColor]	CGColor]
#define cgRANDOMCOLOR	[RANDOMCOLOR	CGColor]
#define cgCLEARCOLOR	[[NSColor clearColor]	CGColor]


// random macros utilizing arc4random()

#define RAND_UINT_MAX		0xFFFFFFFF
#define RAND_INT_MAX		0x7FFFFFFF

// RAND_UINT() positive unsigned integer from 0 to RAND_UINT_MAX
// RAND_INT() positive integer from 0 to RAND_INT_MAX
// RAND_INT_VAL(a,b) integer on the interval [a,b] (includes a and b)
#define RAND_UINT()				arc4random()
#define RAND_INT()				((int)(arc4random() & 0x7FFFFFFF))
#define RAND_INT_VAL(a,b)		((arc4random() % ((b)-(a)+1)) + (a))

// RAND_FLOAT() float between 0 and 1 (including 0 and 1)
// RAND_FLOAT_VAL(a,b) float between a and b (including a and b)
#define RAND_FLOAT()			(((float)arc4random()) / RAND_UINT_MAX)
#define RAND_FLOAT_VAL(a,b)		(((((float)arc4random()) * ((b)-(a))) / RAND_UINT_MAX) + (a))

// note: Random doubles will contain more precision than floats, but will NOT utilize the
//        full precision of the double. They are still limited to the 32-bit precision of arc4random
// RAND_DOUBLE() double between 0 and 1 (including 0 and 1)
// RAND_DOUBLE_VAL(a,b) double between a and b (including a and b)
#define RAND_DOUBLE()			(((double)arc4random()) / RAND_UINT_MAX)
#define RAND_DOUBLE_VAL(a,b)	(((((double)arc4random()) * ((b)-(a))) / RAND_UINT_MAX) + (a))

// RAND_BOOL() a random boolean (0 or 1)
// RAND_DIRECTION() -1 or +1 (usage: int steps = 10*RAND_DIRECTION();  will get you -10 or 10)
#define RAND_BOOL()				(arc4random() & 1)
#define RAND_DIRECTION()		(RAND_BOOL() ? 1 : -1)


//CGFloat DEGREEtoRADIAN(CGFloat degrees) {return degrees * M_PI / 180;};
//CGFloat RADIANtoDEGREEES(CGFloat radians) {return radians * 180 / M_PI;};

CGImageRef ApplyQuartzComposition(const char* compositionName, const CGImageRef srcImage);
static inline float RandomComponent() {  return (float)random() / (float)LONG_MAX; }

#define rand() (arc4random() % ((unsigned)RAND_MAX + 1)) 


//BOOL flag = YES;
//NSLog(flag ? @"Yes" : @"No");
//?: is the ternary conditional operator of the form:
//condition ? result_if_true : result_if_false
#define StringFromBOOL(b) ((b) ? @"YES" : @"NO")

#define LogProps(a) NSLog(@"%@", a.propertiesPlease)


// degree to radians
#define ARAD	 0.017453f
#define DEG2RAD(x) ((x) * ARAD)
#define RAD2DEG(rad) (rad * 180.0f / M_PI)

//returns float in range 0 - 1.0f
//usage RAND01()*3, or (int)RAND01()*3 , so there is no risk of dividing by zero
#define RAND01() ((random() / (float)0x7fffffff ))


*/