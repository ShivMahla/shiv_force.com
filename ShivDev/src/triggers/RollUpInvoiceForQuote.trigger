// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

trigger RollUpInvoiceForQuote on Invoices__c (After Insert,After Update,After Delete){
//Limit the size of list by using Sets which do not contain duplicate elements
  set<ID> SQIds = new set<ID>();
 
  //When adding new create invoice or updating existing quote
if(trigger.isInsert || trigger.isUpdate){
    for(Invoices__c p : trigger.new){
      SQIds.add(p.Sales_Quote_Id__c);
    }
   
    //Map will contain one quote Id to one Count value(no of Invoice)
  map<Id,Decimal> SalesQuoteMap = new map<Id,Decimal>();
 
  try{
          //use group by to have a single appointment Id with a single sum value
    for(AggregateResult q : [select Sales_Quote_Id__c,Count(Name)from Invoices__c where Sales_Quote_Id__c IN :SQIds group by Sales_Quote_Id__c ]){
              SalesQuoteMap.put((Id)q.get('Sales_Quote_Id__c'),(Double)q.get('expr0'));
     }
  }Catch(Exception e){
             //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please check in invoice and quote');
             //ApexPages.addMessage(myMsg); 
          }      
 
  //List<gii__SalesQuote__c> SalesQuoteToUpdate = new List<gii__SalesQuote__c>();
 
  //Run the for loop on Sales Quote using the non-duplicate set of Sales quote Ids
 /*  try{
   List<Invoices__c> lsti=[select Name,Sales_Quote_Id__c  from Invoices__c where Sales_Quote_Id__c IN :SQIds];   
     for(gii__SalesQuote__c o : [Select Id,Invoice_ID__c , NO_Of_Invoice__c from gii__SalesQuote__c where Id IN :SQIds]){
          for(Invoices__c i : lsti)  {
              if(i.Sales_Quote_Id__c  == o.Id){ 
                  Double QuoteCount = SalesQuoteMap.get(o.Id);
                  //Invoices__c i=[select Name,Sales_Quote_Id__c  from Invoices__c where Sales_Quote_Id__c IN :SQIds Limit 1];
                  o.Invoice_ID__c=i.Name;         
                  o.NO_Of_Invoice__c= QuoteCount;
                  SalesQuoteToUpdate.add(o);
              }
         }
     }
     update SalesQuoteToUpdate;
   }Catch(Exception e){
             //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please check in invoice and quote');
             //ApexPages.addMessage(myMsg); 
          }*/ 
 } 
 
//When deleting created quote
if(trigger.isDelete){
    for(Invoices__c p : trigger.old){
      SQIds.add(p.Sales_Quote_Id__c);
    }
    //Map will contain one appointment Id to one Count value(no of Invoice)
 map<Id,Decimal> SalesQuoteMap = new map<Id,Decimal>();
 
 try{ 
      //use group by to have a single Quote Id with a single sum value
      for(AggregateResult q : [select Sales_Quote_Id__c,Count(Name)from Invoices__c where Sales_Quote_Id__c IN :SQIds group by Sales_Quote_Id__c ]){
          SalesQuoteMap.put((Id)q.get('Sales_Quote_Id__c'),(Double)q.get('expr0'));
        }
    }Catch(Exception e){
             //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please check in invoice and quote');
             //ApexPages.addMessage(myMsg); 
          }
 /* List<gii__SalesQuote__c> SalesQuoteToUpdate = new List<gii__SalesQuote__c>();
 
 try{ //Run the for loop on sales quote using the non-duplicate set of Quote Ids  
  for(gii__SalesQuote__c o : [Select Id,Invoice_ID__c,NO_Of_Invoice__c from gii__SalesQuote__c where Id IN :SQIds]){
          Double QuoteCount = SalesQuoteMap.get(o.Id);      
          o.NO_Of_Invoice__c= QuoteCount;
          o.Invoice_ID__c=String.ValueOf(QuoteCount);
          SalesQuoteToUpdate.add(o);      
   }
   update SalesQuoteToUpdate;
  }Catch(Exception e){
             //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please check in invoice and quote');
             //ApexPages.addMessage(myMsg); 
    } */
  }
}