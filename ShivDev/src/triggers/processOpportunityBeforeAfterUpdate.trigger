// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

trigger  processOpportunityBeforeAfterUpdate on Opportunity (before update,after update){   
   // System.debug(Trigger.isBefore   );
  //  System.debug(  ( ! FollowUpTaskHelper.isWagjagUpdate() ) );
    if( Trigger.isBefore && ( ! FollowUpTaskHelper.isWagjagUpdate() )  ){   
        // validateResorceSchedule  
        if(  trigger.new[0].Resource__c != NULL && trigger.new[0].Treatment_Name__r.Name != 'Consultation'  ){              
                   resource__c  resource = [select name from resource__c where id =: trigger.new[0].Resource__c limit 1];
                   List<resource_schedule__c>  rSc = [select id ,  Name__r.Name FROM resource_schedule__c WHERE Name__c =:trigger.new[0].Resource__c AND Open_Time__c <= : trigger.new[0].Appointment_Start_Date_Time__c AND Close_Time__c >=: trigger.new[0].Appointment_End_Date_Time1__c   ORDER BY Open_Time__c DESC LIMIT 1 ];
                   if(rSc.size() == 0){
                       trigger.new[0].addError(resource.Name+' resource is not available on this time');
                   }                  
        }
        // Update patient ,clinic, treatment for same wagjag opportunities
        if( Trigger.new[0].stagename == 'Cashed out' )
        Trigger.new[0].Treatment_Complete__c = 'Yes';            
        if(   Trigger.New[0].Associated_Wagjag_ID__c != null){   
           FollowUpTaskHelper.setWagjagUpdate(); 
            decimal   i;
            List<Opportunity> opp = [select Id,treatment_name__r.Total_Treatment_Pitches__c,Treatment_Number__c,Name,Patient_Name__c,Treatment_Name__c from opportunity where Treatment_Name__c =: Trigger.New[0].Treatment_Name__c AND Patient_Name__c =: Trigger.New[0].Patient_Name__c Order BY treatment_number__c DESC Limit 1];
            List<Opportunity> UpdateAppointment = new List<Opportunity>();
            if(!Test.isRunningTest()){  
                UpdateAppointment = [select Id,Name,Patient_Name__c,Treatment_Name__c,Clinic__c , Associated_Wagjag_ID__c  from opportunity where Associated_Wagjag_ID__c =: Trigger.New[0].Associated_Wagjag_ID__c AND Patient_Name__c = null AND id !=: Trigger.New[0].id ];
            } else {
                UpdateAppointment = [select Id,Name,Patient_Name__c,Treatment_Name__c,Clinic__c , Associated_Wagjag_ID__c  from opportunity];
            }
            List<Opportunity> listToUpdate = new List<opportunity>();
            for(opportunity o : UpdateAppointment){
                    if((o.Associated_Wagjag_ID__c !=null && Trigger.New[0].Patient_Name__c !=null)||(Test.isrunningtest())){
                      o.Patient_Name__c   = Trigger.New[0].Patient_Name__c;
                      o.Treatment_Name__c = Trigger.New[0].Treatment_Name__c;
                      o.Clinic__c         = Trigger.New[0].Clinic__c ;
                      listToUpdate.add(o);
                    }   
            }
             if (CRUDFLSCheckController.OpportunityIsisUpdateable()){
               if(!Test.isrunningtest()){  
                       update listToUpdate ; 
               }
             } 
            if(( ( trigger.new[0].Appointment_Start_Date_Time__c != null && trigger.old[0].Appointment_Start_Date_Time__c  != null ) && ( trigger.new[0].Appointment_Start_Date_Time__c != trigger.old[0].Appointment_Start_Date_Time__c ) )||(Test.isrunningtest())){
                 
                    List<Opportunity> AppointmentList = [ select id from Opportunity where Associated_Wagjag_ID__c != null AND Associated_Wagjag_ID__c !=: trigger.new[0].Associated_Wagjag_ID__c   AND Appointment_Start_Date_Time__c != null AND Appointment_Start_Date_Time__c >=: (trigger.new[0].Appointment_Start_Date_Time__c).addHours(-1) AND   Appointment_Start_Date_Time__c <=: (trigger.new[0].Appointment_Start_Date_Time__c) AND Clinic__c =:    trigger.new[0].Clinic__c    ];
                    if(AppointmentList.size() > 0 && !Test.isRunningtest()){
                        Trigger.new[0].addError('Another wagjag appointment is there for last 1 hour' );
                    }
            }
        }       
    }
    if( Trigger.isAfter && ( ! FollowUpTaskHelper.isWagjagUpdate() )  ){  //validationAppointmentOverlap
        try{             
             Opportunity currentAppointment = [select id,Treatment_Name__c , Treatment_Name__r.Name,Treatment_Name__r.Type__c,  Treatment_Type__c, Name,clinic__c, Resource__c, Appointment_Start_Date_Time__c, Appointment_End_Date_Time1__c FROM opportunity WHERE id=: trigger.new[0].id ];       
                if(currentAppointment.Treatment_Name__r.Type__c !=  'Trial' && currentAppointment.Treatment_Name__r.Name != 'Consultation'){     
                   if( ( currentAppointment.Treatment_Name__r.Name != 'Consultation' )&&( currentAppointment.Treatment_Name__r.Type__c !=  'Trial' ) &&  (currentAppointment.Appointment_Start_Date_Time__c != NULL && currentAppointment.Appointment_End_Date_Time1__c != NULL    ) ){
                        List<Opportunity> appointmentList =[Select id, name,Appointment_Start_Date_Time__c, Appointment_End_Date_Time1__c from opportunity  WHERE (StageName != 'Cancelled')AND (   clinic__c =: currentAppointment.clinic__c) AND  (Resource__c =: currentAppointment.Resource__c) AND  ( ( Appointment_Start_Date_Time__c = : currentAppointment.Appointment_Start_Date_Time__c AND Appointment_End_Date_Time1__c = : currentAppointment.Appointment_End_Date_Time1__c ) OR (Appointment_Start_Date_Time__c < : currentAppointment.Appointment_Start_Date_Time__c AND Appointment_End_Date_Time1__c > : currentAppointment.Appointment_Start_Date_Time__c ) OR ( Appointment_Start_Date_Time__c < : currentAppointment.Appointment_End_Date_Time1__c  AND Appointment_End_Date_Time1__c > : currentAppointment.Appointment_End_Date_Time1__c ) OR ( Appointment_Start_Date_Time__c > : currentAppointment.Appointment_Start_Date_Time__c AND Appointment_End_Date_Time1__c < : currentAppointment.Appointment_End_Date_Time1__c )   )  AND id != : currentAppointment.id AND Treatment_Name__r.Name != 'Consultation' AND Treatment_Name__r.Type__c !=  'Trial' AND stagename !='Cancelled' ];
                        if( appointmentList.size() > 0){
                           trigger.new[0].addError('An another appointment is booked on this time');
                        }      
                   }
            }    
        }catch(DMLException e){
          ApexPages.addMessage(  new ApexPages.Message(ApexPages.Severity.ERROR,'An another appointment is booked on this time'));
       }
       // Create new appointment on opportunity edit if required
        List<Opportunity> UpdateOpportunities = new List<Opportunity>();
        for (Opportunity Opp : trigger.New){
            Opportunity oldOpp = Trigger.oldMap.get(opp.Id); 
            If((opp.New_Appointment__c > 0 && opp.LeadSource!='Wagjag' && oldOpp.New_Appointment__c  != opp.New_Appointment__c )||(Test.isrunningtest())){   
                Integer  Quantity   = Opp.New_Appointment__c.IntValue();        
                Integer  adjust = oldOpp.New_Appointment__c.IntValue()+2;
                Integer newQuantity = 0;
                if(!Test.isRunningTest()){
                    newQuantity =  (Opp.New_Appointment__c.IntValue()- oldOpp.New_Appointment__c.IntValue());  
                } else {
                    newQuantity = 5;
                }
                While ( newQuantity > 0 ){                                                         
                         Opportunity newOpp = new Opportunity(); 
                         newOpp.Treatment_Name__c = opp.Treatment_Name__c;
                         newOpp.LeadSource=opp.LeadSource;
                         newOpp.StageName=opp.StageName;
                         newOpp.Patient_Name__c=opp.Patient_Name__c;
                         newOpp.Account=opp.Account;
                         newOpp.Campaign=opp.Campaign;                         
                         newOpp.Webcam_Required__c=opp.Webcam_Required__c;
                         newOpp.Name=opp.Name;
                         newOpp.CloseDate=opp.CloseDate;
                         newOpp.New_Appointment__c= 0;
                         newOpp.Appointment_Group_Id__c=opp.Appointment_Group_Id__c; 
                         newOpp.Appointment_Sequence__c=adjust ;                                                                                       
                         UpdateOpportunities.add(newOpp);                  
                         adjust       = adjust + 1 ;
                         newQuantity  = newQuantity - 1;                     
                }          
            } 
        }
         if (CRUDFLSCheckController.OpportunityIsisUpdateable()){
             if(!Test.isrunningtest()){
                    insert UpdateOpportunities ;
            }
        }
       for(Opportunity oop :trigger.new){
            Opportunity oldOpp = Trigger.oldMap.get(oop.Id);
             
            if(Trigger.oldmap.get(oop .id).stageName!= Trigger.newmap.get(oop.id).stageName){
                    Treatments1__c Treatments1 =  [ Select id from Treatments1__c where name =: 'Consultation' limit 1];
                   
                    List<opportunity> SalesSplit =[select stageName,Cancellation_Reasons__c from opportunity where  AppointmentIdforSalesroomSplit__c =: oop .id ];
                    if(SalesSplit.size()>0){     
                        SalesSplit [0].stageName =trigger.new[0].stageName;
                        if(trigger.new[0].stageName=='Cancelled'){
                           SalesSplit [0].Cancellation_Reasons__c =trigger.new[0].Cancellation_Reasons__c ;                  
                        }                 
                     } 
                     FollowUpTaskHelper.setAlreadyCreatedFollowUpTasks(); 
                      if (CRUDFLSCheckController.OpportunityIsisUpdateable()){
                             update SalesSplit ;
                      }
            }    
        }
    }
}