public with sharing class Google_Drive_Integration_Controller {
	
	public Static String Client_Id = '578491248469-63ad5rv45ep8lpbre656nqsqak36mvm8.apps.googleusercontent.com' ;
	public Static String Client_Secret = '0rbptFoqAcl_JANVjokAbORw' ;
	public Static String End_point_url = 'https://accounts.google.com' ;
	public Static String Redirect_URI = 'https://c.ap1.visual.force.com/apex/Googe_Data' ; //'http://forcespider-developer-edition.ap1.force.com/Authorization_Page' ;   
	public Static String access_Token ;
	
	private Static String Scope = 'https://www.googleapis.com/auth/drive' ;
	
	//private Static String Access_Token_End_point_url = 'https://accounts.google.com' ;

	//Method to create base URL for Authorization code
	public Static String createAuthorizationURL() {
		String URL = '/o/oauth2/auth?' ;
 		URL += 'redirect_uri='+EncodingUtil.urlEncode(Redirect_URI,'UTF-8');
		URL += '&response_type=code' ;
		URL += '&client_id='+EncodingUtil.urlEncode(Client_Id,'UTF-8');
		URL += '&scope='+EncodingUtil.urlEncode(Scope,'UTF-8');
		URL += '&approval_prompt=force&access_type=offline' ;
		System.debug('') ;	
		return End_point_url + URL ;
	}
	
	//Method to fetchAccessTokens
	public Static String fetchAccessTokenAndRefreshToken(String localCode) {
		HttpRequest req = new HttpRequest();
    	req.setEndpoint(End_point_url+'/o/oauth2/token') ;
     	req.setBody('code='+EncodingUtil.urlEncode(localCode,'UTF-8') +
     		'&client_id='+EncodingUtil.urlEncode(Client_Id,'UTF-8')+
     		'&client_secret='+EncodingUtil.urlEncode(client_secret,'UTF-8')+
     		'&redirect_uri='+EncodingUtil.urlEncode(Redirect_URI,'UTF-8')+
     		'&grant_type='+EncodingUtil.urlEncode('authorization_code','UTF-8')) ;
     	req.setHeader('Content-length', String.valueOf(req.getbody().length())) ;
     	req.setMethod('POST');
     	req.setHeader('Content-Type','application/x-www-form-urlencoded') ;
     	Http http = new Http();
     	HTTPResponse res = http.send(req);
		return res.getbody() ;
	}
	
	//Method to create new Access using Refresh_token
	public Static String fetchAccessTokenUsingRefreshToken(String refresh_Token) {		
		HttpRequest req = new HttpRequest();
    	req.setEndpoint(End_point_url+'/o/oauth2/token') ;
     	req.setBody('refresh_token='+EncodingUtil.urlEncode(refresh_Token,'UTF-8') +
     		'&client_id='+EncodingUtil.urlEncode(Client_Id,'UTF-8')+
     		'&client_secret='+EncodingUtil.urlEncode(client_secret,'UTF-8')+
     		'&grant_type='+EncodingUtil.urlEncode('refresh_token','UTF-8')) ;
     	req.setMethod('POST');
     	req.setHeader('Content-Type','application/x-www-form-urlencoded') ;
     	Http http = new Http();
     	HTTPResponse res = http.send(req);
		return res.getbody() ;		
	}

	//Method to fetch all files from Drive
	public Static String fetchAllFiels(String accessToken) {	
		HttpRequest req = new HttpRequest();
    	req.setEndpoint('https://www.googleapis.com/drive/v2/files/') ;
     	req.setMethod('GET');
     	req.setHeader('Authorization','Bearer ' + 'ya29.1.AADtN_WTeIgrKd09Bw1CcJnATeBZ-Q6Jl1TvouJ6UbxQtm6h72m6PORNe-GBzg') ;    	
     	req.setHeader('Content-Type','application/json; charset=UTF-8') ;
     	Http http = new Http();
     	HTTPResponse res = http.send(req);
     	return res.getBody() ;
	}
	
	
	//Method to upload a file to Drive
	public Static String uploadFile(String accessToken, String title , String mimeType , String description , Blob body) {
		HttpRequest req = new HttpRequest();
    	req.setEndpoint('https://www.googleapis.com/upload/drive/v2/files/') ;

     	req.setMethod('POST');
     	req.setHeader('Authorization','Bearer ' + accessToken) ;    	
     	req.setHeader('Content-Type','multipart/related; boundary="foo_bar_baz"') ;
 	
     	String reqString = '\r\n--foo_bar_baz\r\n'
							+'Content-Type: application/json\r\n\r\n' 
							+'{\r\n'
							+'"title": "' + title+ '"\r\n'
							+'}\r\n\r\n'
							+'--foo_bar_baz\r\n'
							+'Content-Type: '+mimeType+'\r\n'
							+'Content-Transfer-Encoding: base64\r\n\r\n'
							+EncodingUtil.base64Encode(body) +'\n'
							+'\r\n--foo_bar_baz--' ;
     	System.debug('------------reqString------'+reqString) ;
     	req.setBody(reqString) ;
  		req.setHeader('Content-Length',String.valueOf(req.getbody().length())) ;
     	
     	Http http = new Http();
     	HTTPResponse res = http.send(req);
     	return res.getBody() ;
	}
	//Method to delete a file from GoogleDrive
	public Static String deleteFile(String fileId,String accessToken) {
		HttpRequest req = new HttpRequest();
    	req.setEndpoint('https://www.googleapis.com/drive/v2/files/'+fileId) ;
     	req.setMethod('DELETE');
     	req.setHeader('Authorization','Bearer ' + accessToken) ;    	
     	req.setHeader('Content-length','0') ;
     	Http http = new Http();
     	HTTPResponse res = http.send(req);
     	System.debug('------------------res-------'+res) ;
     	return res.getBody() ;
	}
	public Class DriveItemWrapper {
		public String Title  { get ; set ; }
		public String Id  { get ; set ; }
		public String Type  { get ; set ; }
		public String fileExtension  { get ; set ; }
		public String DownLoad_Link  { get ; set ; }
		public String webViewLink  { get ; set ; }
		public String Modified_Date  { get ; set ; }
		public String viewLink { get ; set ; }
		
		public DriveItemWrapper() {
			
		}
		//Wrapper Constructor
		public DriveItemWrapper(String Title, String Id, String Type, String fileExtension, String DownLoad_Link ,String webViewLink ,String Modified_Date , String viewLink) {
			this.Title = Title ;
			this.Id = Id ;
			this.Type = Type ;
			this.fileExtension = fileExtension ;
			this.DownLoad_Link = DownLoad_Link ;
			this.webViewLink = webViewLink ;
			this.Modified_Date = Modified_Date ;	
			this.viewLink = viewLink ;
		}
	}
}