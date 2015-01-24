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
//  CWSAPI.h
//  CWSAPI
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CWSCreditCard.h"
#import "CWSTransactionData.h"
#import "CWSDifferenceData.h"

@interface CWSAPI : NSObject


/**
* sharedAPIWithKey:
*
* Initializes the CWSAPI API with the provided credentials. The credentials provided 
* determines the type of operations can performed. You can inspect the operations supported
* by calling getServiceInformation
*
* Parameters:
*  - identityToken: The identity token for access to EVO Payments International.  
*  - baseURL: The base URL of the endpoint connecting to
*  - merchantProfileId: The merchant id
*  - serviceId: The service id
*  - workflowId: The workflow id
*  - applicationProfileId: the application id.
*  - error: out parameter used if an error occurs while processing the request. May be NULL.
*
* Return Value:
* The singleton CWSAPI, or nil if an error occured.
* 
* Discussion:
* Calling this method first before any other is required, it is therefore strongly 
* recommended that you call this in applicationDidFinishLaunching: of your app delegate. 
*/
+ (CWSAPI *) sharedAPIWithIdentityToken:(NSString *)identityToken
                             andBaseURL:(NSString *)baseURL
                   andMerchantProfileId:(NSString *)merchantProfileId
                           andServiceId:(NSString *)serviceId
                          andWorkflowId:(NSString *)workflowId
                andApplicationProfileId:(NSString *)applicationProfileId
                                  error:(NSError **)error;

/**
* sharedAPI
*
* Returns the singleton CWSAPI object previously initialized with sharedAPIWithIdentityToken:
* 
* Return Value:
* The singleton CWSAPI object, or nil if sharedAPIWithIdentityToken: has not been called. 
*/
+ (CWSAPI *) sharedAPI;


/**
 * getServiceInformation
 *
 * Returns the service information for the credentials you provided when calling the API. 
 * Included in this is the supported operations.
 *
 * Return Value:
 * An NSDictionary passed through from the CWS API.
 *
 * Discussion:
 * This is different from getSupportedOperations in that it returns the full ServiceInformation object
 * from CWS. If you're just looking for what operations are available, consider using getSupportedOperations
 */
- (NSDictionary *) getServiceInformation;


/**
 * getSupportedOperations
 *
 * A convenience method. Returns an NSArray of just string names of the operations supported.
 * An identical result can be obtained by parsing out the information from the getServiceInformation call
 *
 * Return Value:
 * An NSArray of supported operations
 *
 * Discussion:
 * This is different from getServiceInformation in that it only returns the supported operations, which is
 * the most frequently checked parameter from the getServiceInformation call.
 */
- (NSArray *) getSupportedOperations;

/**
 * Authorize
 * authorizeTransaction:withCreditCard:
 *
 * This method is used to authorize transactions by performing a check on cardholder's funds and reserves 
 * the authorization amount if sufficient funds are available. 
 * Unlike the authorizeAndCaptureTransaction:withCreditCard: operation, transactions authorized using this method
 * must then be flagged for settlement by invoking one of the capture operations.
 *
 * Parameters:
 *  - transactionData: an object containing the information of the transaction to be authorized.
 *  - creditCard: an object containing the credit card information to use to authorize the transaction.
 *  - error: out parameter used if an error occurs while processing the request. May be NULL.
 *
 * Return Value:
 * An NSDictionary containing the full BankcardTransactionResponsePro response from CWS, or nil if an error occured.
 * 
 * Discussion:
 * This method is available if the getSupportedOperations return includes "Authorize". 
 */
- (NSDictionary *) authorizeTransaction:(CWSTransactionData *)transactionData withCreditCard:(CWSCreditCard *)creditCard error:(NSError **)error;




/**
 * Capture
 * captureTransactionWithId:forAmount:andTipAmount:withTag:error:
 *
 * This method is used to capture a single transaction for settlement after it has been successfully authorized by 
 * the authorizeTransaction:withCreditCard: method.
 *
 * Parameters:
 *  - transactionId: the ID of the transaction to capture.
 *  - amount: the amount to charge for the transaction, if different than the authorized amount. Optional.
 *  - tipAmount: the amount of tip to add to the transaction. Optional.
 *  - optionalTag: an optional, service specific string (can be XML). Optional.
 *  - error: out parameter used if an error occurs while processing the request. May be NULL.
 *
 * Return Value:
 * An NSDictionary containing the full BankcardCaptureResponse response from CWS, or nil if an error occured.
 *
 * Discussion:
 * This method is available if the getSupportedOperations return includes "Capture".
 */
- (NSDictionary *) captureTransactionWithId:(NSString *)transactionId forAmount:(NSNumber *)amount andTipAmount:(NSNumber *)tipAmount andCreds:(NSArray *)withCreds withTag:(NSString *)optionalTag error:(NSError **)error;

/**
 * AuthAndCapture
 * authorizeAndCaptureTransaction:withCreditCard:error:
 *
 * This method is used to authorize transactions by performing a check on cardholder's funds and reserves the 
 * authorization amount if sufficient funds are available, followed by flagging the transaction for capture 
 * (settlement) in a single invocation.
 * Unlike the authorizeTransaction:withCreditCard: operation, that means there is no need to make a seperate 
 * capture* call.
 *
 * Parameters:
 *  - transactionData: an object containing the information of the transaction to be authorized.
 *  - creditCard: an object containing the credit card information to use to authorize the transaction.
 *  - error: out parameter used if an error occurs while processing the request. May be NULL.
 *
 *
 * Return Value:
 * An NSDictionary containing the full BankcardTransactionResponsePro response from CWS, or nil if an error occured.
 *
 * Discussion:
 * This method is available if the getSupportedOperations return includes "AuthAndCapture". 
 */
- (NSDictionary *) authorizeAndCaptureTransaction:(CWSTransactionData *)transactionData withCreditCard:(CWSCreditCard *)creditCard  error:(NSError **)error;





/**
 * Adjust
 * adjustTransactionWithId:withDifferenceData:withTag:error:
 *
 * This method is used to make adjustments to a previously authorized amount (incremental or reversal) prior to capture/settlement.
 *
 * Parameters:
 *  - transactionId: the ID of the transaction to undo.
 *  - difference: the difference between the authorized transaction and the desired transaction.
 *  - optionalTag: an optional, service specific string (can be XML). Optional.
 *  - error: out parameter used if an error occurs while processing the request. May be NULL.
 *
 * Return Value:
 * An NSDictionary containing the full BankcardTransactionResponsePro response from CWS, or nil if an error occured.
 *
 * Discussion:
 * This method is available if the getSupportedOperations return includes "Adjust".
 */
- (NSDictionary *) adjustTransactionWithId:(NSString *)transactionId withDifferenceData:(CWSDifferenceData *)difference withTag:(NSString *)optionalTag error:(NSError **)error;



/**
 * Undo
 * undoTransactionWithId:withTag:error:
 *
 * This method is used to release cardholder funds by performing a void on a previously authorized transaction 
 * that has not been captured (flagged) for settlement.
 * The fundamental difference between this method and returnUnlinkedTransaction:withCreditCard: (ReturnUnlinked) 
 * is that this method is used to void or reverse a previously authorized transaction, while ReturnUnlinked can 
 * only be used to return funds for a transaction that has been previously flagged for capture.
 *
 * Parameters:
 *  - transactionId: the ID of the transaction to undo.
 *  - optionalTag: an optional, service specific string (can be XML). Optional.
 *  - error: out parameter used if an error occurs while processing the request. May be NULL.
 *
 * Return Value:
 * An NSDictionary containing the full BankcardTransactionResponsePro response from CWS, or nil if an error occured.
 * 
 * Discussion:
 * This method is available if the getSupportedOperations return includes "Undo".
 */
- (NSDictionary *) undoTransactionWithId:(NSString *)transactionId andCreds:(NSArray *)withCreds withTag:(NSString *)optionalTag error:(NSError **)error;


/**
 * ReturnById
 * returnTransactionWithId:forAmount:andTipAmount:withTag:error:
 *
 * This method is used to perform a linked credit (refund) to a cardholder’s account from the merchant’s account based 
 * on a previously authorized and settled transaction.
 *
 * Parameters:
 *  - transactionId: the ID of the transaction to return
 *  - amount: the amount to return, if different than the charged amount. Optional.
 *  - optionalTag: an optional, service specific string (can be XML). Optional.
 *  - error: out parameter used if an error occurs while processing the request. May be NULL.
 *
 * Return Value:
 * An NSDictionary containing the full BankcardTransactionResponsePro response from CWS, or nil if an error occured.
 * 
 * Discussion:
 * This method is available if the getSupportedOperations return includes "ReturnById". If you do not have the transaction id
 * you should use refundUnlinkedTransaction:
 */
- (NSDictionary *) returnTransactionWithId:(NSString *)transactionId forAmount:(NSNumber *)amount andCreds:(NSArray *)withCreds withTag:(NSString *)optionalTag error:(NSError **)error;


/**
 * ReturnUnlinked
 * returnUnlinkedTransaction:withCreditCard:error:
 *
 * This method is used to perform an "unlinked", or standalone, credit to a cardholder’s account from the 
 * merchant’s account. 
 * This is useful when a return transaction is not associated with a previously authorized and settled transaction.
 *
 * Parameters:
 *  - transactionData: an object containing the information of the transaction (amount) to be returned.
 *  - creditCard: an object containing the credit card information to refund to.
 *  - error: out parameter used if an error occurs while processing the request. May be NULL.
 *
 *
 * Return Value:
 * An NSDictionary containing the full BankcardTransactionResponsePro response from CWS, or nil if an error occured.
 * 
 * Discussion:
 * This method is available if the getSupportedOperations return includes "ReturnUnlinked".
 */
- (NSDictionary *) returnUnlinkedTransaction:(CWSTransactionData *)transactionData withCreditCard:(CWSCreditCard *)creditCard error:(NSError **)error;



/**
 * CaptureSelective
 * captureSelectiveTransactionsWithIds:withDifferenceData:withTag:error:
 *
 * This method is used to flag a specific list of transactions (by transactionId) for settlement 
 * that have been successfully authorized.
 *
 * Parameters:
 *  - transactionIds: an array of the transactionIds of the transactions to be captured.
 *  - differences: an array of changes to make to the transaction prior to capture (differences is a subset of transactionsIds).
 *  - optionalTag: an optional, service specific string (can be XML). Optional.
 *  - callback: A delegate that gets call when a response is ready. Optional.
 *  - error: out parameter used if an error occurs while processing the request. May be NULL.
 * 
 * Discussion:
 * This method actually calls the CaptureSelectiveAsync API call. 
 * This method is available if the getSupportedOperations return includes "CaptureSelective".
 */
- (NSDictionary *) captureSelectiveTransactionsWithIds:(NSArray *)transactionIds withDifferenceData:(NSArray *)differences withTag:(NSString *)optionalTag error:(NSError **)error;

/**
 * CaptureAll
 * captureAllTransactionsWithDifferenceData:withTag:error:
 *
 * This method is used to flag all transactions for settlement that have been successfully authorized using the Authorize 
 * operation
 *
 * Parameters:
 *  - differences: an array of changes to make to the transaction prior to capture.
 *  - optionalTag: an optional, service specific string (can be XML). Optional.
 *  - error: out parameter used if an error occurs while processing the request. May be NULL.
 * 
 * Discussion:
 * This method actually calls the CaptureAllAsync API call. 
 * This method is available if the getSupportedOperations return includes "CaptureAll".
 */
- (NSDictionary *) captureAllTransactionsWithDifferenceData:(NSArray *)differences withTag:(NSString *)optionalTag error:(NSError **)error;


/**
 * QueryBatch
 * queryBatchWithTransactionIds:error:
 *
 * This method queries for the results from the captureSelective and captureAll methods. 
 * If you want to restrict the query to specific transaction ids, you can specify
 * these. If left as null, this will return the state of all unsettled transaction in the last 90 days
 *
 * Parameters:
 *  - transactionIds: an array of transaction ids to check for. If nil, will check all transactions
 *  - error: out parameter used if an error occurs while processing the request. May be NULL.
 *
 *
 * Return Value:
 * An NSArray of the full BatchDetailData response from CWS, or nil if an error occured. 
 * 
 */
- (NSArray *) queryBatchWithTransactionIds:(NSArray *)transactionIds error:(NSError **)error;


@end
