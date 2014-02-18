// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

trigger CreateTaskForPatient on Referral_Card__c (After insert,After Update)
{
List<Task> taskInsert = new List<Task>();
List<Referral_Card__c> UpdateReferralCard=New List<Referral_Card__c>();
if(Trigger.IsInsert)
{
for(Referral_Card__c RC : Trigger.new)
{
  try{
     if(RC.Redeemed_Patient_Name__c!= null)
     {
          task tsk=New Task();
          tsk.WhatId=RC.Id;
          tsk.WhoId=RC.Patient_Name__c;
          tsk.Subject='Referral card-FollowUp';          
          tsk.ActivityDate=RC.LastModifiedDate.Date()+14;
          taskInsert.add(tsk);
     }   
  Insert taskInsert;
 }
  Catch(Exception e)
          {
             //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please check referral card or payment record');
             //ApexPages.addMessage(myMsg); 
          } 
}
}
if(Trigger.IsUpdate)
{
for(Referral_Card__c RC : Trigger.new)
{
  try{
    Referral_Card__c oldOpp = Trigger.oldMap.get(RC.Id);
    if(RC.Redeemed_Patient_Name__c!= null && oldOpp.Redeemed_Patient_Name__c != RC.Redeemed_Patient_Name__c)
     {
          task tsk=New Task();
          tsk.WhatId=RC.Id;
          tsk.WhoId=RC.Patient_Name__c;
          tsk.Subject='Referral card-FollowUp';          
          tsk.ActivityDate=RC.LastModifiedDate.Date()+14;
          taskInsert.add(tsk);
          Insert taskInsert;
     }
   }
    Catch(Exception e)
          {
             //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please check Referral card object');
             //ApexPages.addMessage(myMsg); 
          }  
}
 //Update UpdateReferralCard; 
}
}