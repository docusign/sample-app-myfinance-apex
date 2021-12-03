public with sharing class MyFinanceController {

	@AuraEnabled
	public static String saveLoan(final Loan__c recordToInsert) {
		insert recordToInsert;
		return recordToInsert.Id;
	}

	@AuraEnabled
	public static String saveWireTransfer(final Wire_Transfer__c recordToInsert) {
		insert recordToInsert;
		return recordToInsert.Id;
	}
}