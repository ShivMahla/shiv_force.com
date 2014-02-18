global class SearchPageController 
{
	webservice static void createPage(String ObjectName, String describeLayout)
	{
		String[] fieldsApi;
		String[] sectionNames;
		
		Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe() ;
		Schema.SObjectType sobjtType  = globalDescribe.get(ObjectName);
		Schema.Describesobjectresult describeSObject = sobjtType.getDescribe();
		Map<String, Schema.SObjectField> fields = describeSObject.fields.getMap() ;
		
		String output = '';
    
	   output += '<' + 'apex' + ':' + 'page standardController=' + '"' + ObjectName + '"' + '>';
	   output += '\n';
	   output += '<' + 'apex' + ':' + 'sectionHeader' + ' title=' + '"' + ObjectName + ' Edit' + '"' + ' subtitle=' + '"' + '{' + '!' + ObjectName + '.name}' + '"' + '/>';
	   output += '\n';
	   output += '<' + 'apex' + ':' + 'form' + '>';
	   output += '\n';
	   output += '<' + 'apex' + ':' + 'pageBlock title=' + '"' + ObjectName + ' Edit' + '"' + ' mode=' + '"edit">';
	   output += '\n';
	   output += '\n';
	   output += '<' + 'apex' + ':' + 'pageBlockButtons location=' + '"top">';
	   output += '\n';
	   output += '<' + 'apex:commandButton value=' + '"' + 'Save' + '" ' + 'action=' + '"' + '{' + '!' + 'save' + '}"' + '/>';
	   output += '\n';
	   output += '<' + 'apex:commandButton value=' + '"' + 'Save & New' + '"' + ' action=' + '"' + '{' + '!save}" />';
	   output += '\n';
	   output += '<' + 'apex:commandButton value="Cancel" action=' + '"' + '{' + '!cancel}' + '"/>';
	   output += '\n';
	   output += '<' + '/apex:pageBlockButtons>';
	   output += '\n';
	   output += '\n';
	   output += '<' + 'apex' + ':' + 'pageBlockButtons location=' + '"bottom">';
	   output += '\n';
	   output += '<' + 'apex:commandButton value=' + '"' + 'Save' + '" ' + 'action=' + '"' + '{' + '!' + 'save' + '}"' + '/>';
	   output += '\n';
	   output += '<' + 'apex:commandButton value=' + '"' + 'Save & New' + '"' + ' action=' + '"' + '{' + '!save}" />';
	   output += '\n';
	   output += '<' + 'apex:commandButton value="Cancel" action=' + '"' + '{' + '!cancel}' + '"/>';
	   output += '\n';
	   output += '<' + '/apex:pageBlockButtons>';
	   
	  
	   //adding fields and section
	   system.debug('##########'+describeLayout);
	   Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(describeLayout);
	   system.debug('*********'+result);
      
      
      Map<String, Object> allTheLayouts = (Map<String, Object>) result.get('layouts');
      system.debug('-----------------------'+ allTheLayouts.keySet() ) ;
      system.debug('-----------------------'+allTheLayouts.get('editLayoutSections'));
      List<object> sections = (List<Object>)allTheLayouts.get('editLayoutSections');
      system.debug('----------sections-----'+sections);
            
      if(sections != NULL)
      {
	      for (Integer i = 0; i < sections.size(); i++)
	      {
	      	Map<String, Object> section = (Map<String, Object>) sections[i] ;
	      	system.debug('///////////'+section);
	      	
	      	List<Object> layoutRows = new List<Object>();
	      	if(section.get('layoutRows') instanceof Map<String,Object>)
	      	{
	      		layoutRows.add((object)section.get('layoutRows'));
	      	}
	      	else
	      	{
	      		for(Object rec : (List<Object>)section.get('layoutRows'))
	      		{
	      			layoutRows.add(rec) ;
	      		}
	      	}
	      	
	      	List<Object> layoutItems = new List<Object>();
	      	
	      	// Layout Items
	      	for(Object obj : layoutRows) 
	      	{
	      		
	      		Map<String, Object> row = (Map<String,Object>) obj ;
		      	if(row.get('layoutItems') instanceof Map<String,Object>)
		      	{
		      		layoutItems.add((object) row.get('layoutItems'));
		      	}
		      	else
		      	{
		      		for(Object rec : (List<Object>) row.get('layoutItems'))
		      		{
		      			layoutItems.add(rec) ;
		      		}
		      	}
	      		
	      	}
	      	
	      	
	      	List<Object> layoutComponents = new List<Object>();
	      	for(Object obj : (List<Object>) layoutItems)
	      	{
	      		Map<String, Object> item = (Map<String, Object>) obj;
	      		
	      		
	      		layoutComponents.add((Object)item.get('layoutComponents'));
	      		system.debug('99999999999999999999'+item.get('')) ;
	      	}
	      	
	      	for(Object obj : layoutComponents)
	      	{
	      		if(obj != NULL)
	      		{
	      			Map<String, Object> component = (Map<String, Object>) obj;
	      			system.debug('::::::::::::::'+component.get('value'));
	      		}
	      		
	      		
	      	}
	      	
	      	//Map<String,Object> layoutRows = (Map<String,Object>) section.get('layoutRows');
	      	
	      	//system.debug('---LayoutRows---'+layoutRows);
	      	/*if(layoutRows != NULL)
	      	{
		      	for(Integer j=0; j < layoutRows.size() ; j++)
		      	{
		      		Map<String, Object> row = (Map<String, Object>) layoutRows[j] ;
		      		system.debug('============'+row);
		      	}
	      	}
	      	  Map<String, Object> section = (Map<String, Object>) sections[i] ;
	      	
	      	Map<String, Object> layout = (Map<String, Object>) allTheLayouts.values()[i] ;
	         if (layout.get('editLayoutSections') != null)
	         {
	         	system.debug('---****---'+layout);   		
	         }
	         
	         for()
	         {
	         	
	         } */
	      } 
	    }   
      
      output += '\n';
      output += '<' + '/apex:pageBlock>';
      output += '\n';
      output += '<' + '/apex:form>';
      output += '\n';
      output += '<' + '/apex:page>';
	  

	}
}