@IsTest
private class MyFinanceControllerTest {

	@IsTest static void saveWireTransferRecord_ExecutesSuccessfully() {
		Test.startTest();
		String wireTransferId = MyFinanceController.saveWireTransfer(new Wire_Transfer__c());
		Test.stopTest();
		System.assertNotEquals(null, wireTransferId);
		List<Wire_Transfer__c> wireTransferAssertList = [SELECT Id FROM Wire_Transfer__c];
		System.assertEquals(1, wireTransferAssertList.size());
	}

	@IsTest static void saveLoanRecord_ExecutesSuccessfully() {
		Test.startTest();
		String loanId = MyFinanceController.saveLoan(new Loan__c());
		Test.stopTest();
		List<Loan__c> loanListAssertList = [SELECT Id FROM Loan__c];
		System.assertNotEquals(null, loanId);
		System.assertEquals(1, loanListAssertList.size());
	}
}