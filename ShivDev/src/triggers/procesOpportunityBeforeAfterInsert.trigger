// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

trigger procesOpportunityBeforeAfterInsert on opportunity ( before insert, after insert) 
{
    System.debug(Trigger.new[0]);
    // Assuming all appointment creation is one at a time apart from wagjag
    if( Trigger.isBefore ){
        Treatments1__c  Treatment = [select id from Treatments1__c where name =: 'Consultation' limit 1];
        if( Trigger.new[0].stagename == 'Cashed out' )
        Trigger.new[0].Treatment_Complete__c = 'Yes';       
        
        for(opportunity o : trigger.new){            
            if(o.Treatment_Name__c != Treatment.id ){
              o.Appointment_Group_Id__c=o.Patient_Name__r.FirstName + o.Patient_Name__r.LastName + o.Treatment_Name__c + System.TODAY();
            }  
        }        
        if(  trigger.new[0].Resource__c != NULL && trigger.new[0].Treatment_Name__r.Name != 'Consultation'  ){              
                   resource__c  resource = [select name from resource__c where id =: trigger.new[0].Resource__c limit 1];
                   List<resource_schedule__c>  rSc = [select id ,  Name__r.Name FROM resource_schedule__c WHERE Name__c =:trigger.new[0].Resource__c AND Open_Time__c <= : trigger.new[0].Appointment_Start_Date_Time__c AND Close_Time__c >=: trigger.new[0].Appointment_End_Date_Time1__c   ORDER BY Open_Time__c DESC LIMIT 1 ];
                   if(rSc.size() == 0){
                       trigger.new[0].addError(resource.Name+' resource is not available on this time');
                   }                  
        }
    }
    if( Trigger.isAfter ){   
       List<Opportunity> newOpportunities      = new List<Opportunity>();
        for(Opportunity op: Trigger.New){    
             //NewOpportunityInsert from current opportunity
             If(op.New_Appointment__c > 0 && op.LeadSource!='Wagjag' ){             
                Integer Number_of_Appointment   = Op.New_Appointment__c.IntValue() - 1; 
                Integer Appointment_Sequence    = op.Appointment_Sequence__c.IntValue()+1;                  
                While ( Number_of_Appointment  > 0){                                      
                        Opportunity newOpp = new Opportunity(); 
                        newOpp.Treatment_Name__c = op.Treatment_Name__c;
                        newOpp.LeadSource=op.LeadSource;                         
                        newOpp.StageName=op.StageName;
                        newOpp.Patient_Name__c=op.Patient_Name__c;
                        newOpp.Account=op.Account;
                        newOpp.Campaign=op.Campaign;
                        newOpp.Webcam_Required__c=op.Webcam_Required__c;
                        newOpp.Name=op.Name;
                        newOpp.CloseDate=op.CloseDate;
                        newOpp.New_Appointment__c= 0;
                        newOpp.Appointment_Group_Id__c=op.Appointment_Group_Id__c;  
                        newOpp.Appointment_Sequence__c = Appointment_Sequence    ;                                                                                           
                        newOpportunities.add(newOpp); 
                        Appointment_Sequence= Appointment_Sequence + 1;
                        Number_of_Appointment  = Number_of_Appointment  - 1;                      
                }
                                      
             }                 
        }  
          if (!CRUDFLSCheckController.OpportunityIsCreatable()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
                // return null;
          }else{
                Insert newOpportunities ; 
         }
        // Validate appointment overlap for Tratment and Trial
        try
        {             
             Opportunity currentAppointment = [select id,Treatment_Name__c , Treatment_Name__r.Name,Treatment_Name__r.Type__c,  Treatment_Type__c, Name,clinic__c, Resource__c, Appointment_Start_Date_Time__c, Appointment_End_Date_Time1__c FROM opportunity WHERE id=: trigger.new[0].id ];       
             System.debug(currentAppointment);  
             if(currentAppointment.Treatment_Name__r.Type__c !=  'Trial' && currentAppointment.Treatment_Name__r.Name != 'Consultation')
             {     
                   if( ( currentAppointment.Treatment_Name__r.Name != 'Consultation' )&&( currentAppointment.Treatment_Name__r.Type__c !=  'Trial' ) &&  (currentAppointment.Appointment_Start_Date_Time__c != NULL && currentAppointment.Appointment_End_Date_Time1__c != NULL    ) )
                   {
                        List<Opportunity> appointmentList =[Select id, name,Appointment_Start_Date_Time__c, Appointment_End_Date_Time1__c from opportunity  WHERE (StageName != 'Cancelled') AND (   clinic__c =: currentAppointment.clinic__c) AND  (Resource__c =: currentAppointment.Resource__c) AND  ( ( Appointment_Start_Date_Time__c = : currentAppointment.Appointment_Start_Date_Time__c AND Appointment_End_Date_Time1__c = : currentAppointment.Appointment_End_Date_Time1__c ) OR (Appointment_Start_Date_Time__c < : currentAppointment.Appointment_Start_Date_Time__c AND Appointment_End_Date_Time1__c > : currentAppointment.Appointment_Start_Date_Time__c ) OR ( Appointment_Start_Date_Time__c < : currentAppointment.Appointment_End_Date_Time1__c  AND Appointment_End_Date_Time1__c > : currentAppointment.Appointment_End_Date_Time1__c ) OR ( Appointment_Start_Date_Time__c > : currentAppointment.Appointment_Start_Date_Time__c AND Appointment_End_Date_Time1__c < : currentAppointment.Appointment_End_Date_Time1__c )   )  AND id != : currentAppointment.id AND Treatment_Name__r.Name != 'Consultation' AND Treatment_Name__r.Type__c !=  'Trial' AND stagename != 'Cancelled'];
                         
                        if( appointmentList.size() > 0)
                        {
                           trigger.new[0].addError('An another appointment is booked on this time');
                        }      
                    }
              }        
       }
       catch(DMLException e)
       {
          ApexPages.addMessage(  new ApexPages.Message(ApexPages.Severity.ERROR,'An another appointment is booked on this time'));
       } 
        
    }  
    ///////////////////////////////////////   Wagjag Opportunity Insert ///////////////////////////////////////////////////
    if(  trigger.new[0].Associated_Wagjag_ID__c != null  ){
        if( Trigger.isinsert && Trigger.isbefore && trigger.new[0].Associated_Wagjag_ID__c != null ){          
            Map<String,Treatments1__c> Treatments1Map = new Map<String,Treatments1__c>([ Select id , Name from Treatments1__c ]);
            Map<String,id> Treatments1NametoId  = new  Map<String,id>();
            Map<String,Campaign> CampaignMap = new Map<String,Campaign>([ Select id , Name from Campaign]);
            Map<String,id> CampaignMapNametoId  = new  Map<String,id>();    
      
            for(Treatments1__c Treatments1 : Treatments1Map.values()){
             Treatments1NametoId.put(Treatments1.Name,Treatments1.id);             
            }
            for(Opportunity Opp: Trigger.new){
              opp.Treatment_Name__c = Treatments1NametoId.get( opp.Treatment_Name_for_Wagjag__c );             
            }
            for(Campaign cmp: CampaignMap.values()){
             CampaignMapNametoId.put(cmp.Name,cmp.id);             
            }
            for(Opportunity Opp: Trigger.new){
              opp.Campaignid = CampaignMapNametoId.get( opp.Campaign_Name__c);            
            }        
        }        
        List<Opportunity> wagjagOpportunityList = new List<Opportunity>();        
        if( Trigger.isinsert && Trigger.isafter && trigger.new[0].Associated_Wagjag_ID__c != null  ){
            for (Opportunity Opp : trigger.New){          
                If(opp.Associated_Wagjag_ID__c != null){                   
                   Integer Quantity              =  Opp.Quantity__c.IntValue() - 1;
                   Integer Appointment_Sequence  = opp.Appointment_Sequence__c.IntValue()+1;                                             
                    While ( Quantity > 0){
                        Opportunity newOpp = new Opportunity();                              
                        newOpp.Associated_Wagjag_ID__c = opp.Associated_Wagjag_ID__c;
                        newOpp.Discount__c = opp.Discount__c;
                        newOpp.LeadSource=opp.LeadSource;
                        newOpp.StageName=opp.StageName;
                        newOpp.Patient_Name__c=opp.Patient_Name__c;
                        newOpp.Referral_Card_Id1__c=opp.Referral_Card_Id1__c;
                        newOpp.Account=opp.Account;
                        newOpp.Campaign=opp.Campaign;
                        newOpp.Total_Purchase__c=opp.Total_Purchase__c;
                        newOpp.Description__c=opp.Description__c;
                        newOpp.Services__c=opp.Services__c;
                        newOpp.Webcam_Required__c=opp.Webcam_Required__c;
                        newOpp.Name=opp.Name;
                        newOpp.CloseDate=opp.CloseDate;
                        newOpp.Quantity__c = 0;
                        newOpp.Appointment_Group_Id__c=opp.Appointment_Group_Id__c; 
                        newOpp.Appointment_Sequence__c=Appointment_Sequence ; 
                        newOpp.Treatment_Name__c   = opp.Treatment_Name__c   ;   
                        newOpp.Treatment_Name_for_Wagjag__c  = opp.Treatment_Name_for_Wagjag__c ;   
                        newOpp.Campaign_Name__c    = opp.Campaign_Name__c;   
                        newOpp.Campaignid            = opp.Campaignid ;                                                                                          
                        wagjagOpportunityList.add(newOpp);          
                        Quantity = Quantity -1;
                        Appointment_Sequence = Appointment_Sequence + 1;
                    }   
                }
            }
           if (!CRUDFLSCheckController.OpportunityIsCreatable()){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
                 //return null;
                 }else{
                if(!Test.isrunningtest()){  
                insert wagjagOpportunityList ;
                }
               } 
        }   
    }
        System.debug(Trigger.new[0]);

    ///////////////////////////////////////   Wagjag Opportunity Insert ///////////////////////////////////////////////////
}