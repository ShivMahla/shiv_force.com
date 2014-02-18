// Copyright (c) 2012, 2013 All Rights Reserved
//
// This source is subject to the BigKite License granted to Skin Vitality, and only Skin Vitality.
// All code is owned solely by BigKite and BigKite hereby grants
// Skin Vitality a worldwide, perpetual, non-exclusive, non-transferable, royalty-free license to use and
// modify such work product solely for its internal business purposes.
// All other rights reserved.

public class StaffEvent{
 public Id id            { get; set; }           { this.id = null; }
    public string staffName {get;set;}
    public Id staffID {get;set;}
    public String staffRecordID {get;set;} 
    public string resourceName {get; set;}
    public string clinic {get;set;} {this.clinic = '';}
    public string ObjectName {get;set;}             {this.ObjectName = '';}    
    public string className { get; set; }           { this.className = ''; }
    public string url       { get; set; }
    public DateTime start_DateTime { get; set; }
    public DateTime end_DateTime { get; set; }
    public string title{get;set;}
    public Date allDayDate  { get; set; } 
    public boolean editable { get; set; }           { this.editable = true; }
    public boolean visible  { get; set; }           { this.visible = true; }
    public String startMs   { get {         return String.valueOf(start_DateTime .getTime());    }} 
    public String endMs     { get {             return String.valueOf(end_DateTime.getTime());    }}
    public Boolean allDayEvent { get; set; }        { allDayEvent = false; } 
    public string description { get; 
        set { 
            description = truncate( value!=null?value:'.',128 );
            description = escapeNaughtyChars(description); 
        } 
    }
    
    
    public StaffEvent() {    }    
    public StaffEvent(Datetime s) {        start_DateTime  = s;    }
    public StaffEvent(Datetime s, Id pId) {      start_DateTime  = s;        id = pId;    }
    
    public string getStartISO() {
        if ( allDayEvent && allDayDate != null ) return allDayDate.format(); 
        return dateToJSON(start_DateTime );
    }
    public string getEndISO() { 
        if ( allDayEvent  ) return end_DateTime .formatGMT('MM/dd/yyyy'); 
        return dateToJSON(end_DateTime );
    }
    public string getStartJS() {        return dateToJavaScript(start_DateTime );    }
    public string getEndJS() {        return dateToJavaScript(end_DateTime );    }
    
    public static string dateToJavaScript(datetime dtm) { 
        string ret = 'new Date(' + 
        dtm.year() + ', ' + (dtm.month()-1) + ', ' + dtm.day() + 
        ', '+dtm.hour() +', '+ dtm.minute() +', ' + dtm.second() + ')';  
        return ret;
    }  
    public static string dateToJSON(datetime dtm) { 
        //return dtm.format('');
        string ret =   dtm.year() + '-' + (dtm.month()<10?'0':'' ) +
             dtm.month() +'-' + (dtm.day()<10?'0':'' ) + dtm.day() + 
        ' ' + (dtm.hour()<10?'0':'' ) + dtm.hour() +':'+ 
            (dtm.minute()<10?'0':'' ) + dtm.minute() +':00';  
        return ret;
    }  
    static string truncate(string s,integer len) {
        if ( s.length() <= len) return s;
        return s.substring(0,len);
    } 
      
    /* these are causing me problems, remove or clean them up */
    static string escapeNaughtyChars(String s) {
        s = s.replaceAll('\n','<br />');  
        s = s.replaceAll('\r',' ');
        pattern myPattern = pattern.compile( Pattern.quote('\\') ); 
        matcher myMatcher = myPattern.matcher(s); 
        s = myMatcher.replaceAll('');
        s = s.replaceAll('"','\\\\"');
        return s;
    } 
    
     public static testMethod void test() {
        staffevent s = new staffevent();
        Datetime t = Datetime.newInstance( 2010,9,9,0,0,0 );
        Event e = new Event(DurationInMinutes= 3,activitydatetime = t );
        
        insert e;
        e = [ select id, endDateTime from event where id = :e.id limit 1];
        StaffEvent v = new StaffEvent(t,e.id);
        v.description = 'foo\"';
        v.end_DateTime = e.EndDateTime;
        v.title = 'bar sd sd \\ sdf sdf sdf sdf sdf sd fsd fs df sdf sdf s dfs df sdf sdf sdf sdf ';
        system.assert( v.getStartJS() != null );        
        system.assert( v.startMs != null);
        system.assert( v.endMs != null);
        pattern myPattern = pattern.compile( Pattern.quote('\\') ); 
        matcher myMatcher = myPattern.matcher('sdfjl \\ sdflkj'); 
    }
   /****************TestMethod***********************************/ 
    public static testMethod void test2() {
        Datetime t = Datetime.newInstance( 2010,9,9,0,0,0 );
    
        StaffEvent v2 = new StaffEvent(t);
        
        system.assert( v2.startMs != null);
        system.assert( v2.getStartISO() != null );
        system.assert( v2.getStartJS() != null);
        v2.end_DateTime = t.addDays(1);
        system.assert( v2.getEndISO() != null ); 
        system.assert( v2.getEndJS() != null );   
        
        system.assert( new fullcalendarEvent() != null );
        System.assert( dateToJSON(system.now()) != null ); 
    }
    
}