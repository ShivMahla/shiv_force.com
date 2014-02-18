// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

/*
RollUp no. of appointment for change stage as cash out.
Created by:Durgesh choubey K V P Business solution on 9/Aug/2012
*/
trigger rollupappointmentInvoice on Invoices__c (after insert, after update, after delete)
{ 
  //Limit the size of list by using Sets which do not contain duplicate elements
  set<ID> OppIds = new set<ID>();
 // List<gii__SalesQuote__c > SQ=new List<gii__SalesQuote__c >();
 // gii__SalesQuote__c oldOpp = Trigger.oldMap.get(SQ.Id);
  //When adding new create quote or updating existing Appointment
 if(trigger.isInsert || trigger.isUpdate)
  {
    for(Invoices__c  p : trigger.new)
    {
      OppIds.add(p.Appointment_Name__c);
    }
    //Map will contain one appointment Id to one Count value(no of sales quote)
  map<Id,Decimal> AppontmentMap = new map<Id,Decimal>();
 
  
  //use group by to have a single appointment Id with a single sum value
 
      for(AggregateResult q : [select Appointment_Name__c,Count(Name)from Invoices__c where Appointment_Name__c IN :OppIds group by Appointment_Name__c])
        {
          AppontmentMap.put((Id)q.get('Appointment_Name__c'),(Double)q.get('expr0'));
         
 
  List<opportunity> AppointmentToUpdate = new List<opportunity>();
 
  //Run the for loop on appointment using the non-duplicate set of appointment Ids
  //Get the count value from the map and create a list of appointment to update
  
  for(Opportunity o : [Select Id, No_Of_Invoice__c from opportunity where Id IN :OppIds])  
   {
      Double InvoiceCount = AppontmentMap.get(o.Id);
      
      Invoices__c i =[select Total_Amount__c,Amount_after_discount__c,Amount_Due__c  from Invoices__c where Appointment_Name__c IN :OppIds Limit 1];
      o.No_of_qoute__c = InvoiceCount;
      //AppointmentToUpdate.add(o);
      System.debug('Update appointment'+i.Total_Amount__c +i.Amount_after_discount__c  );
      if(i.Total_Amount__c >0 && i.Amount_Due__c==0 && i.Amount_after_discount__c>0)
       {
         o.stageName='Cashed out';
         AppointmentToUpdate.add(o);
       }             
      
   }
   update AppointmentToUpdate;
 
 }
} 
//When deleting created quote
if(trigger.isDelete)
  {
    for(Invoices__c p : trigger.old)
    {
      OppIds.add(p.Appointment_Name__c);
    }
     //Map will contain one appointment Id to one Count value(no of sales quote)
  map<Id,Decimal> AppontmentMap = new map<Id,Decimal>();
 
  
  //use group by to have a single appointment Id with a single sum value
  for(AggregateResult q : [select Appointment_Name__c,Count(Name)from Invoices__c where Appointment_Name__c IN :OppIds group by Appointment_Name__c])
    {
      AppontmentMap.put((Id)q.get('Appointment_Name__c'),(Double)q.get('expr0'));
    }
   
  List<opportunity> AppointmentToUpdate = new List<opportunity>();
 
  //Run the for loop on appointment using the non-duplicate set of appointment Ids
  //Get the count value from the map and create a list of appointment to update
 
  for(Opportunity o : [Select Id, No_Of_Invoice__c from opportunity where Id IN :OppIds])  
   {
      Double InvoiceCount = AppontmentMap.get(o.Id);     
      o.No_of_qoute__c = InvoiceCount;
      AppointmentToUpdate.add(o);      
   }
   update AppointmentToUpdate;
  
 }
 
}