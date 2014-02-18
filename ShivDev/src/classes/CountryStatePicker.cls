public with sharing Class CountryStatePicker{
    public String state{get;set;}
    public String country{get;set;}
    
    public List<SelectOption> getCountriesSelectList(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--Select One--'));
        
        Map<String,Foundation_Countries__c> countries = Foundation_Countries__c.getAll();
        
        //sort them by name
        List<String> countryNames = new List<string>();
        countryNames.addAll(countries.keySet());
        countryNames.sort();
        
        //create the select option
        for(String countryName : countryNames){
            Foundation_Countries__c temp = countries.get(countryName);
            options.add(new SelectOption(temp.country_code__c,temp.name));
        }
        return options;
        
    }
    
    // To generate the states picklist based on the country selected by user.
    public List<SelectOption> getStatesSelectList() {
        List<SelectOption> options = new List<SelectOption>();
        // Find all the states we have in custom settings.
        Map<String, Foundation_States__c> allstates = Foundation_States__c.getAll();

        // Filter states that belong to the selected country
        Map<String, Foundation_States__c> states = new Map<String, Foundation_States__c>();
        for(Foundation_States__c state : allstates.values()) {
            if (state.country_code__c == this.country) {
                states.put(state.name, state);
            }
        }
        
        // Sort the states based on their names
        List<String> stateNames = new List<String>();
        stateNames.addAll(states.keySet());
        stateNames.sort();
        
        // Generate the Select Options based on the final sorted list
        for (String stateName : stateNames) {
            Foundation_States__c state = states.get(stateName);
            options.add(new SelectOption(state.state_code__c, state.state_name__c));
        }
        
        // If no states are found, just say not required in the dropdown.
        if (options.size() > 0) {
            options.add(0, new SelectOption('', '-- Select One --'));
        } else {
            options.add(new SelectOption('', 'Not Required'));
        }
        return options;
    }
}