// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

//Owner :KVP || Company Name;KVP BUsiness Solution || Created Date:13/06/2012 
trigger AppointmentSalesRoom on Opportunity (after insert,after update){ 
  if(Trigger.new[0].Treatment_Name__c != null )  
    if (!FollowUpTaskHelper.hasAlreadyCreatedFollowUpTasks()&& [select Name from Treatments1__c where  id =: Trigger.new[0].Treatment_Name__c ].Name !='Consultation' ){
      List<Opportunity> M = new List<Opportunity>(); 
      List<Opportunity> UpdateM = new List<Opportunity>();
      List<Opportunity> RescheduleConsult = new List<Opportunity>();
      List<Opportunity> RescheduleConsult1 = new List<Opportunity>(); 
      List<Opportunity> RescheduleConsult2 = new List<Opportunity>();
      List<Treatment__c> TreatmentList = new List<Treatment__c>();
      List<Treatment__c> TreatmentListToUpdate = new List<Treatment__c>(); 
      List<Treatment__c> TreatmentListToUpdate1 = new List<Treatment__c>(); 
      List<Opportunity>updateAppointmentList = new List<Opportunity>();
      List<Treatment_Pitch_Information__c> PitchListInsert = new List<Treatment_Pitch_Information__c>();
      set<id>  updateAppointmentSet = new set<id>();
      Set<ID> ContactIds = new Set<ID>();
      set<id> opid=new set<id>();
        
      //id's of patient Record.
      if(trigger.isInsert || trigger.IsUpdate){
        for(Opportunity  p : trigger.New){
          ContactIds.add(p.Patient_Name__c);
        }
      }
                           
      //To update information about total appointment and total webcam used by patient on patient record
      map<Id,Decimal> ContactMap = new map<Id,Decimal>();         
      for(AggregateResult q : [select Patient_Name__c,Count(Id),Count(Webcam_Required__c)from Opportunity where Patient_Name__c IN :ContactIds group by Patient_Name__c]){
        ContactMap.put((Id)q.get('Patient_Name__c'),(Double)q.get('expr0'));
      }
      List<contact> ContactToUpdate = new List<contact>();
      for(Contact o : [Select Id, No_of_Appointment__c,No_Of_Webcam_Used__c from Contact where Id IN :ContactIds]){
        Double AppointmentCount    = ContactMap.get(o.Id);
        o.No_of_Appointment__c     = AppointmentCount;                        
        Double WebCamCount         = ContactMap.get(o.Id);
        o.No_Of_Webcam_Used__c     = WebCamCount;
        ContactToUpdate.add(o);
      }         
      update ContactToUpdate;    
         
        /*------------------------------------------------------------------------------------------------------------------------------------------        
                                                   For create appointment block 
        -------------------------------------------------------------------------------------------------------------------------------------------*/           
  
      if(Trigger.IsInsert){
        for(Opportunity opp: Trigger.New){ 
          //Appointment block for type Trial      
          if(opp.Treatment_Type__c  == 'Trial' && opp.stageName  == 'Booked' && opp.Appointment_Start_Date_Time__c != null ){
            Treatment__c treat                         = new Treatment__c();
            treat.Appointment_Name__c                  = opp.Id;
            treat.Patient_Name__c                      = opp.Patient_Name__c;
            treat.Appointment_Type__c                  = 'Trial';
            treat.Name                                 = 'Tour/New Patient Form Fill';
            if( opp.Appointment_Start_Date_Time__c != null ){                           
              treat.Start_Time__c                        = opp.Appointment_Start_Date_Time__c;   
              datetime newMinutes                        = treat.Start_Time__c.addMinutes(10);
              datetime newMinutes1                       = treat.Start_Time__c.addMinutes(15);
              treat.Appointment_Time_after_15_minute__c  = newminutes1;
              treat.End_Time__c                          = newMinutes;
            }     
            TreatmentList.add(treat);                             
            Treatment__c treat1                        = new Treatment__c(); 
            treat1.Appointment_Name__c                 = opp.Id;
            treat1.Patient_Name__c                     = opp.Patient_Name__c;
            treat1.Appointment_Type__c                 = 'Trial';
            treat1.Name                                = 'Trial Against Resource';
            if( opp.Appointment_Start_Date_Time__c != null ){                           
              treat1.Start_Time__c                       = opp.Appointment_Start_Date_Time__c.addMinutes(10);   
              datetime newMinutes2                       = treat1.Start_Time__c.addMinutes(30);
              datetime newMinutes3                       = treat1.Start_Time__c.addMinutes(15);
              treat1.Appointment_Time_after_15_minute__c = newminutes3;
              treat1.End_Time__c                         = newMinutes2; 
            }    
            TreatmentList.add(treat1);  
          }   
                
          //Appointment block for type treatment  
          if(opp.Treatment_Type__c == 'Treatment' && opp.stageName    ==  'Booked'  &&  opp.Appointment_Start_Date_Time__c != null  && opp.Appointment_End_Date_Time1__c != null  ){
            Treatment__c treat                         = new Treatment__c();
            treat.Appointment_Name__c                  = opp.Id;
            treat.Patient_Name__c                      = opp.Patient_Name__c;
            treat.Appointment_Type__c                  = 'Treatment';
            if(opp.Treatment_Name__r.Name     !=   'Consultation'){
              treat.Name                              = 'Tour/New Patient Form Fill';
            }  
            if(opp.Treatment_Name__r.Name      ==   'Consultation'){
              treat.Name                              = 'Consultation';
            }
            if( opp.Appointment_Start_Date_Time__c != null ){
              treat.Start_Time__c                        = opp.Appointment_Start_Date_Time__c; 
              datetime newMinutes1                       = opp.Appointment_Start_Date_Time__c.addMinutes(15);
              treat.Appointment_Time_after_15_minute__c  = newminutes1;
              treat.End_Time__c                          = opp.Appointment_End_Date_Time1__c;
            }
            TreatmentList.add(treat);                      
          }
          insert TreatmentList; 
/*------------------------------------------------------------------------------------------------------------------------------------------        
                                                   For create new record for consultaion for treatment. 
-------------------------------------------------------------------------------------------------------------------------------------------*/      
                    Opportunity MS = new Opportunity(); 
                    if (opp.Treatment_Type__c == 'Trial' &&  opp.Appointment_Start_Date_Time__c != null ) {
                   
                        Treatments1__c tt                    =    [select id, name from Treatments1__c where name='Consultation' limit 1];
                        Resource__c rr                       =    [select id,name from Resource__c where Clinic__c =:  opp.Clinic__c  AND name='Sales Room' limit 1];
                        MS.Treatment_Name__c                 =    tt.id;  
                        Ms.Related_Treatment__c              =    opp.Treatment_Name__c;
                        MS.LeadSource                        =    opp.LeadSource;
                        if( opp.Appointment_Start_Date_Time__c    != null )
                        MS.Appointment_Start_Date_Time__c    =    opp.Appointment_Start_Date_Time__c.addMinutes(40); 
                        if( opp.Appointment_End_Date_Time1__c     != null )
                        MS.Appointment_End_Date_Time1__c     =    opp.Appointment_Start_Date_Time__c.addMinutes(60);                        
                        MS.StageName                         =    opp.StageName;
                        MS.Patient_Name__c                   =    opp.Patient_Name__c;
                        MS.Treatment_Complete__c             =    'No';
                        MS.Clinic__c                         =    opp.Clinic__c;
                        MS.Account                           =    opp.Account;
                        MS.Campaign                          =    opp.Campaign;
                        MS.Webcam_Required__c                =    opp.Webcam_Required__c;
                        MS.Name                              =    opp.Name;
                        MS.Resource__c                       =    rr.id;
                        MS.CloseDate                         =    opp.CloseDate;
                        MS.New_Appointment__c                =    0;
                        MS.Appointment_Group_Id__c           =    opp.Appointment_Group_Id__c; 
                        MS.Appointment_Sequence__c           =    opp.Appointment_Sequence__c;   
                        MS.AppointmentIdforSalesroomSplit__c =    opp.Id;                                                                                         
                        try
                        {
                            insert MS;
                            
    
                        }
                        catch(Exception e){
                          
                          trigger.new[0].addError(  e.getMessage() );
                        }
            
                    }  
                    
                    Opportunity MS1          = new Opportunity();  
                    if( opp.Treatment_Type__c == 'Treatment' &&  opp.Appointment_Start_Date_Time__c != null  && opp.Appointment_End_Date_Time1__c != null){
                        Treatments1__c tt                     =    [select id, name from Treatments1__c where name=: 'Consultation' limit 1];
                        Resource__c rr                        =    [select id,name from Resource__c  where  Clinic__c =:  opp.Clinic__c AND name='Sales Room' limit 1];
                        MS1.Treatment_Name__c                 =    tt.id;  
                        Ms1.Related_Treatment__c              =    opp.Treatment_Name__c;
                        MS1.LeadSource                        =    opp.LeadSource;
                        if( opp.Consult_Start_time__c         != null )
                        MS1.Appointment_Start_Date_Time__c    =    opp.Appointment_End_Date_Time1__c ;
                        if( opp.Consult_Start_time__c         != null )
                        MS1.Appointment_End_Date_Time1__c     =    opp.Appointment_End_Date_Time1__c.addminutes(20);
                        MS1.StageName                         =    opp.StageName;
                        MS1.Patient_Name__c                   =    opp.Patient_Name__c;
                        MS1.Clinic__c                         =    opp.Clinic__c;
                        MS1.Account                           =    opp.Account;
                        MS1.Campaign                          =    opp.Campaign;
                        MS1.Webcam_Required__c                =    opp.Webcam_Required__c;
                        MS1.Treatment_Complete__c             =    'No';
                        MS1.Name                              =    opp.Name;
                        MS1.Resource__c                       =    rr.id; 
                        MS1.CloseDate                         =    opp.CloseDate;
                        MS1.New_Appointment__c                =    0;
                        MS1.Appointment_Group_Id__c           =    opp.Appointment_Group_Id__c;
                        MS1.Appointment_Sequence__c           =    opp.Appointment_Sequence__c;                                                                                             
                        MS1.AppointmentIdforSalesroomSplit__c = opp.id;   
                        try
                        {
                            insert MS1;
                           
                            
                        }
                        catch(Exception e){
                          trigger.new[0].addError(  e.getMessage() );
                        }                       
                        
                    } 
            
            }
         }   
    /*------------------------------------------------------------------------------------------------------------------------------------------        
                                                   Update start time ,End time 
-------------------------------------------------------------------------------------------------------------------------------------------*/  
      if(Trigger.IsUpdate){
        FollowUpTaskHelper.setAlreadyCreatedFollowUpTasks();
        Treatment__c treat;
        for(Opportunity op : Trigger.New){             
          updateAppointmentList.add(op); 
          updateAppointmentSet.add(op.id); 
        }
        Map <id,List<Treatment__c>> opidTreatmentMap = new Map <id,List<Treatment__c>>();
        for(Treatment__c t: [Select Appointment_Name__c,Start_Time__c, End_Time__c  from Treatment__c  where Appointment_Name__c in :updateAppointmentSet]){
          List<Treatment__c> TreatmentList1 = opidTreatmentMap.get(t.Appointment_Name__c );
          if(TreatmentList1 == null ) {
            TreatmentList1 = new List<Treatment__c>();
            opidTreatmentMap.put(t.Appointment_Name__c,TreatmentList1 );
          }
          TreatmentList1.add(t);     
        }
         
        //-------------------------------------Opp.Treatment_Name__r.Name !='Consultation' &&-------------------------------------------------------------------------------------------------   
           
        Datetime StarttimeforConsultation ;
        for (Opportunity opp : trigger.new){
          Opportunity oldOpp = Trigger.oldMap.get(opp.Id);    
          if (opp.Treatment_Type__c != 'None' && oldOpp.Appointment_Start_Date_Time__c != NULL && oldOpp.Appointment_Start_Date_Time__c != Opp.Appointment_Start_Date_Time__c && Opp.Appointment_Start_Date_Time__c != NULL ){       
            for(Treatment__c Trt : opidTreatmentMap.get(opp.id)){  
              datetime myminute1      = (opp.Appointment_Start_Date_Time__c);
              datetime myminute2      = (oldOpp.Appointment_Start_Date_Time__c);
              Double myminutes        =  Math.Floor(Double.Valueof(myminute1.minute() - myminute2.minute()));                
              Integer myminutesInt    = Integer.valueof(myminutes);
              Trt.Start_Time__c       = Trt.Start_Time__c.addminutes(myminutesInt);
              Trt.End_Time__c         = Trt.End_Time__c .addminutes(myminutesInt);  
                             
              //User Can Change   Hour    
              datetime myhour1        = (opp.Appointment_Start_Date_Time__c);
              datetime myhour2        = (oldOpp.Appointment_Start_Date_Time__c);
              Double myhours          =  Math.Floor(Double.Valueof(myhour1.hour() - myhour2.hour()));                
              Integer myhourInt       = Integer.valueof(myhours);
              Trt.Start_Time__c       = Trt.Start_Time__c.addhours(myhourInt);
              Trt.End_Time__c         = Trt.End_Time__c .addhours(myhourInt);
              //User Can Change   Days 
              datetime myday1         = (opp.Appointment_Start_Date_Time__c);
              datetime myday2         = (oldOpp.Appointment_Start_Date_Time__c);
              Double mydays           =  Math.Floor(Double.Valueof(myday1.day() - myday2.day()));                
              Integer mydayInt        = Integer.valueof(mydays);
              Trt.Start_Time__c       = Trt.Start_Time__c.addDays(mydayInt);
              Trt.End_Time__c         = Trt.End_Time__c .addDays(mydayInt);
              //User Can Change   Months 
              datetime mymonth1       = (opp.Appointment_Start_Date_Time__c);
              datetime mymonth2       = (oldOpp.Appointment_Start_Date_Time__c);
              Double mymonths         =  Math.Floor(Double.Valueof(mymonth1.month() - mymonth2.month()));                
              Integer mymonthInt      = Integer.valueof(mymonths);
              Trt.Start_Time__c       = Trt.Start_Time__c.addMonths(mymonthInt);
              Trt.End_Time__c         = Trt.End_Time__c .addMonths(mymonthInt);
              //Year Update 
              datetime myyear1        = (opp.Appointment_Start_Date_Time__c);
              datetime myyear2        = (oldOpp.Appointment_Start_Date_Time__c);
              Double myyears          =  Math.Floor(Double.Valueof(myyear1.year() - myyear2.year()));                
              Integer myyearInt       = Integer.valueof(myyears);
              Trt.Start_Time__c       = Trt.Start_Time__c.addYears(myyearInt);
              Trt.End_Time__c         = Trt.End_Time__c .addYears(myyearInt); 
              StarttimeforConsultation= Trt.End_Time__c;
              TreatmentListToUpdate.add(Trt);                 
            } 
          }
          //Update appointment end date time 
          // else 
          if ( Opp.Appointment_End_Date_Time1__c != oldOpp.Appointment_End_Date_Time1__c && oldOpp.Appointment_End_Date_Time1__c != NULL && Opp.Appointment_End_Date_Time__c != Opp.Appointment_End_Date_Time1__c){
            List<Treatment__c> sortOrderList = new List<Treatment__c>();
            sortOrderList = opidTreatmentMap.get(opp.id);           
            if(sortOrderList != null){
              if( sortOrderList.size() != 0  ){
                Treatment__c Trt    = new Treatment__c();
                sortOrderList.sort();
                Trt = sortOrderList.get(sortOrderList.size()-1);
                Trt.End_Time__c     = opp.Appointment_End_Date_Time1__c;
                StarttimeforConsultation= Trt.End_Time__c;                            
                TreatmentListToUpdate1.add(Trt); 
              }
            }
          } 
           
          if( ( ( Opp.Appointment_End_Date_Time1__c != oldOpp.Appointment_End_Date_Time1__c ) || (opp.Appointment_Start_Date_Time__c !=   oldOpp.Appointment_Start_Date_Time__c )) && (  oldOpp.Appointment_Start_Date_Time__c != NULL ) && (  oldOpp.Appointment_End_Date_Time1__c != NULL ) && ( trigger.new[0].Treatment_Name__r.Name != 'Consultation'  ) ){
            system.debug('Controle came insiede --->');
            Opportunity  SalesSplit =[select Reason_For_Rescheduling__c,Appointment_End_Date_Time1__c,Appointment_Start_Date_Time__c,Appointment_Sequence__c,Treatment_Name__r.Name ,Resource__c, Resource__r.Name from opportunity where AppointmentIdforSalesroomSplit__c =:trigger.new[0].id  ];
            SalesSplit.Appointment_Start_Date_Time__c   =  StarttimeforConsultation;
            SalesSplit.Reason_For_Rescheduling__c       =  trigger.new[0].Reason_For_Rescheduling__c  ;
            salesSplit.Appointment_End_Date_Time1__c = StarttimeforConsultation.addMinutes(20);
            update SalesSplit;
          }
               
          if(Trigger.oldmap.get(opp.id).stageName  != Trigger.newmap.get(opp.id).stageName){
            Treatments1__c Treatments1 =  [ Select id from Treatments1__c where name =: 'Consultation' ];
            List<opportunity> o1 =[select stageName,Cancellation_Reasons__c from opportunity where Appointment_Sequence__c =:trigger.new[0].Appointment_Sequence__c AND Treatment_Name__c =: Treatments1.id AND Appointment_Start_Date_Time__c=:Trigger.old[0].Appointment_End_Date_Time1__c ];
            if(o1.size()>0){     
              o1[0].stageName =trigger.new[0].stageName;
              if(trigger.new[0].stageName=='Cancelled'){
                o1[0].Cancellation_Reasons__c =trigger.new[0].Cancellation_Reasons__c ;                  
              }                 
              RescheduleConsult2.add(o1[0]); 
            }  
          }
        } 
        Update TreatmentListToUpdate ;
        Update TreatmentListToUpdate1 ;
        //Update taskUpdate;
        update RescheduleConsult1;
        update RescheduleConsult2; 
      }
      FollowUpTaskHelper.setAlreadyCreatedFollowUpTasks();
    }  
}