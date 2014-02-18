global with sharing class SendAccountInfoToCSBatch implements Database.Batchable<sObject>
{
	public static String query = '';
	
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
      // To make a query for all fields of account object
      query = 'SELECT ' ;
      Map<String, schema.Sobjecttype> sObjectTypes = Schema.getGlobalDescribe() ;
      schema.Describesobjectresult desSobject = sObjectTypes.get('Account').getDescribe();
      query = query + fieldsQuery(desSobject) + ' FROM Account' ;
      return Database.getQueryLocator(query); 
   }

	global void execute(Database.BatchableContext BC, List<sObject> accounts)
	{
   	// create JSON for account data
   	String accountsJSON = JSON.serializePretty(accounts);
   	
   	// describe request
   	Httprequest request = new Httprequest();
   	
   	Http http = new Http();
   	
	}

   global void finish(Database.BatchableContext BC)
   {
   	
   }
   
   /* Method : fieldsQuery
      purpose : To create a coma seprated fields API name string
   */     
	public static String fieldsQuery (Schema.DescribeSObjectResult desSObjResult)
	{
   	String fieldStr = '';
      schema.Describefieldresult fieldDes ;
      Boolean isFirstField = true;
      Map<String,Schema.SObjectField> fields = desSObjResult.fields.getMap() ;
      for(SObjectField field : fields.values())
      {
      	fieldDes = field.getDescribe() ;
         if(fieldDes.isAccessible())
         {
         	if(isFirstField)
            {
            	fieldStr = fieldStr + fieldDes.getName();
            	isFirstField = false;
            }
            else
            {
            	fieldStr = fieldStr + ', ' + fieldDes.getName();
            }
         }
   	}
   	return fieldStr ;
	}

}