// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

public class fullcalUserMasterTest {
    public string selectedClinic { get; private set;}   
    Calendar cal = new Calendar(); 
    public Event editEvent { get; set; } { editEvent = new Event(); }
    public string clinicId {get;set;}
    public String clinic {get;set;}//merge field of clinic picklist values.
    public String startDate ;
    public String endDate;
    public String TreatmentName {get;set;}
    public String treatmentNameValue {get;set;}
    public List<AppointmentType> AppointmentsType {get;set;}
    public List<staffClass> staffList {get;set;}
    public List<resourceClass> resourceList {get;set;}
    public List<Id> resourceIds {get;set;}
    Public List<Selectoption>   ResourcetSelectList{get;set;}
    Public String Resource {get;set;}
    public boolean againstResour = false;
    public Resource_Schedule__c resourceschedule;// object to create resource schedule from calendar.  
    public Opportunity oppty{get;set;} // object to create appointment from calendar
    public Staff_Schedule__c StaffSchedule;// object to create staff schedule from calendar
    Opportunity oppStageChange;
    ApexPages.StandardController Opprortunity;
    Public String AppoinmentIdList{get;set;}
    Public String StaffIdList {get;set;}
    Public String ResourceIdList {get;set;}
    Public Boolean AppoinmentSelected {get;set;}
    Public Boolean StaffIdListSelected {get;set;}
    Public Boolean ResourceIdListSelected {get;set;}
    Public List<fullcalendarEvent>         AppoinmentWrapperList{get;set;}
    Public List<fullcalendarEventStaff>    StafftWrapperList{get;set;}
    Public List<fullcalendarEventResource> ResourceWrapperList{get;set;}
    public string isOverlapd {get;set;}
    public string patientId {get;set;}
    public string TreatmentId {get;set;}
    public string ResourceId {get;set;}
    public string StartDateTime {get;set;}
    public string EndDateTime {get;set;}
    public string StartDateTimeEvent {get;set;}
    public string EndDateTimeEvent {get;set;}
    public string AppointmentName {get;set;}
    public string AppointmentSourceId {get;set;}
    public string AppointmentReferelId {get;set;}
    public string opportunitySource {get;set;}
    public string CalendarDate {get;set;}
    public List<string> BlockingIntervels {get;set;}
    public String saveError {get;set;}
    public String selectedClinicName {get;set;}
    public String clinicforSelectedResource{get;set;}
    public fullcalUserMasterTest (ApexPages.StandardController controller){
        ResourcetSelectList = new List<Selectoption>();
        clinic='ALL';
        clinic    =  ApexPages.currentPage().getParameters().get('clinicId')== null ? 'ALL': ApexPages.currentPage().getParameters().get('clinicId');
        clinicId  =  ApexPages.currentPage().getParameters().get('clinicId')== null ? 'ALL': ApexPages.currentPage().getParameters().get('clinicId');
        
        startDate =   ( ApexPages.currentPage().getParameters().get('sDate')   )  ; 
        endDate   =   ( ApexPages.currentPage().getParameters().get('eDate')   )   ;
        
        StartDateTime  = ( ApexPages.currentPage().getParameters().get('sDate')   )  ; 
        
        EndDateTime  = ( ApexPages.currentPage().getParameters().get('eDate')   )  ; 
        cal = new Calendar();
        AppointmentsType = cal.AppointmentsType;
        staffList = cal.getStaffList(clinic);
        resourceList = cal.getResourceList(clinic);
        AppoinmentIdList = 'EMPTY';
        StaffIdList  = 'EMPTY';
        ResourceIdList  = 'EMPTY';
        CalendarDate = String.valueOf( Date.today());
        BlockingIntervels = new List<String>();
        opportunitySource = null;
        saveError  = 'OK';
        LoadResourceSchedule();
       }
    //function will be called when clinic will be change
    public void clinicChanged(){
        staffList.clear();
        resourceList.clear();
        clinicId = clinic;         
        staffList = cal.getStaffList(clinic);
        resourceList = cal.getResourceList(clinic);
        oppty  = new Opportunity();
        if( clinic != 'ALL' )
        selectedClinicName =  [Select Name from Clinic__c where id =: clinic ].Name;
        else
        selectedClinicName  = 'ALL';
        LoadResourceSchedule()  ; 
     }
    //Used for resource blocking
    Public void LoadResourceSchedule(){
      BlockingIntervels.clear();
      Map<String,String> BlockingIntervelsMap = new  Map<String,String> ();
      if(  clinic != 'ALL'  ){       
       List<Resource__c> ResourceList = [Select id from Resource__c where Clinic__c =: clinic Limit 1000 ];        
       List<Resource_Schedule__c >  Resource_Schedule_List;
       if(  StartDateTime != null )
        Resource_Schedule_List = [Select id, ResourceScheduleDate__c ,  Open_Time__c,Close_Time__c,Name__c from Resource_Schedule__c Where Clinic__c =: clinic  AND ResourceScheduleDate__c  =:     Date.valueOf(    StartDateTime )      ORDER BY Name__c,Open_Time__c   Limit 1000 ];
      else
        Resource_Schedule_List = [Select id, ResourceScheduleDate__c , Open_Time__c,Close_Time__c,Name__c from Resource_Schedule__c Where Clinic__c =: clinic     ORDER BY Name__c,Open_Time__c  Limit 1000  ];
       for( Resource_Schedule__c Resource_Schedule : Resource_Schedule_List  ){
        if( ( Resource_Schedule.Open_Time__c != null ) && ( Resource_Schedule.Close_Time__c != null )) {
            if( ( BlockingIntervelsMap.get(Resource_Schedule.Name__c  ) == null ) )
            BlockingIntervelsMap.put( Resource_Schedule.Name__c , String.valueOf( Resource_Schedule.ResourceScheduleDate__c  ) +';' +    '0,'+ String.valueOf(  (Resource_Schedule.Open_Time__c).hour())+'.'+String.valueOf( (Resource_Schedule.Open_Time__c).minute())+'*'+'60' +','+ String.valueOf( (Resource_Schedule.Close_Time__c).hour())+'.'+String.valueOf( (Resource_Schedule.Close_Time__c).minute())+'*'+'60'   );
            else
            BlockingIntervelsMap.put( Resource_Schedule.Name__c ,  BlockingIntervelsMap.get(Resource_Schedule.Name__c  )+','+ String.valueOf(  (Resource_Schedule.Open_Time__c).hour())+'.'+String.valueOf( (Resource_Schedule.Open_Time__c).minute())+'*'+'60' +','+ String.valueOf( (Resource_Schedule.Close_Time__c).hour())+'.'+String.valueOf( (Resource_Schedule.Close_Time__c).minute())+'*'+'60'    );
          }
       }
       integer I = 0;
    //  while(  DateTime.valueOf(  StartDateTime   ).addDays( I ) <=  DateTime.valueOf(   StartDateTime   )   )
        {    
          for(Resource__c Resource : ResourceList ){
            if( BlockingIntervelsMap.get( Resource.id ) == null  ){
              BlockingIntervels.add( String.valueOf(  DateTime.valueOf(    StartDateTime   ).addDays( I )  )+';'+ '0,24*60!'+Resource.id );
             }
            else
            {
              BlockingIntervels.add( BlockingIntervelsMap.get( Resource.id  )    +',24*60' +'!'+Resource.id);
              }
           }
           
           I ++;
       } 
     }
      else
        { 
           List<Resource__c> ResourceList = [Select id from Resource__c  Limit 1000 ];        
            List<Resource_Schedule__c >  Resource_Schedule_List;
            Date StartDate =    StartDateTime  != null ?  Date.valueOf(   StartDateTime   )   : Date.today();          
            if(  startDate  != null )
                Resource_Schedule_List = [Select id, ResourceScheduleDate__c ,  Open_Time__c,Close_Time__c,Name__c from Resource_Schedule__c   where     ResourceScheduleDate__c  =: StartDate    ORDER BY Name__c,Open_Time__c   Limit 1000 ];
            else
                Resource_Schedule_List = [Select id, ResourceScheduleDate__c , Open_Time__c,Close_Time__c,Name__c from Resource_Schedule__c   where     ResourceScheduleDate__c  =: StartDate   ORDER BY Name__c,Open_Time__c  Limit 1000  ];
            for( Resource_Schedule__c Resource_Schedule : Resource_Schedule_List  ){
                if( ( Resource_Schedule.Open_Time__c != null ) && ( Resource_Schedule.Close_Time__c != null )){
                    if( ( BlockingIntervelsMap.get(Resource_Schedule.Name__c  ) == null ) )
                    BlockingIntervelsMap.put( Resource_Schedule.Name__c , String.valueOf( Resource_Schedule.ResourceScheduleDate__c  ) +';' +    '0,'+ String.valueOf(  (Resource_Schedule.Open_Time__c).hour())+'.'+String.valueOf( (Resource_Schedule.Open_Time__c).minute())+'*'+'60' +','+ String.valueOf( (Resource_Schedule.Close_Time__c).hour())+'.'+String.valueOf( (Resource_Schedule.Close_Time__c).minute())+'*'+'60'   );
                    else
                    BlockingIntervelsMap.put( Resource_Schedule.Name__c ,  BlockingIntervelsMap.get(Resource_Schedule.Name__c  )+','+ String.valueOf(  (Resource_Schedule.Open_Time__c).hour())+'.'+String.valueOf( (Resource_Schedule.Open_Time__c).minute())+'*'+'60' +','+ String.valueOf( (Resource_Schedule.Close_Time__c).hour())+'.'+String.valueOf( (Resource_Schedule.Close_Time__c).minute())+'*'+'60'    );
                  }
               }
            integer I = 0;
            {  
                 for(Resource__c Resource : ResourceList ){
                    if( BlockingIntervelsMap.get( Resource.id ) == null  ){ 
                      BlockingIntervels.add( String.valueOf( StartDate.addDays( I )  )+';'+ '0,24*60!'+Resource.id );
                     }
                    else
                    {
                       BlockingIntervels.add( BlockingIntervelsMap.get( Resource.id  )    +',24*60' +'!'+Resource.id);
                       }
                    }
                   
                   I ++;
            } 
          } 
       }
     Public void LoadAltogether()
       {
        AppoinmentSelected        =  ApexPages.currentPage().getParameters().get('appIds').replaceAll(';','') == 'EMPTY' ? false:true;
        StaffIdListSelected       =  ApexPages.currentPage().getParameters().get('staffIds').replaceAll(';','') == 'EMPTY' ? false:true;
        ResourceIdListSelected    =  ApexPages.currentPage().getParameters().get('resourceIds').replaceAll(';','') == 'EMPTY' ? false:true;
        AppoinmentWrapperList = new List<fullcalendarEvent>();
        StafftWrapperList     = new List<fullcalendarEventStaff>(); 
        ResourceWrapperList   = new List<fullcalendarEventResource>(); 
        clinic = ApexPages.currentPage().getParameters().get('clinicId');
        StartDateTime   = ApexPages.currentPage().getParameters().get('startDate');
        EndDateTime   = ApexPages.currentPage().getParameters().get('endDate');
         if(clinic == 'ALL'){
         //  Only Appointment  
              if( ( !ResourceIdListSelected ) && ( !StaffIdListSelected )&& ( AppoinmentSelected) ){
               for( Opportunity e: [Select e.ObjectName__c,e.StageName,e.clinic__r.name,e.Staff_Name__r.name, e.treatment_name__r.name,e.resource__c, e.resource__r.name, e.Name,e.ColorClass__c,e.Appointment_Start_Date_Time__c, Appointment_End_Date_Time1__c,e.Patient_Name__c,e.Patient_Name__r.FirstName,e.Patient_Name__r.LastName, e.id,e.OwnerId, e.Appointment_End_Date_Time__c, e.type
                            From Opportunity e
                            where e.stagename in : ApexPages.currentPage().getParameters().get('appIds').split(';')
                            and e.Appointment_Start_Date_Time__c >= : DateTime.valueOf(   StartDateTime  ) 
                            and  e.Appointment_End_Date_Time1__c <= : DateTime.valueOf(   EndDateTime  )Limit 1000
                            ])
                           
                         {
                            fullcalendarEvent v = new fullcalendarEvent();
                             v.pname = e.Patient_Name__c;
                             v.title= e.Patient_Name__r.FirstName+' '+e.Patient_Name__r.LastName;
                             v.description = e.type;
                             v.appoinmentStage = e.StageName;
                             v.clinic = e.clinic__r.name;
                             v.treatmentName = e.treatment_name__r.name;
                             v.resource = e.resource__r.name;
                             v.resourceId = e.resource__c;
                             v.staff = e.Staff_Name__r.name;
                             v.Id=e.id;
                             v.url = '/'+e.id;
                             v.classname = e.ColorClass__c;//+e.ownerid; //getClassName( classNames.get(e.OwnerId) ); 
                             v.ownerid = e.OwnerId;
                             v.startDateTime = e.Appointment_Start_Date_Time__c;
                             v.endDateTime = e.Appointment_End_Date_Time1__c;
                             v.ObjectName = e.ObjectName__c;
                             AppoinmentWrapperList.add( v);    
                         } 
                   }
         //only Resource
           if( ResourceIdListSelected && ( !StaffIdListSelected )&& ( !AppoinmentSelected) ){
               for( Resource_Schedule__c e: [Select e.ObjectName__c,e.Clinic__c,e.Staff_Name__r.name ,e.clinic__r.name, e.Name__r.Id,e.Id,e.Name__r.Name,e.Close_Time__c, e.Open_Time__c From Resource_Schedule__c e   where Name__c in :ApexPages.currentPage().getParameters().get('resourceIds').split(';')    and e.Open_Time__c >= :DateTime.valueOf(   StartDateTime  )  and  e.Close_Time__c<= :DateTime.valueOf(   EndDateTime   )Limit 1000 ]){                          
                            fullcalendarEventResource v = new fullcalendarEventResource();                            
                            v.title=e.Name__r.Name +' ('+ e.Staff_Name__r.name +')'; // To Display resource name staff name together on calendar
                            v.description = e.Staff_Name__r.name;
                            v.Id=e.id;    
                            v.resourceId = e.Name__r.Id ;  
                            v.clinic=e.clinic__r.name;                      
                            v.url = '/'+e.id;
                            if(e.Staff_Name__r.name != Null){ 
                                   v.classname = 'resourceWithStaff'+' '+'resourceEvent';                                
                                }
                              if(e.Staff_Name__r.name  == Null){                                
                                 v.classname ='fc-'+e.Name__r.Id+' '+'resourceEvent';                              
                                }                                                      
                            v.startDateTime = e.Open_Time__c ;                            
                            v.endDateTime = e.Close_Time__c;   
                            v.ObjectName = e.ObjectName__c;                                                     
                            ResourceWrapperList.add( v);
                       }
                }
      
           //Appointment and Resource
           if( ( ResourceIdListSelected ) && ( !StaffIdListSelected )&& ( AppoinmentSelected) ){
                for( Resource_Schedule__c e: [Select e.ObjectName__c,e.clinic__r.name, e.Clinic__c,e.Staff_Name__r.name ,e.Name__r.Id,e.Id,e.Name__r.Name,e.Close_Time__c, e.Open_Time__c From Resource_Schedule__c e   where Name__c in :ApexPages.currentPage().getParameters().get('resourceIds').split(';')    and e.Open_Time__c >= : Datetime.valueOf( StartDateTime  )    and  e.Close_Time__c<= : Datetime.valueOf( EndDateTime  )      Limit 1000 ]){                          
                            fullcalendarEventResource v = new fullcalendarEventResource();                            
                            v.title=e.Name__r.Name +' ('+ e.Staff_Name__r.name +')'; // To Display resource name staff name together on calendar
                            v.description = e.Staff_Name__r.name;
                            v.Id=e.id; 
                            v.resourceId = e.Name__r.Id ;                           
                            v.url = '/'+e.id;
                            v.clinic=e.clinic__r.name;
                            if(e.Staff_Name__r.name != Null){ 
                                   v.classname = 'resourceWithStaff'+' '+'resourceEvent';                                  
                                }
                              if(e.Staff_Name__r.name  == Null){                                
                                 v.classname ='fc-'+e.Name__r.Id+' '+'resourceEvent';                                 
                                }                                                      
                            v.startDateTime = e.Open_Time__c ;                            
                            v.endDateTime = e.Close_Time__c;   
                            v.ObjectName = e.ObjectName__c;                                                     
                            ResourceWrapperList.add( v);
                           }
                         for( Opportunity e: [Select e.ObjectName__c,e.resource__c,e.Staff_Name__r.name, e.StageName,e.Name,e.clinic__r.name, e.treatment_name__r.name, e.resource__r.name, e.ColorClass__c,e.Appointment_Start_Date_Time__c, Appointment_End_Date_Time1__c,e.Patient_Name__c,e.Patient_Name__r.FirstName,e.Patient_Name__r.LastName, e.id,e.OwnerId, e.Appointment_End_Date_Time__c, e.type
                            From Opportunity e
                            where e.stagename in : ApexPages.currentPage().getParameters().get('appIds').split(';')
                            and e.Appointment_Start_Date_Time__c >= :Datetime.valueOf( StartDateTime  ) 
                            and  e.Appointment_End_Date_Time1__c <= :Datetime.valueOf( EndDateTime  )
                            and e.Resource__c in : ApexPages.currentPage().getParameters().get('resourceIds').split(';')    Limit 1000
                            ])
                         {
                             fullcalendarEvent v = new fullcalendarEvent();
                             v.pname = e.Patient_Name__c;
                             v.title= e.Patient_Name__r.FirstName+' '+e.Patient_Name__r.LastName;
                             v.description = e.type;
                             v.appoinmentStage = e.StageName;
                             v.Id=e.id;
                             v.resourceId = e.resource__c;
                             v.url = '/'+e.id;
                             v.clinic = e.clinic__r.name;
                             v.treatmentName = e.treatment_name__r.name;
                             v.resource = e.resource__r.name;
                             v.staff = e.Staff_Name__r.name;
                             v.classname = e.ColorClass__c;//+e.ownerid; //getClassName( classNames.get(e.OwnerId) ); 
                             v.ownerid = e.OwnerId;
                             v.startDateTime = e.Appointment_Start_Date_Time__c;
                             v.endDateTime = e.Appointment_End_Date_Time1__c;
                             v.ObjectName = e.ObjectName__c;
                             AppoinmentWrapperList.add( v);    
                         }
                  }
       
        }
        else{
      // Only Appointment  
          if( ( !ResourceIdListSelected ) && ( !StaffIdListSelected )&& ( AppoinmentSelected) ){
            for( Opportunity e: [Select e.ObjectName__c,e.StageName,e.resource__c,e.Staff_Name__r.name, e.Name,e.clinic__r.name, e.treatment_name__r.name, e.resource__r.name, e.ColorClass__c,e.Appointment_Start_Date_Time__c, Appointment_End_Date_Time1__c,e.Patient_Name__c,e.Patient_Name__r.FirstName,e.Patient_Name__r.LastName, e.id,e.OwnerId, e.Appointment_End_Date_Time__c, e.type
                            From Opportunity e
                            where e.stagename in : ApexPages.currentPage().getParameters().get('appIds').split(';')
                            and e.Appointment_Start_Date_Time__c >= :  Datetime.valueOf( StartDateTime  ) 
                            and  e.Appointment_End_Date_Time1__c <= :  Datetime.valueOf( EndDateTime  ) 
                            and clinic__c =: clinic    Limit 1000
                            ])
                         {
                             fullcalendarEvent v = new fullcalendarEvent();
                             v.pname = e.Patient_Name__c;
                             v.title= e.Patient_Name__r.FirstName+' '+e.Patient_Name__r.LastName;
                             v.description = e.type;
                             v.appoinmentStage = e.StageName;
                             v.Id=e.id;
                             v.url = '/'+e.id;
                             v.resourceId = e.resource__c;
                             v.clinic = e.clinic__r.name;
                             v.treatmentName = e.treatment_name__r.name;
                             v.resource = e.resource__r.name;
                             v.staff = e.Staff_Name__r.name;
                             v.classname = e.ColorClass__c;//+e.ownerid; //getClassName( classNames.get(e.OwnerId) ); 
                             v.ownerid = e.OwnerId;
                             v.startDateTime = e.Appointment_Start_Date_Time__c;
                             v.endDateTime = e.Appointment_End_Date_Time1__c;
                             v.ObjectName = e.ObjectName__c;
                             AppoinmentWrapperList.add( v);    
                         } 
               }
            //only Resource
           if( ResourceIdListSelected && ( !StaffIdListSelected )&& ( !AppoinmentSelected) ){
                for( Resource_Schedule__c e: [Select e.ObjectName__c,e.clinic__r.name, e.Clinic__c,e.Staff_Name__r.name ,e.Name__r.Id,
                            e.Id,e.Name__r.Name,e.Close_Time__c, e.Open_Time__c From Resource_Schedule__c e   
                            where Name__c in :ApexPages.currentPage().getParameters().get('resourceIds').split(';')    
                            and e.Open_Time__c >= :  Datetime.valueOf( StartDateTime  )   and  e.Close_Time__c<= :  Datetime.valueOf( EndDateTime  )  and clinic__c =: clinic    Limit 1000 ])                         
                        {                          
                            
                            fullcalendarEventResource v = new fullcalendarEventResource();                            
                            v.title=e.Name__r.Name +' ('+ e.Staff_Name__r.name +')'; // To Display resource name staff name together on calendar
                            v.description = e.Staff_Name__r.name;
                            v.Id=e.id;       
                            v.resourceId = e.Name__r.Id ;                     
                            v.url = '/'+e.id;
                            v.clinic=e.clinic__r.name;
                            if(e.Staff_Name__r.name != Null)
                                {                                                               
                                  v.classname = 'resourceWithStaff'+' '+'resourceEvent';                                  
                                }
                              if(e.Staff_Name__r.name  == Null)
                                {                                
                                 v.classname ='fc-'+e.Name__r.Id+' '+'resourceEvent';                                 
                                }                                                      
                            v.startDateTime = e.Open_Time__c ;                            
                            v.endDateTime = e.Close_Time__c;   
                            v.ObjectName = e.ObjectName__c;                                                     
                            ResourceWrapperList.add( v);
              
                        }
            }
       
       // Appointment and Resource
       if( ( ResourceIdListSelected ) && ( !StaffIdListSelected )&& ( AppoinmentSelected) ){ 
           for( Resource_Schedule__c e: [Select e.ObjectName__c,e.Clinic__c, e.clinic__r.name, e.Staff_Name__r.name ,
                         e.Name__r.Id,e.Id,e.Name__r.Name,e.Close_Time__c, e.Open_Time__c From Resource_Schedule__c e  
                         where Name__c in :ApexPages.currentPage().getParameters().get('resourceIds').split(';')    
                         and e.Open_Time__c >= :  Datetime.valueOf( StartDateTime  )   and  e.Close_Time__c<= :  Datetime.valueOf( EndDateTime  )  and clinic__c =: clinic    Limit 1000 ])                         
                        {                                                      
                            fullcalendarEventResource v = new fullcalendarEventResource();                            
                            v.title=e.Name__r.Name +' ('+ e.Staff_Name__r.name +')'; // To Display resource name staff name together on calendar
                            v.description = e.Staff_Name__r.name;
                            v.Id=e.id;   
                            v.resourceId = e.Name__r.Id ;   
                            v.clinic=e.clinic__r.name;                      
                            v.url = '/'+e.id;
                            if(e.Staff_Name__r.name != Null){ 
                                                              
                                  v.classname = 'resourceWithStaff'+' '+'resourceEvent';                                  
                                }
                              if(e.Staff_Name__r.name  == Null){                                
                                 v.classname ='fc-'+e.Name__r.Id+' '+'resourceEvent';                                 
                                }                                                      
                            v.startDateTime = e.Open_Time__c ;                            
                            v.endDateTime = e.Close_Time__c;   
                            v.ObjectName = e.ObjectName__c;                                                     
                            ResourceWrapperList.add( v);
                            }
                         for( Opportunity e: [Select e.ObjectName__c,e.resource__c,e.Staff_Name__r.name, e.StageName,e.Name, e.clinic__r.name, e.treatment_name__r.name, e.resource__r.name, e.ColorClass__c,e.Appointment_Start_Date_Time__c, Appointment_End_Date_Time1__c,e.Patient_Name__c,e.Patient_Name__r.FirstName,e.Patient_Name__r.LastName, e.id,e.OwnerId, e.Appointment_End_Date_Time__c, e.type
                            From Opportunity e
                            where e.stagename in : ApexPages.currentPage().getParameters().get('appIds').split(';')
                            and e.Appointment_Start_Date_Time__c >= :  Datetime.valueOf( StartDateTime  )  
                            and  e.Appointment_End_Date_Time1__c <= :  Datetime.valueOf( EndDateTime  ) 
                            and e.Resource__c in : ApexPages.currentPage().getParameters().get('resourceIds').split(';')
                            and clinic__c =: clinic    Limit 1000
                            ])
                         {
                             fullcalendarEvent v = new fullcalendarEvent();
                             v.pname = e.Patient_Name__c;
                             v.title=e.Patient_Name__r.FirstName+' '+e.Patient_Name__r.LastName;
                             v.description = e.type;
                             v.appoinmentStage = e.StageName;
                             v.Id=e.id;
                             v.resourceId = e.resource__c;
                             v.url = '/'+e.id;
                             v.clinic = e.clinic__r.name;
                             v.treatmentName = e.treatment_name__r.name;
                             v.resource = e.resource__r.name;
                             v.staff = e.Staff_Name__r.name;
                             v.classname = e.ColorClass__c;//+e.ownerid; //getClassName( classNames.get(e.OwnerId) ); 
                             v.ownerid = e.OwnerId;
                             v.startDateTime = e.Appointment_Start_Date_Time__c;
                             v.endDateTime = e.Appointment_End_Date_Time1__c;
                             v.ObjectName = e.ObjectName__c;
                             AppoinmentWrapperList.add( v);    
                         }
                    }
             }
          }
    public fullcalUserMasterTest () { 
       //getoppty();
       getoppStageChange();
      // getresourceschedule();
      // getStaffSchedule();
        
    }
   public Opportunity getoppty() {
      oppty= new Opportunity();
      return oppty;
   }
    public Opportunity getoppStageChange() {
      if(oppty== null) oppStageChange= new Opportunity();
      return oppStageChange;
   }
   public void testmessage()
     {
        ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Resource is not available on this time'));
     }
    public pagereference SaveOpportunity ()
    { 
       saveError  = 'OK';
       Opportunity Opp                    =  new Opportunity ();
       if( clinic != 'ALL' )
         Opp.Clinic__c                    =  clinic;
       else
         Opp.Clinic__c                    =  clinicforSelectedResource;
      
       Opp.Appointment_Start_Date_Time__c =  Datetime.valueOf( StartDateTimeEvent);
       Opp.Appointment_End_Date_Time1__c  =  Datetime.valueOf( EndDateTimeEvent);
       Opp.Treatment_Name__c              =  TreatmentId;
       if(patientId != null && patientId.trim() != '' )
       Opp.Patient_Name__c                =  patientId;
       Opp.CloseDate                      =  Date.Today();
       Opp.Name                           =  AppointmentName;
       Opp.Resource__c                    =  ResourceId;
       Opp.StageName                      =  'Booked';
       if( opportunitySource != 'NONE'  && opportunitySource   != null  && opportunitySource .trim() != '')
       Opp.LeadSource                     = opportunitySource; 
       if( ( AppointmentReferelId  != null ) && ( AppointmentReferelId != '' ) )
       Opp.Referral_Card_Id1__c           = AppointmentReferelId ;
       if( ( AppointmentSourceId   != null ) && ( AppointmentSourceId   != '' ) )
       Opp.CampaignId                     = AppointmentSourceId ;
       AppointmentSourceId    = null;
       AppointmentReferelId   = null;
       opportunitySource      = null;
       clinicforSelectedResource = null;
       patientId                 = null;
         
      try
      {
           List<Opportunity > appointmentList =[Select id, name,Appointment_Start_Date_Time__c, Appointment_End_Date_Time1__c from Opportunity  WHERE (clinic__c =: Opp.clinic__c) AND                      (Resource__c =: Opp.Resource__c) AND                     (Treatment_Name__c != : 'a2LJ00000008LH2') AND                     ((Appointment_Start_Date_Time__c = : Opp.Appointment_Start_Date_Time__c AND Appointment_End_Date_Time1__c = : Opp.Appointment_End_Date_Time1__c )OR                     (Appointment_Start_Date_Time__c < : Opp.Appointment_Start_Date_Time__c AND Appointment_End_Date_Time1__c > : Opp.Appointment_Start_Date_Time__c )OR                     (Appointment_Start_Date_Time__c < : Opp.Appointment_End_Date_Time1__c  AND Appointment_End_Date_Time1__c > : Opp.Appointment_End_Date_Time1__c)OR                     (Appointment_Start_Date_Time__c > : Opp.Appointment_Start_Date_Time__c AND Appointment_End_Date_Time1__c < : Opp.Appointment_End_Date_Time1__c)                    )                    AND id != : Opp.id ];     
           if( appointmentList.size() > 0){
             
           }
       }
      catch(Exception e)
      {
          return null;
      }
     
      try
      {
        if (!CRUDFLSCheckController.OpportunityIsCreatable()){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
                 return null;
        }else{
            insert Opp;
        }
      }
      catch(Exception e){
               return null;
      }
       return null;
    }
      string qstr(string s) { 
        String ret = Apexpages.currentPage().getParameters().get(s) ;
       
     if (ret != null ) 
            ret = String.escapeSingleQuotes( ret );    
          return ret; 
    }
    public void changeStageOfAppointment(){
        string id = Apexpages.currentPage().getParameters().get('appointmentId');
        string stageName = Apexpages.currentPage().getParameters().get('stageName');
        Opportunity op = [select id,StageName,Cancellation_Reasons__c from opportunity where id=:id];
        op.StageName=stageName;
        if(stageName == 'Cancelled'){
            string reason = Apexpages.currentPage().getParameters().get('reason');
            op.Cancellation_Reasons__c = reason;
        }
         if (CRUDFLSCheckController.OpportunityIsisUpdateable()){
           update op;
        }
        
    }
   public List<SelectOption> getclinicnames()//method to add picklist values dynamically in to the picklist.
     {
          List<SelectOption> options = new List<SelectOption>();
          List<clinic__c> clinicList = new List<clinic__c>();
          clinicList = [Select Id,Name FROM clinic__c ];
          options.add(new SelectOption('ALL','ALL'));
          for (Integer j=0;j<clinicList.size();j++)
          {
              options.add(new SelectOption(clinicList [j].id ,clinicList [j].name));
          }
          return options;
      }
      //****************** Accessing all appointment for particular clinic***********
    public Pagereference updateRescheduleReason(){
        String parObjectName = qstr('ObjectName');
        if(parObjectName == 'Appointment'){
            Id eventId = qstr('eventId');
            DateTime startDateTimeOfAppointment = DateTime.valueOf(qstr('startDateTime'));
            DateTime endDateTimeOfAppointment = DateTime.valueOf(qstr('endDateTime'));
            string reasonForRescedule = qstr('appointmentResizeReason');
            try {
                    Opportunity eventToUpdate = [select Id, Appointment_Start_Date_Time__c, Appointment_End_Date_Time1__c,Reason_For_Rescheduling__c 
                                        from Opportunity where Id = :eventId limit 1];
                    eventToUpdate.Appointment_Start_Date_Time__c = startDateTimeOfAppointment ;
                    eventToUpdate.Appointment_End_Date_Time1__c = endDateTimeOfAppointment ;
                    eventToUpdate.Reason_For_Rescheduling__c = reasonForRescedule;
                    if (!CRUDFLSCheckController.OpportunityIsisUpdateable()){
                
                 }else{
                      update eventToUpdate;
                 }                   
            }catch (Exception e) {
              
             }
         }
      return null; 

    }
   
}