// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

trigger TreatmentSeriesQuantity on Treatments__c ( before insert,before update) {
   Set<String> TreatmentsSet = new   Set<String>();
   for( Treatments__c Treatment : trigger.new )
   {
    if( Treatment.Treatment_Name__c != null  ) 
         TreatmentsSet.add(Treatment.Treatment_Name__c);
   }
  
   Map<id,Treatments1__c> Treatments1Map  =  new Map<id,Treatments1__c>( [  Select id ,Type__c , Series_Quantity__c from  Treatments1__c where id =: TreatmentsSet  ] );
   for( Treatments__c Treatment : trigger.new )
   {
      if( Treatments1Map.get(Treatment.Treatment_Name__c   ).Type__c == 'Series') 
          Treatment.of_Treatment__c = Treatments1Map.get(Treatment.Treatment_Name__c   ).Series_Quantity__c ;
   }
}