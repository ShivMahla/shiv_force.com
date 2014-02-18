trigger OpportunityRollUpPayments on Payment__c (after delete, after insert, after update) {
 
  //Limit the size of list by using Sets which do not contain duplicate elements
  set<Id> OpportunityIds = new set<Id>();
 
  //When adding new payments or updating existing payments
  if(trigger.isInsert || trigger.isUpdate){
    for(Payment__c p : trigger.new){
      OpportunityIds.add(p.Opportunity__c);
    }
  }
 
  //When deleting payments
  if(trigger.isDelete){
    for(Payment__c p : trigger.old){
      OpportunityIds.add(p.Opportunity__c);
    }
  }
 
  //Map will contain one Opportunity Id to one sum value
  map<Id,Double> OpportunityMap = new map<Id,Double> ();
 
  //Produce a sum of Payments__c and add them to the map
  //use group by to have a single Opportunity Id with a single sum value
  for(AggregateResult q : [select Opportunity__c,sum(Amount__c)
    from Payment__c where Opportunity__c IN :OpportunityIds group by Opportunity__c]){
      OpportunityMap.put((Id)q.get('Opportunity__c'),(Double)q.get('expr0'));
  }
 
  List<opportunity> OpportunitiesToUpdate = new List<opportunity>();
 
  //Run the for loop on Opportunity using the non-duplicate set of Opportunities Ids
  //Get the sum value from the map and create a list of Opportunities to update
  for(Opportunity o : [Select Id, Total_Payments__c from Opportunity where Id IN :OpportunityIds]){
    Double PaymentSum = OpportunityMap.get(o.Id);
    o.Total_Payments__c = PaymentSum;
    OpportunitiesToUpdate.add(o);
  }
 
  update OpportunitiesToUpdate;
}