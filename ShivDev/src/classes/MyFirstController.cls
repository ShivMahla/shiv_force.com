public class MyFirstController
{
   public MyFirstController(ApexPages.standardController controller){
   }
   //List<Employee__c> emp=new List<Employee__c>();
   public List<Employee__c> getMyEmployee()
   {
       return[SELECT Name,age__c FROM Employee__c];
   }
}