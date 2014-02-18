public with sharing class IntegrationController 
{
	public String baseLink ;
	public String accessToken
	{
		get
		{
			String isApproved = ApexPages.currentPage().getParameters().get('error');
			String accessCode = ApexPages.currentPage().getParameters().get('code');
			system.debug('*******'+isApproved+'------'+accessCode) ;
			if( isApproved != 'access_denied')
			{
				if(accessCode != '')
				{
					accessToken = Google_Drive_Integration_Controller.fetchAccessTokenAndRefreshToken(accessCode);
				}
			}
			return accessToken ;
		}
		set ;
	}
	
	//Method to fetch Authorization code
	public String getbaseLink() 
	{
 		baseLink = Google_Drive_Integration_Controller.createAuthorizationURL();
 		return baseLink;
	}
	
	public void fetchAllFilesFromDrive() 
	{
		Map<String,Object> responseMap = new Map<String,Object> () ;
		List<Google_Drive_Integration_Controller.DriveItemWrapper> GoogleDriveItemDetailsList = new List<Google_Drive_Integration_Controller.DriveItemWrapper>() ;
		String response = Google_Drive_Integration_Controller.fetchAllFiels(accessToken) ;
		system.debug('***JSON Response***'+response);
		responseMap =(Map<String,Object>)JSON.deserializeUntyped(response) ;
		system.debug('***ResponseMap***'+responseMap);
		List<Object> filesList = new List<Object>();
		if(responseMap.containsKey('items'))
		{
			filesList = (List<Object>)(responseMap.get('items')) ;
		}
		for(Object file : filesList)
		{
			/* Object Structure
			   {
				   "kind": "drive#file",
				   "id": "0AsjJ5iS7QvIcdDVLV3JBWFZZUDM1WFE3U1BqbjI1LWc",
				   "etag": "\"11QSOvUX6KZKZVB6nCB3GloLTJQ/MTM4OTAwMjA1NTMxNg\"",
				   "selfLink": "https://www.googleapis.com/drive/v2/files/0AsjJ5iS7QvIcdDVLV3JBWFZZUDM1WFE3U1BqbjI1LWc",
				   "alternateLink": "https://docs.google.com/a/briskminds.com/spreadsheet/ccc?key=0AsjJ5iS7QvIcdDVLV3JBWFZZUDM1WFE3U1BqbjI1LWc&usp=drivesdk",
				   "embedLink": "https://docs.google.com/a/briskminds.com/spreadsheet/ccc?key=0AsjJ5iS7QvIcdDVLV3JBWFZZUDM1WFE3U1BqbjI1LWc&output=html&chrome=false&widget=true",
				   "iconLink": "https://ssl.gstatic.com/docs/doclist/images/icon_11_spreadsheet_list.png",
				   "thumbnailLink": "https://docs.google.com/a/briskminds.com/feeds/vt?gd=true&id=0AsjJ5iS7QvIcdDVLV3JBWFZZUDM1WFE3U1BqbjI1LWc&v=34&s=AMedNnoAAAAAUtAYy3HwIKjU9MMVbzHVykX7UHp4vHQc&sz=s220",
				   "title": "Client Credentials",
				   "mimeType": "application/vnd.google-apps.spreadsheet",
				   "labels": {
				    "starred": false,
				    "hidden": false,
				    "trashed": false,
				    "restricted": false,
				    "viewed": true
   				  }
   			 }	  
   		*/	
   		String title,Id ,Type,fileExtension,downLoad_Link,webViewLink,modifiedDate,viewLink;
			Map<String,Object> mapFileAttributeToValue = new Map<String,Object>() ;
			mapFileAttributeToValue = (Map<String,Object>)file ;
			Map<String,Object> mapFileLabelToValue = (Map<String,Object>)mapFileAttributeToValue.get('labels') ;
			Boolean isThisFileTrashed = (boolean)mapFileLabelToValue.get('trashed') ;
			if(! isThisFileTrashed)
			{
				
				if(mapFileAttributeToValue.containsKey('title'))
					title = (String)mapFileAttributeToValue.get('title') ;
				if(mapFileAttributeToValue.containsKey('id'))
					Id = (String)mapFileAttributeToValue.get('id') ;
				if(mapFileAttributeToValue.containsKey('mimeType'))
					type = (String)mapFileAttributeToValue.get('mimeType') ;
				if(mapFileAttributeToValue.containsKey('title'))
					fileExtension = (String)mapFileAttributeToValue.get('fileExtension') ;
				if(mapFileAttributeToValue.containsKey('downloadUrl'))
					downLoad_Link = (String)mapFileAttributeToValue.get('webContentLink') ;
				if(mapFileAttributeToValue.containsKey('webViewLink'))
					webViewLink = (String)mapFileAttributeToValue.get('webViewLink') ;
				if(mapFileAttributeToValue.containsKey('modifiedDate'))
					modifiedDate = (String)mapFileAttributeToValue.get('modifiedDate') ;
				if(mapFileAttributeToValue.containsKey('alternateLink'))
					viewLink = (String)mapFileAttributeToValue.get('alternateLink') ;
					
				Google_Drive_Integration_Controller.DriveItemWrapper DIW = new Google_Drive_Integration_Controller.DriveItemWrapper(title,Id,Type,fileExtension,downLoad_Link,webViewLink,modifiedDate,viewLink);	
				GoogleDriveItemDetailsList.add(DIW) ;
			}
		}
		
	}
		
}