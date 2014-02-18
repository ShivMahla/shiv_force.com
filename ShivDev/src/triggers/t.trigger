trigger t on Case (before update){
    integer count1;
    integer count2;
    integer differenceindays;

    list<case> mp=new list<case>();
    for(Case c:trigger.new){
        //Integer start_day_as_int = start_date_time.dayOfYear();
        if(c.status=='closed'){
                   count1=integer.valueof(DateTime.now().dayOfYear()); // Since Case is Closing now sow Today Datae will be 
                   system.debug('Count1--'+count1);
                   count2=integer.valueof(c.createddate.dayOfYear());
                   system.debug('Count1--'+count2);
                   differenceindays = count1-count2;
                   if(differenceindays==0){                         
                        c.Inquiry_completed_in_days__c=1;
                   } else if(differenceindays>0){
                        c.Inquiry_completed_in_days__c=differenceindays;
                   }                       
        }          
    }
}