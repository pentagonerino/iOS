//
//  Payments.swift
//  SampleApp-Swift
//
//  Created by Alejandro Perezpaya on 24/01/15.
//  Copyright (c) 2015 Punskyy, Roman. All rights reserved.
//

import Foundation

class Payments {
    
    var paymentPlatform = CWSAPI.sharedAPIWithIdentityToken("PHNhbWw6QXNzZXJ0aW9uIE1ham9yVmVyc2lvbj0iMSIgTWlub3JWZXJzaW9uPSIxIiBBc3NlcnRpb25JRD0iXzdmMjUzNjUxLTM4YTMtNDRjNS04Y2U1LWM2NjlmZWRlMDA0ZCIgSXNzdWVyPSJJcGNBdXRoZW50aWNhdGlvbiIgSXNzdWVJbnN0YW50PSIyMDE1LTAxLTE1VDA2OjA5OjM5LjE1NVoiIHhtbG5zOnNhbWw9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjEuMDphc3NlcnRpb24iPjxzYW1sOkNvbmRpdGlvbnMgTm90QmVmb3JlPSIyMDE1LTAxLTE1VDA2OjA5OjM5LjE1NVoiIE5vdE9uT3JBZnRlcj0iMjAxOC0wMS0xNVQwNjowOTozOS4xNTVaIj48L3NhbWw6Q29uZGl0aW9ucz48c2FtbDpBZHZpY2U+PC9zYW1sOkFkdmljZT48c2FtbDpBdHRyaWJ1dGVTdGF0ZW1lbnQ+PHNhbWw6U3ViamVjdD48c2FtbDpOYW1lSWRlbnRpZmllcj5BQTZGQzY5QzRERjAwMDAxPC9zYW1sOk5hbWVJZGVudGlmaWVyPjwvc2FtbDpTdWJqZWN0PjxzYW1sOkF0dHJpYnV0ZSBBdHRyaWJ1dGVOYW1lPSJTQUsiIEF0dHJpYnV0ZU5hbWVzcGFjZT0iaHR0cDovL3NjaGVtYXMuaXBjb21tZXJjZS5jb20vSWRlbnRpdHkiPjxzYW1sOkF0dHJpYnV0ZVZhbHVlPkFBNkZDNjlDNERGMDAwMDE8L3NhbWw6QXR0cmlidXRlVmFsdWU+PC9zYW1sOkF0dHJpYnV0ZT48c2FtbDpBdHRyaWJ1dGUgQXR0cmlidXRlTmFtZT0iU2VyaWFsIiBBdHRyaWJ1dGVOYW1lc3BhY2U9Imh0dHA6Ly9zY2hlbWFzLmlwY29tbWVyY2UuY29tL0lkZW50aXR5Ij48c2FtbDpBdHRyaWJ1dGVWYWx1ZT40MmU0ZGY1Mi05M2E4LTQ4NzMtODZkZC1hODkyZjdjOTQxYjQ8L3NhbWw6QXR0cmlidXRlVmFsdWU+PC9zYW1sOkF0dHJpYnV0ZT48c2FtbDpBdHRyaWJ1dGUgQXR0cmlidXRlTmFtZT0ibmFtZSIgQXR0cmlidXRlTmFtZXNwYWNlPSJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcyI+PHNhbWw6QXR0cmlidXRlVmFsdWU+QUE2RkM2OUM0REYwMDAwMTwvc2FtbDpBdHRyaWJ1dGVWYWx1ZT48L3NhbWw6QXR0cmlidXRlPjwvc2FtbDpBdHRyaWJ1dGVTdGF0ZW1lbnQ+PFNpZ25hdHVyZSB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+PFNpZ25lZEluZm8+PENhbm9uaWNhbGl6YXRpb25NZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzEwL3htbC1leGMtYzE0biMiPjwvQ2Fub25pY2FsaXphdGlvbk1ldGhvZD48U2lnbmF0dXJlTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI3JzYS1zaGExIj48L1NpZ25hdHVyZU1ldGhvZD48UmVmZXJlbmNlIFVSST0iI183ZjI1MzY1MS0zOGEzLTQ0YzUtOGNlNS1jNjY5ZmVkZTAwNGQiPjxUcmFuc2Zvcm1zPjxUcmFuc2Zvcm0gQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjZW52ZWxvcGVkLXNpZ25hdHVyZSI+PC9UcmFuc2Zvcm0+PFRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMTAveG1sLWV4Yy1jMTRuIyI+PC9UcmFuc2Zvcm0+PC9UcmFuc2Zvcm1zPjxEaWdlc3RNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjc2hhMSI+PC9EaWdlc3RNZXRob2Q+PERpZ2VzdFZhbHVlPkEzRkplMUF1NnhVdHdIRkJaOXdBL3lDVWdNbz08L0RpZ2VzdFZhbHVlPjwvUmVmZXJlbmNlPjwvU2lnbmVkSW5mbz48U2lnbmF0dXJlVmFsdWU+UkVScXhsZTEvRjlGTVNlNldqQW9iT1k4RllQaURmOUErZkwrak52Mk1BWXUralhQNW9aVjZ4dnUwbGJhSDdLVkhpVGd5dFNXTWVadDI1VHByOHRWL0Fka1JsVk5QTkYwb01xMENQNTQyelp0QS94UW91cVBDR2ZoeXl5b0Z2OHcxb3lhRGdZdG10R0hPejFoN3E5MUlBUUszSHFkSm1WUitWNHNqZEV4ODFHUEw1NWtVdWdFcEJXcHgvTE1NQStLWFFEeWNqR2ExQXdFZTJza2VjSFJlWWQ4dU1pKzRNcUM2N25LMDVlZG5SaVV3WThhUnZ3Z1d3WlkrOVdlYUF0U0xzRE84ODVPc3Y4NGtPWkN3TDZmbTFlYUtKdUlCZUNYL1AxZXZUQlFuWEZYbDA3OVNEbHU5akJ2dFJma2N3MTNuZzA4ajNtMTVRMXM0Tnk4ZG1PWGJ3PT08L1NpZ25hdHVyZVZhbHVlPjxLZXlJbmZvPjxvOlNlY3VyaXR5VG9rZW5SZWZlcmVuY2UgeG1sbnM6bz0iaHR0cDovL2RvY3Mub2FzaXMtb3Blbi5vcmcvd3NzLzIwMDQvMDEvb2FzaXMtMjAwNDAxLXdzcy13c3NlY3VyaXR5LXNlY2V4dC0xLjAueHNkIj48bzpLZXlJZGVudGlmaWVyIFZhbHVlVHlwZT0iaHR0cDovL2RvY3Mub2FzaXMtb3Blbi5vcmcvd3NzL29hc2lzLXdzcy1zb2FwLW1lc3NhZ2Utc2VjdXJpdHktMS4xI1RodW1icHJpbnRTSEExIj5iQkcwU0cvd2RCNWJ4eVpyYjEvbTVLakhLMU09PC9vOktleUlkZW50aWZpZXI+PC9vOlNlY3VyaXR5VG9rZW5SZWZlcmVuY2U+PC9LZXlJbmZvPjwvU2lnbmF0dXJlPjwvc2FtbDpBc3NlcnRpb24+",
        andBaseURL: "https://api.cipcert.goevo.com/REST/2.0.22",
        andMerchantProfileId: "SNAP_00006",
        andServiceId: "DF83D00001",
        andWorkflowId: "",
        andApplicationProfileId: "72446",
        error: nil)

    init () {
        
    }
    
    func chargePayment (cardType: String, cardNumber: String, expiration: String, price: Double) -> (Bool){

        var a : CWSCreditCard = CWSCreditCard()
        
        a.type = cardType
        a.number = cardNumber
        a.expiration = expiration
        a.name = nil
        
        a.track1 = nil
        a.track2 = nil
        a.address = nil
        a.city = nil
        a.state = nil
        a.zip = nil
        a.country = nil
        a.phone = nil
        a.cvv = "111"
        
        var transactionData : CWSTransactionData = CWSTransactionData()
        /* For authorize */
        transactionData.accountType = "BankcardTransactionDataPro,http://schemas.evosnap.com/CWS/v2.0/Transactions/Bankcard/Pro"
        transactionData.accountType = nil
        transactionData.approvalCode = nil//nil
        transactionData.cashBackAmount = nil//nil
        transactionData.currencyCode = "EUR"
        transactionData.customerPresent = "Present"
        transactionData.employeeId = "1"
        transactionData.entryMode = "Keyed"
        transactionData.goodsType = ""
        transactionData.laneId = "1"
        transactionData.industryType = "Retail"
        transactionData.invoiceNumber = nil
        transactionData.orderNumber = "1"
        transactionData.signatureCaptured = false
        transactionData.tipAmount = 0.00
        transactionData.amount = price
        transactionData.CFeeAmount = 1.00
        var date = NSDate()
        transactionData.dateTime = date
        transactionData.reference = "1122432" // Should be unique
        transactionData.transactionCode = "NotSet"
        
        var response = paymentPlatform.authorizeTransaction(transactionData, withCreditCard: a, error: nil)
        
        if (response["Status"] as String) == "Successful" {
            return true
        } else {
            return false
        }
        
        
    }
    
    
    
}