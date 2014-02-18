// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

trigger validationAppointmentOverlap on Opportunity (after insert, after update) {
   
   
  
   
    Try{
                  
                        
               Opportunity currentAppointment = [select id,Treatment_Name__c , Treatment_Name__r.Name,Treatment_Name__r.Type__c,  Treatment_Type__c, Name,clinic__c, Resource__c, Appointment_Start_Date_Time__c, Appointment_End_Date_Time1__c FROM opportunity WHERE id=: trigger.new[0].id ];       
                
                if(currentAppointment.Treatment_Name__r.Type__c !=  'Trial' && currentAppointment.Treatment_Name__r.Name != 'Consultation'){
                    if( ( currentAppointment.Treatment_Name__r.Name != 'Consultation' )&&( currentAppointment.Treatment_Name__r.Type__c !=  'Trial' ) &&  (currentAppointment.Appointment_Start_Date_Time__c != NULL && currentAppointment.Appointment_End_Date_Time1__c != NULL    ) ){
            
              
                       
                        List<Opportunity> appointmentList =[Select id, name,Appointment_Start_Date_Time__c, Appointment_End_Date_Time1__c from opportunity 
                        WHERE (clinic__c =: currentAppointment.clinic__c) AND
                        (Resource__c =: currentAppointment.Resource__c) AND
                        ((Appointment_Start_Date_Time__c = : currentAppointment.Appointment_Start_Date_Time__c AND Appointment_End_Date_Time1__c = : currentAppointment.Appointment_End_Date_Time1__c )OR
                         (Appointment_Start_Date_Time__c < : currentAppointment.Appointment_Start_Date_Time__c AND Appointment_End_Date_Time1__c > : currentAppointment.Appointment_Start_Date_Time__c )OR
                         (Appointment_Start_Date_Time__c < : currentAppointment.Appointment_End_Date_Time1__c  AND Appointment_End_Date_Time1__c > : currentAppointment.Appointment_End_Date_Time1__c)OR
                         (Appointment_Start_Date_Time__c > : currentAppointment.Appointment_Start_Date_Time__c AND Appointment_End_Date_Time1__c < : currentAppointment.Appointment_End_Date_Time1__c)
                        )
                        AND id != : currentAppointment.id AND Treatment_Name__r.Name != 'Consultation' AND Treatment_Name__r.Type__c !=  'Trial' ];
                       
                         
                        if(appointmentList.size() > 0){
                           // ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'An another appointment is booked on this time'));
                           trigger.new[0].addError('An another appointment is booked on this time');
                        }      
                    }
                }    
        
        
      }
      catch(DMLException e) {
          ApexPages.addMessage(  new ApexPages.Message(ApexPages.Severity.ERROR,'An another appointment is booked on this time---'));
          
      }

}