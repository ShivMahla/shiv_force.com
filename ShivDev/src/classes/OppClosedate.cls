// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.
//Controller for auto fill close date and appointment name.//Durgesh/KVP Business Solution
public class OppClosedate {
    public OppClosedate(fullcalUserStaff controller) { }
    public OppClosedate(ApexPages.StandardController controller) 
    {
        Opportunity opp = (Opportunity) controller.getRecord();
        opp.Closedate = system.Today();
        //Fill the appointment name by using patient name or created date of create appointment.  
      if(opp.Patient_Name__r.FirstName==Null)
       {
        opp.Name=opp.Patient_Name__r.LastName + System.TODAY();
       }
       else
       {  
            opp.Name=opp.Patient_Name__r.FirstName + opp.Patient_Name__r.LastName + System.TODAY();
            //opp.Appointment_Group_Id__c=opp.Patient_Name__r.FirstName + opp.Patient_Name__r.LastName + System.TODAY();
           
       }
    }
   
    /********** building test methods here**************/ 
        public static testMethod void OppClosedate(){
        fullcalUserStaff contr= new fullcalUserStaff();
           OppClosedate oppcl=new OppClosedate(contr);
           Clinic__c clinic= new Clinic__c(Name = 'Ajax');
                insert clinic;
            //creating staff record
            Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter',clinic__c=clinic.id);
                insert staff;
            //creating rsource record
            Resource__c resource = new Resource__c(Name = 'X-rayMachine',clinic__c=clinic.id);
                insert resource;
            //Creating record for patient
            Contact patient = new Contact(FirstName='', LastName='Methew',Email='abc@gmail.com', Status__c='open', Preferred_Phone_Number__c='9886402200', LeadSource='Other');
                insert patient;
            //creating record for treatment
            Treatments1__c treatment = new Treatments1__c(Name='Consultation', type__c='Treatment', price__c=1000,Resource_Name__c=resource.id);
            insert treatment;
            Resource_Schedule__c resourceSchedule = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=DateTime.now().addHours(5), Open_Time__c=DateTime.now().addHours(-1), Clinic__c=clinic.id, Name__c = resource.id);
            insert resourceSchedule;
            //Creating appointment record 
            Opportunity opp= new Opportunity(Name='null',CloseDate=system.Today(),clinic__c=clinic.id,
                                                  Treatment_Name__c = treatment.id, Type='Treatment', stageName='Booked',resource__c = resource.id);
            insert opp;
      
                ApexPages.StandardController sc= new ApexPages.StandardController(opp);
                OppClosedate oppcls=new OppClosedate(sc);
                Opportunity op= new Opportunity(Name='test+system.Today()',CloseDate=system.Today(),clinic__c=clinic.id,
                                                      Treatment_Name__c = treatment.id, Type='Treatment', stageName='Booked',resource__c = resource.id);
                insert op;
                
                ApexPages.StandardController scc= new ApexPages.StandardController(op);
                OppClosedate oppclss=new OppClosedate(scc);
       
        }
}