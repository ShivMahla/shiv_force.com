Public class CRUDFLSCheckController
{
    Public static boolean OpportunityIsCreatable()
    {          
        
         
        
         String [] FieldsList = new String [] { 'Patient_Name__c','New_Appointment__c' , 'Name','AppointmentIdforSalesroomSplit__c','LeadSource','Clinic__c','Referral_card_ID1__c','Appointment_Start_Date_Time__c',
                          'Type','Appointment_End_Date_Time1__c','StageName','Treatment_Name__c','Treatment_Complete__c','Follow_Up_Date__c','Cancellation_Reasons__c',
                          'Appointment_Follow_Up_Date__c','Reason_For_Rescheduling__c','Associated_Wagjag_ID__c','Wagjag_Id_Used__c','Resource__c','Redeemed_Date_Time__c',
                          'Total_Purchase__c','Description__c','Discount__c','Quantity__c','Services__c','IsActive__c','Unlimited__c','Override__c','Webcam_Required__c'};  
  
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Opportunity.fields.getMap();
        for (String fieldToCheck : FieldsList ) {
            if (!m.get(fieldToCheck).getDescribe().isCreateable()) {
                return false;
            }
        }
        return true;    
    }
    Public static boolean OpportunityIsisUpdateable()
    {          
        String [] FieldsList  = new String [] {'Patient_Name__c','New_Appointment__c' , 'Name','LeadSource','AppointmentIdforSalesroomSplit__c','Clinic__c','Referral_card_ID1__c','Appointment_Start_Date_Time__c',
                          'Type','Appointment_End_Date_Time1__c','StageName','Treatment_Name__c','Treatment_Complete__c','Follow_Up_Date__c','Cancellation_Reasons__c',
                          'Appointment_Follow_Up_Date__c','Reason_For_Rescheduling__c','Associated_Wagjag_ID__c','Wagjag_Id_Used__c','Resource__c','Redeemed_Date_Time__c',
                          'Total_Purchase__c','Description__c','Discount__c','Quantity__c','Services__c','IsActive__c','Unlimited__c','Override__c','Webcam_Required__c'};  
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Opportunity.fields.getMap();
        for (String fieldToCheck : FieldsList ) {
            if (!m.get(fieldToCheck).getDescribe().isUpdateable()) {
                return false;
            }
        }
        return true;    
    }
    public static Boolean OpportunityisDeletable() {
        if (!Opportunity.sObjectType.getDescribe().isDeletable()){
            return false;
        }
        return true;
    }
    
    Public static boolean OpportunityisAccessible()
    {          
        String [] FieldsList  = new String [] {'Patient_Name__c','New_Appointment__c' , 'Name','LeadSource','AppointmentIdforSalesroomSplit__c','Clinic__c','Referral_card_ID1__c','Appointment_Start_Date_Time__c',
                          'Type','Appointment_End_Date_Time1__c','StageName','Treatment_Name__c','Treatment_Complete__c','Follow_Up_Date__c','Cancellation_Reasons__c',
                          'Appointment_Follow_Up_Date__c','Reason_For_Rescheduling__c','Associated_Wagjag_ID__c','Wagjag_Id_Used__c','Resource__c','Redeemed_Date_Time__c',
                          'Total_Purchase__c','Description__c','Discount__c','Quantity__c','Services__c','IsActive__c','Unlimited__c','Override__c','Webcam_Required__c'};  
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Opportunity.fields.getMap();
        for (String fieldToCheck : FieldsList ) {
            if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
                return false;
            }
        }
        return true;    
    }
     Public static boolean ResourceScheduleIsCreatable()
    {          
        String [] FieldsList  = new String [] {'ObjectName__c','Clinic__c','Close_Time__c','Open_Time__c'};  
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Resource_Schedule__c.fields.getMap();
        for (String fieldToCheck : FieldsList ) {
            if (!m.get(fieldToCheck).getDescribe().isCreateable()) {
                return false;
            }
        }
        return true;    
    }
    Public static boolean ResourceScheduleIsisUpdateable()
    {          
        String [] FieldsList  = new String [] {'ObjectName__c','Clinic__c','Close_Time__c','Open_Time__c'};  
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Resource_Schedule__c.fields.getMap();
        for (String fieldToCheck : FieldsList ) {
            if (!m.get(fieldToCheck).getDescribe().isUpdateable()) {
                return false;
            }
        }
        return true;    
    }
    public static Boolean ResourceScheduleisDeletable() {
        if (!Resource_Schedule__c.sObjectType.getDescribe().isDeletable()){
            return false;
        }
        return true;
    }
    
    Public static boolean ResourceScheduleisAccessible()
    {          
        String [] FieldsList  = new String [] {'ObjectName__c','Clinic__c','Close_Time__c','Open_Time__c'};  
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Resource_Schedule__c.fields.getMap();
        for (String fieldToCheck : FieldsList ) {
            if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
                return false;
            }
        }
        return true;    
    }    
     Public static boolean StaffSheduleIsCreatable()
    {          
        String [] FieldsList  = new String [] {'Clinic__c','Staff__c','Shift_Start__c','Shift_Endds__c','Resource__c','Clock_In__c','Clock_Out__c'};  
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Staff_Schedule__c.fields.getMap();
        for (String fieldToCheck : FieldsList ) {
            if (!m.get(fieldToCheck).getDescribe().isCreateable()) {
                return false;
            }
        }
        return true;    
    }
    Public static boolean StaffSheduleisUpdateable()
    {          
        String [] FieldsList  = new String [] {'Clinic__c','Staff__c','Shift_Start__c', 'Shift_Endds__c','Resource__c','Clock_In__c','Clock_Out__c'};  
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Staff_Schedule__c.fields.getMap();
        for (String fieldToCheck : FieldsList ) {
            if (!m.get(fieldToCheck).getDescribe().isUpdateable()) {
                return false;
            }
        }
        return true;    
    }
    public static Boolean StaffSheduleisDeletable() {
        if (!Staff_Schedule__c.sObjectType.getDescribe().isDeletable()){
            return false;
        }
        return true;
    }
    
    Public static boolean StaffSheduleisAccessible()
    {          
        String [] FieldsList  = new String [] {'Clinic__c','Staff__c','Shift_Start__c','Shift_Endds__c','Resource__c','Clock_In__c','Clock_Out__c'};  
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Staff_Schedule__c.fields.getMap();
        for (String fieldToCheck : FieldsList ) {
            if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
                return false;
            }
        }
        return true;    
    }
    Public static boolean siteIsCreatable()
    {          
        String [] FieldsList  = new String [] {'Opportunity_Id__c','Opportunity_Stage__c','Start_Date_Time__c'};  
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Sites__c.fields.getMap();
        for (String fieldToCheck : FieldsList ) {
            if (!m.get(fieldToCheck).getDescribe().isCreateable()) {
                return false;
            }
        }
        return true;   
    }
    Public static boolean siteIsisUpdateable()
    {          
        String [] FieldsList  = new String [] {'Opportunity_Id__c','Opportunity_Stage__c','Start_Date_Time__c'};  
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Sites__c.fields.getMap();
        for (String fieldToCheck : FieldsList ) {
            if (!m.get(fieldToCheck).getDescribe().isUpdateable()) {
                return false;
            }
        }
        return true;    
    }
    public static Boolean siteisDeletable() {
        if (!Sites__c.sObjectType.getDescribe().isDeletable()){
            return false;
        }
        return true;
    }    
    Public static boolean siteisAccessible()
    {          
        String [] FieldsList  = new String [] {'Opportunity_Id__c','Opportunity_Stage__c','Start_Date_Time__c'};  
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Sites__c.fields.getMap();
        for (String fieldToCheck : FieldsList ) {
            if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
                return false;
            }
        }
        return true;    
    }
    /**********************************Test Method *************************************/
    public static testMethod void mytestmethod(){
    CRUDFLSCheckController cont=new CRUDFLSCheckController();
    CRUDFLSCheckController.OpportunityIsCreatable();
    CRUDFLSCheckController.OpportunityIsisUpdateable();
    CRUDFLSCheckController.OpportunityisDeletable();
    CRUDFLSCheckController.OpportunityisAccessible();
    CRUDFLSCheckController.ResourceScheduleIsCreatable();
    CRUDFLSCheckController.ResourceScheduleIsisUpdateable();
    CRUDFLSCheckController.ResourceScheduleisDeletable();
    CRUDFLSCheckController.ResourceScheduleisAccessible();
    CRUDFLSCheckController.StaffSheduleIsCreatable();
    CRUDFLSCheckController.StaffSheduleisUpdateable();
    CRUDFLSCheckController.StaffSheduleisDeletable();
    CRUDFLSCheckController.StaffSheduleisAccessible();
    CRUDFLSCheckController.siteIsCreatable();
    CRUDFLSCheckController.siteIsisUpdateable();
    CRUDFLSCheckController.siteisDeletable();
    CRUDFLSCheckController.siteisAccessible();
    }
}