// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

trigger UpdateReferralCard on Payment_Record__c (After Insert,after Update){
List<Referral_Card__c> RC = new List<Referral_Card__c>();
List<Payment_Record__c> UpdatePaymentRecord=new List<Payment_Record__c>();
set<id>  UpdateReferralCard = new set<id>();
    for(Payment_Record__c p:Trigger.new){
        UpdateReferralCard.add(p.Referral_card_ID__c); 
        System.debug('ReferralId'+UpdateReferralCard);    
      }
    //Referral_Card__c Reff=[Select Id,Name,Used_By_Redeemed_Patient__c,Used_By_Referrer_Patient__c from Referral_Card__c Where Id In :UpdateReferralCard];
   for(Payment_Record__c pp : Trigger.new){ 
        try{
             if(pp.Referral_card_ID__c !=null){               
                  Referral_Card__c Reff=[Select Id,Name,Used_By_Redeemed_Patient__c,Used_By_Referrer_Patient__c,Redeemed_Patient_Name__c from Referral_Card__c Where Id In :UpdateReferralCard];
                    if(pp.Referral_Type__c=='Referrer'){
                                  Reff.Used_By_Referrer_Patient__c =True;
                                  RC.add(Reff);
                    }else if(pp.Referral_Type__c=='Redeemed'){
                                  Reff.Used_By_Redeemed_Patient__c=True;
                                  Reff.Redeemed_Patient_Name__c=pp.Patient_Name__c;
                                  RC.add(Reff);
                    }                         
                  Update RC; 
            } 
        }Catch(Exception e){
                 //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please check payment record.');
                 //ApexPages.addMessage(myMsg); 
        }  
    } 
}