@isTest(seealldata=true)
public class TestvalidationAppointmentOverlap
{
    public static testMethod void mytestoverlapvw()
    {
          //creating Clinic record
        Clinic__c cl = new Clinic__c(Name = 'Ajax');
        insert cl;
        //creating staff record
        Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter',clinic__c=cl.id);
        insert staff;
        //creating staff schedule record
        Staff_Schedule__c staffSchedule = new Staff_Schedule__c( staff__c=staff.id,Shift_Start__c=DateTime.now().addHours(-5),Shift_Endds__c=DateTime.now(), Clinic__c=cl.id);
        insert staffSchedule;
        //creating record for treatment
        Treatments1__c treatment = new Treatments1__c(Name='testtrsover',Type__c ='Series', price__c=1000);
        insert treatment;
          //Creating record for patient
        contact patient = new contact(FirstName='john', LastName='Methew',Email='abc@gmail.com', Status__c='open', Preferred_Phone_Number__c='9886402200', LeadSource='Other');
        insert patient;
        //creating rsource record
        Resource__c resource = new Resource__c(Name = 'X-rayMachine',clinic__c=cl.id,background_color__c='#FCD116',color__c='#1C1C1C',Resource_ID__c='testid');
        insert resource;
        //creating resource schedule
        Resource_Schedule__c resourceSchedule = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=DateTime.now(), Open_Time__c=DateTime.now().addHours(-5), Clinic__c=cl.id, Name__c = resource.id);
        insert resourceSchedule;
        //insert related resouce for treatement
        Related_Resources__c relatedResource = new Related_Resources__c(Resource__c=resource.id, Treatments__c = treatment.id);
        insert relatedResource ;    
        // insert appointMent for opportunity
        opportunity appointMent = new opportunity(Name='testAppointMent',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(-4),New_Appointment__c = 3,
                                                Appointment_Sequence__c=3,Quantity__c=3,Treatment_Name__c=treatment.Id,LeadSource='Other',stagename = 'Cashed out',Treatment_Complete__c='Yes',Appointment_Group_Id__c=patient.Id, Appointment_End_Date_Time1__c = DateTime.now().addHours(-3), Type='Trial',resource__c = resource.id);
         insert appointMent;   
          opportunity appointMent1 = new opportunity(Name='testAppointMent2',CloseDate=system.Today(),Patient_Name__c=patient.id,clinic__c=cl.id,Appointment_Start_Date_Time__c =DateTime.now().addHours(-3),New_Appointment__c = 3,
                                               Appointment_Sequence__c=3,Quantity__c=3,Treatment_Name__c=treatment.Id,LeadSource='Other',stagename = 'Cashed out',Treatment_Complete__c='Yes',Appointment_Group_Id__c=patient.Id, Appointment_End_Date_Time1__c = DateTime.now().addHours(-2), Type='Trial',resource__c = resource.id);
         insert appointMent1;                                  
       
      }  
      
}