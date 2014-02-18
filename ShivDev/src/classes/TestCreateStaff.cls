// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

@isTest
public class TestCreateStaff
{
  public static testMethod void testocc()  
  {
        //creating clinic record
        Clinic__c cl = new Clinic__c(Name = 'Ajax');
        insert cl;
        Clinic__c cl2 = new Clinic__c(Name = 'Hamilton');
        insert cl2;
        //creating staff record
        Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter');
        insert staff;
        //creating rsource record
        Resource__c resource = new Resource__c(Name = 'X-rayMachine',Clinic__c=cl.id);
        insert resource; 
        Resource__c resource1 = new Resource__c(Name = 'AAA',Clinic__c=cl2.id);
        insert resource1; 
        
        List<Resource_Schedule__c> insertListRS = new List<Resource_Schedule__c>();  
        List<Resource_Schedule__c> updateListRS = new List<Resource_Schedule__c>();
        List<Resource_Schedule__c> updateListRS1 = new List<Resource_Schedule__c>(); 
        List<Resource_Schedule__c> updateListRS2 = new List<Resource_Schedule__c>();
        List<Resource_Schedule__c> updateListRS3 = new List<Resource_Schedule__c>();  
        Datetime myDate = datetime.newInstance(2008, 2, 5, 8, 30, 12);
       
       //creating resource schedule
       //for(integer i=0; i <201 ;i++)
       //{
            Resource_Schedule__c resourceSchedule = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=myDate+1, Open_Time__c=myDate, Clinic__c=cl.id, Name__c = resource.id);
            insertListRS.add(resourceSchedule);
            system.debug('time'+resourceSchedule .Open_Time__c);
       //}
       insert insertListRS;
        
        Resource_Schedule__c r = [select Close_Time__c,Open_Time__c from Resource_Schedule__c limit 1 ];
        r.Close_Time__c= myDate+2;
        r.Open_Time__c= myDate +1; 
        updateListRS.add(r);
       update  updateListRS;
       
       Resource_Schedule__c r1 = [select Close_Time__c from Resource_Schedule__c limit 1 ];
        r1.Close_Time__c= myDate+3;        
        updateListRS1.add(r1);
       update  updateListRS1;
       
       Resource_Schedule__c r2 = [select Clinic__c from Resource_Schedule__c limit 1 ];
        r2.Clinic__c= cl.id;        
        updateListRS2.add(r2);
       update  updateListRS2;
       
       
       Resource_Schedule__c r3 = [select Name__c from Resource_Schedule__c limit 1 ];
        r3.Name__c= resource.id;        
        updateListRS3.add(r3);
       update  updateListRS3;
  }
}