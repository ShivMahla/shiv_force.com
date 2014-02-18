// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

trigger TreatmentPrice on Treatments__c (After Insert,After Update,After Delete)
{
 //Limit the size of list by using Sets which do not contain duplicate elements
  set<ID> SQIds = new set<ID>();
  set<ID> PTIDs=new set<ID>();
  set<string> PFamily=new set<string>(); 
  //When adding new create invoice or updating existing quote
 
if(trigger.isInsert || trigger.isUpdate)
{
    for(Treatments__c p : trigger.new)
    {
      SQIds.add(p.Sales_Quote_Id__c);
      PTIDs.add(p.Treatment_Name__c);
    }
   
  //Map will contain one quote Id to one Count value(no of Invoice)
  map<Id,Decimal> SalesQuoteMap = new map<Id,Decimal>(); 
 
try{  
  List<Treatments__c > PF=[select id,Treatment_Name__c from Treatments__c where Sales_Quote_Id__c  IN :SQIds AND Treatment_Name__c IN :PTIDs ];
  //use group by to have a single appointment Id with a single sum value
  for(AggregateResult q : [select Sales_Quote_Id__c,SUM(Total_Price__c) from Treatments__c where Sales_Quote_Id__c IN :SQIds group by Sales_Quote_Id__c])
    {
      SalesQuoteMap.put((Id)q.get('Sales_Quote_Id__c'),(Double)q.get('expr0'));      
    }
   
 
 /* List<gii__SalesQuote__c> SalesQuoteToUpdate = new List<gii__SalesQuote__c>();
 
  //Run the for loop on Sales Quote using the non-duplicate set of Sales quote Ids  
  for(gii__SalesQuote__c o : [Select Id,Treatment_Discount__c,Estimated_cost__c from gii__SalesQuote__c where Id IN :SQIds])  
   {
      Double QuoteCount = SalesQuoteMap.get(o.Id);              
      o.Estimated_cost__c =QuoteCount ;
      
      SalesQuoteToUpdate.add(o);
   }
   update SalesQuoteToUpdate;*/
 }
  Catch(Exception e)
          {
             //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please check treatment object');
             //ApexPages.addMessage(myMsg); 
             for(Treatments__c t :trigger.new)
             {
               //t.addError('Please check treatment object');
             }
          }  
 }
 
//When deleting created quote
if(trigger.isDelete)
{
    for(Treatments__c p : trigger.old)
    {
      SQIds.add(p.Sales_Quote_Id__c); 
       system.debug('Quote id'+SQIds);
       PFamily.add(p.Name);
    }
    //Map will contain one appointment Id to one Count value(no of Invoice)
  map<Id,Decimal> SalesQuoteMap = new map<Id,Decimal>(); 
  List<Treatments__c > PF=[select id,Name,Sales_Quote_Id__c from Treatments__c where Sales_Quote_Id__c  IN :SQIds AND Name=:PFamily];
     
  //use group by to have a single Quote Id with a single sum value
if(PF.size()>0)
{ 
  for(AggregateResult q : [select Sales_Quote_Id__c,SUM(Total_Price__c) from Treatments__c where Name=:PFamily AND Sales_Quote_Id__c IN :SQIds group by Sales_Quote_Id__c])
    {
      SalesQuoteMap.put((Id)q.get('Sales_Quote_Id__c'),(Double)q.get('expr0'));
    }
   
 /*
  List<gii__SalesQuote__c> SalesQuoteToUpdate = new List<gii__SalesQuote__c>();
 
  //Run the for loop on sales quote using the non-duplicate set of Quote Ids  
  for(gii__SalesQuote__c o : [Select Id, Treatment_Discount__c,Estimated_cost__c from gii__SalesQuote__c where Id IN :SQIds])  
   {
      Double QuoteCount = SalesQuoteMap.get(o.Id);    
      o.Estimated_cost__c =o.Estimated_cost__c-QuoteCount;
      SalesQuoteToUpdate.add(o);
           
   }
   update SalesQuoteToUpdate; */
  }
}
}