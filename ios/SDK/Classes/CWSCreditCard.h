
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
//  CWSCreditCard.h
//  Created by Darren Adelgren on 12/30/13.
//

#import <Foundation/Foundation.h>

@interface CWSCreditCard : NSObject
{
	    
}

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *expiration;
@property (nonatomic, strong) NSString *cvv;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *track1;
@property (nonatomic, strong) NSString *track2;
@property (nonatomic, strong) NSString *encryptionKeyId;
@property (nonatomic, strong) NSString *securePaymentAccountData;
@property (nonatomic, strong) NSString *identificationInformation;
@property (nonatomic, strong) NSString *swipeStatus;
@property (nonatomic, strong) NSString *paymentAccountDataToken;
@property (nonatomic, strong) NSString *deviceSerialNumber;

@end
