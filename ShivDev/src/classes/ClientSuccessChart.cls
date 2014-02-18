public with sharing class ClientSuccessChart 
{
	public String DispositionwidgetData ;
	public String getDispositionwidgetData()
	{
		//HttpRequest httpReq = new Httprequest();
		//httpReq.setEndpoint('') ;
		
		
		HttpRequest req = new HttpRequest();
    	req.setEndpoint(ClientSuccessIntegration.baseURL+'api/disposition/clients/risklevels/daily') ;
     	req.setMethod('GET');
     	System.debug('access token :::'+ ClientSuccessIntegration.accessToken) ;
     	req.setHeader('Authorization','Bearer ' + ClientSuccessIntegration.accessToken) ;    	
     	req.setHeader('Content-Type','application/json; charset=UTF-8') ;
     	Http http = new Http();
     	HTTPResponse res = http.send(req);
     	System.debug('Content *:*'+res.getBody()) ;
     	return res.getBody() ;
		
	}
}