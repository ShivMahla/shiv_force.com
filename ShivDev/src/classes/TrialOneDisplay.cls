Public Class TrialOneDisplay
{
    Public TrialOneDisplay(ApexPages.StandardController Controller)
    {
    }
    Public List <TrialOne__c>getData()
    {
        return[select Name,is_it_working__c from TrialOne__c];
    }
}