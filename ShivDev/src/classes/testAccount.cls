public with sharing class testAccount 
{
	public SObject act{get;set;}
	public List<String> fieldList{get;set;}
	public testAccount()
	{
		act = new Account();
		fieldList = new List<String>();
		fieldList.add('Name');
		fieldList.add('Type');
		fieldList.add('Industry');
	}
	
	public void save()
	{
		insert act;
	}
}