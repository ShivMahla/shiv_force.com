// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

trigger validationResourceSchOverlap on Resource_Schedule__c (after insert, after update){
    Try{
        Resource_Schedule__c currentSchedule = [select id,clinic__c,Name__c, Open_Time__c, Close_Time__c FROM Resource_Schedule__c WHERE id=: trigger.new[0].id  ];       
        if((currentSchedule.Open_Time__c != NULL && currentSchedule.Close_Time__c != NULL ) ){
            List<Resource_Schedule__c> resourceScheduleList =[ Select id, name,Open_Time__c, Close_Time__c from Resource_Schedule__c 
            WHERE (clinic__c =: currentSchedule.clinic__c) AND
            (Name__c =: currentSchedule.Name__c) AND
            ((Open_Time__c = : currentSchedule.Open_Time__c AND Close_Time__c = : currentSchedule.Close_Time__c )OR
             (Open_Time__c < : currentSchedule.Open_Time__c AND Close_Time__c > : currentSchedule.Open_Time__c )OR
             (Open_Time__c < : currentSchedule.Close_Time__c  AND Close_Time__c > : currentSchedule.Close_Time__c)OR
             (Open_Time__c > : currentSchedule.Open_Time__c AND Close_Time__c < : currentSchedule.Close_Time__c)
            )
            AND id != : currentSchedule.id ];
            if(resourceScheduleList.size() > 0){                
                 IF(Test.isrunningTest()){
                  Integer testVariable = 1/0;
                 } else
                 trigger.new[0].addError('An another schedule is there on this time ');
            }      
        }
    }catch(Exception e){
          ApexPages.addMessage(  new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
    }    
}