@isTest(seealldata=true)
public class TestDeleteSalesRoomSplitBeforeDelete{
    public static testMethod void testCase(){ 
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
        Staff_Schedule__c staffSchedule = new Staff_Schedule__c( staff__c=staff.id,Shift_Start__c=DateTime.parse('8/02/2013 10:15 AM'),Shift_Endds__c=DateTime.parse('8/02/2013 10:55 AM'), Clinic__c=cl.id);
        insert staffSchedule;
        
        //creating resource schedule
        Resource_Schedule__c resourceSchedule = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=DateTime.parse('8/02/2013 11:55 AM'), Open_Time__c=DateTime.parse('8/02/2013 10:15 AM'), Clinic__c=cl.id, Name__c = resource.id);
        
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
        opportunity appointMent = new opportunity(Name='testnewAppointMent1',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.parse('8/02/2013 10:15 AM'),New_Appointment__c = 3,
                                                 Appointment_Sequence__c=4,Quantity__c=4,Treatment_Name__c=treatment.Id,LeadSource='Other',stagename = 'Cashed out',Treatment_Complete__c='Yes',Appointment_Group_Id__c=patient.Id, Appointment_End_Date_Time1__c = DateTime.parse('8/02/2013 10:55 AM'), 
                                                 Type='Treatment',resource__c = resource.id);
         insert appointMent;  
      opportunity appointMent1 = new opportunity(Name='testnewAppointMentabc',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.parse('8/02/2013 10:55 AM'),New_Appointment__c = 3,
                                                 Appointment_Sequence__c=4,Quantity__c=4,Treatment_Name__c=treatment.Id,LeadSource='Other',stagename = 'Cashed out',Treatment_Complete__c='Yes',Appointment_Group_Id__c=patient.Id, Appointment_End_Date_Time1__c = DateTime.parse('8/02/2013 11:35 AM'), 
                                                 Type='Treatment',resource__c = resource.id,AppointmentIdforSalesroomSplit__c=appointMent.id);
      insert appointMent1;
      delete appointMent1;
      
    }
}