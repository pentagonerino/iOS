/* Copyright (c) 2013 EVO Payments International, Inc. - All Rights Reserved.
 *
 * This software and documentation is subject to and made
 * available only pursuant to the terms of an executed license
 * agreement, and may be used only in accordance with the terms
 * of said agreement. This software may not, in whole or in part,
 * be copied, photocopied, reproduced, translated, or reduced to
 * any electronic medium or machine-readable form without
 * prior consent, in writing, from EVO Payments International, Inc.
 *
 * Use, duplication or disclosure by the U.S. Government is subject
 * to restrictions set forth in an executed license agreement
 * and in subparagraph (c)(1) of the Commercial Computer
 * Software-Restricted Rights Clause at FAR 52.227-19; subparagraph
 * (c)(1)(ii) of the Rights in Technical Data and Computer Software
 * clause at DFARS 252.227-7013, subparagraph (d) of the Commercial
 * Computer Software--Licensing clause at NASA FAR supplement
 * 16-52.227-86; or their equivalent.
 *
 * Information in this software is subject to change without notice
 * and does not represent a commitment on the part of EVO Payments International.
 *
 * Sample Code is for reference Only and is intended to be used for educational purposes. It's the responsibility of
 * the software company to properly integrate into their solution code that best meets their production needs.
 */
//
//  CWSAPI.m
//  CWSAPI
//  https://my.evosnap.com/Docs/1.17.16/CWS_REST_Developer_Guide/Introduction.aspx

#import "CWSAPI.h"
#import "CWSTransactionData.h"
#import "CWSTransactionDataPro.h"
#import "SBJson.h"
#import "NSString+Base64Encode.h"
#import "NSDate+InternetDateTime.h"
#import "CWSTransactionReportingData.h"
#import "CWSAlternativeMerchantData.h"
#import "CWSAddressInfo.h"

//When debug, log warnings, else not.
#ifdef DEBUG
#    define InfoLog(...) NSLog(__VA_ARGS__)
#else
#    define InfoLog(...) /* */
#endif


//#define BASE_URL @"https://cws-01.cert.evosnap.com/REST/2.0.18"

#define kTenderData @"TenderData"
#define kTransactionData @"TransactionData"

//Card keys
#define kCardDataCardType @"CardType"
#define kCardDataCardholderName @"CardholderName"
#define kCardDataPAN @"PAN"
#define kCardDataExpire  @"Expire"
#define kCardDataTrack1Data @"Track1Data"
#define kCardDataTrack2Data @"Track2Data"
#define kCardData @"CardData"
#define kEncryptionKeyId @"EncryptionKeyId"
#define kSecurePaymentAccountData @"SecurePaymentAccountData"
#define kIdentificationInformation @"IdentificationInformation"
#define kSwipeStatus @"SwipeStatus"
#define kDeviceSerialNumber @"DeviceSerialNumber"

//CardSecurity keys
#define kAVSCardholderName @"CardholderName"
#define kAVSStreet @"Street"
#define kAVSCity @"City"
#define kAVSStateProvince @"StateProvince"
#define kAVSPostalCode @"PostalCode"
#define kAVSCountry @"Country"
#define kAVSPhone @"Phone"
#define kAVSData @"AVSData"

#define kCVDataProvided @"CVDataProvided"
#define kCVData @"CVData"
#define kCardSecurityData @"CardSecurityData"

#define kReportingComments @"ReportingComments"
#define kReportingDescription @"ReportingDescription"
#define kReportingReference @"ReportingReference"
#define kReportingData @"ReportingData"

#define kAccountType @"$type"
#define kAmount  @"Amount"
#define kCashBackAmount @"CashBackAmount"
#define kCurrencyCode @"CurrencyCode"
#define kGoodsType @"GoodsType"
#define kInvoiceNumber @"InvoiceNumber"
#define kTransactionDateTime @"TransactionDateTime"
#define kCFeeAmount @"CFeeAmount"
#define kAlternativeMerchantData @"AlternativeMerchantData"
#define kApprovalCode @"ApprovalCode"
#define kCustomerPresent @"CustomerPresent"
#define kEmployeeId @"EmployeeId"
#define kEntryMode @"EntryMode"
#define kIndustryType @"IndustryType"
#define kOrderNumber @"OrderNumber"
#define kSignatureCaptured @"SignatureCaptured"
#define kLaneId @"LaneId"
#define kTerminalId @"TerminalId"
#define kTipAmount @"TipAmount"
#define kReference @"Reference"
#define kTransactionCode @"TransactionCode"

#define kAltMerchantCustomerServicePhone @"CustomerServicePhone"
#define kAltMerchantCustomerServiceInternet @"CustomerServiceInternet"
#define kAltMerchantDescription @"Description"
#define kAltMerchantSIC @"SIC"
#define kAltMerchantMerchantId @"MerchantId"
#define kAltMerchantName @"Name"
#define kAltMerchant @"AlternativeMerchantData"

#define kAdrInfoStreet1 @"Street1"
#define kAdrInfoStreet2 @"Street2"
#define kAdrInfoCity @"City"
#define kAdrInfoStateProvince @"StateProvince"
#define kAdrInfoPostalCode @"PostalCode"
#define kAdrInfoCountryCode @"CountryCode"
#define kAltMerchantAddress @"Address"

#define kAddendum @"Addendum"
#define kUnmanaged @"Unmanaged"
#define kAny @"Any"

#define kDateTime @"TransactionDateTime"
#define kOperations @"Operations"

#define kApplicationProfileId @"ApplicationProfileId"
#define kMerchantProfileId @"MerchantProfileId"
#define kTransactionId @"TransactionId"
#define kTransactionIds @"TransactionIds"
#define kTransaction @"Transaction"
#define kDifferenceData @"DifferenceData"
#define kServiceId @"ServiceId"
#define kQueryBatchParameters @"QueryBatchParameters"
#define kPagingParameters @"PagingParameters"
#define kPage @"Page"
#define kPageSize @"PageSize"
#define kIncludeRelated @"IncludeRelated"
static CWSAPI *sharedAPI = nil;


@interface CWSAPI()

@property (nonatomic, retain) NSString *identityToken;
@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, retain) NSString *merchantProfileId;
@property (nonatomic, retain) NSString *serviceId;
@property (nonatomic, retain) NSString *workflowId;
@property (nonatomic, retain) NSString *applicationProfileId;
@property (nonatomic, retain) NSString *sessionToken;
@property (nonatomic, retain) NSDate *lastTimeSessionTokenFetched;

//App lifecycle callbacks.
-(void)applicationWillTerminate:(NSNotification *)notification;
-(void)applicationWillEnterForeground:(NSNotificationCenter *)notification;

//Helper Functions
- (NSString *)signOn:(NSError **)error;
- (NSString *)getSessionAuthorizationHeader:(NSError **)error;
- (NSString *)getIdentityAuthorizationHeader;

- (NSString *)sendToURL:(NSString *)url withHTTPmethod:(NSString *)method andBodyJSONOfDict:(NSDictionary *)bodyDict requiresSession:(BOOL)sessionRequired error:(NSError **)error;

- (id)notNillObject:(id)aObject;
- (NSMutableDictionary *)buildDifferenceWithDifferenceData:(CWSDifferenceData *)differenceData;
- (NSMutableDictionary *)buildTransactionWithCC:(CWSCreditCard *)creditCard andTransaction:(CWSTransactionData *)transaction error:(NSError **)error;

@end

@implementation CWSAPI

@synthesize identityToken;
@synthesize baseURL;
@synthesize merchantProfileId;
@synthesize serviceId;
@synthesize workflowId;
@synthesize applicationProfileId;
@synthesize sessionToken;
@synthesize lastTimeSessionTokenFetched;

#pragma mark -
#pragma mark Singleton methods

+ (CWSAPI *) sharedAPIWithIdentityToken:(NSString *)identityToken
                             andBaseURL:(NSString *)baseURL
                   andMerchantProfileId:(NSString *)merchantProfileId
                           andServiceId:(NSString *)serviceId
                          andWorkflowId:(NSString *)workflowId
                andApplicationProfileId:(NSString *)applicationProfileId
                                  error:(NSError **)error
{
    @synchronized(self)
    {
        if (sharedAPI == nil)
		{
            sharedAPI = [[CWSAPI alloc] init];
            sharedAPI.identityToken = identityToken;
            sharedAPI.baseURL = baseURL;
            sharedAPI.merchantProfileId = merchantProfileId;
            sharedAPI.serviceId = serviceId;
            sharedAPI.workflowId = workflowId;
            sharedAPI.applicationProfileId = applicationProfileId;
            sharedAPI.lastTimeSessionTokenFetched = [NSDate distantPast];
            
            
            
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            //If iOS > 4.0, then we need to listen for the didEnterForeground notification so we can re-auth after suspend.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
			if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
            {
				if (&UIApplicationWillEnterForegroundNotification) {
                    [notificationCenter addObserver:sharedAPI
                                           selector:@selector(applicationWillEnterForeground:)
                                               name:UIApplicationWillEnterForegroundNotification
                                             object:nil];
				}
			}
#endif
            //Always listen to will terminate.
			[notificationCenter addObserver:self
								   selector:@selector(applicationWillTerminate:)
									   name:UIApplicationWillTerminateNotification
									 object:nil];
            
            
            
            
            [sharedAPI applicationWillEnterForeground:nil];
            
            
        }
    }
    return sharedAPI;
}

+ (CWSAPI *) sharedAPI
{
    @synchronized(self)
    {
        if (sharedAPI == nil)
		{
            InfoLog(@"CWSAPI: ERROR - Returning nil object in sharedAPI as sharedAPIWithKey: has not been called.");
            //Note: Could throw this instead: [NSException raise:@"API Not Initialized" format:@"ERROR - Returning nil object in sharedAPI as sharedAPIWithKey: has not been called."];
        }
    }
    return sharedAPI;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedAPI == nil)
		{
            sharedAPI = [super allocWithZone:zone];
            return sharedAPI;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}


- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}


#pragma mark -
#pragma mark Lifecycle methods


- (void)applicationWillTerminate:(NSNotification*) notification
{
}

- (void)applicationWillEnterForeground:(NSNotificationCenter*) notification
{
    InfoLog(@"applicationWillEnterForeground");
    [self signOn:nil];
}
- (void)dealloc
{
    [identityToken release];
    [baseURL release];
    [merchantProfileId release];
    [serviceId release];
    [workflowId  release];
    [applicationProfileId release];
    [sessionToken release];
    [lastTimeSessionTokenFetched release];
    
    [super dealloc];
}

/**
 * This method explcitly makes a call to the REST API's signOn method, regardless of how long
 * ago the previous call was made. 
 * It not only returns the new session token but also updates it.
 */
- (NSString *)signOn:(NSError **)error
{
    NSString *token = [self sendToURL:[NSString stringWithFormat:@"%@/SvcInfo/token", self.baseURL] withHTTPmethod:@"GET" andBodyJSONOfDict:nil requiresSession:NO error:error];
    
    if (token == nil)
    {
        InfoLog(@"No token returned from signOn. Is identityToken correct?");
        return token;
    }
    self.lastTimeSessionTokenFetched = [NSDate date];
    self.sessionToken = [token stringByReplacingOccurrencesOfString:@"\"" withString:@""];//Borked API
    return self.sessionToken;
}

- (NSString *)getSessionAuthorizationHeader:(NSError **)error
{
    
    NSTimeInterval thirtyMinutes = 29*60;
    
    if([[NSDate date] timeIntervalSinceDate:self.lastTimeSessionTokenFetched] > thirtyMinutes)
    {
        //If it's been more than 30 minutes, then the session token is definitely outdated so we need a new one.
        //We'll actually check if it's been 29 minutes, just to avoid weird boundary cases.
        //This is strictly a convenience to the developer - we could just return the string and let them track
        //for themselves that they're out of time. But this seemed nicer..
        NSError *signOnError = nil;        
        [self signOn:&signOnError];
        if(signOnError != nil)
        {
            if(error != nil)
            {
                //Something messed with signon. Passing error along to caller to deal with if they care.
                *error = signOnError;  
            }
            return nil;
        }
    }
    
    //Else we just return the last one we fetched. 
    NSString *sessionString = [NSString stringWithFormat:@"%@:",self.sessionToken]; 
    NSString *base64String = [NSString base64Encode:[sessionString dataUsingEncoding:NSUTF8StringEncoding]];
    return [NSString stringWithFormat:@"Basic %@",base64String];
    
}


- (NSString *)getIdentityAuthorizationHeader
{
    NSString *identityString = [NSString stringWithFormat:@"%@:",self.identityToken]; 
    NSString *base64String = [NSString base64Encode:[identityString dataUsingEncoding:NSUTF8StringEncoding]];
    return [NSString stringWithFormat:@"Basic %@",base64String];
}


- (NSString *) sendToURL:(NSString *)url withHTTPmethod:(NSString *)method andBodyJSONOfDict:(NSDictionary *)bodyDict requiresSession:(BOOL)sessionRequired error:(NSError **)error
{
    NSURL *actualUrl = [NSURL URLWithString:url];
    if(actualUrl == nil)
    {
        InfoLog(@"%@ doesn't seem like a correct url", url);
        assert(NO);
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:actualUrl];
    //[request setValue:@"iOS CWS API" forHTTPHeaderField:@"User-Agent"];
    if(sessionRequired)
    {
        NSError *loginError = nil;
        [request setValue:[self getSessionAuthorizationHeader:&loginError] forHTTPHeaderField:@"Authorization"];
        if(loginError != nil)
        {
            if(error == nil)
            {
                //Bail on the request, as the session has expired, but we're failing to log in
                *error = loginError;
            }
            [request release];
            return nil;
        }
    }
    else 
    {
        [request setValue:[self getIdentityAuthorizationHeader] forHTTPHeaderField:@"Authorization"];
    }
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];  
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [request setHTTPMethod:method];
    if([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"])
    {
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        [jsonWriter setSortKeys:YES];
        NSData *postBody = [jsonWriter dataWithObject:bodyDict];
        [request setHTTPBody:postBody];
    }
    
    
    NSHTTPURLResponse* response;
    
    //Capturing server response
    NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    [request release];
    if(result == nil)
    {
        InfoLog(@"RESULT IS NIL");
        return nil; //Error will be passed to caller if he cares
    }
    
    if (!([response statusCode] == 200 || [response statusCode] == 201))
    {
        InfoLog(@"response status code = %i", [response statusCode]);
        InfoLog(@"error response: \n%@",[[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease]);
        //Error
        if(error != nil)
        {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:[[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease]forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:@"CWS" code:[response statusCode] userInfo:details];
        }
        return nil;
    } 
    
    return [[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
    
}

- (id)notNillObject:(id)aObject
{
    if (aObject)
        return aObject;
    else
        return [NSNull null];
}

- (NSMutableDictionary *)buildDifferenceWithDifferenceData:(CWSDifferenceData *)differenceData
{
    if (differenceData)
    {
        //Create dict to hold CWSDifferenceData
        NSMutableDictionary *difference = [[NSMutableDictionary alloc] init];
        difference[kTransactionId] = differenceData.transactionID;
        if (differenceData.amount)
            difference[kAmount] = [NSString stringWithFormat:@"%.2f", [differenceData.amount floatValue]];
        if (differenceData.tipAmount)
            difference[kTipAmount] = [NSString stringWithFormat:@"%.2f", [differenceData.tipAmount floatValue]];
        /*
         * Addendum
         */
        if(differenceData.creds != nil)
        {
            NSMutableDictionary *addendum = [NSMutableDictionary dictionary];
            NSMutableDictionary *unmanaged = [NSMutableDictionary dictionary];
            [unmanaged setObject:differenceData.creds forKey:kAny];
            [addendum setObject:unmanaged forKey:kUnmanaged];
            
            [difference setObject:addendum forKey:kAddendum];
        }
        
        return difference;
    }
    return nil;
}

- (NSMutableDictionary *)buildTransactionWithCC:(CWSCreditCard *)creditCard andTransaction:(CWSTransactionData *)transaction error:(NSError **)error
{
    
    //Create dict to hold BankcardTransaction info
    NSMutableDictionary *bank_trans = [NSMutableDictionary dictionary];
    //'$type': 'BankcardTransactionPro,http://schemas.evosnap.com/CWS/v2.0/Transactions/Bankcard/Pro',	
    
    //Tender data is sub of BankcardTransaction
    NSMutableDictionary *tenderData = [NSMutableDictionary dictionary];
    
    /*
     *  Values for End to End Encryption transactions
     */
    [tenderData setObject:[self notNillObject:creditCard.securePaymentAccountData] forKey:kSecurePaymentAccountData];
    [tenderData setObject:[self notNillObject:creditCard.encryptionKeyId] forKey:kEncryptionKeyId];
    [tenderData setObject:[self notNillObject:creditCard.swipeStatus] forKey:kSwipeStatus];
    [tenderData setObject:[self notNillObject:creditCard.deviceSerialNumber] forKey:kDeviceSerialNumber];
    /*
     * CardData
     */
    
    //PaymentAccountDataToken is out of scope, so card data will always be present.
    NSMutableDictionary *cardData = [NSMutableDictionary dictionary];
    
    [cardData setObject:[self notNillObject:creditCard.type] forKey:kCardDataCardType];
    [cardData setObject:[self notNillObject:creditCard.name] forKey:kCardDataCardholderName];
    [cardData setObject:[self notNillObject:creditCard.number] forKey:kCardDataPAN];
    [cardData setObject:[self notNillObject:creditCard.expiration] forKey:kCardDataExpire];
    [cardData setObject:[self notNillObject:creditCard.track1] forKey:kCardDataTrack1Data];
    [cardData setObject:[self notNillObject:creditCard.track2] forKey:kCardDataTrack2Data];
    
    //Card data is sub of TenderData
    [tenderData setObject:cardData forKey:kCardData];
    
    
    /*
     * CardSecurityData
     */
    if((creditCard.zip != nil && ![creditCard.zip isEqualToString:@""]) ||
       (creditCard.cvv != nil && ![creditCard.cvv isEqualToString:@""]) ||
       creditCard.identificationInformation != nil)
    {
        NSMutableDictionary *cardSecurityData = [NSMutableDictionary dictionary];
        
        if(creditCard.zip != nil && ![creditCard.zip isEqualToString:@""])
        {
            /*
             * AVSData
             */
            NSMutableDictionary *AVSData = [NSMutableDictionary dictionary];
            [AVSData setObject:[self notNillObject:creditCard.name] forKey:kAVSCardholderName];
            [AVSData setObject:[self notNillObject:creditCard.address] forKey:kAVSStreet];
            [AVSData setObject:[self notNillObject:creditCard.city] forKey:kAVSCity];
            [AVSData setObject:[self notNillObject:creditCard.state] forKey:kAVSStateProvince];
            [AVSData setObject:[self notNillObject:creditCard.zip] forKey:kAVSPostalCode];
            [AVSData setObject:[self notNillObject:creditCard.country] forKey:kAVSCountry];
            [AVSData setObject:[self notNillObject:creditCard.phone] forKey:kAVSPhone];
            
            [cardSecurityData setObject:AVSData forKey:kAVSData];
        }
        
        if(creditCard.cvv != nil && ![creditCard.cvv isEqualToString:@""])
        {
            [cardSecurityData setObject:@"Provided" forKey:kCVDataProvided];
            [cardSecurityData setObject:[self notNillObject:creditCard.cvv] forKey:kCVData];
        }
        if(creditCard.identificationInformation != nil)
        {
            [cardSecurityData setObject:[self notNillObject:creditCard.identificationInformation] forKey:kIdentificationInformation];
            [cardSecurityData setObject:@"NotSet" forKey:kCVDataProvided];
            [tenderData setObject:[NSNull null] forKey:kCardData];

        }
                
        [tenderData setObject:cardSecurityData forKey:kCardSecurityData];
        
    }


    //Add Tender Data object to BankcardTransaction
    [bank_trans setObject:tenderData forKey:kTenderData];
    
    
    /*
     * TransactionData
     */
    NSMutableDictionary *transactionData = [NSMutableDictionary dictionary];
    //'$type' : 'BankcardTransactionDataPro,http://schemas.evosnap.com/CWS/v2.0/Transactions/Bankcard/Pro',"
    
    if(transaction.accountType != nil && ![transaction.accountType isEqualToString:@""])
    {
        [transactionData setObject:transaction.accountType forKey:kAccountType];
    }
    [transactionData setObject:[NSString stringWithFormat:@"%.2f", [transaction.amount floatValue]] forKey:kAmount];
    [transactionData setObject:[self notNillObject:transaction.approvalCode] forKey:kApprovalCode];
    if(transaction.cashBackAmount != nil)
    {
        [transactionData setObject:[NSString stringWithFormat:@"%.2f", [transaction.cashBackAmount floatValue]] forKey:kCashBackAmount];
    }
    [transactionData setObject:[self notNillObject:transaction.currencyCode] forKey:kCurrencyCode];
    [transactionData setObject:[self notNillObject:transaction.customerPresent] forKey:kCustomerPresent];
    [transactionData setObject:[self notNillObject:transaction.employeeId] forKey:kEmployeeId];
    [transactionData setObject:[self notNillObject:transaction.entryMode] forKey:kEntryMode];
    
    if(transaction.goodsType != nil && ![transaction.goodsType isEqualToString:@""])
    {
        [transactionData setObject:transaction.goodsType forKey:kGoodsType];
    }
    
    [transactionData setObject:[self notNillObject:transaction.laneId] forKey:kLaneId];
    [transactionData setObject:[self notNillObject:transaction.industryType] forKey:kIndustryType];
    [transactionData setObject:[self notNillObject:transaction.invoiceNumber] forKey:kInvoiceNumber];
    [transactionData setObject:[self notNillObject:transaction.orderNumber] forKey:kOrderNumber];
    [transactionData setObject:[NSNumber numberWithBool:transaction.signatureCaptured] forKey:kSignatureCaptured];
    [transactionData setObject:[self notNillObject:transaction.reference] forKey:kReference];
    [transactionData setObject:[self notNillObject:transaction.transactionCode] forKey:kTransactionCode];
    
    
    // FIXME: does not work without terminal id
    [transactionData setObject:[NSNull null] forKey:kTerminalId];
    
    if(transaction.tipAmount != nil && [transaction.tipAmount floatValue] != 0.0f)
    {
        [transactionData setObject:[NSString stringWithFormat:@"%.2f", [transaction.tipAmount floatValue]] forKey:kTipAmount];
        float newAmount = [transaction.amount floatValue] + [transaction.tipAmount floatValue];
        [transactionData setObject:[NSString stringWithFormat:@"%.2f", newAmount] forKey:kAmount];
    }
    
    if(transaction.CFeeAmount != nil && [transaction.CFeeAmount floatValue] != 0.0f)
    {
        [transactionData setObject:[NSString stringWithFormat:@"%.2f", [transaction.CFeeAmount floatValue]] forKey:kCFeeAmount];
    }
    
    [transactionData setObject:[transaction.dateTime stringWithRFC3339Format] forKey:kDateTime];
    
    /*
     * Addendum
     */
    if(transaction.creds != nil)
    {
        NSMutableDictionary *addendum = [NSMutableDictionary dictionary];
        NSMutableDictionary *unmanaged = [NSMutableDictionary dictionary];
        [unmanaged setObject:transaction.creds forKey:kAny];
        [addendum setObject:unmanaged forKey:kUnmanaged];
        
        [bank_trans setObject:addendum forKey:kAddendum];
    }
    
    /*
     * ReportingData
     */
    if(transaction.reportingData != nil)
    {
        NSMutableDictionary *reportingData = [NSMutableDictionary dictionary];
        [reportingData setObject:transaction.reportingData.comments  forKey:kReportingComments];
        [reportingData setObject:transaction.reportingData.description forKey:kReportingDescription];
        [reportingData setObject:transaction.reportingData.reference forKey:kReportingReference];
        [transactionData setObject:reportingData forKey:kReportingData];
    }
    
    
    /*
     * ReportingData
     */
    if(transaction.altMerchantData != nil)
    {
        NSMutableDictionary *alternativeMerchantData = [NSMutableDictionary dictionary];
        
        [alternativeMerchantData setObject:transaction.altMerchantData.customerServicePhone forKey:kAltMerchantCustomerServicePhone];
        [alternativeMerchantData setObject:transaction.altMerchantData.customerServiceInternet forKey:kAltMerchantCustomerServiceInternet];
        [alternativeMerchantData setObject:transaction.altMerchantData.description forKey:kAltMerchantDescription];
        [alternativeMerchantData setObject:transaction.altMerchantData.SIC forKey:kAltMerchantSIC];
        [alternativeMerchantData setObject:transaction.altMerchantData.merchantId forKey:kAltMerchantMerchantId];
        [alternativeMerchantData setObject:transaction.altMerchantData.name forKey:kAltMerchantName];
        
        /*
         * AddressInfo
         */
        NSMutableDictionary *address = [NSMutableDictionary dictionary];
        [address setObject:transaction.altMerchantData.address.street1 forKey:kAdrInfoStreet1];
        [address setObject:transaction.altMerchantData.address.street2 forKey:kAdrInfoStreet2];
        [address setObject:transaction.altMerchantData.address.city forKey:kAdrInfoCity];
        [address setObject:transaction.altMerchantData.address.stateProvince forKey:kAdrInfoStateProvince];
        [address setObject:transaction.altMerchantData.address.postalCode forKey:kAdrInfoPostalCode];
        [address setObject:transaction.altMerchantData.address.countryCode forKey:kAdrInfoCountryCode];
        
        [alternativeMerchantData setObject:address forKey:kAltMerchantAddress];
        
        
        [transactionData setObject:alternativeMerchantData forKey:kAlternativeMerchantData];
    }
    
    //Add Transaction Data object to BankcardTransaction
    [bank_trans setObject:transactionData forKey:kTransactionData];

    return bank_trans;
}





#pragma mark -
#pragma api methods

- (NSDictionary *) authorizeTransaction:(CWSTransactionData *)transactionData withCreditCard:(CWSCreditCard *)creditCard error:(NSError **)error
{
    /* Create transaction data object */
    NSError *transactionError = nil;
    NSMutableDictionary *transactionDataGenerated = [self buildTransactionWithCC:creditCard andTransaction:transactionData error:&transactionError];
    [transactionDataGenerated setObject:@"BankcardTransactionPro,http://schemas.evosnap.com/CWS/v2.0/Transactions/Bankcard/Pro" forKey:kAccountType];
    NSMutableDictionary *postDictionary = [[NSMutableDictionary alloc] init];
    [postDictionary setObject:@"AuthorizeTransaction,http://schemas.evosnap.com/CWS/v2.0/Transactions/Rest" forKey:kAccountType];
    [postDictionary setObject:self.applicationProfileId forKey:kApplicationProfileId];
    [postDictionary setObject:self.merchantProfileId forKey:kMerchantProfileId];
    [postDictionary setObject:transactionDataGenerated forKey:kTransaction];
    InfoLog(@"Generated Dict: \n%@",postDictionary);
    /*
     SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
     NSString *myJsonString = [jsonWriter stringWithObject:postDictionary];
     
     InfoLog(@"MyJSON: \n%@", myJsonString);
     [jsonWriter release];
     */
    NSString *response;
    if (creditCard.securePaymentAccountData != nil)
    {
        response = [self sendToURL:[NSString stringWithFormat:@"%@/Txn/%@", self.baseURL, self.workflowId] withHTTPmethod:@"POST" andBodyJSONOfDict:postDictionary requiresSession:YES error:error];
        InfoLog(@"RESPONSE = \n%@", response);
    }
    else
    {
        response = [self sendToURL:[NSString stringWithFormat:@"%@/Txn/%@", self.baseURL, self.serviceId] withHTTPmethod:@"POST" andBodyJSONOfDict:postDictionary requiresSession:YES error:error];
        InfoLog(@"RESPONSE = \n%@", response);
    }
    
    if (response)
        return (NSDictionary *)[response JSONValue];
    return nil;
}

- (NSDictionary *)getServiceInformation
{
    NSError *error = nil;
    NSString *serviceInformation = [self sendToURL:[NSString stringWithFormat:@"%@/SvcInfo/serviceInformation", self.baseURL] withHTTPmethod:@"GET" andBodyJSONOfDict:nil requiresSession:YES error:&error];
    
    if (serviceInformation == nil)
    {
        InfoLog(@"No service information retrieved. Is identityToken correct?");
        return nil;
    }
    return (NSDictionary *)[serviceInformation JSONValue];
}

- (NSArray *) getSupportedOperations
{
    NSDictionary *serviceInformation = [self getServiceInformation];
    
    if (serviceInformation == nil)
    {
        InfoLog(@"No supported operations.");
        return nil;
    }
    NSArray *servicesSupported = [serviceInformation allValues];
    for (NSArray *singleService in servicesSupported)
    {
        if (singleService)
        {
            for (NSDictionary *serviceData in singleService)
            {
                if ([serviceData objectForKey:kOperations])
                {
                    if ([[serviceData objectForKey:kServiceId] isEqualToString:self.serviceId])
                    {
                        NSArray *allPossibleOperations = [(NSDictionary *)[serviceData objectForKey:kOperations] allKeys];
                        NSDictionary *allPossibleOperationsDict = [serviceData objectForKey:kOperations];
                        NSMutableArray *supportedOperations = [[NSMutableArray alloc] init];
                        for (NSString *operation in allPossibleOperations)
                        {
                            if ([allPossibleOperationsDict[operation] integerValue] == 1)
                            {
                                [supportedOperations addObject:operation];
                            }
                        }
                        return supportedOperations;
                    }
                }
            }
        }
    }
    return nil;
}

- (NSDictionary *) captureTransactionWithId:(NSString *)transactionId forAmount:(NSNumber *)amount andTipAmount:(NSNumber *)tipAmount andCreds:(NSArray *)withCreds withTag:(NSString *)optionalTag error:(NSError **)error
{
    CWSDifferenceData *differenceData = [[CWSDifferenceData alloc] init];
    differenceData.amount = amount;
    differenceData.tipAmount = tipAmount;
    differenceData.transactionID = transactionId;
    differenceData.creds= withCreds;
    NSMutableDictionary *differenceObject = [self buildDifferenceWithDifferenceData:differenceData];
    differenceObject[kAccountType] = @"BankcardCapture,http://schemas.evosnap.com/CWS/v2.0/Transactions/Bankcard";
    
    NSMutableDictionary *putDictionary = [[NSMutableDictionary alloc] init];
    putDictionary[kAccountType] = @"Capture,http://schemas.evosnap.com/CWS/v2.0/Transactions/Rest";
    putDictionary[kApplicationProfileId] = self.applicationProfileId;
    putDictionary[kDifferenceData] = differenceObject;
    InfoLog(@"Generated Dict: \n%@",putDictionary);
    
    NSString *response = [self sendToURL:[NSString stringWithFormat:@"%@/Txn/%@/%@",self.baseURL, self.serviceId, transactionId] withHTTPmethod:@"PUT" andBodyJSONOfDict:putDictionary requiresSession:YES error:error];
    InfoLog(@"CAPTURE RESPONSE = \n%@", response);
    if (response)
        return (NSDictionary *)[response JSONValue];
    return nil;
}

- (NSDictionary *) authorizeAndCaptureTransaction:(CWSTransactionData *)transactionData withCreditCard:(CWSCreditCard *)creditCard  error:(NSError **)error
{
    /* Create transaction data object */
    NSError *transactionError = nil;
    NSMutableDictionary *transactionDataGenerated = [self buildTransactionWithCC:creditCard andTransaction:transactionData error:&transactionError];
    [transactionDataGenerated setObject:@"BankcardTransactionPro,http://schemas.evosnap.com/CWS/v2.0/Transactions/Bankcard/Pro" forKey:kAccountType];
    NSMutableDictionary *postDictionary = [[NSMutableDictionary alloc] init];
    postDictionary[kAccountType] = @"AuthorizeAndCaptureTransaction,http://schemas.evosnap.com/CWS/v2.0/Transactions/Rest";
    postDictionary[kApplicationProfileId] = self.applicationProfileId;
    postDictionary[kMerchantProfileId] = self.merchantProfileId;
    postDictionary[kTransaction] = transactionDataGenerated;
    InfoLog(@"Generated Dict: \n%@",postDictionary);
    
    NSString *response;
    
    if (creditCard.securePaymentAccountData != nil)
    {
        response = [self sendToURL:[NSString stringWithFormat:@"%@/Txn/%@", self.baseURL, self.workflowId] withHTTPmethod:@"POST" andBodyJSONOfDict:postDictionary requiresSession:YES error:error];
        InfoLog(@"RESPONSE = %@", response);
    }
    else
    {
        response = [self sendToURL:[NSString stringWithFormat:@"%@/Txn/%@", self.baseURL, self.serviceId] withHTTPmethod:@"POST" andBodyJSONOfDict:postDictionary requiresSession:YES error:error];
        InfoLog(@"RESPONSE = %@", response);
    }
    if (response)
        return (NSDictionary *)[response JSONValue];
    return nil;

    
    return nil;
}

- (NSDictionary *) adjustTransactionWithId:(NSString *)transactionId withDifferenceData:(CWSDifferenceData *)difference withTag:(NSString *)optionalTag error:(NSError **)error
{
    NSDictionary *differenceDict = [self buildDifferenceWithDifferenceData:difference];
    
    NSMutableDictionary *putDictionary = [[NSMutableDictionary alloc] init];
    putDictionary[kAccountType] = @"Adjust,http://schemas.evosnap.com/CWS/v2.0/Transactions/Rest";
    putDictionary[kApplicationProfileId] = self.applicationProfileId;
    putDictionary[kDifferenceData] = differenceDict;
    InfoLog(@"Generated Dict: \n%@",putDictionary);
    
    NSString *response = [self sendToURL:[NSString stringWithFormat:@"%@/Txn/%@/%@",self.baseURL, self.serviceId, transactionId] withHTTPmethod:@"PUT" andBodyJSONOfDict:putDictionary requiresSession:YES error:error];
    InfoLog(@"ADJUST RESPONSE = \n%@", response);
    if (response)
        return (NSDictionary *)[response JSONValue];
    return nil;
}

- (NSDictionary *) undoTransactionWithId:(NSString *)transactionId andCreds:(NSArray *)withCreds withTag:(NSString *)optionalTag error:(NSError **)error
{
    CWSDifferenceData *differenceData = [[CWSDifferenceData alloc] init];
    differenceData.transactionID = transactionId;
    differenceData.creds= withCreds;
    NSMutableDictionary *differenceObject = [self buildDifferenceWithDifferenceData:differenceData];
    differenceObject[kAccountType] = @"BankcardUndo,http://schemas.evosnap.com/CWS/v2.0/Transactions/Bankcard";
    
    NSMutableDictionary *putDictionary = [[NSMutableDictionary alloc] init];
    putDictionary[kAccountType] = @"Undo,http://schemas.evosnap.com/CWS/v2.0/Transactions/Rest";
    putDictionary[kApplicationProfileId] = self.applicationProfileId;
    putDictionary[kDifferenceData] = differenceObject;
    InfoLog(@"Generated Dict: \n%@",putDictionary);

    NSString *response = [self sendToURL:[NSString stringWithFormat:@"%@/Txn/%@/%@",self.baseURL, self.serviceId, transactionId] withHTTPmethod:@"PUT" andBodyJSONOfDict:putDictionary requiresSession:YES error:error];
    InfoLog(@"UNDO RESPONSE = \n%@", response);
    if (response)
        return (NSDictionary *)[response JSONValue];
    return nil;
}

- (NSDictionary *) returnTransactionWithId:(NSString *)transactionId forAmount:(NSNumber *)amount andCreds:(NSArray *)withCreds withTag:(NSString *)optionalTag error:(NSError **)error
{
    CWSDifferenceData *differenceData = [[CWSDifferenceData alloc] init];
    differenceData.amount = amount;
    differenceData.transactionID  = transactionId;
    differenceData.creds = withCreds;
    NSMutableDictionary *differenceDict = [self buildDifferenceWithDifferenceData:differenceData];
    differenceDict[kAccountType] = @"BankcardReturn,http://schemas.evosnap.com/CWS/v2.0/Transactions/Bankcard";
    
    NSMutableDictionary *postDictionary = [[NSMutableDictionary alloc] init];
    postDictionary[kAccountType] = @"ReturnById,http://schemas.evosnap.com/CWS/v2.0/Transactions/Rest";
    postDictionary[kApplicationProfileId] = self.applicationProfileId;
    postDictionary[kMerchantProfileId] = self.merchantProfileId;
    postDictionary[kDifferenceData] = differenceDict;
    InfoLog(@"Generated Dict: \n%@",postDictionary);
    
    NSString *response = [self sendToURL:[NSString stringWithFormat:@"%@/Txn/%@",self.baseURL, self.serviceId] withHTTPmethod:@"POST" andBodyJSONOfDict:postDictionary requiresSession:YES error:error];
    InfoLog(@"RETURN BY ID RESPONSE = \n%@", response);
    if (response)
        return (NSDictionary *)[response JSONValue];
    return nil;
}

- (NSDictionary *) returnUnlinkedTransaction:(CWSTransactionData *)transactionData withCreditCard:(CWSCreditCard *)creditCard error:(NSError **)error
{
    NSError *transactionError = nil;
    NSMutableDictionary *transactionDataGenerated = [self buildTransactionWithCC:creditCard andTransaction:transactionData error:&transactionError];
    [transactionDataGenerated setObject:@"BankcardTransaction,http://schemas.evosnap.com/CWS/v2.0/Transactions/Bankcard" forKey:kAccountType];
    NSMutableDictionary *postDictionary = [[NSMutableDictionary alloc] init];
    [postDictionary setObject:@"ReturnTransaction,http://schemas.evosnap.com/CWS/v2.0/Transactions/Rest" forKey:kAccountType];
    [postDictionary setObject:self.applicationProfileId forKey:kApplicationProfileId];
    [postDictionary setObject:self.merchantProfileId forKey:kMerchantProfileId];
    [postDictionary setObject:transactionDataGenerated forKey:kTransaction];
    InfoLog(@"Generated Dict: \n%@",postDictionary);
    
    NSString *response = [self sendToURL:[NSString stringWithFormat:@"%@/Txn/%@", self.baseURL, self.serviceId] withHTTPmethod:@"POST" andBodyJSONOfDict:postDictionary requiresSession:YES error:error];
    InfoLog(@"RETURN UNLINKED RESPONSE = \n%@", response);
    
    if (response)
        return (NSDictionary *)[response JSONValue];
    return nil;
}

- (NSDictionary *) captureSelectiveTransactionsWithIds:(NSArray *)transactionIds withDifferenceData:(NSArray *)differences withTag:(NSString *)optionalTag error:(NSError **)error
{
    NSMutableArray *differenceObjects = nil;
    if (differences)
    {
        differenceObjects = [[NSMutableArray alloc] initWithCapacity:[transactionIds count]];
        for (int i=0 ; i < [transactionIds count]; i++)
        {
            NSMutableDictionary *differenceDict = [self buildDifferenceWithDifferenceData:differences[i]];
            differenceDict[kAccountType] = @"BankcardCapture,http://schemas.evosnap.com/CWS/v2.0/Transactions/Bankcard";
            [differenceObjects addObject:differenceDict];
        }
    }
    
    NSMutableDictionary *putDictionary = [[NSMutableDictionary alloc] init];
    putDictionary[kAccountType] = @"CaptureSelectiveAsync,http://schemas.evosnap.com/CWS/v2.0/Transactions/Rest";
    putDictionary[kApplicationProfileId] = self.applicationProfileId;
    putDictionary[kDifferenceData] = differenceObjects?differenceObjects:[NSNull null];
    putDictionary[kTransactionIds] = transactionIds;
    InfoLog(@"Generated Dict: \n%@",putDictionary);
    
    NSString *response = [self sendToURL:[NSString stringWithFormat:@"%@/Txn/%@",self.baseURL, self.serviceId] withHTTPmethod:@"PUT" andBodyJSONOfDict:putDictionary requiresSession:YES error:error];
    InfoLog(@"CAPTURE SELECTIVE RESPONSE = \n%@", response);
    if (response)
        return (NSDictionary *)[response JSONValue];
    return nil;
}

- (NSDictionary *) captureAllTransactionsWithDifferenceData:(NSArray *)differences withTag:(NSString *)optionalTag error:(NSError **)error
{
    NSMutableArray *differenceObjects = nil;
    if (differences)
    {
        differenceObjects = [[NSMutableArray alloc] initWithCapacity:[differences count]];
        for (CWSDifferenceData *differenceData in differences)
        {
            NSMutableDictionary *differenceDict = [self buildDifferenceWithDifferenceData:differenceData];
            differenceDict[kAccountType] = @"BankcardCapture,http://schemas.evosnap.com/CWS/v2.0/Transactions/Bankcard";
            [differenceObjects addObject:differenceDict];

        }
    }
    
    NSMutableDictionary *putDictionary = [[NSMutableDictionary alloc] init];
    putDictionary[kAccountType] = @"CaptureAllAsync,http://schemas.evosnap.com/CWS/v2.0/Transactions/Rest";
    putDictionary[kApplicationProfileId] = self.applicationProfileId;
    putDictionary[kMerchantProfileId] = self.merchantProfileId;
    putDictionary[kDifferenceData] = differenceObjects?differenceObjects:[NSNull null];
    InfoLog(@"Generated Dict: \n%@",putDictionary);
    
    NSString *response = [self sendToURL:[NSString stringWithFormat:@"%@/Txn/%@",self.baseURL, self.serviceId] withHTTPmethod:@"PUT" andBodyJSONOfDict:putDictionary requiresSession:YES error:error];
    InfoLog(@"CAPTURE ALL RESPONSE = \n%@", response);
    if (response)
        return (NSDictionary *)[response JSONValue];
    return nil;
}

- (NSArray *) queryBatchWithTransactionIds:(NSArray *)transactionIds error:(NSError **)error
{
    NSMutableDictionary *postDictionary = [[NSMutableDictionary alloc] init];
    postDictionary[kAccountType] = @"QueryBatch,http://schemas.evosnap.com/CWS/v2.0/DataServices/TMS/Rest";
    postDictionary[kIncludeRelated] = @"true";
    postDictionary[kPagingParameters] = @{ kPage: @"0", kPageSize: @"50"};
    if (transactionIds)
    {
        postDictionary[kQueryBatchParameters] = @{
        kTransactionIds : transactionIds
        };
    }
    InfoLog(@"Generated Dict: \n%@",postDictionary);
    
    NSString *response = [self sendToURL:[NSString stringWithFormat:@"%@/DataServices/TMS/batch",self.baseURL] withHTTPmethod:@"POST" andBodyJSONOfDict:postDictionary requiresSession:YES error:error];
    InfoLog(@"QUESRY BATCH RESPONSE = \n%@", response);
    if (response)
        return (NSArray *)[response JSONValue];
    return nil;
}

@end
