public class dynamicpicklist
{
public String city{get; set;}

public List<SelectOption> getcitynames()
{
  List<SelectOption> options = new List<SelectOption>();
  List<DynamicPicklist__c> citylist = new List<DynamicPicklist__c>();
  citylist = [Select Id, PicklistValue__c FROM DynamicPicklist__c ];
  options.add(new SelectOption('--None--','--None--'));
  for (Integer j=0;j<citylist.size();j++)
  {
      options.add(new SelectOption(citylist[j].PicklistValue__c,citylist[j].PicklistValue__c));
  }
  return options;
}
public String newpicklistvalue{get; set;}

public void saverec()
{
  DynamicPicklist__c newrec = new DynamicPicklist__c(PicklistValue__c=newpicklistvalue);
  insert newrec;
  newpicklistvalue=NULL;
}

}