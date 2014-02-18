// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

public class StaffScheduleTimeIn{
    public staff_schedule__c staffSchedule{get;set;}
    public List<Staff_Schedule__c> staffScheduleList = new List<staff_schedule__c>();
    
    //clock In
    public void saveStaffSchedule() {
        try{
            id staffId = userinfo.getUserId(); // current user(staff) ID
            Staff__c staff = [select id from staff__c where User_Name__c =:staffId];
            DateTime currentDateTime =  DateTime.now();       
            staffScheduleList = [select id, Staff__c,End_Time_30__c,Shift_Start__c,start_time_30__c,Clock_In__c,Clock_Out__c from staff_schedule__c 
                                               where staff__c =: staff.id AND ((start_time_30__c <= :currentDateTime AND Shift_Endds__c >= :currentDateTime)
                                               OR(Shift_Start__c <= :currentDateTime AND Shift_Endds__c >= :currentDateTime))
                                               ORDER BY Shift_Start__c DESC Limit 1 ]; 
                        
        
            if(staffScheduleList.size() == 0){            
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,('Staff schedule unavailable')));
                return;
            }
            if(staffScheduleList[0].Clock_In__c == Null){
                staffScheduleList[0].Clock_In__c=System.Now(); 
                Update staffScheduleList[0];
            }
            else{
                Datetime cDT = staffScheduleList[0].Clock_In__c;
                String LongDate = cDT.format('dd/MM/yyyy h:mm a');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, ('You have already clocked In at-' +' '+ LongDate));
                ApexPages.addMessage(myMsg);
            }
        }
        Catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'You have already clocked In');
            ApexPages.addMessage(myMsg); 
        }   
              
    }
    
    public void saveClockOut() {
        try{
            id staffId = userinfo.getUserId(); 
            Staff__c staff = [select id from staff__c where User_Name__c =:staffId];
            DateTime currentDateTime =  DateTime.now();  
        
            staffScheduleList = [select id, Staff__c,Shift_Start__c,Shift_Endds__c,End_Time_30__c,start_time_30__c,Clock_In__c,Clock_Out__c from staff_schedule__c
                                 where staff__c =: staff.id AND ((End_Time_30__c >= : currentDateTime AND Shift_Start__c <= :currentDateTime )
                                 OR(Shift_Endds__c <= :currentDateTime AND Shift_Start__c >= :currentDateTime))
                                 ORDER BY Shift_Start__c DESC Limit 1 ]; 
                
           
            if(staffScheduleList.size() == 0){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.FATAL,('Staff schedule unavailable')));
                return;
            }   
            
            
            if(staffScheduleList[0].Clock_In__c == Null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, ('You need to clock in first..'));
                ApexPages.addMessage(myMsg);
            }
            else if(staffScheduleList[0].Clock_Out__c == Null){
                staffScheduleList[0].Clock_Out__c=System.Now(); 
                Update staffScheduleList[0];
            }
            else{  
                Datetime cDT = staffScheduleList[0].Clock_Out__c;
                String LongDate = cDT.format('dd/MM/yyyy h:mm a');                     
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, ('You have already clocked out at-' + ' '+ LongDate ));
                ApexPages.addMessage(myMsg);
            }
        }
        Catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'You have already clocked out');
            ApexPages.addMessage(myMsg); 
        }   
               
                
    }  
    
    public StaffScheduleTimeIn(){
    
    }
    
    public StaffScheduleTimeIn(ApexPages.StandardController sc){
    }

    
}