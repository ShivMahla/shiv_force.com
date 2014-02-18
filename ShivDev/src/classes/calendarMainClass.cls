// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

public class calendarMainClass {
    public String clinic{get;set;}//merge field of clinic picklist values.
    public DateTime start_DateTime ;
    public DateTime end_DateTime;
    public List<resource__c> resourceList ;
    public List<staff__c> staffList;
    public List<OpportunityStage> AppointmentsType;
    public List<SelectOption> clinicnames{set;}
    public string clinicId;
    Public List<fullcalendarEvent> AppoinmentWrapperList{get;set;}
    Public List<StaffEvent> StafftWrapperList{get;set;}
    Public List<ResourceEvent> ResourceWrapperList{get;set;}
    public string StartDateTime{get;set;}
    public string EndDateTime{get;set;}
    public DateTime startDate ;
    public DateTime endDate;
    public Boolean AppoinmentSelected ;
    public Boolean StaffIdListSelected ;
    public Boolean ResourceIdListSelected ;
    public Opportunity patinetAppointment;
    public List<resourceClass> resourcesList{get;set;}
    public string CalendarDate{get;set;}
    public string staffId{get;set;}
    public string ResourceId{get;set;}
    public string SAVE{get;set;}
    public string selectedClinicName{get;set;}
    public List<clinic__c> clinicList{get;set;}
        Calendar cal = new Calendar();
    public calendarMainClass(ApexPages.StandardController controller) {
        clinic =  ApexPages.currentPage().getParameters().get('clinicId')== null ? 'ALL': ApexPages.currentPage().getParameters().get('clinicId');
        SAVE = 'OK';
        resourcesList =  cal.getResourceList(clinic);
        CalendarDate = String.valueOf( Date.today());
        clinicList = new  List<clinic__c>();
        clinicList = [Select Id,Name FROM clinic__c ];
    }
    public calendarMainClass() {
       resourceList();  
    }
    public void clinicChanged(){
         resourcesList.clear();
        clinicId = ApexPages.currentPage().getParameters().get('clinicId');
        resourcesList = cal.getResourceList(clinic);
        if( clinic   != 'ALL')
            selectedClinicName =  [Select Name from Clinic__c where id =: clinic ].Name;
        else
            selectedClinicName  ='ALL';
    }
    public opportunity getpatinetAppointment(){
        patinetAppointment = new Opportunity();
        return patinetAppointment;
    }
    //method to add picklist values dynamically in to the picklist.
    public List<SelectOption> getclinicnames(){
        List<SelectOption> options = new List<SelectOption>();
        clinicList = new List<clinic__c>();
        clinicList = [Select Id,Name FROM clinic__c ];
        options.add(new SelectOption('ALL','ALL'));
        for (Integer j=0;j<clinicList.size();j++){
            options.add(new SelectOption(clinicList [j].id ,clinicList [j].name));
        }
        return options;
    }
    //Resource List
     public List<resource__c> resourceList(){
        if(resourceList == null){
             resourceList = new List<resource__c>();
        }else{
             resourceList.clear();
        }    
        if(clinic !='ALL' ){
            for (Resource__c r :  [select id, Clinic__r.Name , Name from Resource__c where clinic__c =:clinic]){
                resourceList.add(r);
            }
        }else{
            for (Resource__c r :  [select id, Clinic__r.Name ,background_color__c,color__c,Resource_ID__c,Name from Resource__c] ){
                resourceList.add(r);   
            }
        }
        return resourceList;
    }
    //Staff List
    public List<staff__c> getstaffList(){
        if(staffList == null){
            staffList = new List<staff__c>();
        }else{
            staffList.clear();
        }if(clinic !='ALL' ){        
            for (Staff__c s :  [select id,background_color__c,color__c,Staff_ID__c,Name ,Clinic__r.Clinic_Code__c ,clinic__r.name,Title__c from staff__c WHERE clinic__c =:clinic order by Name , Clinic__r.Clinic_Code__c] ){
                 staffList.add(s);
            }
        }else{
            for (Staff__c s :  [select id,background_color__c,color__c,Staff_ID__c,Name ,Clinic__r.Clinic_Code__c,clinic__r.name,Title__c from staff__c order by Name , Clinic__r.Clinic_Code__c] ){ 
                 staffList.add(s);
            }
        }
        return staffList;           
    }
    //Appointment Type (Opportunity Stage) List
    public List<OpportunityStage> getAppointmentsType(){
        if(AppointmentsType == null){
            AppointmentsType = new List<OpportunityStage>();
        }
        for ( OpportunityStage os :  [select id, MasterLabel from OpportunityStage where isActive = TRUE ]){
            AppointmentsType.add(os);
        }   
        return AppointmentsType;
    }
    Public void LoadAltogether(){
        clinicId = ApexPages.currentPage().getParameters().get('clinicId');
        startDate = DateTime.valueOf(ApexPages.currentPage().getParameters().get('startDate') );  
        endDate = DateTime.valueOf(   ApexPages.currentPage().getParameters().get('endDate') );
        AppoinmentSelected = ApexPages.currentPage().getParameters().get('appIds').replaceAll(';','') == 'EMPTY' ? false:true;
        StaffIdListSelected = ApexPages.currentPage().getParameters().get('staffIds').replaceAll(';','') == 'EMPTY' ? false:true;
        ResourceIdListSelected = ApexPages.currentPage().getParameters().get('resourceIds').replaceAll(';','') == 'EMPTY' ? false:true;
        AppoinmentWrapperList = new List<fullcalendarEvent>();
        StafftWrapperList = new List<StaffEvent>(); 
        ResourceWrapperList = new List<ResourceEvent>(); 
        if(clinicId == 'ALL'){
           //only Resource
            if( ResourceIdListSelected  ){
               for( Resource_Schedule__c e: [Select e.ObjectName__c,e.Clinic__c,e.Clinic__r.id,e.Staff_Name__r.name ,e.clinic__r.name, e.Name__r.Id,e.Id,e.Name__r.Name,e.Close_Time__c, e.Open_Time__c From Resource_Schedule__c e   where    Name__c in :ApexPages.currentPage().getParameters().get('resourceIds').split(';')    and e.Open_Time__c >= :startDate  and  e.Close_Time__c<= :endDate ]){                          
                 ResourceEvent  v = new ResourceEvent ();  
                   v.Id=e.id; 
                   v.resourceName =e.Name__r.Name;// To Display resource name staff name together on calendar
                   v.staffName  = e.Staff_Name__r.name;
                   v.resourceID = e.Name__r.Id ;  
                   v.clinic= e.clinic__r.name;                      
                   v.clinicName   = e.clinic__r.id;
                   v.url = URL.getSalesforceBaseUrl().toExternalForm() + '/' + v.Id;                                                     
                   v.start_DateTime  = e.Open_Time__c ;                            
                   v.end_DateTime  = e.Close_Time__c;   
                   v.ObjectName = e.ObjectName__c;  
                   ResourceWrapperList.add( v);
                }

            }
            //Only Staff
            if( ( StaffIdListSelected )  ){
                    for( Staff_Schedule__c e: [Select e.ObjectName__c,e.Staff__c, e.clinic__r.name, e.resource__r.name, e.Staff__r.Id,e.Id,e.Staff__r.Name,e.Staff_ID__c,e.Shift_Start__c,e.Shift_Endds__c
                        From Staff_Schedule__c e  where e.Staff__c in : ApexPages.currentPage().getParameters().get('staffIds').split(';')
                        and e.Shift_Start__c>= :startDate  
                        //and resource__c =: null
                        and  e.Shift_Endds__c<= :endDate  
                        ])                         
                        { 
                            StaffEvent v = new StaffEvent();                            
                            v.staffName = e.Staff__r.Name;
                            v.staffID = e.id;
                            v.staffRecordID  = e.Staff__r.Id;
                            v.url = URL.getSalesforceBaseUrl().toExternalForm() + '/' + v.Id;
                            v.clinic = e.clinic__r.name;
                            v.resourceName = e.resource__r.name;
                            v.start_DateTime = e.Shift_Start__c;
                            v.end_DateTime = e.Shift_Endds__c;   
                            v.ObjectName = e.ObjectName__c;                         
                            StafftWrapperList.add( v);
                        }
            }
        }else{
            //only Resource
            if( ResourceIdListSelected   ){
                for( Resource_Schedule__c e: [Select e.ObjectName__c,e.Clinic__c,e.Staff_Name__r.name ,e.clinic__r.name, e.Name__r.Id,e.Id,e.Name__r.Name,e.Close_Time__c, e.Open_Time__c From Resource_Schedule__c e   where Name__c in :ApexPages.currentPage().getParameters().get('resourceIds').split(';')    and e.Open_Time__c >= :startDate  and  e.Close_Time__c<= :endDate and clinic__c =: clinicId  ]){                          
                   ResourceEvent  v = new ResourceEvent ();  
                   v.Id=e.id; 
                   v.resourceName =e.Name__r.Name;// To Display resource name staff name together on calendar
                   v.staffName  = e.Staff_Name__r.name;
                   v.resourceID = e.Name__r.Id ;  
                   v.clinic=e.clinic__r.name;     
                   v.clinicName   = e.clinic__r.id;                 
                   v.url = URL.getSalesforceBaseUrl().toExternalForm() + '/' + v.Id;                                                     
                   v.start_DateTime  = e.Open_Time__c ;                            
                   v.end_DateTime  = e.Close_Time__c;   
                   v.ObjectName = e.ObjectName__c;  
                   ResourceWrapperList.add( v);
                }
            }
            //Only Staff
            if(StaffIdListSelected   ){
            for(Staff_Schedule__c e: [Select e.ObjectName__c,e.Staff__c,e.clinic__r.name, e.resource__r.name, e.Staff__r.Id,e.Id,e.Staff__r.Name,e.Staff_ID__c,e.Shift_Start__c,e.Shift_Endds__c
                From Staff_Schedule__c e  where e.Staff__c in : ApexPages.currentPage().getParameters().get('staffIds').split(';')
                and e.Shift_Start__c>= :startDate  
                and clinic__c =: clinicId
                and  e.Shift_Endds__c<= :endDate  
                ])                         
                { 
                    StaffEvent v = new StaffEvent();                            
                    v.staffName = e.Staff__r.Name;
                    v.staffID = e.id;
                    v.staffRecordID  = e.Staff__r.Id;
                    v.url = URL.getSalesforceBaseUrl().toExternalForm() + '/' + v.Id;
                    v.clinic = e.clinic__r.name;
                    v.resourceName = e.resource__r.name;
                    v.start_DateTime = e.Shift_Start__c;
                    v.end_DateTime = e.Shift_Endds__c;   
                    v.ObjectName = e.ObjectName__c;                         
                    StafftWrapperList.add( v);
                }
            }
       }
    }
    //Method to get parameters
    string qstr(string s) { 
        String ret = Apexpages.currentPage().getParameters().get(s) ;
        if (ret != null ) 
            ret = String.escapeSingleQuotes( ret );
        return ret; 
    }
   public void createResourceSchedule(){
        SAVE = 'OK';
        Resource_Schedule__c Resource_Schedule  = new Resource_Schedule__c();
        if( clinic != 'ALL' )
            Resource_Schedule.Clinic__c  = clinic;
        else
            Resource_Schedule.Clinic__c  = selectedClinicName ;     
        if( staffId ==  'NOSTAFF')
            staffId    = null;
        Resource_Schedule.Staff_Name__c  = staffId;
        Resource_Schedule.Name__c        =  ResourceId;
        Resource_Schedule.Open_Time__c   =   Datetime.valueOf( StartDateTime ) ;
        Resource_Schedule.Close_Time__c   =  Datetime.valueOf( EndDateTime ) ;
        try{
            List<Staff_Schedule__c> staffScheduleList =[ Select id  from Staff_Schedule__c 
            WHERE (clinic__c =: clinic) AND
            (Staff__c  =: staffId ) AND
            ((Shift_Start__c = : Resource_Schedule.Open_Time__c   AND Shift_Endds__c = : Resource_Schedule.Close_Time__c   )OR
             (Shift_Start__c < : Resource_Schedule.Open_Time__c   AND Shift_Endds__c > : Resource_Schedule.Open_Time__c   )OR
             (Shift_Start__c < : Resource_Schedule.Close_Time__c    AND Shift_Endds__c > : Resource_Schedule.Close_Time__c   )OR
             (Shift_Start__c > : Resource_Schedule.Open_Time__c   AND Shift_Endds__c < : Resource_Schedule.Close_Time__c   )
            )
              ];
        if( staffScheduleList.size() > 0){
          //  SAVE = 'A staff schedule is there on this time';
          //  return;
        }else
        if(  ( staffId != 'NONE' ) && (staffId != null) && ( staffId != '')){
            Staff_Schedule__c Staff_Schedule  = new Staff_Schedule__c();
            if( clinic != 'ALL' )
                Staff_Schedule.Clinic__c  = clinic;
            else
                Staff_Schedule.Clinic__c  = selectedClinicName ;  
                Staff_Schedule.Staff__c        =   staffId;
                Staff_Schedule.Shift_Start__c  =   Datetime.valueOf( StartDateTime ) ;
                Staff_Schedule.Shift_Endds__c  =  Datetime.valueOf( EndDateTime ) ;
                if (!CRUDFLSCheckController.StaffSheduleIsCreatable()){
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
                 //return null;
        }
        else{
                insert Staff_Schedule;
        }
        } 
          if (!CRUDFLSCheckController.ResourceScheduleIsCreatable()){
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
                // return null;
        }
        else{
                insert Resource_Schedule;
       }
    }catch(Exception e){
        if( e.getMessage().contains('An another schedule is there on this time') )
            SAVE = 'An another schedule is there on this time';
            if( e.getMessage().contains('There are appointemts related to this resouce schedule please delete them first') )
            SAVE = 'There are appointemts related to this resouce schedule please delete them first';
            if( e.getMessage().contains('There are appointemts related to this resouce schedule please delete them first') )
            SAVE = 'There are appointemts related to this resouce schedule please delete them first';
    }
        selectedClinicName  = null;
        staffId ='NOSTAFF';
    }
    public void createStaffSchedule(){
        SAVE = 'OK';
        Staff_Schedule__c Staff_Schedule  = new Staff_Schedule__c();
        if( clinic != 'ALL' )
            Staff_Schedule.Clinic__c  = clinic;     
        else
            Staff_Schedule.Clinic__c  = selectedClinicName;      
            Staff_Schedule.Staff__c        =   staffId;
            Staff_Schedule.Shift_Start__c  =   Datetime.valueOf( StartDateTime ) ;
            Staff_Schedule.Shift_Endds__c  =  Datetime.valueOf( EndDateTime ) ;
        try{
            List<Staff_Schedule__c> staffScheduleList =[ Select id  from Staff_Schedule__c 
            WHERE  
            (Staff__c  =: staffId ) AND
            ((Shift_Start__c = : Staff_Schedule.Shift_Start__c AND Shift_Endds__c = : Staff_Schedule.Shift_Endds__c )OR
             (Shift_Start__c < : Staff_Schedule.Shift_Start__c AND Shift_Endds__c > : Staff_Schedule.Shift_Start__c )OR
             (Shift_Start__c < : Staff_Schedule.Shift_Endds__c  AND Shift_Endds__c > : Staff_Schedule.Shift_Endds__c)OR
             (Shift_Start__c > : Staff_Schedule.Shift_Start__c AND Shift_Endds__c < : Staff_Schedule.Shift_Endds__c)
            )
              ];
            If( staffScheduleList.size() > 0  )
                SAVE = 'An another schedule is there on this time';
            else 
                insert Staff_Schedule;
        }catch(Exception e){
        if( e.getMessage().contains('An another schedule is there on this time') )
            SAVE = 'An another schedule is there on this time';
        if( e.getMessage().contains('There are appointemts related to this resouce schedule please delete them first') )
            SAVE = 'There are appointemts related to this resouce schedule please delete them first';
        if( e.getMessage().contains('There are appointemts related to this resouce schedule please delete them first') )
            SAVE = 'There are appointemts related to this resouce schedule please delete them first';
        }
    }
  
    //Method to update reschedule
    public void updateReschedule(){
        String parObjectName = qstr('ObjectName');
        if(parObjectName == 'Appointment'){
            Id eventId = qstr('eventId');
            DateTime startDateTimeOfAppointment =   DateTime.valueOf(qstr('startDateTime'));
            DateTime endDateTimeOfAppointment   =   DateTime.valueOf(qstr('endDateTime'));
            string reasonForRescedule = qstr('appointmentResizeReason');
            try {
                    Opportunity eventToUpdate = [select Id, Appointment_Start_Date_Time__c, Appointment_End_Date_Time1__c,Reason_For_Rescheduling__c 
                                        from Opportunity where Id = :eventId limit 1];
                    eventToUpdate.Appointment_Start_Date_Time__c = startDateTimeOfAppointment ;
                    eventToUpdate.Appointment_End_Date_Time1__c = endDateTimeOfAppointment ;
                    eventToUpdate.Reason_For_Rescheduling__c = reasonForRescedule;
                       if (CRUDFLSCheckController.OpportunityIsisUpdateable()){
                       
                       update eventToUpdate;
                    }
                   
            }
            catch (Exception e) {
                if(! (e.getMessage()).contains('resource is not available on this time')){
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                }  
            }
       }else if(parObjectName == 'ResourceSchedule'){
            Id eventId = qstr('eventId');
            DateTime startDateTimeOfAppointment = DateTime.valueOf(qstr('startDateTime'));
            DateTime endDateTimeOfAppointment = DateTime.valueOf(qstr('endDateTime'));
            Resource_Schedule__c resSch = [select id, Open_Time__c, Close_Time__c from Resource_Schedule__c where id =: eventId ];
            resSch.Open_Time__c = startDateTimeOfAppointment ;
            resSch.Close_Time__c = endDateTimeOfAppointment;
             if (CRUDFLSCheckController.ResourceScheduleIsisUpdateable()){  
                  update  resSch;
             }
            
           
       }else if(parObjectName == 'StaffSchedule'){
            Id eventId = qstr('eventId');
            DateTime startDateTimeOfAppointment = DateTime.valueOf(qstr('startDateTime'));
            DateTime endDateTimeOfAppointment = DateTime.valueOf(qstr('endDateTime'));
            try {
                Staff_Schedule__c eventToUpdate = [select Id, Shift_Start__c, Shift_Endds__c from Staff_Schedule__c where Id = :eventId limit 1];
                eventToUpdate.Shift_Start__c= startDateTimeOfAppointment ; 
                eventToUpdate.Shift_Endds__c= endDateTimeOfAppointment ;
                 List<Staff_Schedule__c> staffScheduleList =[ Select id  from Staff_Schedule__c 
                WHERE  
                (Staff__c  =: staffId ) AND
                ((Shift_Start__c = : eventToUpdate.Shift_Start__c AND Shift_Endds__c = : eventToUpdate.Shift_Endds__c )OR
                 (Shift_Start__c < : eventToUpdate.Shift_Start__c AND Shift_Endds__c > : eventToUpdate.Shift_Start__c )OR
                 (Shift_Start__c < : eventToUpdate.Shift_Endds__c  AND Shift_Endds__c > : eventToUpdate.Shift_Endds__c)OR
                 (Shift_Start__c > : eventToUpdate.Shift_Start__c AND Shift_Endds__c < : eventToUpdate.Shift_Endds__c)
                )
                  ];
            If( staffScheduleList.size() > 0  )
                SAVE = 'An another schedule is there on this time';
            else 
            if (CRUDFLSCheckController.StaffSheduleisUpdateable()){  
                       update eventToUpdate;
                    }
                
            }catch (Exception e) {
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
        }
       
    }
    
}