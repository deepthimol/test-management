namespace testmanagement;

using {cuid,managed,sap.common.CodeList,Currency,sap.common.Currencies} from '@sap/cds/common';
using from '@sap/cds-common-content';

entity Tests:cuid,managed{
//  key testId:String;
 questions:Association to many Questions on questions.test=$self;
 title:String;
 description:String;
 price:Integer;
 currency:Currency;
 //currency: Association to Currencies;
 supplier:Association to Suppliers;
 rating:Integer;
 
}

entity Questions{
 key questionId:String;
test:Association to one Tests;
text:String;
answers:Composition of one Answers; 
}


// entity sap.common.Currencies : CodeList{
//   key code  : String(3); //> ISO 4217 alpha-3 codes
//    symbol    : String(5); //> for example, $, €, £, ₪, ...
//   minorUnit : Int16;     //> for example, 0 or 2
// }

aspect Answers{
   key answerId:String;
    text:String;
    questions:Composition of one Questions;
}

using {  API_BUSINESS_PARTNER as bupa } from '../srv/external/API_BUSINESS_PARTNER';

    entity Suppliers as projection on bupa.A_BusinessPartner {
        key BusinessPartner as ID,
        BusinessPartnerFullName as fullName,
        BusinessPartnerIsBlocked as isBlocked,
}