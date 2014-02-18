// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

public class TreatmentTracker{
    List<wrapperClass> appointmentList {get;set;}
    public Id patientId{get;set;}
    public TreatmentTracker(){
    }
    public TreatmentTracker(ApexPages.standardcontroller sc){
        patientId = Apexpages.currentPage().getparameters().get('Id');
    }
    
   public List<wrapperClass> getappointmentList (){
        wrapperClass tempObj ;
        List<wrapperClass> aReList = new List<wrapperClass>();
        AggregateResult[] groupedResults = [SELECT Patient_Name__c,Treatment_Name__r.Name , COUNT(Treatment_Name__c), COUNT(Treatment_Complete__c),
        SUM(Completed_Treatments__c)
        FROM opportunity where Patient_Name__c=:patientId GROUP BY Treatment_Name__r.Name , Patient_Name__c,Appointment_Group_Id__c];
        for(AggregateResult aR : groupedResults ){
            tempObj = new wrapperClass();
            tempObj.treatmentName = (string) aR.get('Name') ;
            tempObj.treatmentNumber = Integer.valueOf(aR.get('expr0'));
            //tempObj.treatmentCompleted = Integer.valueOf(aR.get('expr1'));
            tempObj.treatmentCompleted = Integer.valueOf(aR.get('expr2'));
            tempObj.OutStandingTreatment = tempObj.treatmentNumber - tempObj.treatmentCompleted;
            aReList.add(tempObj);
        }
        return aReList;
    }
    public class wrapperClass{
        public string treatmentName{get;set;}
        public integer treatmentNumber{get;set;}
        public integer treatmentCompleted{get;set;}
        public integer OutStandingTreatment{get;set;}
        public wrapperClass(){
        }
    }
     /***** building test methods here   *****/
    public static testMethod void TreatmentTracker()
    {
        Clinic__c cl = new Clinic__c(Name = 'Ajax');
        insert cl;
       
        
        //creating staff record
        Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter',clinic__c=cl.id);
        insert staff;
        
        //creating rsource record
        Resource__c resource = new Resource__c(Name = 'X-rayMachine',clinic__c=cl.id,background_color__c='#FCD116',color__c='#1C1C1C',Resource_ID__c='testid');
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
        /*opportunity   ag1 = [SELECT Patient_Name__c,Treatment_Name__r.Name , COUNT(Treatment_Name__c), COUNT(Treatment_Complete__c),SUM(Completed_Treatments__c) FROM opportunity where Patient_Name__c=patient.id GROUP BY Treatment_Name__r.Name , Patient_Name__c,Appointment_Group_Id__c];
        insert ag1; */
        Apexpages.currentPage().getparameters().put('Id',patient.Id);
        ApexPages.StandardController SC = new ApexPages.StandardController(Appointment);
        ApexPages.currentPage().getParameters().put('Appointmentids',Appointment.id);
        TreatmentTracker contn = new TreatmentTracker(SC);
         TreatmentTracker contt = new TreatmentTracker();
        TreatmentTracker.wrapperClass wrp=new TreatmentTracker.wrapperClass();
        
        contn.getappointmentList ();
        
       }
}