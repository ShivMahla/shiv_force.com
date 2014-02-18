// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

@isTest
public class TestLookupController{
    public static testMethod void test(){
      //  PageReference pageRef = Page.LookupPopup;
      //  system.Test.setCurrentPage(PageRef);
        //creating clinic record
        Clinic__c cl = new Clinic__c(Name = 'Ajax');
        insert cl;
         //creating staff record
        Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter',clinic__c=cl.id);
        insert staff;
        //creating rsource record
        Resource__c resource = new Resource__c(Name = 'X-rayMachine',clinic__c=cl.id);
        insert resource;
       //Creating record for patient
        contact patient = new contact(FirstName='john', LastName='Methew',Email='abc@gmail.com', Status__c='open', Preferred_Phone_Number__c='9886402200', LeadSource='Other');
        insert patient;
        //creating record for treatment
        Treatments1__c treatment = new Treatments1__c(Name='SkinTightning', type__c='Treatment', price__c=1000);
        insert treatment;
        //insert related resouce for treatement
        Related_Resources__c relatedResource = new Related_Resources__c(Resource__c=resource.id, Treatments__c = treatment.id);
        insert relatedResource ;
        {
            ApexPages.currentPage().getParameters().put('clinic',cl.id);
            ApexPages.currentPage().getParameters().put('page','staff');
            ApexPages.currentPage().getParameters().put('resourceId',resource.id);
            LookupController controller = new LookupController();
            ApexPages.currentPage().getParameters().put('page','staff');
            LookupController controller1 = new LookupController();
            ApexPages.currentPage().getParameters().put('page','patient');
            LookupController controller2 = new LookupController();
            ApexPages.currentPage().getParameters().put('page','AppointmentSource');
            LookupController controller3 = new LookupController();
            ApexPages.currentPage().getParameters().put('page','AppointmentReferel');
            LookupController controller4 = new LookupController();
            controller4.SearchString = 'ABC';
            controller4.LookupPatients();
            controller4.LookupTreatments();
            controller4.LookupStaffs();
            controller4.LookupAppSource();
            controller4.LookupAppReferel();
            ApexPages.currentPage().getParameters().put('page','treatment');
            LookupController controller5 = new LookupController();
        }    
        {
            ApexPages.currentPage().getParameters().put('clinic','ALL');
            ApexPages.currentPage().getParameters().put('page','staff');
            ApexPages.currentPage().getParameters().put('resourceId',resource.id);
            LookupController controller = new LookupController();
            ApexPages.currentPage().getParameters().put('page','staff');
            LookupController controller1 = new LookupController();
            ApexPages.currentPage().getParameters().put('page','patient');
            LookupController controller2 = new LookupController();
            ApexPages.currentPage().getParameters().put('page','AppointmentSource');
            LookupController controller3 = new LookupController();
            ApexPages.currentPage().getParameters().put('page','AppointmentReferel');
            LookupController controller4 = new LookupController();
            controller4.SearchString = 'ABC';
            controller4.LookupPatients();
            controller4.LookupTreatments();
            controller4.LookupStaffs();
            controller4.LookupAppSource();
            controller4.LookupAppReferel();
            ApexPages.currentPage().getParameters().put('page','treatment');
            LookupController controller5 = new LookupController();
        }  
    }
}