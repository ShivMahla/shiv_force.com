// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

trigger DeleteSalesRoomSplitBeforeDelete on Opportunity (Before delete) {
           //Deleting consult  appointment when main appointment deleted 
            System.debug(trigger.old[0].id);
            Set<String> SalesSplit = new  Set<String>();
            for( Opportunity DeleOpp : Trigger.old   )
            {
              SalesSplit.add( DeleOpp .id  );
            }
            List<opportunity> opList = [select id, AppointmentIdforSalesroomSplit__c from  opportunity where id not in :SalesSplit AND AppointmentIdforSalesroomSplit__c =:SalesSplit];
           
           if (CRUDFLSCheckController.OpportunityisDeletable()){
                Delete oplist;
           }
}