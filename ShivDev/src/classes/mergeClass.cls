public class mergeClass{
    public mergeClass(){
        String output;
        Schema.DescribeSObjectResult R = Case.SObjectType.getDescribe();
        List<Schema.ChildRelationship> C = R.getChildRelationships();
        for (Schema.ChildRelationship CR : C) {
         output += CR.getChildSObject().getDescribe().getName() + ',';
        }
        System.debug('shiv-----'+output);
    }
}