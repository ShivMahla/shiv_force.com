trigger tempObjBU on tempObj__c (before update) {
  if (!ExecuteOnce.SF2SF_tempObj)
  {
   for(tempObj__c vRec : Trigger.new){
       if(vRec.Number__c == 1){
         vRec.Number__c = 2;
       }
   }
   ExecuteOnce.SF2SF_tempObj = true;
  }

}