public with sharing class FBIntegration {
  public String clientId = '633156773386191' ;
  public String clientSecret = '719c77477456ffe8f80ec05c19836912';
  public String baseURL = 'https://www.facebook.com/';
  public String redirectUI = 'https://c.ap1.visual.force.com/apex/FaceBook';
  public String baseLink ;
  
  public void AccessToken()
  {
  	 Httprequest req = new Httprequest();
  	 system.debug('****---');
  	 req.setEndpoint('https://graph.facebook.com/oauth/access_token?' +
  	 		'client_id='+clientId +
  	 		'&redirect_uri='+redirectUI +
  	 		'&client_secret='+clientSecret +
  	 		'&code='+ ApexPages.currentPage().getParameters().get('code')) ;     		
     req.setMethod('GET');
  	 Http httpro = new Http();
  	 Httpresponse httpRes = httPro.send(req);
  	 system.debug('****'+httpRes.getBody());
  	 //return httpRes.getBody();
  }
  
  	//Method to fetch Authorization code
	public String getbaseLink() {
 		baseLink = baseURL + 'dialog/oauth?client_id='+clientId+'&redirect_uri='+redirectUI+'';
 		return baseLink;
	}
}