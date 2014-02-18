Public Class A {
	//static demo
	public  Boolean staticVar = true;
	public Account act = new Account();
	public String apexStr{
		get{
			return '<apex:input value="{ ! Account.Name}" />' ;
		}
		set;
	}
	public Component.Apex.InputField getDynamicDetail() {
        Component.Apex.InputField Input = new Component.Apex.InputField();
        Input.value=act.Name;
        return Input;
    }	
	
	public  A(Apexpages.Standardcontroller SC) 
	{
		
	}
	public void firstExCon()
	{
		staticVar = false;
		System.debug('firstExCon:::'+staticVar) ;
	}
	
	public void secExCon()
	{
		System.debug('secExCon:::'+staticVar) ;
	}
}
