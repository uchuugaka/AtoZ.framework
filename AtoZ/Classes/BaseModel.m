
//  BaseModel.m
//  Version 2.3.1
//  Created by Nick Lockwood on 25/06/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//  Get the latest version of BaseModel from either of these locations:
//  http://charcoaldesign.co.uk/source/cocoa#basemodel
//  https://github.com/nicklockwood/BaseModel
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source distribution.

#import "BaseModel.h"



NSString *const BaseModelSharedInstanceUpdatedNotification = @"BaseModelSharedInstanceUpdatedNotification";
// Holds metadata for subclasses of SMModelObject
static NSMutableDictionary *keyNames = nil, *nillableKeyNames = nil;

@implementation BaseModel
- (NSString*)saveInstanceInAppSupp;
{
	NSString *savePath = [self.uniqueID stringByAppendingPathExtension:@"plist"];
	[self writeToFile:savePath atomically:YES];
	AZLOG(savePath);
	return savePath;
}
+ (instancetype)instanceWithID:(NSString*)uniqueID;
{
	return [[self class] instanceWithContentsOfFile:[uniqueID stringByAppendingPathExtension:@"plist"]];
}
#pragma mark -
#pragma mark Private utility methods
+ (NSString *)resourceFilePath:(NSString *)path
{
    //check if the path is a full path or not
    if (![path isAbsolutePath])
    {
        return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:path];
    }
    return path;
}
+ (NSString *)resourceFilePath
{
    return [self resourceFilePath:[self resourceFile]];
}
+ (NSString *)saveFilePath:(NSString *)path
{
    //check if the path is a full path or not
    if (![path isAbsolutePath])
    {
        //get the path to the application support folder
        NSString *folder = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
        
#ifndef __IPHONE_OS_VERSION_MAX_ALLOWED
        
        //append application name on Mac OS
        NSString *identifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
        folder = [folder stringByAppendingPathComponent:identifier];
        
#endif
        
        //create the folder if it doesn't exist
        if (![[NSFileManager defaultManager] fileExistsAtPath:folder])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:folder
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        
        return [folder stringByAppendingPathComponent:path];
    }
    return path;
}
+ (NSString *)saveFilePath
{
    return [self saveFilePath:[self saveFile]];
}
#pragma mark -
#pragma mark Singleton behaviour
static NSMutableDictionary *sharedInstances = nil;
+ (void)setSharedInstance:(BaseModel *)instance
{
    if (![instance isKindOfClass:self])
    {
        [NSException raise:NSGenericException format:@"setSharedInstance: instance class does not match"];
    }
    sharedInstances = sharedInstances ?: [[NSMutableDictionary alloc] init];
    id oldInstance = [sharedInstances objectForKey:NSStringFromClass(self)];
    [sharedInstances setObject:instance forKey:NSStringFromClass(self)];
    if (oldInstance)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:BaseModelSharedInstanceUpdatedNotification object:oldInstance];
    }
}
+ (BOOL)hasSharedInstance
{
    return [sharedInstances objectForKey:NSStringFromClass(self)] != nil;
}
+ (instancetype)sharedInstance
{
    sharedInstances = sharedInstances ?: [[NSMutableDictionary alloc] init];
    id instance = [sharedInstances objectForKey:NSStringFromClass(self)];
    if (instance == nil)
    {
        //load or create instance
        [self reloadSharedInstance];
        
        //get loaded instance
        instance = [sharedInstances objectForKey:NSStringFromClass(self)];
    }
    return instance;
}
+ (void)reloadSharedInstance
{
    id instance = nil;
    
    //try loading previously saved version
    instance = [self instanceWithContentsOfFile:[self saveFilePath]];   
    if (instance == nil)
    {
        //construct a new instance
        instance = [self instance];
    }
    
    //set singleton
    [self setSharedInstance:instance];
}
+ (NSString *)resourceFile
{
    //used for every instance
    return [NSStringFromClass(self) stringByAppendingPathExtension:@"plist"];
}
+ (NSString *)saveFile
{
    //used to save shared (singleton) instance
    return [NSStringFromClass(self) stringByAppendingPathExtension:@"plist"];
}
- (BOOL)useHRCoderIfAvailable
{
    return NO;
}
- (void)save
{
    if ([sharedInstances objectForKey:NSStringFromClass([self class])] == self)
    {
        //shared (singleton) instance
        [self writeToFile:[[self class] saveFilePath] atomically:YES];
    }
    else
    {
        //no save implementation
        [NSException raise:NSGenericException format:@"Unable to save object, save method not implemented"];
    }
}
#pragma mark -
#pragma mark Default constructors
- (void)setUp
{
    //override this
}
+ (instancetype)instance
{
    return AH_AUTORELEASE([[self alloc] init]);
}
static BOOL loadingFromResourceFile = NO;
- (instancetype)init
{
    @synchronized ([BaseModel class])
    {
        if (!loadingFromResourceFile)
        {
            //attempt to load from resource file
            loadingFromResourceFile = YES;
            id object = [[[self class] alloc] initWithContentsOfFile:[[self class] resourceFilePath]];
            loadingFromResourceFile = NO;
            if (object)
            {
                AH_RELEASE(self);
                self = object;
                return self;
            }
        }
        if ((self = [super init]))
        {
            
#ifdef DEBUG
            if ([self class] == [BaseModel class])
            {
                [NSException raise:NSGenericException format:@"BaseModel class is abstract and should be subclassed rather than instantiated directly"];
            }
#endif
            [self setUp];
        }
        return self;
    }
}
+ (instancetype)instanceWithObject:(id)object
{
    //return nil if object is nil
    return object? AH_AUTORELEASE([[self alloc] initWithObject:object]): nil;
}
- (NSString *)setterNameForClass:(Class)class
{
    //get class name
    NSString *className = NSStringFromClass(class);
    
    //strip NS prefix
    if ([className hasPrefix:@"NS"])
    {
        className = [className substringFromIndex:2];
    }
    
    //return setter name
    return [NSString stringWithFormat:@"setWith%@:", className];
}
- (instancetype)initWithObject:(id)object
{
    if ((self = [self init]))
    {
        Class class = [object class];
        while (true)
        {
            SEL setter = NSSelectorFromString([self setterNameForClass:class]);
            if ([self respondsToSelector:setter])
            {
                objc_msgSend(self, setter, object);
                return self;
            }
            if ([class superclass] == [NSObject class]) break;
            class = [class superclass];
        }
        [NSException raise:NSGenericException
                    format:@"%@ not implemented", [self setterNameForClass:class]];
    }
    return self;
}
+ (NSArray *)instancesWithArray:(NSArray *)array
{
	return [array map:^id(id obj) { return [self instanceWithObject:obj]; }];
}
+ (instancetype)instanceWithCoder:(NSCoder *)decoder     //return nil if coder is nil
{
    return decoder ? AH_AUTORELEASE([[self alloc] initWithCoder:decoder]) : nil;
}
- (instancetype)initWithCoder:(NSCoder *)decoder
{
	if (YES) {
		self = [super init];
		if (self) {
			for (NSString *name in [self allKeys])
				[self setValue:[decoder decodeObjectForKey:name] forKey:name];
		}
//		return self;
	}
	else {

			//([self respondsToSelector:@selector(enumerateIvarsUsingBlock:)]) {
//    	if (self = [super init]) {
//			[self enumerateIvarsUsingBlock:^(Ivar var, NSString *name, BOOL *cancel) {
//				[self setValue:[decoder decodeObjectForKey:name] forKey:name];
//			}];
//		}
		if ((self = [self init]))
				[self respondsToSelector:@selector(setWithCoder:)]
			?  	[self setWithCoder:decoder]
			:   [NSException raise:NSGenericException format:@"setWithCoder: not implemented"];

	}
	return self;

}
+ (instancetype)instanceWithContentsOfFile:(NSString *)filePath
{
    //check if the path is a full path or not
    NSString *path = filePath;
    if (![path isAbsolutePath])
    {
        //try resources
        path = [self resourceFilePath:filePath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            //try application support
            path = [self saveFilePath:filePath];
        }
    }
    return AH_AUTORELEASE([[self alloc] initWithContentsOfFile:path]);
}
- (instancetype)initWithContentsOfFile:(NSString *)filePath
{
    static NSCache *cachedResourceFiles = nil;
    if (cachedResourceFiles == nil)        cachedResourceFiles = [[NSCache alloc] init];
    
    //check cache for existing instance
    //only cache files inside the main bundle as they are immutable 
    BOOL isResourceFile = [filePath hasPrefix:[[NSBundle mainBundle] bundlePath]];
    if (isResourceFile)
    {
        id object = [cachedResourceFiles objectForKey:filePath];
        if (object)
        {
            AH_RELEASE(self);
            return ((self = (object == [NSNull null])? nil: AH_RETAIN(object)));
        }
    }
    //load the file
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    //attempt to deserialise data as a plist
    id object = nil;
    if (data) {
        NSPropertyListFormat format;
        NSPropertyListReadOptions options = NSPropertyListMutableContainersAndLeaves;
        object = [NSPropertyListSerialization propertyListWithData:data options:options format:&format error:NULL];
    }
	if (object)	{    //success?
        //check if object is an NSCoded archive
        if ([object respondsToSelector:@selector(objectForKey:)])	{
            if ([object objectForKey:@"$archiver"])    object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            else {
                Class coderClass = NSClassFromString(@"HRCoder");
                NSString *classNameKey = [coderClass valueForKey:@"classNameKey"];
                if ([object objectForKey:classNameKey])
                    object = objc_msgSend(coderClass, @selector(unarchiveObjectWithPlist:), object);
			}
            if ([object isKindOfClass:[self class]]) {
				AH_RELEASE(self); //return object
                return ((self = AH_RETAIN(object)));
            }
        }
        if (isResourceFile)
        {
            //cache for next time
            [cachedResourceFiles setObject:object forKey:filePath];
        }
        
        //load with object
        return ((self = [self initWithObject:object]));
    }
	else if (isResourceFile)   //store null for non-existent files to improve performance next time
        [cachedResourceFiles setObject:[NSNull null] forKey:filePath];
    //failed to load
    AH_RELEASE(self);
    return ((self = nil));
}
- (void)writeToFile:(NSString *)path atomically:(BOOL)atomically
{
    NSData *data = nil;
    Class coderClass = NSClassFromString(@"HRCoder");
    if (coderClass && [self useHRCoderIfAvailable])
    {
        id plist = objc_msgSend(coderClass, @selector(archivedPlistWithRootObject:), self);
        NSPropertyListFormat format = NSPropertyListBinaryFormat_v1_0;
        data = [NSPropertyListSerialization dataWithPropertyList:plist format:format options:0 error:NULL];
    }
    else
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:self];
    }
    [data writeToFile:[[self class] saveFilePath:path] atomically:YES];
}
#pragma mark -
#pragma mark Unique identifier generation
+ (NSString *)newUniqueIdentifier
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef identifier = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return AH_RETAIN(CFBridgingRelease(identifier));
}
//#ifdef BASEMODEL_ENABLE_UNIQUE_ID
@synthesize uniqueID = _uniqueID;
- (NSString *)uniqueID
{
    if (_uniqueID == nil)
    {
        _uniqueID = [[self class] newUniqueIdentifier];
    }
    return _uniqueID;
}
- (void)dealloc
{
    AH_RELEASE(_uniqueID);
//	[self enumerateIvarsUsingBlock:^(Ivar var, NSString *name, BOOL *cancel) {
//		if (ivar_getTypeEncoding(var)[0] == _C_ID) [self setValue:nil forKey:name];
//	}];
//    for (NSString *name in [self nillableKeys])
//		[self setValue:nil forKey:name];
	AH_SUPER_DEALLOC;
}
//#endif
//@end
//
//
//
//@implementation SMModelObject
	// Before this class is first accessed, we'll need to build up our associated metadata, basically
	// just a list of all our property names so we can quickly enumerate through them for various methods.
	// Also we maintain a separate list of property names that can be set to nil (type ID) for fast dealloc.
	// Helper for easily enumerating through our instance variables.
//- (void)enumerateIvarsUsingBlock:(void (^)(Ivar var, NSString *name, BOOL *cancel))block {
//	BOOL cancel = NO;
//	for (Class cls = [self class]; !cancel && cls != [SMModelObject class]; cls = [cls superclass]) {
//		unsigned int varCount;
//		Ivar *vars = class_copyIvarList(cls, &varCount);
//		for (int i = 0; !cancel && i < varCount; i++) {
//			Ivar var = vars[i];
//			NSString *name = [[NSString alloc] initWithUTF8String:ivar_getName(var)];
//			block(var, name, &cancel);
//			[name release];
//		}
//		free(vars);
//	}
//}
	// NSCoder implementation, for unarchiving
//- (id) initWithCoder:(NSCoder *)aDecoder {
//	if (self = [super init]) {
//		[self enumerateIvarsUsingBlock:^(Ivar var, NSString *name, BOOL *cancel) {
//			[self setValue:[aDecoder decodeObjectForKey:name] forKey:name];
//		}];
//	}
//	return self;
//}
	// NSCoder implementation, for archiving
//- (void) encodeWithCoder:(NSCoder *)aCoder {
//	[self enumerateIvarsUsingBlock:^(Ivar var, NSString *name, BOOL *cancel) {
//		[aCoder encodeObject:[self valueForKey:name] forKey:name];
//	}];
//}
	// Automatic dealloc.

	// NSCopying implementation
//- (id) copyWithZone:(NSZone *)zone {
//	id copied = [[[self class] alloc] init];
//	[self enumerateIvarsUsingBlock:^(Ivar var, NSString *name, BOOL *cancel) {
//		[copied setValue:[self valueForKey:name] forKey:name];
//	}];
//	return copied;
//}
	// Override isEqual to compare model objects by value instead of just by pointer.
//- (BOOL) isEqual:(id)other {
//	__block BOOL equal = NO;
//	if ([other isKindOfClass:[self class]]) {
//		equal = YES;
//		[self enumerateIvarsUsingBlock:^(Ivar var, NSString *name, BOOL *cancel) {
//			if (![[self valueForKey:name] isEqual:[other valueForKey:name]]) {
//				equal = NO;
//				*cancel = YES;
//			}
//		}];
//	}
//	return equal;
//}
	// Must override hash as well, this is taken directly from RMModelObject, basically
	// classes with the same layout return the same number.
//- (NSUInteger)hash
//{
//	__block NSUInteger hash = 0;
//	[self enumerateIvarsUsingBlock:^(Ivar var, NSString *name, BOOL *cancel) {
//		hash += (NSUInteger)var;
//	}];
//	return hash;
//}
//- (void)writeLineBreakToString:(NSMutableString *)string withTabs:(NSUInteger)tabCount {
//	[string appendString:@"\n"];
//	for (int i=0;i<tabCount;i++) [string appendString:@"\t"];
//}
//	// Prints description in a nicely-formatted and indented manner.
//- (void) writeToDescription:(NSMutableString *)description withIndent:(NSUInteger)indent {
//	[description appendFormat:@"<%@ %p", NSStringFromClass([self class]), self];
//	[self enumerateIvarsUsingBlock:^(Ivar var, NSString *name, BOOL *cancel) {
//		[self writeLineBreakToString:description withTabs:indent];
//		id object = [self valueForKey:name];
//		if ([object isKindOfClass:[SMModelObject class]]) {
//			[object writeToDescription:description withIndent:indent+1];
//		}
//		else if ([object isKindOfClass:[NSArray class]]) {
//			[description appendFormat:@"%@ =", name];
//			for (id child in object) {
//				[self writeLineBreakToString:description withTabs:indent+1];
//				if ([child isKindOfClass:[SMModelObject class]])
//					[child writeToDescription:description withIndent:indent+2];
//				else
//					[description appendString:[child description]];
//			}
//		}
//		else {
//			[description appendFormat:@"%@ = %@", name, object];
//		}
//	}];
//	[description appendString:@">"];
//}
//	// Override description for helpful debugging.
//- (NSString *) description {
//	NSMutableString *description = [NSMutableString string];
//	[self writeToDescription:description withIndent:1];
//	return description;
//}
//+ (void) initialize {
//
//	if (!keyNames) keyNames = [NSMutableDictionary new], nillableKeyNames = [NSMutableDictionary new];
//	NSMutableArray *names = [NSMutableArray new], *nillableNames = [NSMutableArray new];
//	for (Class cls = self; cls != [SMModelObject class]; cls = [cls superclass]) {
//		unsigned int varCount;
//		Ivar *vars = class_copyIvarList(cls, &varCount);
//		for (int i = 0; i < varCount; i++) {
//			Ivar var = vars[i];
//			NSString *name = [[NSString alloc] initWithUTF8String:ivar_getName(var)];
//			[names addObject:name];
//			if (ivar_getTypeEncoding(var)[0] == _C_ID) [nillableNames addObject:name];
//			[name release];
//		}
//		free(vars);
//	}
//	[keyNames setObject:names forKey:(id)self];
//	[nillableKeyNames setObject:nillableNames forKey:(id)self];
//	[names release], [nillableNames release];
//}
//
//- (NSArray *)allKeys {
//	return [keyNames objectForKey:[self class]];
//}
//
//- (NSArray *)nillableKeys {
//	return [nillableKeyNames objectForKey:[self class]];
//}
//
//	// NSCoder implementation, for unarchiving
//- (id) initWithCoder:(NSCoder *)aDecoder {
//    self = [super init];
//    if (self) {
//		for (NSString *name in [self allKeys])
//			[self setValue:[aDecoder decodeObjectForKey:name] forKey:name];
//	}
//	return self;
//}
////
////	// NSCoder implementation, for archiving
- (void) encodeWithCoder:(NSCoder *)aCoder {
////
	for (NSString *name in [self allKeys])
		[aCoder encodeObject:[self valueForKey:name] forKey:name];
}
//
//	// Automatic dealloc.
////- (void) dealloc {
////	for (NSString *name in [self nillableKeys])
////		[self setValue:nil forKey:name];
//
////	[super dealloc];
////}
//
//	// NSCopying implementation
- (id) copyWithZone:(NSZone *)zone {

	id copied = [[[self class] alloc] init];

	for (NSString *name in [self allKeys])
		[copied setValue:[self valueForKey:name] forKey:name];

	return copied;
}
//
//	// We implement the NSFastEnumeration protocol to behave like an NSDictionary - the enumerated values are our property (key) names.
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
	return [[self allKeys] countByEnumeratingWithState:state objects:buffer count:len];
}
//
//	// Override isEqual to compare model objects by value instead of just by pointer.
- (BOOL) isEqual:(id)other {
	return [other isKindOfClass:[self class]] ?
		[[self allKeys] isValidForAll:^BOOL(NSString* obj) {
//		for (NSString *name in [self allKeys]) {
			id a = [self valueForKey:obj];
			id b = [other valueForKey:obj];
			return (a || b) && ![a isEqual:b] ? NO : YES; // extra check so a == b == nil is considered equal
		}] : NO;
//		return YES;
//	}
//	else return NO;
}
//
//	// Must override hash as well, this is taken directly from RMModelObject, basically
//	// classes with the same layout return the same number.
- (NSUInteger)hash {
	return (NSUInteger)[self allKeys];
}
//
- (void)writeLineBreakToString:(NSMutableString *)string withTabs:(NSUInteger)tabCount {
	[string appendString:@"\n"];
	for (int i=0;i<tabCount;i++) [string appendString:@"\t"];
}

// Prints description in a nicely-formatted and indented manner.
- (void) writeToDescription:(NSMutableString *)description withIndent:(NSUInteger)indent {
	[description appendFormat:@"<%@ %p", NSStringFromClass([self class]), self];
	for (NSString *name in [self allKeys]) {
		[self writeLineBreakToString:description withTabs:indent];
		id object = [self valueForKey:name];
		if ([object isKindOfClass:[SMModelObject class]])
			[object writeToDescription:description withIndent:indent+1];
		else if ([object isKindOfClass:[NSArray class]]) ^{
			[description appendFormat:@"%@ =", name];
			for (id child in object) ^{
				[self writeLineBreakToString:description withTabs:indent+1];
				if ([child isKindOfClass:[SMModelObject class]])
					[child writeToDescription:description withIndent:indent+2];
				else [description appendString:[child description]];
			}();
		}();
		else if ([object isKindOfClass:[NSDictionary class]]) {
			[description appendFormat:@"%@ =", name];
			for (id key in object) {
				[self writeLineBreakToString:description withTabs:indent];
				[description appendFormat:@"\t%@ = ",key];
				id child = [object objectForKey:key];
				if ([child isKindOfClass:[SMModelObject class]])
					[child writeToDescription:description withIndent:indent+2];
				else	[description appendString:[child description]];
			}
		}
		else [description appendFormat:@"%@ = %@", name, object];
	}
	[description appendString:@">"];
}

	// Override description for helpful debugging.
- (NSString *) description {
	NSMutableString *description = [NSMutableString string];
	[self writeToDescription:description withIndent:1];
	return description;
}
@end