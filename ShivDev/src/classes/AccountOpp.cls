public class AccountOpp{

    public List<Opportunity> oppList{get;set;}
    public set<Id> opIds;
    Public Opportunity op;
    public Map<Id,Account> actIdToOppId{get;set;}
    public List<Contact> contactList{get;set;}
    public Boolean temp {get; set; }
    public String check {get; set;}
    public ApexPages.StandardController controller ;
    public AccountOpp(){
        temp = true;
        oppList = [select id, Name, Amount,owner.name,Owner.MobilePhone, AccountId from Opportunity where Account.Name LIKE 'Nirmala%'];
        opIds = new set<ID>();
        for(Opportunity op : oppList){
            opIds.add(op.AccountId);
        }
        actIdToOppId = new Map<Id,Account>([select Id,Name,Industry,(select id, Name , Amount from Opportunities) from account where Id in : opIds]);
        contactList = [Select id, MailingCity From Contact ];
        system.debug('Op List Size :'+ oppList.size());
    }
    
    public void addError(){
        op.addError('This is the error');
    }
    public AccountOpp(ApexPages.StandardController SC){
        //controller = new ApexPages.StandardController(sObject);
        controller = sc;
        oppList = [select id, Name, Amount,owner.name,Owner.MobilePhone, AccountId from Opportunity where Account.Name LIKE 'Nirmala%'];
        op = oppList[0];
        
    }
    
    public void showMessage(){
        PageReference pr = Page.AccountOpportunity;
        pr.getParameters().put('id','0019000000AANfr');
        Blob body = pr.getContent();
        system.debug('content--'+body.toString());
        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter correct Ref ID/File Number'));
        //return (new PageReference('https://ap1.salesforce.com/0019000000N7L5X')).setRedirect(true);
    }
    
    
    public Opportunity getOp(){
        if(op == null){
            op = new Opportunity();
        }
        return op;
    }
    
    public void setOp(Opportunity opp){
        system.debug('Set Op :'+opp);
        this.op.Amount = 100;
    }
    
    public void save(){
        opportunity o = (Opportunity)controller.getRecord();
        insert op;
    }
    
    public void onloadAccount(){
        Account act = new Account(Name='Ashis Yadav');
        insert act;
    }
}