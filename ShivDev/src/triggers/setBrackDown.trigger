trigger setBrackDown on Membership__c (after insert, after update) {
for(Membership__c M : Trigger.new)
{
    Date d = M.Starting_Date__c;
    double amt = M.Amount__c/M.Number_of_Months__c; 
    for(integer i=0;i<M.Number_of_Months__c;i++)
    {
        breakdown__c s = new breakdown__c(date_of_Payment__c=d,Amount__c=amt,Membership_Name__c=M.id);
        insert s;
        d = d.addMonths(1);
    }
}

}