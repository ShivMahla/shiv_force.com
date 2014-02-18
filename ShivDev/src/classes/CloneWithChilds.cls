/* This class is a controller for custom apex:component clone. 
   Purpose      : To create a clone for a record. Record Id need to be passed in custom component.
                  Implemented functionality clones parent record and it's custom boject child records.
   Developed By : BriskMinds
   Date Created : 2-1-2012
   version      : 1.0
*/   

global  Class CloneWithChilds
{
    // Id object of current record / parent record
    private static Id recordId ;
        
    // current record / parent record
    private static sObject currentRecord ;
    private static Schema.SObjectType recordSObjectType ;
    
    //clone of parent record
    private static sObject clonedParentRecord ;
    // Dynamic SOQL query 
    private static String query ;
    
        
    /* Method     : cloneRecords 
     purpose    : To clone current record with it's child records
     parameters : None
     Returns    : None
    */
    webService static void cloneRecords (Id sObjId)
    {
        SObject clonedChildRecord ;
        // List of relationshp name between parent object and child object.
        ChildRelationship[] childRelationShips;
        List<SObject> clonedChildRecords = new List<SObject> ();
        
        recordId = sObjId;
        recordSObjectType = recordId.getSObjectType();
        Schema.DescribeSObjectResult desSObjResult = recordSObjectType.getDescribe(); 
        Map<String,Schema.SObjectField> fields = desSObjResult.fields.getMap() ; 
        // create dynamic query for current / parent record fields
        query = 'SELECT Id' ;
        // Add coma seprated fields API name
        query = query + fieldsQuery(desSObjResult)+' FROM ' + desSObjResult.getName() + ' WHERE Id =:  recordId';
        currentRecord = Database.query(query);
        clonedParentRecord= currentRecord.clone(false);
        system.debug('::::::::'+desSObjResult.getName()+'------------'+(desSObjResult.getName() == 'Quote__c'));
        
        //To avoid validation rules , assign default values, which are stored in custom settings. If it's not stored in custom setting unexpected error can occur.
        List<Additional_Values__c> defaultValues = Additional_Values__c.getall().values();
        Map<String, Map<String,String>> objectNameToField = new Map<String, Map<String,String>>();
        for(Additional_Values__c rec : defaultValues)
        {
        	  if(objectNameToField.get(rec.Object_API_Name__c) == NULL)
        	  {
        	  	objectNameToField.put(rec.Object_API_Name__c, new Map<String, String>() );
        	  	objectNameToField.get(rec.Object_API_Name__c).put(rec.Field_API_Name__c, rec.Default_Value__c) ;
        	  }
        	  else
        	  {
        	  	objectNameToField.get(rec.Object_API_Name__c).put(rec.Field_API_Name__c, rec.Default_Value__c) ;
        	  }
        }
        
        if(objectNameToField.get(desSObjResult.getName()) != NULL)
        {
          for(String fieldAPI : objectNameToField.get(desSObjResult.getName()).keySet())
          {
          	Object dataValue = dataValidate(objectNameToField.get(desSObjResult.getName()).get(fieldAPI), String.valueOf(desSObjResult.fields.getMap().get(fieldAPI).getDescribe().getType())) ;
          	clonedParentRecord.put(fieldAPI, dataValue);
          }
                   
        }
        insert clonedParentRecord;   
           
        //find out list of relationship with child objects  
        childRelationShips = desSObjResult.getchildRelationships();
                
        // To create child records
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe() ;  
        String fieldApiNameOfRelation ; // field API that has a foreign key back to the parent sObject.
        for(ChildRelationship rec : childRelationShips) 
        {            
          //child object API name
            String rName = String.valueOf(rec.childSObject) ;
            //create clone only for custom object 
            // in want for all add this condition && rName != 'FeedItem' and remove isCustom() condion  
            schema.Describesobjectresult childObjDes = globalDescribe.get(rName).getDescribe() ;
            if(childObjDes.isQueryable() && childObjDes.isCreateable() && childObjDes.isCustom() || (Test.isRunningTest() == true && childObjDes.isQueryable() && childObjDes.isCreateable())) 
            {
              String strDynamicQuery = 'SELECT Id' ;
                fieldApiNameOfRelation = String.valueOf(rec.field) ; 
                List<sObject> childRecords = new List<sObject>();
                Schema.SObjectType sObjType = globalDescribe.get(rName);
                Schema.DescribeSObjectResult desChildSObjResult = sObjType.getDescribe();                                
                strDynamicQuery = strDynamicQuery + fieldsQuery(desChildSObjResult)+' FROM ' + desChildSObjResult.getName() + ' WHERE ' + fieldApiNameOfRelation + '=: recordId ';
                childRecords.clear();
                childRecords = database.query(strDynamicQuery );
                if(childRecords.size() > 0) 
                {
                  for(SObject childRec :  childRecords) 
                    {
                    		//create clone record with same values of parent.
                    		clonedChildRecord = childRec.clone(false);
                    		// Overide the parent reocrd values in cloned record if any default value is there.
                        if(objectNameToField.get(desChildSObjResult.getName()) != NULL)
			            	{
				          		for(String fieldAPI : objectNameToField.get(desChildSObjResult.getName()).keySet())
				          		{
				          			Object dataValue = dataValidate(objectNameToField.get(desChildSObjResult.getName()).get(fieldAPI), String.valueOf(desChildSObjResult.fields.getMap().get(fieldAPI).getDescribe().getType())) ;
				          			clonedChildRecord.put(fieldAPI, dataValue);
				          		}
			                   
			        			}
                        clonedChildRecord.put(fieldApiNameOfRelation,clonedParentRecord.id);
                        clonedChildRecords.add(clonedChildRecord );
                    }  
                      
                }             
           
            }   
        }   
        if(clonedChildRecords.size() > 0) 
        {
                insert clonedChildRecords;
        }
        
    
    }
    
    
    
    /* Method   : fieldsQuery 
     purpose    : To create a coma seprated fields API name string
     parameters : None
     Returns    : String
    */
    public static String fieldsQuery (Schema.DescribeSObjectResult desSObjResult)
    {
        String queryStr = '';
        Map<String,Schema.SObjectField> fields = desSObjResult.fields.getMap() ;
        for(SObjectField field : fields.values())
        {
            if( field.getDescribe().isCreateable() && field.getDescribe().isAccessible())
            {
              queryStr = queryStr + ', ' + field.getDescribe().getName();
            }
        }
        return queryStr ;
    }
    
   
   //This will verify the field data type and convert the approciate data type  
	private static object dataValidate(String data1 ,String DataType)
   {
   	try
      {
      	if(CheckFieldValue(data1))
         	return null;
               
         String data = data1.trim(); 
         //If field type are email, picklist ,String ,url, combobox,text ,text area ,phone then it will return data as it is becase data field is string type
         if(DataType.equalsIgnoreCase('EMAIL') || DataType.equalsIgnoreCase('PICKLIST') || DataType.equalsIgnoreCase('STRING') || DataType.equalsIgnoreCase('URL') || DataType.equalsIgnoreCase('TEXT') || DataType.equalsIgnoreCase('TEXTAREA') || DataType.equalsIgnoreCase('COMBOBOX') || DataType.equalsIgnoreCase('PHONE') )
         {
         	return data;
         }
         //If  field is doucble ,currency and percent type then we are converting in daouble type
         else if(DataType.equalsIgnoreCase('DOUBLE')|| DataType.equalsIgnoreCase('CURRENCY') || DataType.equalsIgnoreCase('PERCENT'))
         {
         	return Double.valueOf(data);
                    
         }
         //if field is number and integer then we are converting into integer
         else if (DataType.equalsIgnoreCase('INTEGER')|| DataType.equalsIgnoreCase('NUMBER'))
         {
         	return integer.valueOf(data);
                    
         }
         //If field is date type (date format should be (MM-dd_YYYY)
         else if (DataType.equalsIgnoreCase('DATE'))
         {
         	if(data.contains('-'))
            	return  date.valueOf(data+' 0:0:0');
            else if (data.contains('/'))
            	return date.parse(data);
         }
         
         //If field is dateTime type (date format should be (MM-dd_YYYY)
         else if (DataType.equalsIgnoreCase('DATETIME'))
         {
            	if(data.contains('/')) 
            		return  DateTime.parse(data);
            	else if(data.contains('-'))
            		return  datetime.valueOf(data);
         }
         
         //If field is reference type
         else if (DataType.equalsIgnoreCase('REFERENCE'))
         {
                        
         	if(verifingReference(data)) 
         	{
            	return (ID) data;
            }
            return null;        
         }
               
         //If field is boolean type
        	else if(DataType.equalsIgnoreCase('BOOLEAN'))
         {
         	if(data.equalsIgnoreCase('true') || data.equalsIgnoreCase('1'))
            	return true;
            return false;    
         }
      }
      catch(Exception e){}
                       
      	return null;
	}
        
	//Verify value is not null or not empty
   private static boolean CheckFieldValue(String val)
   {
   	if(val == null || val=='')
      	return true;
           
      return false;        
   }    
        
        
	private static boolean verifingReference(String d)
	{
   	String id = String.escapeSingleQuotes(d);
      if((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id)) 
      {
      	return true; 
      }
      return false;
	}    
    

}