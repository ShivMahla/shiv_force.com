@isTest(seealldata=true)
public class TestvalidationResourceSchOverlap
{
    public static testMethod void mytestnew()
    {
        //creating Clinic record
        Clinic__c cl = new Clinic__c(Name = 'Ajax');
        insert cl;
        //creating staff record
        Staff__c staff = new Staff__c(Name = 'Dr. Joe Carter',clinic__c=cl.id);
        insert staff;
        //creating record for treatment
        Treatments1__c treatment = new Treatments1__c(Name='testtrsover',Type__c ='Series', price__c=1000);
        insert treatment;
        //creating rsource record
        Resource__c resource = new Resource__c(Name = 'X-rayMachine',clinic__c=cl.id,background_color__c='#FCD116',color__c='#1C1C1C',Resource_ID__c='testid');
        insert resource;
        //creating resource schedule
        Resource_Schedule__c resourceSchedule = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=DateTime.now().addHours(5), Open_Time__c=DateTime.now(), Clinic__c=cl.id, Name__c = resource.id);
        insert resourceSchedule;
        //insert related resouce for treatement
        Related_Resources__c relatedResource = new Related_Resources__c(Resource__c=resource.id, Treatments__c = treatment.id);
        insert relatedResource ;
        //creating resource schedule
        Resource_Schedule__c resourceSchedule1 = new Resource_Schedule__c(Staff_Name__c=staff.id,Close_Time__c=DateTime.now().addHours(5), Open_Time__c=DateTime.now(), Clinic__c=cl.id, Name__c = resource.id);
        insert resourceSchedule1;
      }
}