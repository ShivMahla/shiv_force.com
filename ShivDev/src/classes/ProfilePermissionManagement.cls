public class ProfilePermissionManagement {

    public Profile[] pr {get;set;}
    public User[] usr {get;set;}
    public String selectedObj{get;set;}
    public list<ProfileSelector> allProfileSelector{get;set;}
    public list<UserSelector> allUserSelector{get;set;}
    public Boolean displayUsers{get;set;}
    public Sobject objMap;
    public Map<string, String> globalObjNames;
   
   //List of selected users
    public List<userSelector> selectedUsers{get;set;}
    
    public string debugText{get;private set;}
    public Map<User, PermissionSet> calculatedSystemPermissions {get;private set;}
    public Map<User, List<ObjectPermissions>> calculatedObjectPermissions {get;private set;}
    public Map<User, List<FieldPermissions>> calculatedFieldPermissions {get;set;}
    public List<User> existingUserResultsList;
    
    public List<string> varlist{get;set;}
    public Map<string,Schema.DisplayType> varmap2=new Map<string,Schema.DisplayType>();
    public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    public List<fieldSelector> fildlst{get;set;}
    public List<String> selectedfields{get;set;}
    public boolean selectusr{get;set;}
    //Instantiate the StandardSetController
    //public ApexPages.StandardSetController con{get; set;}
    public ApexPages.StandardSetController con
        {
            get
            {
                if (con == null)
                {
                    con = new ApexPages.StandardSetController(existingUserResultsList);
                    //Sets the number of records in each page set
                    con.setPageSize(2);
                }
                return con;
            }
            set;
        }
    
    
    public ProfilePermissionManagement (){
        pr = [Select id , Name From Profile];
        Map<string, Schema.Sobjecttype>  globalMap = Schema.getGlobalDescribe();   
        globalObjNames = new Map<string, String>();
        for (Schema.Sobjecttype obj: globalMap.Values()){
            Schema.DescribeSObjectResult r = obj.getDescribe();
            system.debug('###r ' + r) ;
            globalObjNames.put(r.getLabel(),r.getName());
        }
        
        system.debug('###globalMap ' + globalMap) ;
        allProfileSelector = new list<ProfileSelector>(); 
        
        displayUsers = false;
        for (Profile thispr: pr){
            allProfileSelector.add(new ProfileSelector(thispr.Name));
        }   
    }
    
    //Boolean to check if there are more records after the present displaying records
        public Boolean hasNext
        {
            get
            {
                return con.getHasNext();
            }
            set;
        }
     
        //Boolean to check if there are more records before the present displaying records
        public Boolean hasPrevious
        {
            get
            {
                return con.getHasPrevious();
            }
            set;
        }
     
        //Page number of the current displaying records
        public Integer pageNumber
        {
            get
            {
                return con.getPageNumber();
            }
            set;
        }
    
        //Returns the previous page of records
        public void previous()
        {System.debug('::::::::::::::::::::::::::::::::::::::::::::::IN PREVIOUS');
            con.previous();
            submitProfiles();
            System.debug('(List<User>)con.getRecords():::::::::::::::::::::PREVIOUS::::::::::::::::::::'+(List<User>)con.getRecords()); 
        }
     
        //Returns the next page of records
        public void next()
        {System.debug('::::::::::::::::::::::::::::::::::::::::::::::IN NEXT');
            con.next();
            submitProfiles();
            System.debug('(List<User>)con.getRecords():::::::::::::::::::::NEXT::::::::::::::::::::'+(List<User>)con.getRecords()); 
        }
    
    public PageReference submitUsers(){
        try{
            selectedfields=new List<String>();
            for(fieldSelector fsel:getfileds()){
                if(fsel.selectedfield==true){
                    selectedfields.add(fsel.con);
                }
            }
            debugText = '';
            calculatedSystemPermissions = new Map<User, PermissionSet>();
            calculatedObjectPermissions = new Map<User, List<ObjectPermissions>>();
            calculatedFieldPermissions = new Map<User, List<FieldPermissions>>();
            
            for (UserSelector eachusr: allUserSelector){
                if(eachusr.selectedUser){
                    debugText += eachusr.usr + ' was selected';
                    buildPermissions(eachusr.usr, selectedObj,selectedfields);
                }
            }
            //System.Debug(calculatedObjectPermissions+'***********************************'+calculatedFieldPermissions);
        }
        catch(Exception e){
            selectusr=true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You forgot to select an User');
            ApexPages.addMessage(myMsg);
        }
        return null;
    }
    /*
    public pageReference selected(){ system.debug('Input check box@@@@@@@@@@@@22');
        selectedUsers = new List<userSelector>();
        
        integer c;
        for(userSelector u: allUserSelector){            
            selectedUsers.add(new UserSelector(u.thisUser, u.usr,u.selecteduser));
             if(u.selecteduser)                   
                c++;
        }
        allUserSelector.clear();
        allUserSelector.addAll(selectedUsers);
        system.debug('Seleted list size'+c); system.debug('New user selsecot class@@@@@ '+alluserselector.size());
        return null;
    }
    */
    private void buildPermissions(User u, String objectName,List<string> fieldNames){
        List<string> reffields=new List<String>();
        for(Integer i=0;i<fieldNames.size();i++){
            reffields.add(objectName+'.'+fieldNames[i]);
        }
        PermissionSet base = [SELECT Id, Name,profileid,
            PermissionsManageDynamicDashboards, PermissionsManageDashboards, PermissionsManageCustomReportTypes,
            PermissionsEmailTemplateManagement, PermissionsEmailAdministration,
            (SELECT SobjectType, PermissionsCreate, PermissionsRead, PermissionsEdit, PermissionsDelete 
                FROM ObjectPerms
                WHERE SobjectType = :objectName
                ORDER BY SobjectType
            )
            ,(SELECT SobjectType, Field, PermissionsRead, PermissionsEdit
                FROM FieldPerms
                Where Field in: reffields
                and SobjectType = :objectName
                ORDER BY Field
             )
            FROM PermissionSet
            WHERE ProfileId = :u.ProfileId];
        
        PermissionSet finalSystemPermissions = base.clone(false, true);
        List<ObjectPermissions> finalSobjectPermissions = base.ObjectPerms.deepClone();
        List<FieldPermissions> finalFieldPermissions = base.FieldPerms.deepClone();
        //System.Debug('==================='+fieldNames);
        List<PermissionSet> extensions = [SELECT Id, Name,
            PermissionsManageDynamicDashboards, PermissionsManageDashboards, PermissionsManageCustomReportTypes,
            PermissionsEmailTemplateManagement, PermissionsEmailAdministration,
            (SELECT SobjectType, PermissionsCreate, PermissionsRead, PermissionsEdit, PermissionsDelete 
                FROM ObjectPerms
                WHERE SobjectType = :objectName
                ORDER BY SobjectType
            )
            ,(SELECT SobjectType, Field, PermissionsRead, PermissionsEdit
                FROM FieldPerms
                Where Field in: reffields
                and SobjectType = :objectName
                ORDER BY Field
             )
            FROM PermissionSet
            WHERE Id IN (SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :u.Id)];
        
        for(PermissionSet ps : extensions){
            finalSystemPermissions.PermissionsManageDynamicDashboards |= ps.PermissionsManageDynamicDashboards;
            finalSystemPermissions.PermissionsManageDashboards |= ps.PermissionsManageDashboards;
            finalSystemPermissions.PermissionsManageCustomReportTypes |= ps.PermissionsManageCustomReportTypes;
            finalSystemPermissions.PermissionsEmailTemplateManagement |= ps.PermissionsEmailTemplateManagement;
            finalSystemPermissions.PermissionsEmailAdministration |= ps.PermissionsEmailAdministration;
    
            for(Integer i = 0; i < ps.ObjectPerms.size(); ++i){
                finalSobjectPermissions[i].PermissionsCreate |= ps.ObjectPerms[i].PermissionsCreate;
                finalSobjectPermissions[i].PermissionsRead |= ps.ObjectPerms[i].PermissionsRead;
                finalSobjectPermissions[i].PermissionsEdit |= ps.ObjectPerms[i].PermissionsEdit;
                finalSobjectPermissions[i].PermissionsDelete |= ps.ObjectPerms[i].PermissionsDelete;
            }System.Debug('===================****'+ps.FieldPerms.size());
            for(Integer i = 0; i < ps.FieldPerms.size(); ++i){
                finalFieldPermissions[i].PermissionsRead |= ps.FieldPerms[i].PermissionsRead;
                finalFieldPermissions[i].PermissionsEdit |= ps.FieldPerms[i].PermissionsEdit;
            }
        }
        
        calculatedSystemPermissions.put(u, finalSystemPermissions);
        calculatedObjectPermissions.put(u, finalSobjectPermissions);
        calculatedFieldPermissions.put(u, finalFieldPermissions);
    }
        
    public PageReference submitProfiles(){
        existingUserResultsList = new List<User>();
        String objFound = globalObjNames.get(selectedObj); 
        system.debug('###objFound ' + objFound) ;
        
        ObjectPermissions[] objPerms = [Select SobjectType, PermissionsViewAllRecords, PermissionsRead, PermissionsModifyAllRecords, PermissionsEdit, PermissionsDelete, PermissionsCreate, ParentId From ObjectPermissions where SobjectType=:objFound];
        system.debug('###objPerms ' + objPerms) ;
        
        allUserSelector = new list<UserSelector>(); 
        Set<String> selProfilesSet = new Set<String>();
        for (ProfileSelector eachpr: allProfileSelector)
            if (eachpr.selectedProfile) selProfilesSet.add(eachpr.thisProfile);
        
        //con = new ApexPages.StandardSetController(Database.getQueryLocator([Select FirstName, LastName, Name, id, ProfileId From User where Profile.Name In :selProfilesSet]));
            existingUserResultsList = [Select FirstName, LastName, Name, id, ProfileId From User where Profile.Name In :selProfilesSet];
            // sets the number of records in each page set
                //con.setPageSize(3);
           System.debug('(List<User>)con.getRecords():::::::::::::::::::::::::::::::::::::::::'+(List<User>)con.getRecords()); 
        for (User thisusr: (List<User>)con.getRecords() ){
            allUserSelector.add(new UserSelector(thisusr.FirstName + ' ' + thisusr.LastName, thisusr,false)); //Mod: Mar 02
        }
        system.debug('### allUserSelector ' + allUserSelector);
        if (!allUserSelector.isempty()) {
            displayUsers = true;
            
        }
        else{
            displayUsers = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Users were found, please select another Profile.'));     
        }
        
        return null;
    }   
         
    public List<SelectOption> getObjectValues(){
        List<SelectOption> optionList = new List<SelectOption>();
        optionList.add(new SelectOption('None' ,'None'));
        List<String> entities = new List<String>(schemaMap.keySet());
        entities.sort();
        //IncludeObjects__c incObj = IncludeObjects__c.getinstance('allobjects');  /*commented by aniqa*/
        // String[] allObjects = new String[]{};
        //try{
          //  allObjects = incObj.include_this__c.split(';');
            
            for(String eachobj: entities){
                optionList.add(new SelectOption(eachobj ,eachobj));
            }
            
        //}
        //catch(Exception ex){}
        
        return optionList;
    }
    // created by aniqa
    
    public Integer getReccount() {
       // return setCon.getResultSize();
       return null;
    }

    
    Public void Next1(){
        //setCon.next();        
    }

    Public void Previous1(){
       // setCon.previous();
    }
    
    public void Searchfilds() {
        try{
            Boolean temp;
            for (UserSelector eachusr: allUserSelector){
                if(eachusr.selectedUser==true){
                    temp=true;
                }
            }
            if (!allUserSelector.isempty() && temp==true) {
                if(fildlst!=null){
                    //fildlst.clear();
                    fildlst=null;
                }
                varlist=new List<string>();
                if(selectedObj!='none'){
                   // System.Debug('*******************'+selectedObj);
                    Map <String, Schema.SObjectField> fieldMap = schemaMap.get(selectedObj).getDescribe().fields.getMap();
                    //System.Debug('==================='+fieldMap.Values());
                    for(Schema.SObjectField sfield : fieldMap.Values()){
                        schema.describefieldresult dfield = sfield.getDescribe();
                        if(String.valueOf(dfield.getType())!='TEXTAREA'){
                            varlist.add(dfield.getname());
                            varmap2.put(dfield.getname(),dfield.getType());
                        }
                    }
                }
            }
        }
        catch(Exception e){
        }
    }
    /* Mod: 12:50 AM - Not used anywhere 
    public ApexPages.StandardSetController setCon {get {
       // fildlst=new List<fieldSelector>(new ApexPages.StandardController());
            if(setCon == null) {
               // setCon = new ApexPages.StandardSetController();
            }
            setCon.setPageSize(10);
            return setCon;
        }set;
    }
    */
    public List<fieldSelector> getfileds(){
            if(fildlst==null && varlist!=null){
                fildlst=new List<fieldSelector>();
                for(integer i=0;i<varlist.size();i++){
                    fildlst.add(new fieldSelector(varlist[i]));
                   // System.Debug('...............................'+fildlst[i]);
                }
            }
       
        return fildlst;
    }
    public class fieldSelector{
        public string con{get;set;}
        public Boolean selectedfield{get;set;}
        public fieldSelector(String s){
            con=s;
            selectedfield=false;
        }
    }
    public class ProfileSelector{
        public String thisProfile{get;set;}
        public Boolean selectedProfile{get;set;}
        
        public ProfileSelector(String newProfile){
            thisProfile = newProfile;
            selectedProfile = false;
        }
    }
    
    public class UserSelector{
        public User usr{get;set;}
        public String thisUser{get;set;}
        public Boolean selectedUser{get;set;}
        
        public UserSelector(String newUser, User newUsr, boolean b){ //Added 3rd parameter boolean
            thisUser = newUser;
            usr = newUsr;
            selectedUser = b;  //changed default value false to 3rd parameter
        }
      }
    
    // This is used for the different PermissionSets
    //e.g. modify
    public class PermissionSelector{
        public String thisUser{get;set;}
        //public Boolean selectedUser{get;set;}
        //public Boolean selectedUser{get;set;}
        //public Boolean selectedUser{get;set;}
        //public Boolean selectedUser{get;set;}
        //public Boolean selectedUser{get;set;}
        //public Boolean selectedUser{get;set;}
        
        public PermissionSelector(String newUser){
            //thisPermission = newPermission;
            //selectedPermission = false;
        }
    }
      
   
  
}