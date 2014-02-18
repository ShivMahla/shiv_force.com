public with sharing class ClientSuccessIntegration 
{
    public static String baseURL = 'http://ec2-54-200-36-181.us-west-2.compute.amazonaws.com:8080/clientsuccess/' ;
    public static String UserName = 'amit@briskminds.com';
    public static String Password = 'briskminds' ;
    public static String accessToken;
    
    // Method to fetch access token or Outh token
    public String getAccessToken ()
    {
    	  
    	  Httprequest request = new Httprequest();
    	  request.setEndpoint(baseURL +'oauth/token?grant_type=implicit') ;
    	  request.setHeader('Authorization', 'Basic ' + Encodingutil.base64Encode(Blob.valueOf(UserName+':'+Password)) ) ;
    	  request.setHeader('Cache-Control','no-cache');
    	  request.setBody( 'grant_type = implicit') ; 
    	  request.setMethod('POST');
    	  Http http = new Http();
        HTTPResponse response = http.send(request);      
        Map<String,Object> aOuthResponse = new Map<String,Object>();
        aOuthResponse = (Map<String,Object>) JSON.deserializeUntyped(response.getBody()) ;
        if(aOuthResponse.containsKey('access_token'))
        {
      	  accessToken = String.valueOf(aOuthResponse.get('access_token'));
        }
        else
        {
      	  accessToken = 'error' ;
        }
        system.debug('Access Token *:*:'+accessToken);
        return accessToken; 
    }
}