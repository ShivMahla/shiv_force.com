// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

public class AppointmentCloneController{
    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
    public Opportunity Appointment{get;set;}
    public Id appId;
    public AppointmentCloneController(){
       //appId= Apexpages.CurrentPage().getParameters().get('id');
    }
   public  AppointmentCloneController(ApexPages.StandardController  sc){
        //Initialize the standar controller
        this.controller = sc;
        //load the current record
        Appointment = (opportunity)controller.getRecord();
       Appointment =[SELECT Patient_Name__c,New_Appointment__c , Name,id,LeadSource,Clinic__c,Referral_card_ID1__c,AccountId,CampaignId,Appointment_Start_Date_Time__c,
                          Type,Appointment_End_Date_Time1__c,StageName,Treatment_Name__c,Treatment_Complete__c,Follow_Up_Date__c,Expiry_Date__c,Cancellation_Reasons__c,
                          Appointment_Follow_Up_Date__c,Reason_For_Rescheduling__c,Associated_Wagjag_ID__c,Wagjag_Id_Used__c,Resource__c,Redeemed_Date_Time__c,
                          Total_Purchase__c,Description__c,Discount__c,Quantity__c,Services__c,IsActive__c,Unlimited__c,Override__c,Webcam_Required__c,Webcam_Type__c
                          FROM opportunity WHERE id=:Appointment.id];
    }
   public PageReference customSave(){
       
      // pagereference p =new pagereference('/apex/Appointment_view');          
       pagereference p =new pagereference('/'+controller.getrecord().id);
       try
       {
            //setup the save point for rollback
            Savepoint sp = Database.setSavepoint();
            Opportunity newAppointment;
            newAppointment = Appointment.clone(false);            
            newAppointment.Closedate = System.today();
            try{   
                 
                if (!CRUDFLSCheckController.OpportunityIsCreatable()){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
                 return null;
                 }
                 else
                 {
                   insert newAppointment; 
                   p.getParameters().put('Id',newAppointment.id);                 
                   p.setRedirect(true);
                 }
                
            }catch(Exception e){
                 return null;
            }
        }catch(Exception e){
          
       }
       return p;
    }
     /************** building test methods here *****************/
    public static testMethod void AppointmentCloneController()
    {
        // creating record for clinic
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
        opportunity appointMent = new opportunity(Name='testAppointMent',Patient_Name__c=patient.id,CloseDate=system.Today(),clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(1),
                                                  Treatment_Name__c = treatment.id, Appointment_End_Date_Time1__c =DateTime.now().addHours(4), Type='Treatment', stageName='Booked',resource__c = resource.id);
        insert appointMent ;

        ApexPages.StandardController SC = new ApexPages.StandardController(Appointment);
        ApexPages.currentPage().getParameters().put('Appointmentids',Appointment.id);
        AppointmentCloneController cont = new AppointmentCloneController(SC);
        AppointmentCloneController contt = new AppointmentCloneController();
        cont.customSave();
       
    }
}