@isTest(seealldata=true)
public class TestprocessOpportunityBeforeAfterUpdate{
    public static testMethod void mytest1(){
         //creating clinic record
        Clinic__c cl = new Clinic__c(Name = 'Ajax');
        insert cl;
       
       /* Campaign canp=new Campaign(Name='test',Status='Completed',Type='Email',Priority__c='High');
        insert canp;*/
        //creating staff record
        Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter',clinic__c=cl.id);
        insert staff;
        
        //creating rsource record
        Resource__c resource = new Resource__c(Name = 'X-rayMachine',clinic__c=cl.id,background_color__c='#FCD116',color__c='#1C1C1C',Resource_ID__c='testid');
        insert resource;
        
        //creating staff schedule record
        Staff_Schedule__c staffSchedule = new Staff_Schedule__c( staff__c=staff.id,Shift_Start__c=DateTime.now().addHours(-5),Shift_Endds__c=DateTime.now(), Clinic__c=cl.id);
        insert staffSchedule;
        
        //creating resource schedule
        Resource_Schedule__c resourceSchedule = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=DateTime.now(), Open_Time__c=DateTime.now().addHours(-5), Clinic__c=cl.id, Name__c = resource.id);
        try{
        insert resourceSchedule;
        }
        catch(Exception e){
        }
        //Creating record for patient
        contact patient = new contact(FirstName='john', LastName='Methew',Email='abc@gmail.com', Status__c='open', Preferred_Phone_Number__c='9886402200', LeadSource='Other');
        insert patient;
        
        //creating record for treatment
        Treatments1__c treatment = new Treatments1__c(Name='Consultation', type__c='Series', price__c=1000);
        insert treatment;
        
        //insert related resouce for treatement
        Related_Resources__c relatedResource = new Related_Resources__c(Resource__c=resource.id, Treatments__c = treatment.id);
        insert relatedResource ;
        
         // insert appointMent for opportunity
        opportunity appointMent = new opportunity(Name='testAppointMent',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(-4),New_Appointment__c = 0,
                                                Treatment_Number__c=1,Appointment_Sequence__c=3,Quantity__c=3,Treatment_Name__c=treatment.Id,LeadSource='Other',stagename = 'Cashed out',Treatment_Complete__c='Yes',Appointment_Group_Id__c=patient.Id, Appointment_End_Date_Time1__c = DateTime.now().addHours(-3), Type='Treatment',resource__c = resource.id);
         insert appointMent;
          appointMent.stageName = 'Arrived';
        update appointMent; 
         opportunity appointMent1 = new opportunity(Appointment_External_ID__c='123',Wagjag_Id__c='456',Name='testAppointMent',CloseDate=system.Today(),clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(-2),New_Appointment__c = 3,
                                              Associated_Wagjag_ID__c ='qrtwqywueiorputygtfr',Appointment_Sequence__c=3,Quantity__c=3,Treatment_Name__c=treatment.Id,LeadSource='Other',stagename = 'Cashed out',Treatment_Complete__c='Yes',Appointment_Group_Id__c=patient.Id, Appointment_End_Date_Time1__c = DateTime.now().addHours(-1), Type='Treatment',resource__c = resource.id);
        insert appointMent1 ; 
        opportunity appointMent3 = new opportunity(Appointment_External_ID__c='1234',Wagjag_Id__c='123',Name='testAppointMent',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,  
                                              Associated_Wagjag_ID__c ='qrtwqywueiorputygtfrhjghj',Treatment_Name__c=treatment.Id,LeadSource='Other',stagename = 'Cashed out', Quantity__c =2, Type='Treatment',resource__c = resource.id);
         insert appointMent3 ; 
         appointMent1.Appointment_Start_Date_Time__c = System.now().addHours(4);
         appointMent1.Reason_For_Rescheduling__c = 'Sick';
         update appointMent1;
         update appointMent3 ;
    }  
     public static testMethod void mytest2(){
         //creating clinic record
        Clinic__c cl = new Clinic__c(Name = 'Ajax');
        insert cl;
       
        Campaign canp=new Campaign(Name='test2',Status='Completed',Type='Email',Priority__c='High');
        insert canp;
        //creating staff record
        Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter',clinic__c=cl.id);
        insert staff;
        
        //creating rsource record
        Resource__c resource = new Resource__c(Name = 'X-rayMachine',clinic__c=cl.id,background_color__c='#FCD116',color__c='#1C1C1C',Resource_ID__c='testid');
        insert resource;
        
        //creating staff schedule record
        Staff_Schedule__c staffSchedule = new Staff_Schedule__c( staff__c=staff.id,Shift_Start__c=DateTime.now().addHours(1),Shift_Endds__c=DateTime.now().addHours(8), Clinic__c=cl.id);
        insert staffSchedule;
        
        //creating resource schedule
        Resource_Schedule__c resourceSchedule = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=DateTime.now().addHours(8), Open_Time__c=DateTime.now().addHours(1), Clinic__c=cl.id, Name__c = resource.id);
        try{
        insert resourceSchedule;
        }
        catch(Exception e){
        }
        //Creating record for patient
        contact patient = new contact(FirstName='john', LastName='Methew',Email='abc@gmail.com', Status__c='open', Preferred_Phone_Number__c='9886402200', LeadSource='Other');
        insert patient;
        
        //creating record for treatment
        Treatments1__c treatment = new Treatments1__c(Name='Consultation', type__c='Series', price__c=1000);
        insert treatment;
        
        //insert related resouce for treatement
        Related_Resources__c relatedResource = new Related_Resources__c(Resource__c=resource.id, Treatments__c = treatment.id);
        insert relatedResource ;
        
         // insert appointMent for opportunity
        opportunity appointMent = new opportunity(Name='testAppointMent',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(2),New_Appointment__c = 3,
                                                Treatment_Number__c=1,Appointment_Sequence__c=3,Quantity__c=3,Treatment_Name__c=treatment.Id,LeadSource='Other',stagename = 'Arrived',Treatment_Complete__c='Yes',Appointment_Group_Id__c=patient.Id, Appointment_End_Date_Time1__c = DateTime.now().addHours(3), Type='Treatment',resource__c = resource.id);
         insert appointMent;
           // insert appointMent for opportunity
        opportunity appointMent4 = new opportunity(Appointment_External_ID__c='321',Wagjag_Id__c='123',Name='testAppointMent',CloseDate=system.Today(),Patient_Name__c=null,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(4),New_Appointment__c = 3,
                                                Associated_Wagjag_ID__c ='qrtwqywueiorputygtfr',Treatment_Number__c=1,Appointment_Sequence__c=3,Quantity__c=3,Treatment_Name__c=treatment.Id,LeadSource='Other',stagename = 'Arrived',Treatment_Complete__c='Yes',Appointment_Group_Id__c=patient.Id, Appointment_End_Date_Time1__c = DateTime.now().addHours(5), Type='Treatment',resource__c = resource.id);
         insert appointMent4; 
         opportunity appointMent5 = new opportunity(Appointment_External_ID__c='231',Wagjag_Id__c='1236',Name='testAppointMent43',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(6),New_Appointment__c = 3,
                                                Associated_Wagjag_ID__c ='qrtwqywueiorputygtfrtw',Treatment_Number__c=1,Appointment_Sequence__c=3,Quantity__c=3,Treatment_Name__c=treatment.Id,LeadSource='Other',stagename = 'Arrived',Treatment_Complete__c='Yes',Appointment_Group_Id__c=patient.Id, Appointment_End_Date_Time1__c = DateTime.now().addHours(7), Type='Treatment',resource__c = resource.id);
         insert appointMent5; 
         
         update appointMent5;
         }       
}