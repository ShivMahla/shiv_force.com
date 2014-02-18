public with sharing class DynamicForm
{
    public Sobject obj{
    	set
    	{
    		obj = new Account();
    		obj = value;
    	}
    	get;
    	}
   // public DynamicForm(Apexpages.standardController ctlr)
   // {
        //constructor code
   // }
   
    public DynamicForm()
    {
        obj = new Account();
    }
    //Create a page block dynamically
    public Component.Apex.PageBlock getActionForm()
    {
        Component.Apex.PageBlock pb = new Component.Apex.PageBlock();
      
        //creating an input field dynamically
        Component.Apex.InputField name = new Component.Apex.InputField(value = obj.get('name'));
        obj.put('Name','Ram');
        name.expressions.value = '{! obj.name}';
        name.id = 'name';
        Component.Apex.OutputLabel label = new Component.Apex.OutputLabel();
        label.value = 'Name';
        label.for = 'name';
        //Use the above block to create other input fields
      
        Component.Apex.CommandButton save = new Component.Apex.CommandButton();
        save.value = 'Save';
        save.expressions.action = '{!Save}';


        pb.childComponents.add(label);
        pb.childComponents.add(name);
        pb.childComponents.add(save);
        return pb;
    }

  
    //Create Section Header dynamically
    public Component.Apex.SectionHeader getSectionHeader()
    {
        Component.Apex.SectionHeader sh = new Component.Apex.SectionHeader();
        sh.title = 'Create Account';
        return sh;
    }
    
    public void save()
    {
    	insert obj;
    }
}