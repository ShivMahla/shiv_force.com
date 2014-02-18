public class MyCustomController {
public Account acc;
public MyCustomController(){
acc=[select name,id,phone,industry,website,rating,BillingCity,BillingCountry,
ShippingCity,ShippingCountry,AnnualRevenue from Account where id=:Apexpages.currentPage().getParameters().get('id')];
}
public Account getAccount() {
return acc;
}
public PageReference saveMethod()
{
update acc;
PageReference pf=new apexPages.StandardController(acc).view();
return pf;
}
}