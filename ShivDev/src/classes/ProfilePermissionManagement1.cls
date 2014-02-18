public class ProfilePermissionManagement1 {
    List<Profile> profileList {get; set;}
    List<ProfileSelecter> profileSelecterList;
    
    public profilePermissionManagement1(){
        profileList = [SELECT Id, Name FROM Profile];
    }
    
    public List<ProfileSelecter> getProfileSelecterList(){
        if(profileSelecterList == NULL){
            profileSelecterList = new List<ProfileSelecter>();
            if(profileList != NULL){
                for(Profile pf : profileList){
                    profileSelecterList.add(new ProfileSelecter(pf.Name));
                }
            }
        }
        return profileSelecterList ;
    }
    
    public class ProfileSelecter{
        public String profileName {get; set;}
        public Boolean isProfileSelected {get; set;}
        public ProfileSelecter(String newProfile){
            profileName = newProfile;
            isProfileSelected  = false;
        }
    }
    
}