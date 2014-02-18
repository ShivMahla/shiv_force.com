public class MyControllerClass
{
    public MyControllerClass(ApexPages.StandardController Controller)
    {
    }
    public List<Employee__c> getMyEmployee()
    {
        return[SELECT Name, age__c FROM Employee__c];
    }
}