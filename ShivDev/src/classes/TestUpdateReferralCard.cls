@isTest(seealldata=true)
public class TestUpdateReferralCard {
    public static testMethod void testCase1(){ 
     Clinic__c cl = new Clinic__c(Name = 'Ajax');
        insert cl;
        //creating staff record
        Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter',clinic__c=cl.id);
        insert staff;
        //creating rsource record
        Resource__c resource = new Resource__c(Name = 'X-rayMachine',clinic__c=cl.id,background_color__c='#FCD116',color__c='#1C1C1C',Resource_ID__c='testid');
        insert resource;
        //creating staff schedule record
        Staff_Schedule__c staffSchedule = new Staff_Schedule__c( staff__c=staff.id,Shift_Start__c=DateTime.now(),Shift_Endds__c=DateTime.now().addHours(3), Clinic__c=cl.id);
        insert staffSchedule;
        //creating resource schedule
        Resource_Schedule__c resourceSchedule = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=DateTime.now().addHours(3), Open_Time__c=DateTime.now(), Clinic__c=cl.id, Name__c = resource.id);
        
        insert resourceSchedule;
        //Creating record for patient
        contact patient = new contact(FirstName='john', LastName='Methew',Email='abc@gmail.com', Status__c='open', Preferred_Phone_Number__c='9886402200', LeadSource='Other');
        insert patient;
        //creating record for treatment
        Treatments1__c treatment = new Treatments1__c(Name='Consultation',Type__c ='Series', price__c=1000);
        insert treatment;
        //insert related resouce for treatement
        Related_Resources__c relatedResource = new Related_Resources__c(Resource__c=resource.id, Treatments__c = treatment.id);
        insert relatedResource ;
        // insert appointMent for opportunity
        opportunity appointMent = new opportunity(Name='testnewAppointMent1',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(1),New_Appointment__c = 3,
                                                 Appointment_Sequence__c=4,Quantity__c=4,Treatment_Name__c=treatment.Id,LeadSource='Other',stagename = 'Cashed out',Treatment_Complete__c='Yes',Appointment_Group_Id__c=patient.Id, Appointment_End_Date_Time1__c = DateTime.now().addHours(2), 
                                                 Type='Treatment',resource__c = resource.id);
         insert appointMent;
        // insert record for salesquote
       /* gii__SalesQuote__c salesquote=new gii__SalesQuote__c (Medical_Representative__c=staff.id,Customer_Name__c=patient.id,Appointment_Name__c=appointMent.id);
        insert salesquote; */
        // insert record for invoices  
        Invoices__c invoices=new Invoices__c(Total_Amount__c=1000,Amount_Due__c=500,Appointment_Name__c=appointMent.id,Contact_ID__c=patient.id);
        insert invoices;
        // insert record for Referral 
        Referral_Card__c Referral=new Referral_Card__c(Redeemed_Patient_Name__c=patient.id,Referral_Card_Type__c='Facial Rejuvenation');
        insert Referral;
        //insert record for payment
        Payment_Record__c payment=new Payment_Record__c (Invoice_ID__c=invoices.id,Payment_Status__c='Outstanding', Referral_card_ID__c=Referral.id,Patient_Name__c=patient.id,Referral_Type__c='Referrer');
        insert payment;
      
       }
        public static testMethod void testCase2(){ 
     Clinic__c cl = new Clinic__c(Name = 'Ajax');
        insert cl;
        //creating staff record
        Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter',clinic__c=cl.id);
        insert staff;
        //creating rsource record
        Resource__c resource = new Resource__c(Name = 'X-rayMachine',clinic__c=cl.id,background_color__c='#FCD116',color__c='#1C1C1C',Resource_ID__c='testid');
        insert resource;
        //creating staff schedule record
        Staff_Schedule__c staffSchedule = new Staff_Schedule__c( staff__c=staff.id,Shift_Start__c=DateTime.now().addHours(4),Shift_Endds__c=DateTime.now().addHours(7), Clinic__c=cl.id);
        insert staffSchedule;
        //creating resource schedule
        Resource_Schedule__c resourceSchedule = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=DateTime.now().addHours(7), Open_Time__c=DateTime.now().addHours(4), Clinic__c=cl.id, Name__c = resource.id);
        
        insert resourceSchedule;
        //Creating record for patient
        contact patient = new contact(FirstName='john', LastName='Methew',Email='abc@gmail.com', Status__c='open', Preferred_Phone_Number__c='9886402200', LeadSource='Other');
        insert patient;
        //creating record for treatment
        Treatments1__c treatment = new Treatments1__c(Name='Consultation',Type__c ='Series', price__c=1000);
        insert treatment;
        //insert related resouce for treatement
        Related_Resources__c relatedResource = new Related_Resources__c(Resource__c=resource.id, Treatments__c = treatment.id);
        insert relatedResource ;
        // insert appointMent for opportunity
        opportunity appointMent = new opportunity(Name='testnewAppointMent1',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(5),New_Appointment__c = 3,
                                                 Appointment_Sequence__c=4,Quantity__c=4,Treatment_Name__c=treatment.Id,LeadSource='Other',stagename = 'Cashed out',Treatment_Complete__c='Yes',Appointment_Group_Id__c=patient.Id, Appointment_End_Date_Time1__c =DateTime.now().addHours(6), 
                                                 Type='Treatment',resource__c = resource.id);
         insert appointMent;
        // insert record for salesquote
       /* gii__SalesQuote__c salesquote=new gii__SalesQuote__c (Medical_Representative__c=staff.id,Customer_Name__c=patient.id,Appointment_Name__c=appointMent.id);
        insert salesquote; */
        // insert record for invoices  
        Invoices__c invoices=new Invoices__c(Total_Amount__c=1000,Amount_Due__c=500,Appointment_Name__c=appointMent.id,Contact_ID__c=patient.id);
        insert invoices;
        // insert record for Referral 
        Referral_Card__c Referral=new Referral_Card__c(Redeemed_Patient_Name__c=patient.id,Referral_Card_Type__c='Facial Rejuvenation');
        insert Referral;
        //insert record for payment
        Payment_Record__c payment=new Payment_Record__c (Invoice_ID__c=invoices.id,Payment_Status__c='Outstanding', Referral_card_ID__c=Referral.id,Patient_Name__c=patient.id,Referral_Type__c='Redeemed');
        insert payment;
        }
}