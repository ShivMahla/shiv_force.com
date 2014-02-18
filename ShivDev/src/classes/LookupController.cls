// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

Public class LookupController{
  
   Public  List<Contact>      ContactList{get;set;}
   Public  List<Treatments1__c> TreatmentList{get;set;}
   Public  List<Staff__c>  StaffList{get;set;}
   Public  List<Campaign>  AppointmentSourcelist{get;set;}
   Public  List<Referral_Card__c>  ReferralList{get;set;}
   public List<Related_Resources__c> relatedResource {get;set;}
   public List<ID> idList {get;set;}
   Public  String           SearchString{get;set;}
   Public  String  ClinicName {get;set;}
   public String resourceId {get;set;}
   Public LookupController(){ 
       SearchString =  '';
       ContactList     =  new List<Contact>();
       TreatmentList   =  new List<Treatments1__c>();
       relatedResource = new List<Related_Resources__c>();
       idList = new List<ID>();
       StaffList       =  new List<Staff__c>();
       resourceId = ApexPages.CurrentPage().getParameters().get('resourceId');
       if( ApexPages.CurrentPage().getParameters().get('page') == 'staff'){
        ClinicName = ApexPages.CurrentPage().getParameters().get('clinic');
        if( ClinicName  == 'ALL' ) 
        StaffList    = [Select id,Name,Clinic__r.Name,Phone_Number__c from  Staff__c    Limit 30 ];
        else
        StaffList    = [Select id,Name,Clinic__r.Name,Phone_Number__c from  Staff__c    Limit 30 ];
       }
       if( ApexPages.CurrentPage().getParameters().get('page') == 'treatment'){
           relatedResource = [select Treatments__c from Related_Resources__c where Resource__c =: resourceId] ;
           for(Related_Resources__c r : relatedResource ){
               idList.add(r.Treatments__c );
           }            
           TreatmentList =  [Select id,Name,Type__c from Treatments1__c where Id in : idList  Limit 30];
       }
       if( ApexPages.CurrentPage().getParameters().get('page') == 'patient')
       ContactList   =  [Select id,Name from Contact  Limit 30];
       if( ApexPages.CurrentPage().getParameters().get('page') == 'AppointmentSource')
       AppointmentSourcelist =  [Select id, Name, StartDate , EndDate from  Campaign Limit 30];  
       if( ApexPages.CurrentPage().getParameters().get('page') == 'AppointmentReferel')
       ReferralList   =  [Select id,Name,Referral_Card_Type__c , Used_By_Referrer_Patient__c,Discount__c from  Referral_Card__c Limit 30];  
   }
   Public void  LookupPatients(){ 
       SearchString = SearchString + '%';
       ContactList  = [Select id,Name from Contact Where Name LIKE: SearchString Limit 10000 ];
       SearchString  ='';
   }
   Public void  LookupTreatments(){ 
       SearchString = SearchString + '%';
       TreatmentList = [Select id,Name,Type__c from Treatments1__c Where Name LIKE: SearchString AND id in : idList Limit 10000  ];
       SearchString  ='';
   }
   Public void  LookupStaffs(){ 
        SearchString = SearchString + '%';      
        if( ClinicName  == 'ALL' ){
                StaffList    = [Select id,Name,Clinic__r.Name,Phone_Number__c from  Staff__c where Name LIKE: SearchString   Limit 10000];            
        }else{
            StaffList    = [Select id,Name,Clinic__r.Name,Phone_Number__c from  Staff__c where Name LIKE: SearchString  Limit 10000];
            SearchString  ='';
        }
   }
   Public void  LookupAppSource(){ 
       SearchString = SearchString + '%';
       AppointmentSourcelist =  [Select id, Name, StartDate , EndDate from  Campaign Where Name LIKE: SearchString Limit 10000];  
       SearchString  ='';
   }
   Public void  LookupAppReferel(){ 
       SearchString = SearchString + '%';
       ReferralList   =  [Select id,Name,Referral_Card_Type__c , Used_By_Referrer_Patient__c,Discount__c from  Referral_Card__c Where Name LIKE: SearchString Limit 10000];  
       SearchString  ='';
   }
}