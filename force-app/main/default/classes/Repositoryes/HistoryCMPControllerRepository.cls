public with sharing class HistoryCMPControllerRepository {

	public static List<Loan__c> getLoan(String sessionId) {
		if (sessionId == null) {
			return new List<Loan__c>();
		} else {
			return [
					SELECT	
							CreatedDate,
							FirstName__c,
							Full_Name__c,
							Id,
							LastName__c,
							Name,
							Payment_Terms__c,
							Phone_Number__c,
							Status__c
					FROM Loan__c
					WHERE Session_Object__c = :sessionId
					];
		}
	}

	public static List<Wire_Transfer__c> getWire(String sessionId) {
		if (sessionId == null) {
			return new List<Wire_Transfer__c>();
		} else {
			return [
					SELECT  
							Account_Number__c,
							Amount_of_Transfer__c,
							Bank_Name__c,
							CreatedDate,
							Date__c,
							FirstName__c,
							Full_Name__c,
							Id,
							LastName__c,
							Name,
							Receiver_LastName__c,
							Reciever_Account_Number__c,
							Reciever_FirstName__c,
							Routing_Number__c,
							Status__c
					FROM Wire_Transfer__c
					WHERE Session_Object__c = :sessionId
					];
		}
	}
}