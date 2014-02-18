trigger validationRuleOnQuote on Quote (before insert) {
    system.debug('Enered in to the trigger');
    set<Id> oppIds = new set<Id>();
    
    for(Quote qot : Trigger.new){
        oppIds.add(qot.opportunityId);
    }
    Map<Id,Opportunity> idToOpportunity =  new Map<Id,Opportunity>([SELECT id, Name, (SELECT Id FROM OpportunityLineItems) FROM Opportunity WHERE Id IN : oppIds]);
    for(Quote qot : Trigger.new){
        system.debug('OLI--'+idToOpportunity.get(qot.opportunityId).OpportunityLineItems.size());
        if(idToOpportunity.get(qot.opportunityId).OpportunityLineItems.size() == 0){
            qot.addError('Please select atleast one product in Quote line items and sync it');
        }
    }
    
 }