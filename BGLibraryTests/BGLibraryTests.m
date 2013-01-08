//
//  BGLibraryTests.m
//  BGLibraryTests
//
//  Created by Lawrence Lomax on 03/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGLibraryTests.h"
#import "NSIndexPath+BGHelpers.h"
#import "BGLibrary.h"
#import "BGNanoDataStore.h"
#import "BGFileDataStore.h"

@implementation BGLibraryTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testLaunchUtilities
{
    const char * testName = "testName";
    
    [BGLaunchUtilities performBlockOncePerVersionEver:^{
        
    } withName:testName];
    
    [BGLaunchUtilities performBlockOncePerVersionEver:^{
        STFail(@"-performBlockOncePerVersionEver performed more than once");
    } withName:testName];
}


- (void) testDataStore
{
    void (^dataStoreTest)(NSString *) = ^(NSString * dataStoreClassName)
    {
        id<BGDataStore> dataStore = [NSClassFromString(dataStoreClassName) sharedInstance];
        STAssertNotNil(dataStore, @"Data Store %@ does not exist", dataStoreClassName);
        
        NSDictionary * testDict1 = @{ @"key1" : @"value1", @"key2" : @"value2", @"key3" : @(3)};
        NSString * dictKey1 = @"sdgsdgsoig";
    
        [dataStore setObject:testDict1 forKey:dictKey1];
        id retData = dataStore[dictKey1];
        STAssertTrue([testDict1 isEqualToDictionary:retData], @"Stored dictionary %@ is not the same as expected %@", retData, testDict1);
        STAssertTrue([dataStore hasObjectForKey:dictKey1], @"Has ObjectForKey returns NO for a key that should exist");
    
        retData = dataStore[@"FISDJFOISDFOS"];
        STAssertNil(retData, @"Non existing key does not return nil");
    
        id nilValue = nil;
        STAssertNoThrow(retData = dataStore[nilValue], @"Nil key lookup should not throw exception in database");
        STAssertNil(retData, @"Nil Key should return nil value");
    
        STAssertNoThrow(dataStore[dictKey1] = nilValue, @"Nil Value should not throw exception in database");
        STAssertNil(dataStore[dictKey1], @"Upon inserting a nil value for a key, the previous result should be cleared");
        STAssertFalse([dataStore hasObjectForKey:dictKey1], @"Upon inserting a nil value for a key, hasObjectForKey should now be false");
    };
    
    dataStoreTest( @"BGNanoDataStore");
    //dataStoreTest( @"BGFileDataStore");
}

@end
