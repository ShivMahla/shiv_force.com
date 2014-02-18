// Copyright (c) 4044, 4043 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

@istest 
private class TestFullcalUserMasterTest{
    public testMethod static void unitTestFullcalUserMasterTest(){
          //creating clinic record
        Clinic__c cl = new Clinic__c(Name = 'Ajax');
        insert cl;
        //creating staff record
        Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter',clinic__c=cl.id);
        insert staff;
        //creating rsource record
        Resource__c resource = new Resource__c(Name = 'X-rayMachine',clinic__c=cl.id,background_color__c='#FCD446',color__c='#4C4C4C',Resource_ID__c='testid');
        insert resource;
         //creating staff schedule record
        Staff_Schedule__c staffSchedule = new Staff_Schedule__c( staff__c=staff.id,Shift_Start__c=DateTime.now().addHours(-1),Shift_Endds__c=DateTime.now().addHours(5), Clinic__c=cl.id);
        insert staffSchedule;
        //creating resource schedule
        Resource_Schedule__c resourceSchedule = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=DateTime.now().addHours(5), Open_Time__c=DateTime.now().addHours(-1), Clinic__c=cl.id, Name__c = resource.id);
        insert resourceSchedule;
         //Creating record for patient
        contact patient = new contact(FirstName='john', LastName='Methew',Email='abc@gmail.com', Status__c='open', Preferred_Phone_Number__c='9886404400', LeadSource='Other');
        insert patient;
         //creating record for treatment
        Treatments1__c treatment = new Treatments1__c(Name='Consultation', type__c='Treatment', price__c=4000);
        insert treatment;
        //insert related resouce for treatement
        Related_Resources__c relatedResource = new Related_Resources__c(Resource__c=resource.id, Treatments__c = treatment.id);
        insert relatedResource ;
         // insert record for account
       Account account=new account(name='Skin Vitality',Type='Supplier');
        insert account; 
        //Creating appointment record 
        opportunity appointMent = new opportunity(Name='testAppointMent',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(1),
                                                  Treatment_Name__c = treatment.id, Appointment_End_Date_Time1__c =DateTime.now().addHours(4), Type='Treatment', stageName='Booked',resource__c = resource.id);
        insert appointMent ;
        //Instantiate and construct the controller class.
        fullcalUserMasterTest   contr=new fullcalUserMasterTest (); 
        ApexPages.currentPage().getParameters().put('appIds','Booked;Cancelled;Confirmed;No show;Arrived;Cashed out');  
        ApexPages.StandardController sc = new ApexPages.StandardController(appointMent); 
         ApexPages.currentPage().getParameters().put('startDate',String.ValueOf(DateTime.now().addHours(1)));
         ApexPages.currentPage().getParameters().put('endDate',String.ValueOf(DateTime.now().addHours(4)));
         ApexPages.currentPage().getParameters().put('resourceIds',resource.id+';'+resource.id);
        fullcalUserMasterTest controller = new fullcalUserMasterTest (sc);
        controller.clinicChanged();
         controller.clinic = cl.id;
        controller.TreatmentId = treatment.id;
        controller.patientId = patient.id;
        controller.AppointmentName = 'AppointmentName' ;
        controller.ResourceId = resource.id;
        controller.StartDateTime=String.ValueOf(DateTime.now().addHours(4));
        controller.startDate=String.ValueOf(DateTime.now().addHours(4));
        controller.LoadResourceSchedule();
          //Test For Different combination
        ApexPages.currentPage().getParameters().put('clinicRecordId',cl.id);
       //only Appointment 
        ApexPages.currentPage().getParameters().put('clinicId','ALL'); 
        ApexPages.currentPage().getParameters().put('appIds','Booked;Cancelled;Confirmed;No show;Arrived;Cashed out');
        ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
        ApexPages.currentPage().getParameters().put('resourceIds','EMPTY');
        ApexPages.currentPage().getParameters().put('StartDateTime',String.ValueOf(DateTime.now().addHours(-3)));
        ApexPages.currentPage().getParameters().put('EndDateTime',String.ValueOf(DateTime.now().addHours(3)));
        controller.LoadAltogether();
        //only Resource        
        ApexPages.currentPage().getParameters().put('appIds','EMPTY');
        ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
        
        controller.LoadAltogether();
      //Appointment and Resource
        ApexPages.currentPage().getParameters().put('appIds','Booked;Cancelled;Confirmed;No show;Arrived;Cashed out');
        ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
        ApexPages.currentPage().getParameters().put('resourceIds',resource.id);
        ApexPages.currentPage().getParameters().put('StartDateTime',String.ValueOf(DateTime.now().addHours(-3)));
        ApexPages.currentPage().getParameters().put('EndDateTime',String.ValueOf(DateTime.now().addHours(3)));
        controller.LoadAltogether();
        //only Appointment 
        ApexPages.currentPage().getParameters().put('appIds','Booked;Cancelled;Confirmed;No show;Arrived;Cashed out');
        ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
        ApexPages.currentPage().getParameters().put('resourceIds','EMPTY');
        ApexPages.currentPage().getParameters().put('StartDateTime',String.ValueOf(DateTime.now().addHours(-3)));
        ApexPages.currentPage().getParameters().put('EndDateTime',String.ValueOf(DateTime.now().addHours(3)));
        controller.LoadAltogether();
       //only Resource
        ApexPages.currentPage().getParameters().put('appIds','EMPTY');
        ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
        ApexPages.currentPage().getParameters().put('resourceIds',resource.Id);
        controller.LoadAltogether();
        //Appointment and Resource
        ApexPages.currentPage().getParameters().put('appIds','Booked;Cancelled;Confirmed;No show;Arrived;Cashed out');
        ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
        ApexPages.currentPage().getParameters().put('resourceIds',resource.id);
        ApexPages.currentPage().getParameters().put('StartDateTime',String.ValueOf(DateTime.now()));
        ApexPages.currentPage().getParameters().put('EndDateTime',String.ValueOf(DateTime.now().addHours(1))); 
        controller.LoadAltogether();
        controller.getoppty();
        controller.testmessage();
         ApexPages.currentPage().getParameters().put('clinicId','ALL'); 
        ApexPages.currentPage().getParameters().put('clinicRecordId',cl.id);
        controller.StartDateTimeEvent = String.ValueOf(DateTime.now().addMinutes(06));
        controller.EndDateTimeEvent = String.ValueOf(DateTime.now().addMinutes(38));
        controller.SaveOpportunity();
         //Appointment stage changed and reason for cancellation
        ApexPages.currentPage().getParameters().put('appointmentId',appointMent.id);
        ApexPages.currentPage().getParameters().put('stageName','Cancelled');
        ApexPages.currentPage().getParameters().put('reason','Going Out');
        appointMent.Cancellation_Reasons__c='Going Out';
        controller.changeStageOfAppointment();        
         // for updateRescheduleReason
         ApexPages.currentPage().getParameters().put('ObjectName','Appointment');
         ApexPages.currentPage().getParameters().put('appointmentResizeReason','meeting');
         ApexPages.currentPage().getParameters().put('eventId',appointMent.id);
         ApexPages.currentPage().getParameters().put('startDateTime',String.ValueOf(DateTime.now()));
         ApexPages.currentPage().getParameters().put('endDateTime',String.ValueOf(DateTime.now()));
         //test for appointMent when clinic != all
         ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
         ApexPages.currentPage().getParameters().put('appIds',appointMent.id);
         ApexPages.currentPage().getParameters().put('resourceIds','EMPTY');
         controller.updateRescheduleReason();
         controller.getclinicnames();       
    }
     public testMethod static void unitTestFullcalUserMasterTest3(){
          //creating clinic record
        Clinic__c cl = new Clinic__c(Name = 'Ajax');
        insert cl;
        //creating staff record
        Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter',clinic__c=cl.id);
        insert staff;
        //creating rsource record
        Resource__c resource = new Resource__c(Name = 'X-rayMachine',clinic__c=cl.id,background_color__c='#FCD446',color__c='#4C4C4C',Resource_ID__c='testid');
        insert resource;
         //creating staff schedule record
        Staff_Schedule__c staffSchedule = new Staff_Schedule__c( staff__c=staff.id,Shift_Start__c=DateTime.now().addHours(-1),Shift_Endds__c=DateTime.now().addHours(5), Clinic__c=cl.id);
        insert staffSchedule;
        //creating resource schedule
        Resource_Schedule__c resourceSchedule = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=DateTime.now().addHours(5), Open_Time__c=DateTime.now().addHours(-1), Clinic__c=cl.id, Name__c = resource.id);
        insert resourceSchedule;
         //Creating record for patient
        contact patient = new contact(FirstName='john', LastName='Methew',Email='abc@gmail.com', Status__c='open', Preferred_Phone_Number__c='9886404400', LeadSource='Other');
        insert patient;
         //creating record for treatment
        Treatments1__c treatment = new Treatments1__c(Name='Consultation', type__c='Treatment', price__c=4000);
        insert treatment;
        //insert related resouce for treatement
        Related_Resources__c relatedResource = new Related_Resources__c(Resource__c=resource.id, Treatments__c = treatment.id);
        insert relatedResource ;
         // insert record for account
       Account account=new account(name='Skin Vitality',Type='Supplier');
        insert account; 
        //Creating appointment record 
        opportunity appointMent = new opportunity(Name='testAppointMent',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(1),
                                                  Treatment_Name__c = treatment.id, Appointment_End_Date_Time1__c =DateTime.now().addHours(4), Type='Treatment', stageName='Booked',resource__c = resource.id);
        insert appointMent ;
        //Instantiate and construct the controller class.
        fullcalUserMasterTest   contr=new fullcalUserMasterTest (); 
        ApexPages.currentPage().getParameters().put('appIds','Booked;Confirmed;Arrived');  
        ApexPages.StandardController sc = new ApexPages.StandardController(appointMent); 
         ApexPages.currentPage().getParameters().put('startDate',String.ValueOf(DateTime.now().addHours(1)));
         ApexPages.currentPage().getParameters().put('endDate',String.ValueOf(DateTime.now().addHours(4)));
         ApexPages.currentPage().getParameters().put('resourceIds',resource.id+';'+resource.id);
        fullcalUserMasterTest controller = new fullcalUserMasterTest (sc);
        controller.clinicChanged();
         controller.clinic = cl.id;
        controller.TreatmentId = treatment.id;
        controller.patientId = patient.id;
        controller.AppointmentName = 'AppointmentName' ;
        controller.ResourceId = resource.id;
        controller.StartDateTime=String.ValueOf(DateTime.now().addHours(4));
        controller.startDate=String.ValueOf(DateTime.now().addHours(4));
        controller.LoadResourceSchedule();
          //Test For Different combination
        ApexPages.currentPage().getParameters().put('clinicRecordId',cl.id);
        //only Appointment 
        ApexPages.currentPage().getParameters().put('clinicId',cl.id); 
        ApexPages.currentPage().getParameters().put('appIds','Booked;Cancelled;Confirmed;No show;Arrived;Cashed out');
        ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
        ApexPages.currentPage().getParameters().put('resourceIds','EMPTY');
         ApexPages.currentPage().getParameters().put('StartDateTime',String.ValueOf(DateTime.now().addHours(-3)));
            ApexPages.currentPage().getParameters().put('EndDateTime',String.ValueOf(DateTime.now().addHours(3)));
        controller.LoadAltogether();
        //only Resource        
        ApexPages.currentPage().getParameters().put('appIds','EMPTY');
        ApexPages.currentPage().getParameters().put('staffIds','EMPTY');        
        controller.LoadAltogether();
      //Appointment and Resource
        ApexPages.currentPage().getParameters().put('appIds','Booked;Cancelled;Confirmed;No show;Arrived;Cashed out');
        ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
        ApexPages.currentPage().getParameters().put('resourceIds',resource.id);
        ApexPages.currentPage().getParameters().put('StartDateTime',String.ValueOf(DateTime.now().addHours(-3)));
        ApexPages.currentPage().getParameters().put('EndDateTime',String.ValueOf(DateTime.now().addHours(3)));
        controller.LoadAltogether();
        //only Appointment 
        ApexPages.currentPage().getParameters().put('appIds','Booked;Cancelled;Confirmed;No show;Arrived;Cashed out');
        ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
        ApexPages.currentPage().getParameters().put('resourceIds','EMPTY');
        ApexPages.currentPage().getParameters().put('StartDateTime',String.ValueOf(DateTime.now().addHours(-3)));
        ApexPages.currentPage().getParameters().put('EndDateTime',String.ValueOf(DateTime.now().addHours(3)));
        controller.LoadAltogether();
       //only Resource
        ApexPages.currentPage().getParameters().put('appIds','EMPTY');
        ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
        ApexPages.currentPage().getParameters().put('resourceIds',resource.Id);
        controller.LoadAltogether();
        //Appointment and Resource
        ApexPages.currentPage().getParameters().put('appIds','Booked;Cancelled;Confirmed;No show;Arrived;Cashed out');
        ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
        ApexPages.currentPage().getParameters().put('resourceIds',resource.id);
        ApexPages.currentPage().getParameters().put('StartDateTime',String.ValueOf(DateTime.now()));
        ApexPages.currentPage().getParameters().put('EndDateTime',String.ValueOf(DateTime.now().addHours(1))); 
        controller.LoadAltogether();          
    }
}