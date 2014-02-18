public class Tabel1Tabel2Connection
{
    public Tabel1Tabel2Connection(ApexPages.StandardController controller)
     {
     }
    Public List<Tabel2__c>getEmployee()
     {
        return[select Name,Employee__c,Salary__c from Tabel2__c];     
     }  
}