// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

public with sharing class fullcalUserStaff {
    public string selectedGroup { get; private set;}    
    public Event editEvent { get; set; } { editEvent = new Event(); }
    public Staff_Schedule__c StaffSchedule;
    public string clinicId{get;set;}
    public String clinic{get; set;}//merge field of clinic picklist values.
    
    public fullcalUserStaff(ApexPages.StandardController controller){
         }
    public fullcalUserStaff() { 
        getStaffSchedule();
       }
    public Staff_Schedule__c getStaffSchedule(){
        StaffSchedule = new Staff_Schedule__c();
        return StaffSchedule ;
      }
    //Add Staff schedule through calendar
    public void saveStaffSchedule(){
      //  StaffSchedule.clinic__c = clinic;
       
      //  insert StaffSchedule;
       // }
    }
    //method to add picklist values dynamically in to the picklist.
    public List<SelectOption> getclinicnames(){
        List<SelectOption> options = new List<SelectOption>();
        List<clinic__c> clinicList = new List<clinic__c>();
        clinicList = [Select Id,Name FROM clinic__c ];
        options.add(new SelectOption('ALL','ALL'));
        for (Integer j=0;j<clinicList.size();j++){
            options.add(new SelectOption(clinicList [j].id ,clinicList [j].name));
        }
        return options;
      }
    
    //----------------------This function is used to get value of particular parameter from the visual force page--------------------------------------------------------------------------------------------------------
    string qstr(string s) { 
        
        String ret = Apexpages.currentPage().getParameters().get(s);
        if (ret != null ) 
            ret = String.escapeSingleQuotes( ret );
        return ret;       
    }
     
  // data loading
    public List<fullcalendarEventStaff> allEvents { set;  
        get {
            if ( allEvents == null ) {
                allEvents = new List<fullcalendareventStaff>();
                String idsParam = qstr('id');//fatching staff reocrd id.
                clinicId = Apexpages.currentPage().getParameters().get('clinicId');//fatching clinic record id
                set<Id> ids= new set<Id>();//collection of staff reocrd id
                            
                String st =qstr('start'); 
                if ( st != null ) 
                    startDate = Datetime.newInstance( Long.valueof( st )*1000 );  
                    
                string en =     qstr('end');
                if ( en != null ) 
                    endDate = Datetime.newInstance( Long.valueof( en )*1000 ); 
                                  
                
                try {
                    if(clinicId != 'ALL'){
                        for( Staff_Schedule__c e: [Select e.Staff__c,e.clinic__r.Name,e.resource__r.Name, e.Staff__r.Id,e.Id,e.Staff__r.Name,e.Staff_ID__c,e.Shift_Start__c,e.Shift_Endds__c
                        From Staff_Schedule__c e  where e.Staff__c =:idsParam 
                        and e.Shift_Start__c>= :startDate  
                        and  e.Shift_Endds__c<= :endDate 
                        and  Clinic__c =:clinicId])                         
                        { 
                            fullcalendarEventStaff v = new fullcalendarEventStaff();                            
                            v.title= e.Staff__r.Name;                            
                            v.Id=e.id;
                            v.url = '/'+e.id;
                            v.classname ='fc-'+e.Staff__r.Id; //getClassName( classNames.get(e.OwnerId) ); 
                            v.clinic = e.clinic__r.Name;
                            v.resource =   e.resource__r.Name;                        
                            v.startDateTime = e.Shift_Start__c;
                            v.endDateTime = e.Shift_Endds__c;                            
                            allEvents.add( v);
                        }
                    }
                    else{ 
                        for( Staff_Schedule__c e: [Select e.Staff__c,e.Staff__r.Id,e.clinic__r.Name,e.resource__r.Name, e.Id,e.Staff__r.Name,e.Staff_ID__c,e.Shift_Start__c,e.Shift_Endds__c
                        From Staff_Schedule__c e  where e.Staff__c =:idsParam  
                        and e.Shift_Start__c>= :startDate  
                        and  e.Shift_Endds__c<= :endDate  
                        ])                         
                        { 
                            fullcalendarEventStaff v = new fullcalendarEventStaff();                            
                            v.title= e.Staff__r.Name;                            
                            v.Id=e.id;
                            v.url = '/'+e.id;
                            v.classname ='fc-'+e.Staff__r.Id; //getClassName( classNames.get(e.OwnerId) );
                            v.clinic = e.clinic__r.Name;
                            v.resource =   e.resource__r.Name;                             
                            v.startDateTime = e.Shift_Start__c;
                            v.endDateTime = e.Shift_Endds__c;                            
                            allEvents.add( v);
                        }
                        
                    }
                    
                } catch (Exception e) {
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                }
            }
            return allEvents;
        }
    }   
         
/*    public void deleteEventById() {
        Id eventId = qstr('eventId');
        try {
            Event eventToUpdate = [select Id from Event where Id = :eventId limit 1];
            delete eventToUpdate;
        }
        catch (Exception e) {
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    } */
   
//--------------------Reschedule code--------------------------------------------------------------------------------------------------------  
   public void updateEventMove() {
        Id eventId = qstr('eventId');
        String dayDelta = qstr('dayDelta');
        String minuteDelta = qstr('minuteDelta');
         try {
           Staff_Schedule__c eventToUpdate = [select Id, Shift_Start__c, Shift_Endds__c
                                           from Staff_Schedule__c where Id = :eventId limit 1];
            
          {                                                            // time event  
                if(minuteDelta != '0' && minuteDelta != '' )
                {
                    Integer minutes = Double.valueOf(minuteDelta).intValue();
                    eventToUpdate.Shift_Endds__c= eventToUpdate.Shift_Endds__c.addMinutes(minutes);
                    eventToUpdate.Shift_Start__c= eventToUpdate.Shift_Start__c.addMinutes(minutes);
                }
                if (dayDelta != '0' && dayDelta != '')
                 {
                    Integer days = Double.valueOf(dayDelta).intValue();
                    eventToUpdate.Shift_Endds__c= eventToUpdate.Shift_Endds__c.addDays(days);
                    eventToUpdate.Shift_Start__c= eventToUpdate.Shift_Start__c.addDays(days);
                }
            }               
            update eventToUpdate;
        }
        catch (Exception e) {
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
       

    }
//----------------------------------------------------------------------------------------------------------------------------------------------------
    public void viewDisplay() {
        
       // pref.saveView( qstr('view') );
    }    
    
    /* change the group that we are looking at, and clear the users list
     * the users is rebuilt on the next getUsers();
     */
 // <----------------------------------------------------------------------------It fatch the information of selected group--------------------------->
    public void selectedGroup() {
        string param1 = qstr('groupId');//groupid is the parameter of action function selected group
        try { 
            selectedGroup = param1 ;
        }
        catch (Exception e) {
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        Users.clear();       
    }
    
    // inner class to add a classname
    public class UserClass { 
        public Staff__c u {get; set; } 
        public string classname {get; set; } 
        public string backgroundcolor { get; set; } 
        public string color { get; set; } 
    }    
    public List<UserClass> Users { get {
        if ( Users.size() > 0 ) { return Users; } 
        
        // from the group, list all the users
        Users.clear();
        //****************** Accessing all staff Name for particular clinic***********
        set<id> tmp = new set<id>();//id of staff record
        
        if ( selectedGroup != null ) {
            if(selectedGroup !='ALL' ){
                for (Staff__c member : [ select id, Clinic__c from staff__c]){
                                tmp.add(member.id);         
                            }                
            }
            else{
            
                for (Staff__c  member : [ select id, Clinic__c from Staff__c ]){
                                tmp.add(member.id);         
                            }
            }
            //Calendar_Color__c -----shiv|||-----
            for (Staff__c u :  [select id,background_color__c,color__c,Staff_ID__c,Name ,Title__c from staff__c where id IN :tmp] ){
                UserClass uc = new UserClass(); 
                uc.u = u;
                uc.backgroundcolor = 'green';
                uc.color = 'white';
                uc.classname = 'fc-'+u.id;  
                Users.add( uc );
            }
        }

        return Users;
        } 
        private set; 
    } { Users= new List<UserClass>(); }

//--------------------add minutes------------------------------------------------------------------------------------------------------    
   public void updateEventResize() {
        Id eventId = qstr('eventId');
        String minuteDelta = qstr('minuteDelta');
        String dayDelta = qstr('dayDelta');
 
        try {
            Staff_Schedule__c eventToUpdate = [select Id, Shift_Endds__c from Staff_Schedule__c where Id = :eventId limit 1];
            
            if(minuteDelta != '0' && minuteDelta != '' )
            {
                Integer minutes = Double.valueOf(minuteDelta).intValue();
                eventToUpdate.Shift_Endds__c = eventToUpdate.Shift_Endds__c.addMinutes(minutes);
            }
            if (dayDelta != '0' && dayDelta != '')
                 {
                    Integer days = Double.valueOf(dayDelta).intValue();
                    eventToUpdate.Shift_Endds__c= eventToUpdate.Shift_Endds__c.addDays(days);
                   //eventToUpdate.Shift_Start__c= eventToUpdate.Shift_Start__c.addDays(days);
                }
            
            update eventToUpdate;
          }
        catch (Exception e) {
                  ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        
    }
//-------------------------------------------------------------------------------------------------------------------------------    

    private Datetime startDate { get; set; } { startDate = system.now().addMonths(-1); }
    private Datetime endDate { get; set; }   { endDate = system.now(); }
    
    /******************* building test methods here *******************/
    public static testmethod void fullcalUserStaff () { 
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
        Staff_Schedule__c staffSchedule = new Staff_Schedule__c( staff__c=staff.id,Shift_Start__c=DateTime.parse('8/02/2013 8:15 AM'),Shift_Endds__c=DateTime.parse('8/02/2013 11:55 AM'), Clinic__c=cl.id);
        insert staffSchedule;        
        //creating resource schedule
        Resource_Schedule__c resourceSchedule = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=DateTime.parse('8/02/2013 11:55 AM'), Open_Time__c=DateTime.parse('8/02/2013 8:15 AM'), Clinic__c=cl.id, Name__c = resource.id);        
        insert resourceSchedule;        
        //Creating record for patient
        contact patient = new contact(FirstName='john', LastName='Methew',Email='abc@gmail.com', Status__c='open', Preferred_Phone_Number__c='9886402200', LeadSource='Other');
        insert patient;
       fullcalUserStaff contr = new fullcalUserStaff();
        ApexPages.StandardController sc = new ApexPages.StandardController(staffSchedule); 
        fullcalUserStaff controller = new fullcalUserStaff(sc);
        controller.qstr(staffSchedule.Id);
        controller.getclinicnames();
        controller.getStaffSchedule();
        controller.saveStaffSchedule();
        controller.selectedGroup='ALL';
        ApexPages.currentPage().getParameters().put('groupId',cl.id);
        //getting record of user class
        List<UserClass > uist = new List<UserClass >();
        uist = controller.Users;
        List<fullcalendarEventStaff> fCES = new List<fullcalendarEventStaff>();
        ApexPages.currentPage().getParameters().put('clinicId',cl.id);
        ApexPages.currentPage().getParameters().put('id',staff.id);
        controller.startDate =DateTime.parse('8/02/2013 8:15 AM')  ;
        controller.endDate = DateTime.parse('8/02/2013 11:55 AM');
        fCES = controller.allEvents ;      
        //coverage for updateEventMove
        ApexPages.currentPage().getParameters().put('eventId',staffSchedule.Id);
        ApexPages.currentPage().getParameters().put('dayDelta','1');
        //ApexPages.currentPage().getParameters().put('minuteDelta','20');
        controller.qstr(staffSchedule.Id);
        controller.updateEventMove();
        controller.selectedGroup();
        controller.updateEventResize();
        controller.viewDisplay();        
                     
        } 
    }