@IsTest
public with sharing class EmbeddedSigningControllerTest {

	@TestSetup
	public static void setupUser() {
		Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
		List<User> userList = new List<User>();
		User user = new User(
				Alias = 'John Doe',
				Email = 'test@doe.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Testing',
				LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US',
				ProfileId = profile.Id,
				TimeZoneSidKey = 'America/New_York',
				UserName = 'testing@myorg.com',
				Docu_Sing__c = true);
		userList.add(user);
		insert(userList);
	}

	@IsTest
	static void addDocuSignPermissionSetIfNotExists_WithValidUserId_ExecutesSuccessfully() {
		Test.startTest();
		User user = [SELECT Id, LastName FROM User WHERE LastName = 'Testing'LIMIT 1];
		Test.setMock(HttpCalloutMock.class, new EmbeddedSigningControllerMock());
		EmbeddedSigningController.addDocuSignPermissionSetIfNotExists(user.Id);
		List<PermissionSetAssignment> pSetAssert = [
					SELECT Id, PermissionSetId,
							PermissionSet.Name,
							PermissionSet.ProfileId,
							PermissionSet.Profile.Name,
							AssigneeId,
							Assignee.Name
					FROM PermissionSetAssignment
					WHERE
					PermissionSet.Name LIKE '%Sender%'
					AND AssigneeId = :user.Id];
		System.assertEquals(1, pSetAssert.size());
		Test.stopTest();
	}
}
