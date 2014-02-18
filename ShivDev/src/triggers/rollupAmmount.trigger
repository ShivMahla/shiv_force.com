// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

/*
RollUp no. invoive for contact.
Created by:Durgesh choubey K V P Business solution on 9/Aug/2012
*/
trigger rollupAmmount on Invoices__c (after delete, after insert, after update)
{ 
  //Limit the size of list by using Sets which do not contain duplicate elements
  set<ID> OppIds = new set<ID>();
  //When adding new create quote or updating existing Appointment
 if(trigger.isInsert || trigger.isUpdate){
    for(Invoices__c  p : trigger.new){
      OppIds.add(p.Contact_ID__c);
    }
    //Map will contain one appointment Id to one Count value(no of sales quote)
  map<Id,Decimal> AppontmentMap = new map<Id,Decimal>();
  
  //use group by to have a single appointment Id with a single sum value
 
  for(AggregateResult q : [select Contact_ID__c,Sum(Amount_Due__c) from Invoices__c where Contact_ID__c IN :OppIds group by Contact_ID__c]){
              AppontmentMap.put((Id)q.get('Contact_ID__c'),(Double)q.get('expr0'));      
  }       
 
  List<Contact > AppointmentToUpdate = new List<Contact >();
 
  //Run the for loop on appointment using the non-duplicate set of appointment Ids
  //Get the count value from the map and create a list of appointment to update
 
  for(Contact o : [Select Id, Due_Balance__c,Payment_Due_Date__c from Contact where Id IN :OppIds]){
      Double InvoiceCount = AppontmentMap.get(o.Id);      
      Invoices__c i=[select Contact_ID__c,Amount_after_discount__c,Amount_Due__c,Total_Amount__c from Invoices__c where Contact_ID__c IN : OppIds limit 1] ;
         if(i.Amount_after_discount__c > 0){               
          o.Due_Balance__c = InvoiceCount;      
          AppointmentToUpdate.add(o);
      }
   }
  update AppointmentToUpdate;  
 }
 
//When deleting created quote
if(trigger.isDelete){
    for(Invoices__c p : trigger.old){
      OppIds.add(p.Contact_ID__c);
    }
     //Map will contain one appointment Id to one Count value(no of sales quote)
 map<Id,Decimal> AppontmentMap = new map<Id,Decimal>();
 
  //List<Invoices__c > PF=[select Contact_ID__c from Invoices__c where  Contact_ID__c IN:OppIds];
  //use group by to have a single appointment Id with a single sum value
  //if(PF.size()>0)
    //{
  for(AggregateResult q : [select Contact_ID__c,Sum(Amount_Due__c) from Invoices__c where Contact_ID__c IN :OppIds group by Contact_ID__c]){
              AppontmentMap.put((Id)q.get('Contact_ID__c'),(Double)q.get('expr0'));
  }       
  List<Contact > AppointmentToUpdate = new List<Contact >();
 
  //Run the for loop on appointment using the non-duplicate set of appointment Ids
  //Get the count value from the map and create a list of appointment to update
  
    for(Contact o : [Select Id, Due_Balance__c from Contact where Id IN :OppIds]){
              Double InvoiceCount = AppontmentMap.get(o.Id);        
                //o.Due_Balance__c = o.Due_Balance__c-InvoiceCount ;
                     AppointmentToUpdate.add(o);             
    } 
            Update AppointmentToUpdate;       
   // }       
 } 
}