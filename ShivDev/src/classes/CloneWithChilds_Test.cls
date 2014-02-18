/* Test class for CloneWithChilds
*/
@isTest (SeeAllData=false)
private class CloneWithChilds_Test {

    static testMethod void myUnitTest() {
    	
        
        //creat account
        Account act = new Account();
        act.Name = 'ExampleAccount' ;
        act.Type = 'Customer' ;
        insert act;
        
        // creat opportunity
        Opportunity opp = new Opportunity();
        opp.AccountId   = act.id;
        opp.Name        = 'Lan Wire';
        opp.CloseDate   = (system.today() +1) ;
        opp.StageName   = 'Prospecting' ;
        insert opp;
        
        System.assertEquals(opp.AccountId,act.id);
        
        Additional_Values__c newCustomSetting = new Additional_Values__c();
        newCustomSetting.Name = 'Custom';
        newCustomSetting.Object_API_Name__c = 'Account';
        newCustomSetting.Field_API_Name__c = 'Phone';
        newCustomSetting.Default_Value__c = '333333';
        insert newCustomSetting;
        
        Additional_Values__c newCustomSetting1 = new Additional_Values__c();
        newCustomSetting1.Name = 'Custom1';
        newCustomSetting1.Object_API_Name__c = 'Account';
        newCustomSetting1.Field_API_Name__c = 'NumberOfEmployees';
        newCustomSetting1.Default_Value__c = '20';
        insert newCustomSetting1;
        
        Additional_Values__c newCustomSetting2 = new Additional_Values__c();
        newCustomSetting2.Name = 'Custom2';
        newCustomSetting2.Object_API_Name__c = 'Account';
        newCustomSetting2.Field_API_Name__c = 'Industry';
        newCustomSetting2.Default_Value__c = 'Apparel';
        insert newCustomSetting2;
        
        Additional_Values__c newCustomSetting3 = new Additional_Values__c();
        newCustomSetting3.Name = 'Custom3';
        newCustomSetting3.Object_API_Name__c = 'Opportunity';
        newCustomSetting3.Field_API_Name__c = 'Amount';
        newCustomSetting3.Default_Value__c = '100';
        insert newCustomSetting3;
        
        Additional_Values__c newCustomSetting4 = new Additional_Values__c();
        newCustomSetting4.Name = 'Custom4';
        newCustomSetting4.Object_API_Name__c = 'Opportunity';
        newCustomSetting4.Field_API_Name__c = 'IsPrivate';
        newCustomSetting4.Default_Value__c = 'True';
        insert newCustomSetting4;
        
        Additional_Values__c newCustomSetting5 = new Additional_Values__c();
        newCustomSetting5.Name = 'Custom5';
        newCustomSetting5.Object_API_Name__c = 'Opportunity';
        newCustomSetting5.Field_API_Name__c = 'CloseDate';
        newCustomSetting5.Default_Value__c = String.valueOf(system.today());
        insert newCustomSetting5;
        
        
        CloneWithChilds.cloneRecords(act.id);                
           
    }
}