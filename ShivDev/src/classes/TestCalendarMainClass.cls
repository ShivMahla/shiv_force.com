// Copyright (c) 2032, 2033 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

@isTest
public class TestCalendarMainClass{
    public static testMethod void test(){
        //creating clinic record
        Clinic__c cl = new Clinic__c(Name = 'Ajax');
        insert cl;
        //creating staff record
        Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter',clinic__c=cl.id);
        insert staff;
        //creating rsource record
        Resource__c resource = new Resource__c(Name = 'Scan-Machine',clinic__c=cl.id,background_color__c='#FCD336',color__c='#3C3C3C',Resource_ID__c='testid');
        insert resource;
        //creating staff schedule record
        Staff_Schedule__c staffSchedule = new Staff_Schedule__c( staff__c=staff.id,Shift_Start__c=DateTime.now().addMinutes(10),Shift_Endds__c=DateTime.now().addMinutes(40), Clinic__c=cl.id);
        insert staffSchedule;
        //update staffSchedule;
        //creating resource schedule
        Resource_Schedule__c resourceSchedule = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=DateTime.now().addMinutes(40), Open_Time__c=DateTime.now().addMinutes(10), Clinic__c=cl.id, Name__c = resource.id);
        insert resourceSchedule;
       // update resourceSchedule;
        //Creating record for patient
        contact patient = new contact(FirstName='john', LastName='Methew',Email='abc@gmail.com', Status__c='open', Preferred_Phone_Number__c='9886102200', LeadSource='Other');
        insert patient;
         //creating record for treatment
        Treatments1__c treatment = new Treatments1__c(Name='Consultation', type__c='Treatment', price__c=1000);
        insert treatment;
        //insert related resouce for treatement
        Related_Resources__c relatedResource = new Related_Resources__c(Resource__c=resource.id, Treatments__c = treatment.id);
        insert relatedResource ;
        //Creating appointment record 
        opportunity appointMent = new opportunity(Name='testAppointMent',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addMinutes(12),
                                                  Treatment_Name__c = treatment.id, Appointment_End_Date_Time1__c =DateTime.now().addMinutes(35), Type='Treatment', stageName='Booked',resource__c = resource.id);
        insert appointMent;
      
    // Test.StartTest(); 
            ApexPages.StandardController SC = new ApexPages.StandardController(appointMent);
            PageReference pageRef = Page.staffCalendar;
            system.test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('clinicId',cl.id);
            calendarMainClass contr = new calendarMainClass();
            calendarMainClass controller = new calendarMainClass(SC);
            controller.clinicChanged();
            controller.getclinicnames();
            controller.getpatinetAppointment();
            controller.resourceList();
            controller.getstaffList();
            controller.getAppointmentsType();
            ApexPages.currentPage().getParameters().put('startDate',String.ValueOf(DateTime.now().addHours(-3)));
            ApexPages.currentPage().getParameters().put('endDate',String.ValueOf(DateTime.now().addHours(3)));
            //test for resourc calnedar when clinic != all
            ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
            ApexPages.currentPage().getParameters().put('appIds','EMPTY');
            ApexPages.currentPage().getParameters().put('resourceIds','EMPTY');
            //test when clinic == all
            //controller.clinicId = 'All';
            ApexPages.currentPage().getParameters().put('clinicId','All');
            controller.ResourceIdListSelected = true;
            
            //test for staff calendar when clinic != all
            
            ApexPages.currentPage().getParameters().put('staffIds',staff.id);
            ApexPages.currentPage().getParameters().put('appIds','EMPTY');
            ApexPages.currentPage().getParameters().put('resourceIds','EMPTY');
            controller.LoadAltogether();
            //test for resourc calnedar when clinic != all
            ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
            ApexPages.currentPage().getParameters().put('appIds','EMPTY');
            ApexPages.currentPage().getParameters().put('resourceIds',resource.id);
            controller.LoadAltogether();
            // creating createStaffSchedule
            ApexPages.currentPage().getParameters().put('clinicIds',cl.id);
            ApexPages.currentPage().getParameters().put('staffScheduleids',staffSchedule.id);
            ApexPages.currentPage().getParameters().put('appIds','EMPTY');
            ApexPages.currentPage().getParameters().put('staffIds',staff.id);
            ApexPages.currentPage().getParameters().put('resourceIds','EMPTY');
            controller.StartDateTime = String.ValueOf(DateTime.now().addMinutes(10));
            controller.EndDateTime = String.ValueOf(DateTime.now().addMinutes(40));
            controller.createStaffSchedule(); 
            // create resource schedule
            ApexPages.currentPage().getParameters().put('clinicIds',cl.id);
            ApexPages.currentPage().getParameters().put('appIds','EMPTY');
            ApexPages.currentPage().getParameters().put('resourceIds',resource.id);
            controller.StartDateTime =  String.ValueOf(DateTime.now().addHours(-3));
            controller.EndDateTime =  String.ValueOf(DateTime.now().addHours(3));
            controller.createResourceSchedule();
            // for updatereshedule
            ApexPages.currentPage().getParameters().put('ObjectName','Appointment');
            ApexPages.currentPage().getParameters().put('appointmentResizeReason','meeting');
            ApexPages.currentPage().getParameters().put('eventId',appointMent.id);
            ApexPages.currentPage().getParameters().put('startDateTime',String.ValueOf(DateTime.now().addHours(-3)));
            ApexPages.currentPage().getParameters().put('endDateTime',String.ValueOf(DateTime.now().addHours(3)));
            //test for appointMent when clinic != all
            ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
            ApexPages.currentPage().getParameters().put('appIds',appointMent.id);
            ApexPages.currentPage().getParameters().put('resourceIds','EMPTY');
            controller.updateReschedule();
            //test for resourc calnedar when clinic != all
            ApexPages.currentPage().getParameters().put('ObjectName','ResourceSchedule');
            ApexPages.currentPage().getParameters().put('eventId',resourceSchedule.id);
            ApexPages.currentPage().getParameters().put('startDateTime',String.ValueOf(DateTime.now().addHours(-3)));
            ApexPages.currentPage().getParameters().put('endDateTime',String.ValueOf(DateTime.now().addHours(3)));
            ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
            ApexPages.currentPage().getParameters().put('appIds','EMPTY');
            ApexPages.currentPage().getParameters().put('resourceIds',resource.id);
            controller.updateReschedule();
            //test for staff calendar when clinic != all
            ApexPages.currentPage().getParameters().put('ObjectName','StaffSchedule');
            ApexPages.currentPage().getParameters().put('eventId',staffSchedule.id);
            ApexPages.currentPage().getParameters().put('startDateTime',String.ValueOf(DateTime.now().addHours(-3)));
            ApexPages.currentPage().getParameters().put('endDateTime',String.ValueOf(DateTime.now().addHours(3)));
            ApexPages.currentPage().getParameters().put('staffIds',staff.id);
            ApexPages.currentPage().getParameters().put('appIds','EMPTY');
            ApexPages.currentPage().getParameters().put('resourceIds','EMPTY');
            controller.updateReschedule();
       // Test.stopTest();
       }
        public static testMethod void testmthodeone(){
        //creating clinic record
        Clinic__c cl = new Clinic__c(Name = 'Ajax');
        insert cl;
        //creating staff record
        Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter',clinic__c=cl.id);
        insert staff;
        //creating rsource record
        Resource__c resource = new Resource__c(Name = 'Scan-Machine',clinic__c=cl.id,background_color__c='#FCD336',color__c='#3C3C3C',Resource_ID__c='testid');
        insert resource;
        //creating staff schedule record
        Staff_Schedule__c staffSchedule = new Staff_Schedule__c( staff__c=staff.id,Shift_Start__c=DateTime.now().addMinutes(10),Shift_Endds__c=DateTime.now().addMinutes(40), Clinic__c=cl.id);
        insert staffSchedule;
        //update staffSchedule;
        //creating resource schedule
        Resource_Schedule__c resourceSchedule = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=DateTime.now().addMinutes(40), Open_Time__c=DateTime.now().addMinutes(10), Clinic__c=cl.id, Name__c = resource.id);
        insert resourceSchedule;
       // update resourceSchedule;
        //Creating record for patient
        contact patient = new contact(FirstName='john', LastName='Methew',Email='abc@gmail.com', Status__c='open', Preferred_Phone_Number__c='9886102200', LeadSource='Other');
        insert patient;
         //creating record for treatment
        Treatments1__c treatment = new Treatments1__c(Name='Consultation', type__c='Treatment', price__c=1000);
        insert treatment;
        //insert related resouce for treatement
        Related_Resources__c relatedResource = new Related_Resources__c(Resource__c=resource.id, Treatments__c = treatment.id);
        insert relatedResource ;
        //Creating appointment record 
        opportunity appointMent = new opportunity(Name='testAppointMent',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addMinutes(12),
                                                  Treatment_Name__c = treatment.id, Appointment_End_Date_Time1__c =DateTime.now().addMinutes(35), Type='Treatment', stageName='Booked',resource__c = resource.id);
        insert appointMent;
      
    // Test.StartTest(); 
            ApexPages.StandardController SC = new ApexPages.StandardController(appointMent);
            PageReference pageRef = Page.staffCalendar;
            system.test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('clinicId',cl.id);
            calendarMainClass contr = new calendarMainClass();
            calendarMainClass controller = new calendarMainClass(SC);
            controller.clinicChanged();
            controller.getclinicnames();
            controller.getpatinetAppointment();
            controller.resourceList();
            controller.getstaffList();
            controller.getAppointmentsType();
            ApexPages.currentPage().getParameters().put('startDate',String.ValueOf(DateTime.now().addHours(-3)));
            ApexPages.currentPage().getParameters().put('endDate',String.ValueOf(DateTime.now().addHours(3)));
            //test for resourc calnedar when clinic != all
            ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
            ApexPages.currentPage().getParameters().put('appIds','EMPTY');
            ApexPages.currentPage().getParameters().put('resourceIds','EMPTY');
            //test when clinic == all
            controller.clinicId = 'All';
           // ApexPages.currentPage().getParameters().put('clinicId','All');
            controller.ResourceIdListSelected = true;
            
            //test for staff calendar when clinic != all
            
            ApexPages.currentPage().getParameters().put('staffIds',staff.id);
            ApexPages.currentPage().getParameters().put('appIds','EMPTY');
            ApexPages.currentPage().getParameters().put('resourceIds','EMPTY');
            controller.LoadAltogether();
            //test for resourc calnedar when clinic != all
            ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
            ApexPages.currentPage().getParameters().put('appIds','EMPTY');
            ApexPages.currentPage().getParameters().put('resourceIds',resource.id);
            controller.LoadAltogether();
            // creating createStaffSchedule
            ApexPages.currentPage().getParameters().put('clinicIds',cl.id);
            ApexPages.currentPage().getParameters().put('staffScheduleids',staffSchedule.id);
            ApexPages.currentPage().getParameters().put('appIds','EMPTY');
            ApexPages.currentPage().getParameters().put('staffIds',staff.id);
            ApexPages.currentPage().getParameters().put('resourceIds','EMPTY');
            controller.StartDateTime = String.ValueOf(DateTime.now().addMinutes(10));
            controller.EndDateTime = String.ValueOf(DateTime.now().addMinutes(40));
            controller.createStaffSchedule(); 
            // create resource schedule
            ApexPages.currentPage().getParameters().put('clinicIds',cl.id);
            ApexPages.currentPage().getParameters().put('appIds','EMPTY');
            ApexPages.currentPage().getParameters().put('resourceIds',resource.id);
            controller.StartDateTime =  String.ValueOf(DateTime.now().addHours(-3));
            controller.EndDateTime =  String.ValueOf(DateTime.now().addHours(3));
            controller.createResourceSchedule();
            // for updatereshedule
            ApexPages.currentPage().getParameters().put('ObjectName','Appointment');
            ApexPages.currentPage().getParameters().put('appointmentResizeReason','meeting');
            ApexPages.currentPage().getParameters().put('eventId',appointMent.id);
            ApexPages.currentPage().getParameters().put('startDateTime',String.ValueOf(DateTime.now().addHours(-3)));
            ApexPages.currentPage().getParameters().put('endDateTime',String.ValueOf(DateTime.now().addHours(3)));
            //test for appointMent when clinic != all
            ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
            ApexPages.currentPage().getParameters().put('appIds',appointMent.id);
            ApexPages.currentPage().getParameters().put('resourceIds','EMPTY');
            controller.updateReschedule();
            //test for resourc calnedar when clinic != all
            ApexPages.currentPage().getParameters().put('ObjectName','ResourceSchedule');
            ApexPages.currentPage().getParameters().put('eventId',resourceSchedule.id);
            ApexPages.currentPage().getParameters().put('startDateTime',String.ValueOf(DateTime.now().addHours(-3)));
            ApexPages.currentPage().getParameters().put('endDateTime',String.ValueOf(DateTime.now().addHours(3)));
            ApexPages.currentPage().getParameters().put('staffIds','EMPTY');
            ApexPages.currentPage().getParameters().put('appIds','EMPTY');
            ApexPages.currentPage().getParameters().put('resourceIds',resource.id);
            controller.updateReschedule();
            //test for staff calendar when clinic != all
            ApexPages.currentPage().getParameters().put('ObjectName','StaffSchedule');
            ApexPages.currentPage().getParameters().put('eventId',staffSchedule.id);
            ApexPages.currentPage().getParameters().put('startDateTime',String.ValueOf(DateTime.now().addHours(-3)));
            ApexPages.currentPage().getParameters().put('endDateTime',String.ValueOf(DateTime.now().addHours(3)));
            ApexPages.currentPage().getParameters().put('staffIds',staff.id);
            ApexPages.currentPage().getParameters().put('appIds','EMPTY');
            ApexPages.currentPage().getParameters().put('resourceIds','EMPTY');
            controller.updateReschedule();
       // Test.stopTest();
       }
}