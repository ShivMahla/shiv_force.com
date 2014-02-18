// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

public class Calendar{
    public List<staffClass> staffList;
    public List<resourceClass> resourceList;
    public Calendar(){
        }
    public List<AppointmentType> AppointmentsType{ get {
        if ( AppointmentsType.size() > 0 ) { return AppointmentsType; }
        AppointmentsType.clear();
        //Because in initial stage selectedGroup property is null. bacause selectedGroupfunction is not called to set selected group property.
        //When user select clinic from picklist on visualforce page then java script function temp() will be called.
        //this temp() function calls action function 'selected group' and pass the id of selectd clinic
        //this action function calls selected group function of controller.it has clinciid whith the name groupid.        
            for ( OpportunityStage u :  [select id, MasterLabel from OpportunityStage where isActive = TRUE ]){
                AppointmentType uc = new AppointmentType(); 
                uc.u = u;    
                if(u.MasterLabel == 'Booked')
                {
                    uc.backgroundcolor = '#FCD116';
                    uc.color = '#1C1C1C';
                }
                if(u.MasterLabel == 'Confirmed')
                {
                    uc.backgroundcolor = '#E9DDDD';
                    uc.color = '#1C1C1C';
                }
                if(u.MasterLabel == 'Cancelled')
                {
                    uc.backgroundcolor ='#96C8A2';//'#780000';
                    uc.color = '#1C1C1C';
                }
                if(u.MasterLabel == 'No show')
                {
                    uc.backgroundcolor ='#800080';//'#780000';
                    uc.color = '#fff';
                }
                if(u.MasterLabel == 'Arrived')
                {
                    uc.backgroundcolor ='#CD0000';//'#780000';
                    uc.color = '#fff';
                }
                if(u.MasterLabel == 'Cashed out')
                {
                    uc.backgroundcolor =' #5C5C5C';//'#780000';
                    uc.color = '#fff';
                }
                
                //Chatter_Calendar_Prefs__c s = getBackgroundColor( u);
                uc.classname = 'fc-'+u.MasterLabel.substring(0,3);
                AppointmentsType.add( uc );
            }
          return AppointmentsType;
        } 
        private set; 
    } { AppointmentsType= new List<AppointmentType>(); }
    
    //function to fetch the name of staff
    public List<staffClass> getStaffList(string clinicId){
        staffList = new List<staffClass>();
        set<id> tmp = new set<id>();//id of staff record
        boolean a = (clinicId !='ALL');
          system.debug('jai jai maa'+clinicId+a );
           if(clinicId !='ALL' ){
                            
                for (Staff__c u :  [select id,background_color__c,color__c,Staff_ID__c,Name ,Title__c from staff__c order by Name , Clinic__r.Clinic_Code__c ] ){
                staffClass uc = new staffClass(); 
                uc.u = u;
                uc.backgroundcolor = 'green';
                uc.color = 'white';
                uc.classname = 'fc-'+u.id;  
                staffList.add( uc );
            }
            }
            else{
                for (Staff__c u :  [select id,background_color__c,color__c,Staff_ID__c,Name ,Title__c from staff__c order by Name , Clinic__r.Clinic_Code__c ] ){
                staffClass uc = new staffClass(); 
                uc.u = u;
                uc.backgroundcolor = 'green';
                uc.color = 'white';
                uc.classname = 'fc-'+u.id;  
                staffList.add( uc );
            }
            }
            
            return staffList;           
    }
    
    //function to fetch the List of resource
    public List<resourceClass> getResourceList(String clinicId){
        set<String> tmp = new set<String>();
        resourceList = new List<resourceClass>();
        if(clinicId !='ALL' ){
                for (Resource__c u :  [select id,Clinic__r.Clinic_Code__c , Clinic__r.Name,background_color__c,color__c,Resource_ID__c,Name from Resource__c where clinic__c =:clinicId order by Name , Clinic__r.Clinic_Code__c ] ){
                resourceClass uc = new resourceClass(); 
                uc.u = u;
                uc.backgroundcolor = '#3366CC';
                uc.color = '#fff';
                resourceList.add( uc );
         }
         }
         else{
                for (Resource__c u :  [select id,Clinic__r.Clinic_Code__c ,Clinic__r.Name,background_color__c,color__c,Resource_ID__c,Name from Resource__c order by Name , Clinic__r.Clinic_Code__c] ){
                resourceClass uc = new resourceClass(); 
                uc.u = u;
                uc.backgroundcolor = '#3366CC';
                uc.color = '#fff';
                resourceList.add( uc );   
         }
         }
         
         return resourceList;
        }
    }