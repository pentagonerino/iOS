
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
//  CWSTransactionData.h//  Created by Darren Adelgren on 12/30/13.
//

#import <Foundation/Foundation.h>

@class CWSTransactionReportingData;
@class CWSAlternativeMerchantData;

@interface CWSTransactionData : NSObject
{
}

@property (nonatomic, strong) NSString *invoiceNumber;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *customerPresent;
@property (nonatomic, strong) NSString *employeeId;
@property (nonatomic, strong) NSString *entryMode;
@property (nonatomic, strong) NSString *goodsType;
@property (nonatomic, strong) NSString *laneId;
@property (nonatomic, strong) NSString *industryType;
@property (nonatomic, strong) NSString *accountType;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *CFeeAmount;
@property (nonatomic, strong) NSNumber *cashBackAmount;
@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSString *reference;
@property (nonatomic, getter=isSignatureCaptured) BOOL signatureCaptured;
@property (nonatomic, strong) NSNumber *tipAmount;
@property (nonatomic, strong) NSString *approvalCode;
@property (nonatomic, strong) NSArray *creds;
@property (nonatomic, strong) NSDate *dateTime;
@property (nonatomic, strong) NSString *transactionCode;
@property (nonatomic, strong) CWSTransactionReportingData *reportingData;
@property (nonatomic, strong) CWSAlternativeMerchantData *altMerchantData;

@end
