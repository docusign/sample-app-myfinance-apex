trigger UserTrigger on User (after insert, after update) {
    List<Profile> profiles = [SELECT Id 
                    FROM Profile 
                    WHERE Name = 'Customer Community User Profile' 
                    LIMIT 1];

    PermissionSet permSet = [SELECT Id 
                            FROM PermissionSet 
                            WHERE Name = 'DocuSign_Sender'];

    List<PermissionSetAssignment> pSets = [SELECT Id, PermissionSetId, PermissionSet.Name, PermissionSet.ProfileId, PermissionSet.Profile.Name, AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE PermissionSet.Name LIKE '%Sender%'];                             
    Id profileId = profiles.get(0).Id;    

    if(Trigger.isAfter && Trigger.isUpdate){
        if(!profiles.isEmpty()){              
            Set<Id> assigneeIds = new Set<Id>();
            for(PermissionSetAssignment per: pSets){
                assigneeIds.add(per.AssigneeId);
            }
            List<PermissionSetAssignment> listAssigmentInsert = new List<PermissionSetAssignment>();
            for (User u: Trigger.New) {
                if(!assigneeIds.contains(u.Id) && u.ProfileId == profileId){
                    listAssigmentInsert.add(new PermissionSetAssignment(
                            AssigneeId = u.Id,
                            PermissionSetId = permSet.Id
                    ));
                }
            }
            Database.Insert(listAssigmentInsert, false);
        }     
    }
}
