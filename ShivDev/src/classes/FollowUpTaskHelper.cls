// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

public class FollowUpTaskHelper {

    // Static variables are local to the context of a Web request  
    // (or testMethod during a runTests call)  
    // Therefore, this variable will be initialized as false  
    // at the beginning of each Web request which accesses it.  

    public static boolean alreadyCreatedTasks = false;
    private static boolean  WagjagUpdate       = false;

    public static boolean hasAlreadyCreatedFollowUpTasks() {
        return alreadyCreatedTasks;
    }

    // By setting the variable to true, it maintains this  
    // new value throughout the duration of the request  
    // (or testMethod)  
    
    public static void setAlreadyCreatedFollowUpTasks() {
            alreadyCreatedTasks = true;
    }

    public static String getFollowUpSubject(String subject) {
        return 'Follow Up: ' + subject;
    }
    public static void setWagjagUpdate() {
        WagjagUpdate  = true;
    }

    public static Boolean isWagjagUpdate() {
        return WagjagUpdate  ;
    }
}