
@RestResource(UrlMapping='/createAssigment/*')
global with sharing class CreateAssigmentRestClass {

	@HttpPost
	global static void createAssigments() {
		RestRequest request = RestContext.request;
		Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(request.requestBody.toString());
		PermissionSet permSet = [
				SELECT Id
				FROM PermissionSet
				WHERE Name = 'DocuSign_Sender'
		];
		PermissionSetAssignment psa = new PermissionSetAssignment();
		psa.AssigneeId = (Id)results.get('userId');
		psa.PermissionSetId = permSet.Id;
		insert psa;
	}
}
