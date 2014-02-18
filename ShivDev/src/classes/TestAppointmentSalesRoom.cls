@isTest(seealldata=true)
public class TestAppointmentSalesRoom{
    public static testMethod void mytestnewq(){
     //creating Clinic record
        Clinic__c cl = new Clinic__c(Name = 'Ajax');
        insert cl;
        //creating staff record
        Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter',clinic__c=cl.id);
        insert staff;
        
        //creating rsource record
        Resource__c resource = new Resource__c(Name = 'Sales Room',clinic__c=cl.id,background_color__c='#FCD116',color__c='#1C1C1C',Resource_ID__c='testid');
        insert resource;
        
        //creating staff schedule record
        Staff_Schedule__c staffSchedule = new Staff_Schedule__c( staff__c=staff.id,Shift_Start__c=DateTime.now().addHours(-5),Shift_Endds__c=DateTime.now().addHours(5), Clinic__c=cl.id);
        insert staffSchedule;
        
        //creating resource schedule
        Resource_Schedule__c resourceSchedule = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=DateTime.now().addHours(5), Open_Time__c=DateTime.now().addHours(-5), Clinic__c=cl.id, Name__c = resource.id);
        
        insert resourceSchedule;
        
        //Creating record for patient
        contact patient = new contact(FirstName='john', LastName='Methew',Email='abc@gmail.com', Status__c='open', Preferred_Phone_Number__c='9886402200', LeadSource='Other');
        insert patient;
        
        //creating record for treatment
        Treatments1__c treatment = new Treatments1__c(Name='Consultation',Type__c ='Trial', price__c=1000);
        insert treatment;
         //insert related resouce for treatement
        Related_Resources__c relatedResource = new Related_Resources__c(Resource__c=resource.id, Treatments__c = treatment.id);
        insert relatedResource ;
        
        // insert appointMent for opportunity
        opportunity appointMent = new opportunity(Name='testnewAppointMent1',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(-4),New_Appointment__c = 3,
                                                 Appointment_Sequence__c=4,Quantity__c=4,Treatment_Name__c=treatment.Id,LeadSource='Other',stagename = 'Booked',Treatment_Complete__c='Yes',Appointment_Group_Id__c=patient.Id, Appointment_End_Date_Time1__c = DateTime.now().addHours(-3), 
                                                 Type='Trial',resource__c = resource.id);
         insert appointMent; 
         Treatments1__c treatment1 = new Treatments1__c(Name='test',Type__c ='Trial', price__c=1000);
         insert treatment1;      
        
        //insert related resouce for treatement
        Related_Resources__c relatedResource1 = new Related_Resources__c(Resource__c=resource.id, Treatments__c = treatment1.id);
        insert relatedResource1 ;
        
        opportunity appointMent2 = new opportunity(Name='testnewAppointMent1',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(-2),New_Appointment__c = 3,
                                                 Appointment_Sequence__c=4,Quantity__c=4,Treatment_Name__c=treatment1.Id,LeadSource='Other',stagename = 'Booked',Treatment_Complete__c='Yes',Appointment_Group_Id__c=patient.Id, Appointment_End_Date_Time1__c = DateTime.now().addHours(-1), 
                                                 Type='Treatment',resource__c = resource.id);
         insert appointMent2;
      }
          public static testMethod void mytestnewonre(){
     //creating Clinic record
        Clinic__c cl = new Clinic__c(Name = 'Ajax');
        insert cl;
        //creating staff record
        Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter',clinic__c=cl.id);
        insert staff;
        
        //creating rsource record
        Resource__c resource = new Resource__c(Name = 'Sales Room',clinic__c=cl.id,background_color__c='#FCD116',color__c='#1C1C1C',Resource_ID__c='testid');
        insert resource;
        
        //creating staff schedule record
        Staff_Schedule__c staffSchedule = new Staff_Schedule__c( staff__c=staff.id,Shift_Start__c=DateTime.now().addHours(-5),Shift_Endds__c=DateTime.now().addHours(9), Clinic__c=cl.id);
        insert staffSchedule;
        
        //creating resource schedule
        Resource_Schedule__c resourceSchedule = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=DateTime.now().addHours(9), Open_Time__c=DateTime.now().addHours(-5), Clinic__c=cl.id, Name__c = resource.id);
        
        insert resourceSchedule;
        
        //Creating record for patient
        contact patient = new contact(FirstName='john', LastName='Methew',Email='abc@gmail.com', Status__c='open', Preferred_Phone_Number__c='9886402200', LeadSource='Other');
        insert patient;
        
          Treatments1__c treatment2 = new Treatments1__c(Name='Consultation',Type__c ='Treatment', price__c=1000);
         insert treatment2 ;      
        
        //insert related resouce for treatement
        Related_Resources__c relatedResource2 = new Related_Resources__c(Resource__c=resource.id, Treatments__c = treatment2.id);
        insert relatedResource2;
        
        opportunity appointMent3 = new opportunity(Name='testnewAppointMent12',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(2),New_Appointment__c = 3,
                                                 Appointment_Sequence__c=4,Quantity__c=4,Treatment_Name__c=treatment2.Id,LeadSource='Other',stagename = 'Booked',Treatment_Complete__c='Yes',Appointment_Group_Id__c=patient.Id, Appointment_End_Date_Time1__c = DateTime.now().addHours(3), 
                                                 Type='Treatment',resource__c = resource.id);
         insert appointMent3;
         Treatments1__c treatment3 = new Treatments1__c(Name='Consultation23',Type__c ='Treatment', price__c=1000);
         insert treatment3 ;      
        
        //insert related resouce for treatement
        Related_Resources__c relatedResource3 = new Related_Resources__c(Resource__c=resource.id, Treatments__c = treatment3.id);
        insert relatedResource3;
        opportunity appointMent4 = new opportunity(Name='testnewAppointMent12',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(4),New_Appointment__c = 3,
                                                 Appointment_Sequence__c=4,Quantity__c=4,Treatment_Name__c=treatment3.Id,LeadSource='Other',stagename = 'Booked',Treatment_Complete__c='Yes',Appointment_Group_Id__c=patient.Id, Appointment_End_Date_Time1__c = DateTime.now().addHours(5), 
                                                 Type='Treatment',resource__c = resource.id);
         insert appointMent4;
          appointMent4 = [ Select Type,Treatment_Type__c ,Appointment_Start_Date_Time__c ,Appointment_End_Date_Time1__c , Reason_For_Rescheduling__c from opportunity where id =:appointMent3.id ];
          appointMent4.Type='Treatment';
         appointMent4.Appointment_Start_Date_Time__c =DateTime.now().addHours(6);
         appointMent4.Appointment_End_Date_Time1__c = DateTime.now().addHours(7);
         appointMent4.Reason_For_Rescheduling__c='Late';
         update appointMent4;
       
      }   
      public static testMethod void mytestnewonretrewr(){
     //creating Clinic record
        Clinic__c cl1 = new Clinic__c(Name = 'Ajax');
        insert cl1;
        //creating staff record
        Staff__c staff1 = new Staff__c(Name = 'Dr. Joe Carternre',clinic__c=cl1.id);
        insert staff1;
        
        //creating rsource record
        Resource__c resource1 = new Resource__c(Name = 'Sales Room',clinic__c=cl1.id,background_color__c='#FCD116',color__c='#1C1C1C',Resource_ID__c='testid');
        insert resource1;
        
        //creating staff schedule record
        Staff_Schedule__c staffSchedule1 = new Staff_Schedule__c( staff__c=staff1.id,Shift_Start__c=DateTime.now().addHours(-5),Shift_Endds__c=DateTime.now().addHours(9), Clinic__c=cl1.id);
        insert staffSchedule1;
        
        //creating resource schedule
        Resource_Schedule__c resourceSchedule1 = new Resource_Schedule__c(Staff_Name__c=staff1.id,Close_Time__c=DateTime.now().addHours(9), Open_Time__c=DateTime.now().addHours(-5), Clinic__c=cl1.id, Name__c = resource1.id);
        
        insert resourceSchedule1;
        
        //Creating record for patient
        contact patient1 = new contact(FirstName='johnso', LastName='Methew',Email='abc.man@gmail.com', Status__c='open', Preferred_Phone_Number__c='9886402200', LeadSource='Other');
        insert patient1;
        
          Treatments1__c treatment4 = new Treatments1__c(Name='Consultation',Type__c ='Treatment', price__c=1000);
         insert treatment4 ;      
        
        //insert related resouce for treatement
        Related_Resources__c relatedResource3 = new Related_Resources__c(Resource__c=resource1.id, Treatments__c = treatment4.id);
        insert relatedResource3;
        
        opportunity appointMent5 = new opportunity(Name='testnewAppointMent12',CloseDate=system.Today(),Patient_Name__c=patient1.id,clinic__c=cl1.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(-2),New_Appointment__c = 3,
                                                 Appointment_Sequence__c=4,Quantity__c=4,Treatment_Name__c=treatment4.Id,LeadSource='Other',stagename = 'Booked',Treatment_Complete__c='Yes',Appointment_Group_Id__c=patient1.Id, Appointment_End_Date_Time1__c = DateTime.now().addHours(-1), 
                                                 Type='Treatment',resource__c = resource1.id);
         insert appointMent5;
         Treatments1__c treatment5 = new Treatments1__c(Name='Consultation23',Type__c ='Treatment', price__c=1000);
         insert treatment5 ;      
        
        //insert related resouce for treatement
        Related_Resources__c relatedResource4 = new Related_Resources__c(Resource__c=resource1.id, Treatments__c = treatment5.id);
        insert relatedResource4;
        opportunity appointMent6 = new opportunity(Name='testnewAppointMent12',CloseDate=system.Today(),Patient_Name__c=patient1.id,clinic__c=cl1.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(-4),New_Appointment__c = 3,
                                                 Appointment_Sequence__c=4,Quantity__c=4,Treatment_Name__c=treatment5.Id,LeadSource='Other',stagename = 'Booked',Treatment_Complete__c='Yes',Appointment_Group_Id__c=patient1.Id, Appointment_End_Date_Time1__c = DateTime.now().addHours(-3), 
                                                 Type='Treatment',resource__c = resource1.id);
         insert appointMent6;
          appointMent6= [ Select Type,Treatment_Type__c ,Appointment_Start_Date_Time__c ,Appointment_End_Date_Time1__c , Reason_For_Rescheduling__c from opportunity where id =:appointMent6.id ];
          appointMent6.Type='Treatment';
         appointMent6.Appointment_Start_Date_Time__c =DateTime.now();
         appointMent6.Appointment_End_Date_Time1__c = DateTime.now().addHours(1);
         appointMent6.Reason_For_Rescheduling__c='Late';
         update appointMent6;
       
      }  
 }