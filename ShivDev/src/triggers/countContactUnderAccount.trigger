trigger countContactUnderAccount on contact (after insert, after update, after Delete){
    Set<Id> accountIds = new Set<Id>();
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Contact con : trigger.new){
            accountIds.add(con.AccountId);
        }
    } else{
        for(Contact con : trigger.old){
            accountIds.add(con.AccountId);
        }
    }    
    Map<Id, Integer> accountIdToTotalContact = new Map<Id, Integer>();    
    AggregateResult[] groupResults = [select AccountId, Count(id) totalContacts FROM CONTACT WHERE AccountId in : accountIds GROUP BY AccountId];
    List<Account> accountListToUpdate = new List<Account>();
    system.debug('AggregateResult When No Record of Contact for Account : --'+groupResults);
    
    for(AggregateResult agrRes : groupResults){
        accountIdToTotalContact.put((Id)agrRes.get('AccountId'),(Integer) agrRes.get('totalContacts'));
    }
    
    for(Account act : [select id, ContactCount__c From Account WHERE id in : accountIds ]){
        act.ContactCount__c = accountIdToTotalContact.get(act.id);
        accountListToUpdate.add(act);
    }
    update accountListToUpdate;

}