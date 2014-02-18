/***********************************************
 * Class Name: SearchController.cls
 * Author: BriskMind
 * Extends:  None
 * Extended by : None
 * Called By:  Apex Page SearchPage
 * Overview: This class acts as a controller class for Apex Page: SearchPage
 * Changes: None
 ************************************************/
global class SearchController 
{
    public String ObjectName{get;set;}
    private Sobjecttype sObjType ;
    public sObject sObjRec{get;set;}
    public String selectedRecordType{get;set;}
    private ApexPages.StandardSetController ssc;
    public Integer recordPerPage{get;set;} // Number of records in standard set controlelr (setpageSize)
    
    /* collection Data Types */
    private Map<String, String> currentPageParameters; 
    public List<SelectOption> recordTypeSelOpts {get;set;} 
    public String strDescribeLayout{get;set;} //Property to hold json stirng , value is set by the action function attribute assignof visualforce page
    private List<Object> allTheLayouts = new List<Object>();// It holds the list of layouts (Since is JS code we are passing record type id for describe_layout call so we ll always get a single layout)
    private List<sObject> searchResult{get;set;}
    private List<String> SearchableFieldList;
    public List<RecordWrapper> selectList{get;set;} // List to disply search result with select option.
    public List<String> fieldList{get;set;} // Fields which will be displayed in search result.
    private Set<Id> selectedItems; // holds the ids of selected items in serarch result.
    public List<section> sections{get;set;} // wrapper class object list to hold section name and their respective fields api names.
        

    // Controller
    public SearchController()
    {
        
        /* initialization of variables */      
        searchResult = new List<sObject>();
        SearchableFieldList = new List<String>();
        selectList =  new List<RecordWrapper>();
        fieldList = new List<String>();
        selectedItems = new Set<Id>();
        sections = new list<section>();
        recordTypeSelOpts = new List<SelectOption>();
        currentPageParameters = ApexPages.CurrentPage().getParameters();
        
        try
        {
            //Check either Obj parameter in URL, is availabe or not.
            if(! currentPageParameters.keySet().contains('Obj'))
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Errors.objParmNotAvailStr));
                return ;
            }
            ObjectName = currentPageParameters.get('Obj');          
            Map<String, Schema.Sobjecttype> globalSOjbDes = Schema.getGlobalDescribe();
            sObjType = globalSOjbDes.get(ObjectName);
            //check either the object is availabe in to the system or not. which is specified in Obj parameter in url.
            if(sObjType == NULL)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ObjectName + Errors.objNotAvailStr));
                return ;
                
            }
            //
            sObjRec = sObjType.newSObject();
            schema.Describesobjectresult desObject = sObjType.getDescribe();                        
            Map<Id, Schema.RecordTypeInfo> recordTypes = desObject.getRecordTypeInfosById() ;
            for(Id rec : recordTypes.keySet())
            {
                recordTypeSelOpts.add(new SelectOption(String.valueOf(rec), recordTypes.get(rec).getName())) ;
            }
             
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage())); 
            return;
        }   
        
         
    }
    
       
    /*
        Method : createPage
        purpose  : create list of layout objects by parsing json string
        @parameter : none ;
        @returns : none;
    */
    public void createPage()
    {
        // If user change the record type in the middle of defining search critaria for a new search, view state need to be chang to clear field values.
        sObjRec = sObjType.newSObject();
        //clear previous layout
        sections.clear();          
        // List of all the layouts
        allTheLayouts = new List<Object>();
        if(JSON.deserializeUntyped(strDescribeLayout) instanceof Map<String,Object>) // if there is only one DescribeLayoutResult object
        {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(strDescribeLayout);
            if(result.get('layouts') != NULL)
            {
                allTheLayouts.add((object)result.get('layouts'));
            }   
        }
        else
        {
            for(Object rec : (List<Object>)JSON.deserializeUntyped(strDescribeLayout))
            {
                if(((Map<String,Object>) rec).get('layouts') != NULL)
                {
                    allTheLayouts.add(((Map<String,Object>) rec).get('layouts')); // if there is multiple DescribeLayoutResult object
                }
                
            }
        }
        
        
        Map<String, schema.Sobjecttype> globalDescribe = Schema.getGlobalDescribe();      
        Schema.Sobjecttype sObj = globalDescribe.get(ObjectName);
        Schema.Describesobjectresult desObj = sObj.getDescribe();
        Map<String, Schema.Sobjectfield> fields = desObj.Fields.getMap();
      
        for(Object rec : allTheLayouts)
        {
            Map<String, Object> layout = (Map<String,Object>) rec ;
            if(layout.get('editLayoutSections') != NULL)
            {
                if(layout.get('editLayoutSections') instanceof Map<String,Object>) // if only one section
                {
                    Map<String, Object> section = (Map<String, Object>)layout.get('editLayoutSections');
                    Component.Apex.pageBlockSection pbSection = new Component.Apex.pageBlockSection();//create new section
                    pbSection.title = String.valueof(section.get('heading'));    
                    Section sec = new Section();
                    sec.sectionName = String.valueof(section.get('heading'));          
                    if(section.get('layoutRows') != NULL)
                    {
                        if(section.get('layoutRows') instanceof Map<String,Object>) // if single layout row
                        {
                            Map<String,Object> layoutRow = (Map<String, Object>)section.get('layoutRows');
                            if(layoutRow.get('layoutItems') != NULL)
                            {
                                if(layoutRow.get('layoutItems') instanceof Map<String,Object>)
                                {
                                    Map<String,Object> layoutItem = (Map<String, Object>)layoutRow.get('layoutItems');
                                    if(layoutItem.get('layoutComponents') != NULL) 
                                    {
                                        if(layoutItem.get('layoutComponents') instanceof Map<String,Object>) // if only one layout component.
                                        {
                                            Map<String, Object> layoutComponent = (Map<String, Object>) layoutItem.get('layoutComponents');
                                            String comObj = createComponent(fields, (object)layoutComponent);
                                            if(comObj != NULL)
                                            {
                                                sec.fieldApiList.add(comObj); // binding field API List to respective section.
                                                SearchableFieldList.add(comObj); // List which will be used for condition query.
                                            }
                                        }
                                        else
                                        {
                                            for(Object layoutComponent : (List<Object>) layoutItem.get('layoutComponents')) // if multiple layoutcomponent
                                            {
                                                String comObj = createComponent(fields, (object)layoutComponent);
                                                if(comObj != NULL)
                                                {
                                                    sec.fieldApiList.add(comObj); 
                                                    SearchableFieldList.add(comObj);
                                                }
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    for(Object layoutItemObj : (List<Object>) layoutRow.get('layoutItems'))
                                    {
                                        Map<String, Object> layoutItem = (Map<String,Object>) layoutItemObj;
                                        if(layoutItem.get('layoutComponents') != NULL) 
                                        {
                                            if(layoutItem.get('layoutComponents') instanceof Map<String,Object>) // if only one layout component.
                                            {
                                                Object layoutComponentObj = layoutItem.get('layoutComponents');
                                                Map<String, Object> layoutComponent = (Map<String, Object>) layoutComponentObj;
                                                String comObj = createComponent(fields, (object)layoutComponent);
                                                if(comObj != NULL)
                                                {
                                                    sec.fieldApiList.add(comObj); 
                                                    SearchableFieldList.add(comObj);
                                                }
                                            }
                                            else
                                            {
                                                for(Object layoutComponent : (List<Object>) layoutItem.get('layoutComponents')) // if multiple layoutcomponent
                                                {
                                                    String comObj = createComponent(fields, (object)layoutComponent);
                                                    if(comObj != NULL)
                                                    {
                                                        sec.fieldApiList.add(comObj); 
                                                        SearchableFieldList.add(comObj);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            for(Map<String,Object> layoutRow : (List<Map<String,Object>>)section.get('layoutRows'))
                            {
                                if(layoutRow.get('layoutItems') != NULL)
                                {
                                    if(layoutRow.get('layoutItems') instanceof Map<String,Object>)
                                    {
                                        Map<String,Object> layoutItem = (Map<String,Object>) layoutRow.get('layoutItems');
                                        if(layoutItem.get('layoutComponents') != NULL) 
                                        {
                                            if(layoutItem.get('layoutComponents') instanceof Map<String,Object>) // if only one layout component.
                                            {
                                                Map<String, Object> layoutComponent = (Map<String, Object>) layoutItem.get('layoutComponents');
                                                String comObj = createComponent(fields, (object)layoutComponent);
                                                if(comObj != NULL)
                                                {
                                                    sec.fieldApiList.add(comObj); 
                                                    SearchableFieldList.add(comObj);
                                                }
                                            }
                                            else
                                            {
                                                for(Object layoutComponent : (List<Object>) layoutItem.get('layoutComponents')) // if multiple layoutcomponent
                                                {
                                                    String comObj = createComponent(fields, (object)layoutComponent);
                                                    if(comObj != NULL)
                                                    {
                                                        sec.fieldApiList.add(comObj); 
                                                        SearchableFieldList.add(comObj);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        for(Object layoutItemObj : (List<Object>) layoutRow.get('layoutItems'))
                                        {
                                            Map<String, Object> layoutItem = (Map<String,Object>) layoutItemObj;
                                            if(layoutItem.get('layoutComponents') != NULL) 
                                            {
                                                if(layoutItem.get('layoutComponents') instanceof Map<String,Object>) // if only one layout component.
                                                {
                                                    Map<String, Object> layoutComponent = (Map<String, Object>) layoutItem.get('layoutComponents');
                                                    String comObj = createComponent(fields, (object)layoutComponent);
                                                    if(comObj != NULL)
                                                    {
                                                        sec.fieldApiList.add(comObj); 
                                                        SearchableFieldList.add(comObj);
                                                    }
                                                }
                                                else
                                                {
                                                    for(Object layoutComponent : (List<Object>) layoutItem.get('layoutComponents')) // if multiple layoutcomponent
                                                    {
                                                        String comObj = createComponent(fields, (object)layoutComponent);
                                                        if(comObj != NULL)
                                                        {
                                                            sec.fieldApiList.add(comObj); 
                                                            SearchableFieldList.add(comObj);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(sec.fieldApiList.size() > 0)
                    {
                        sections.add(sec);
                    }
                }
                else
                {
                    for(Object sectionObj : (List<Object>) layout.get('editLayoutSections'))   
                    {
                        Map<String,Object> section = (Map<String,Object>) sectionObj;
                        Component.Apex.pageBlockSection pbSection = new Component.Apex.pageBlockSection();//create new section
                        pbSection.title = String.valueof(section.get('heading'));
                        Section sec = new Section();
                        sec.sectionName = String.valueof(section.get('heading'));
                        if(section.get('layoutRows') != NULL)
                        {
                            if(section.get('layoutRows') instanceof Map<String,Object>) // if single layout row
                            {
                                Map<String, Object> layoutRow = (Map<String, Object>) section.get('layoutRows');
                                if(layoutRow.get('layoutItems') != NULL)
                                {
                                    if(layoutRow.get('layoutItems') instanceof Map<String,Object>)
                                    {
                                        Map<String,Object> layoutItem = (Map<String,Object>) layoutRow.get('layoutItems');
                                        if(layoutItem.get('layoutComponents') != NULL) 
                                        {
                                            if(layoutItem.get('layoutComponents') instanceof Map<String,Object>) // if only one layout component.
                                            {
                                                Map<String, Object> layoutComponent = (Map<String,Object>) layoutItem.get('layoutComponents');
                                                String comObj = createComponent(fields, (object)layoutComponent);
                                                if(comObj != NULL)
                                                {
                                                    sec.fieldApiList.add(comObj); SearchableFieldList.add(comObj);
                                                }
                                            }
                                            else
                                            {
                                                for(Object layoutComponent : (List<Object>) layoutItem.get('layoutComponents')) // if multiple layoutcomponent
                                                {
                                                    String comObj = createComponent(fields, (object)layoutComponent);
                                                    if(comObj != NULL)
                                                    {
                                                        sec.fieldApiList.add(comObj); SearchableFieldList.add(comObj);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        for(Object layoutItemObj : (List<Object>) layoutRow.get('layoutItems'))
                                        {
                                            Map<String,Object> layoutItem = (Map<String,Object>) layoutItemObj;
                                            if(layoutItem.get('layoutComponents') != NULL) 
                                            {
                                                if(layoutItem.get('layoutComponents') instanceof Map<String,Object>) // if only one layout component.
                                                {
                                                    Map<String, Object> layoutComponent = (Map<String,Object>) layoutItem.get('layoutComponents');
                                                    String comObj = createComponent(fields, (object)layoutComponent);
                                                    if(comObj != NULL)
                                                    {
                                                        sec.fieldApiList.add(comObj); SearchableFieldList.add(comObj);
                                                    }
                                                }
                                                else
                                                {
                                                    for(Object layoutComponent : (List<Object>) layoutItem.get('layoutComponents')) // if multiple layoutcomponent
                                                    {
                                                        String comObj = createComponent(fields, (object)layoutComponent);
                                                        if(comObj != NULL)
                                                        {
                                                            sec.fieldApiList.add(comObj); SearchableFieldList.add(comObj);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            else
                            {
                                for(Object layoutRowObj : (List<Object>) section.get('layoutRows'))
                                {
                                    Map<String,Object> layoutRow = (Map<String,Object>) layoutRowObj;                        
                                    if(layoutRow.get('layoutItems') != NULL)
                                    {
                                        if(layoutRow.get('layoutItems') instanceof Map<String,Object>)
                                        {
                                            Map<String,Object> layoutItem = (Map<String, Object>)layoutRow.get('layoutItems');
                                            if(layoutItem.get('layoutComponents') != NULL) 
                                            {
                                                if(layoutItem.get('layoutComponents') instanceof Map<String,Object>) // if only one layout component.
                                                {
                                                    Map<String, Object> layoutComponent = (Map<String, Object>) layoutItem.get('layoutComponents');
                                                    String comObj = createComponent(fields, (object)layoutComponent);
                                                    if(comObj != NULL)
                                                    {
                                                        sec.fieldApiList.add(comObj); 
                                                        SearchableFieldList.add(comObj);
                                                    }
                                                }
                                                else
                                                {
                                                    for(Object layoutComponent : (List<Object>) layoutItem.get('layoutComponents')) // if multiple layoutcomponent
                                                    {
                                                        String comObj = createComponent(fields, (object)layoutComponent);
                                                        if(comObj != NULL)
                                                        {
                                                            sec.fieldApiList.add(comObj); SearchableFieldList.add(comObj);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        else
                                        {
                                            for(Object layoutItemObj : (List<Object>) layoutRow.get('layoutItems'))
                                            {
                                                Map<String,Object> layoutItem = (Map<String,Object>) layoutItemObj;
                                                if(layoutItem.get('layoutComponents') != NULL) 
                                                {
                                                    if(layoutItem.get('layoutComponents') instanceof Map<String,Object>) // if only one layout component.
                                                    {
                                                            Map<String, Object> layoutComponent = (Map<String, Object>) layoutItem.get('layoutComponents');
                                                        String comObj = createComponent(fields, (object)layoutComponent);
                                                        if(comObj != NULL)
                                                        {
                                                            sec.fieldApiList.add(comObj); SearchableFieldList.add(comObj);
                                                        }
                                                    }
                                                    else
                                                    {
                                                        for(Object layoutComponent : (List<Object>) layoutItem.get('layoutComponents')) // if multiple layoutcomponent
                                                        {
                                                            String comObj = createComponent(fields, (object)layoutComponent);
                                                            if(comObj != NULL)
                                                            {
                                                                sec.fieldApiList.add(comObj); 
                                                                SearchableFieldList.add(comObj);
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if(sec.fieldApiList.size() > 0)//pbSection.childComponents.size() > 0
                        {
                            //pb.childComponents.add(pbSection); // Add new PB section to PB
                            sections.add(sec);
                        }
                    }
                }      
            }
        }
    }
    

    
    /*
        Property : createComponent
        purpose  : Creates Input element dynamically
        @parameter1 : Object
        @returns : if meets the critaria returns Component.Apex.InputField else returns NULL
    */
    public String createComponent(Map<String, Schema.Sobjectfield> fields, Object rec)
    {
        
        Map<String, Object> obj = (Map<String,Object>) rec ;    
        String comp = String.valueOf(obj.get('value')) ;
        String fieldAPI;
        if(fields.get(comp) != NULL)
        {
            Schema.Sobjectfield field = fields.get(comp);
            Schema.Describefieldresult desField = field.getDescribe();
            if( desField.isCreateable() && desField.isAccessible() && ! desField.isDefaultedOnCreate() && String.ValueOf(desField.getType()) != 'TextArea' && desField.getName() != 'RecordTypeId')
            {
                fieldAPI = desField.getName();
            }
            else
            {
                return NULL;
            }
        }
        return fieldAPI;
             
    }
    
    
    /*
        Property : Search
        purpose  : To search the records which falls in to search critaria. searhced field will be added in to searchResult List.
        @parameter1 : Object
        @returns : if meets the critaria returns Component.Apex.InputField else returns NULL
    */
    public void search()
    {
        try
        {
            Map<String, schema.Sobjecttype> globalDescribe = Schema.getGlobalDescribe();      
            Schema.Sobjecttype sObj = globalDescribe.get(ObjectName);
            Schema.Describesobjectresult desObj = sObj.getDescribe();
            Map<String, Schema.Sobjectfield> fields = desObj.Fields.getMap();
            
            
            String query='';
            Search_Result_View__c searchResultView = Search_Result_View__c.getValues(ObjectName); 
            system.debug('::::searchResultView::::'+ searchResultView +':::::::'+ ObjectName);
            // check eiter custom setting record is availabe or not for the object.
            if(searchResultView == null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Errors.noObjInCustomSettingStr + ObjectName));
                return;
            }
            String fieldsViewStr = searchResultView.Fields_API_Name__c;
            // check either filed list is availabe or not.
            if(fieldsViewStr == '' || fieldsViewStr == null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Errors.noFildListInCusSetStr));
                return;
            }
            else
            {
                fieldList = fieldsViewStr.split(',' , 1000);
                for(String s : fieldList)
                    query = query==''? ''+s : query+', '+s ; 
                if(query != '')         
                    query ='select '+query+ ' FROM ' + ObjectName ;
                
            }
    
            String condition='';
            if(fields.get('RecordTypeId') != NULL)
                condition = ' RecordTypeId = \''+ selectedRecordType +'\'' ;
            
            for(String fieldAPIName : SearchableFieldList)
            {
                if(String.valueOf(sObjRec.get(fieldAPIName)) != '' && String.valueOf(sObjRec.get(fieldAPIName)) != NULL)
                {
                    Object dataValue = sObjRec.get(fieldAPIName) ;
                    if(dataValue instanceof String)
                        dataValue = '\'' + String.valueOf(dataValue) + '\'';
                    if (dataValue instanceof Date)
                        dataValue = String.escapeSingleQuotes((String.valueOf(dataValue)).subString(0,10));
                    if(dataValue instanceof DateTime)
                        dataValue = String.escapeSingleQuotes(((String)((DateTime)dataValue).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'')));
                    condition = condition != '' ? condition + ' AND ' + fieldAPIName + ' ='+ dataValue : condition + fieldAPIName;              
                }
            }
            if (condition.length() > 0)
                query = query + ' WHERE ' + condition + ' LIMIT ' + String.valueOf(Constants.recordLimit);
            else
                query = query + ' LIMIT ' + String.valueOf(Constants.recordLimit);
            system.debug(':::::query:::::'+query);
            ssc = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            recordPerPage = 25;
            ssc.setPageSize(recordPerPage);
            selectList.clear();
            for(SObject record : ssc.getRecords())
            {
                selectList.add(new RecordWrapper(false, record));
            }
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ex.getMessage()));
            return;
        }
                        
    }
    
    
    
    
    // property to return total pages of Standard Set Controller
    public Integer totalPagesInSSC
    {
        get
        {
            Decimal totalpageD = (ssc.getResultSize() / ssc.getPageSize());
            totalpageD = Math.floor(totalpageD) + ((Math.mod(ssc.getResultSize(), ssc.getPageSize() )>0) ? 1 : 0);
            totalPagesInSSC = Integer.valueOf(totalpageD);
            return totalPagesInSSC;
        }
        set
        {
            totalPagesInSSC = value;
        }
    }
    
    // property to return either current page is first page or not.
    public Boolean isFirstPage
    {
        get
        {
            if(ssc.getPageNumber() == 1)
                return true;
            else
                return false;
        }
        set;
    }
    
    // property to return either current page is first page or not.
    public Boolean isLastPage
    {
        get
        {
            if(ssc.getPageNumber() == totalPagesInSSC)
                return true;
            else 
                return false;
        }   
        set;
    }
    
    // Returns either SSC has next page or not.
    public Boolean getHasNext()
    {
        return ssc.getHasNext();
    }
    
    // Returns either SSC has previous page or not.
    public Boolean getHasPrevious()
    {
        return getHasPrevious();
    }
    
    // method to redirect next page
    public void nextPage()
    {
        if (ssc.getHasNext())
        {
            for(RecordWrapper record : selectList)
            {
                if(record.isSelected == true)
                    selectedItems.add(record.rec.id);
                else
                {
                    if(selectedItems.contains(record.rec.id))
                    {
                        selectedItems.remove(record.rec.id);
                    }
                }
            }
            
            selectList = new List<RecordWrapper>();
        
        
            ssc.next() ;
            for(sObject record : ssc.getRecords())
            {
                if(selectedItems.contains(record.id))
                {
                    selectList.add(new RecordWrapper(true, record));
                }
                else
                {
                    selectList.add(new RecordWrapper(false, record));
                }
            }
        }
        
    }
    
    // method to redirect previous page
    public void previoustPage()
    {
        if (ssc.getHasPrevious())
        {
            for(RecordWrapper record : selectList)
            {
                if(record.isSelected == true)
                    selectedItems.add(record.rec.id);
                else
                {
                    if(selectedItems.contains(record.rec.id))
                    {
                        selectedItems.remove(record.rec.id);
                    }
                }
            }
            
            selectList = new List<RecordWrapper>();

            ssc.previous() ;
            for(sObject record : ssc.getRecords())
            {
                if(selectedItems.contains(record.id))
                {
                    selectList.add(new RecordWrapper(true, record));
                }
                else
                {
                    selectList.add(new RecordWrapper(false, record));
                }
            }
        }
        
    }
    
    // Method to redirect on first page.
    public void firstPage()
    {
        for(RecordWrapper record : selectList)
        {
            if(record.isSelected == true)
                selectedItems.add(record.rec.id);
            else
            {
                if(selectedItems.contains(record.rec.id))
                {
                    selectedItems.remove(record.rec.id);
                }
            }
        }
        
        selectList = new List<RecordWrapper>();
        ssc.first() ;
        for(sObject record : ssc.getRecords())
        {
            if(selectedItems.contains(record.id))
            {
                selectList.add(new RecordWrapper(true, record));
            }
            else
            {
                selectList.add(new RecordWrapper(false, record));
            }
        }
        
    }
    
    // Method to redirect on Last page.
    public void LastPage()
    {
        for(RecordWrapper record : selectList)
        {
            if(record.isSelected == true)
                selectedItems.add(record.rec.id);
            else
            {
                if(selectedItems.contains(record.rec.id))
                {
                    selectedItems.remove(record.rec.id);
                }
            }
        }
        
        selectList = new List<RecordWrapper>();
        ssc.last() ;
        for(sObject record : ssc.getRecords())
        {
            if(selectedItems.contains(record.id))
            {
                selectList.add(new RecordWrapper(true, record));
            }
            else
            {
                selectList.add(new RecordWrapper(false, record));
            }
        }
        
    }
    
    // when page size is changed
    public void changePageSize()
    {
        for(RecordWrapper record : selectList)
        {
            if(record.isSelected == true)
                selectedItems.add(record.rec.id);
            else
            {
                if(selectedItems.contains(record.rec.id))
                {
                    selectedItems.remove(record.rec.id);
                }
            }
        }
        
        selectList = new List<RecordWrapper>();
        ssc.setPageSize(recordPerPage);
        for(sObject record : ssc.getRecords())
        {
            if(selectedItems.contains(record.id))
            {
                selectList.add(new RecordWrapper(true, record));
            }
            else
            {
                selectList.add(new RecordWrapper(false, record));
            }
        }
    }
    

    public class RecordWrapper
    {
        public boolean isSelected{get;set;}
        public sObject rec{get;set;}
        public RecordWrapper(boolean isSelected, sObject rec)
        {
            this.isSelected = isSelected;
            this.rec = rec;
        }
    }
    
    public class section
    {
        public String sectionName{get;set;}
        public List<String> fieldApiList{get;set;}
        public section()
        {
            fieldApiList = new List<String>();
        }
    }
      
}