public with sharing class ListController {
  public Account acct {get;set;}
  public ListController(ApexPages.StandardController sc) {
  	this.acct = (Account)sc.getRecord();
  }
}