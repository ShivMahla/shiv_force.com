@isTest(seealldata=true)
public class TestStaffScheduleTimeIn{
     public static testMethod void mytestnew(){
      Profile pf = [Select Id from Profile where Name='System Administrator'];       
        User u = new User(
                            FirstName='Test1',
                            LastName='User1',
                            Email='User1@test.com',
                            CompanyName='KVP',
                            Title='Software Engineer',
                            Username='test1@kvpcorp.com',
                            Alias='test',
                            communityNickName='kvpian',
                            TimeZoneSidKey='America/Mexico_City',
                            LocaleSidKey='en_US',
                            EmailEncodingKey='ISO-8859-1',
                            ProfileId=pf.Id,
                            LanguageLocaleKey = 'en_US'
                        );
        insert u;
        Clinic__c cl = new Clinic__c(Name = 'Ajax');
            insert cl;
        Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter',clinic__c=cl.id,User_Name__c=u.id);
        try{
            insert staff;           
            }catch(DMLException de){
           
            }
        Staff_Schedule__c staffsch=new Staff_Schedule__c( staff__c=staff.id,Shift_Start__c=DateTime.now()-1,Shift_Endds__c=DateTime.now()+3,Clock_Out__c=null,Clock_In__c=null); 
          try{
          Insert staffsch;
         
          }catch(DmlException ex){
                        }
        /*User admin = new User(
                            FirstName='Test',
                            LastName='Admin',
                            Email='Admin@test.com',
                            CompanyName='KVP',
                            Title='Software Engineer',
                            Username='testAdmin@kvpcorp.com',
                            Alias='Admn',
                            communityNickName='Sample',
                            TimeZoneSidKey='America/Mexico_City',
                            LocaleSidKey='en_US',
                            EmailEncodingKey='ISO-8859-1',
                            ProfileId=pf.Id,
                            LanguageLocaleKey = 'en_US'
                        );
        insert admin;
        System.runAs(Admin){
        
             StaffScheduleTimeIn stfSchTime=new StaffScheduleTimeIn();
             ApexPages.StandardController scon=new ApexPages.StandardController(staffsch);
             StaffScheduleTimeIn stfSchhTime=new StaffScheduleTimeIn(scon);
             stfSchhTime.saveClockOut();         
             stfSchhTime.saveStaffSchedule();
        }
       */
        System.runAs(U){
             
             
             StaffScheduleTimeIn stfSchTime=new StaffScheduleTimeIn();
             ApexPages.StandardController scon=new ApexPages.StandardController(staffsch);
             StaffScheduleTimeIn stfSchhTime=new StaffScheduleTimeIn(scon);
             stfSchhTime.saveClockOut();         
             stfSchhTime.saveStaffSchedule();
           
           
           staffsch = [select id, Staff__c,Shift_Start__c,Shift_Endds__c,End_Time_30__c,start_time_30__c,Clock_In__c,Clock_Out__c from staff_schedule__c Where ID=:staffsch.id];
            staffsch.Clock_Out__c=null;
            staffsch.Clock_In__c=DateTime.now();
           update staffsch;
           
           stfSchTime=new StaffScheduleTimeIn();
           scon=new ApexPages.StandardController(staffsch);
              stfSchhTime=new StaffScheduleTimeIn(scon);
             stfSchhTime.saveClockOut();         
             stfSchhTime.saveStaffSchedule();
             
             staffsch = [select id, Staff__c,Shift_Start__c,Shift_Endds__c,End_Time_30__c,start_time_30__c,Clock_In__c,Clock_Out__c from staff_schedule__c Where ID=:staffsch.id];
            staffsch.Clock_Out__c =DateTime.now();
           update staffsch;
           
           stfSchTime=new StaffScheduleTimeIn();
           scon=new ApexPages.StandardController(staffsch);
              stfSchhTime=new StaffScheduleTimeIn(scon);
             stfSchhTime.saveClockOut();         
             stfSchhTime.saveStaffSchedule();
         }
    }
}