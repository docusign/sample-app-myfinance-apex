@IsTest
private class HistoryCMPControllerTest {

	@TestSetup static void testSetup() {
		Session_Object__c session = new Session_Object__c();
		insert session;
		insert new Loan__c(Session_Object__c = session.Id);
		insert new Wire_Transfer__c(Session_Object__c = session.Id);
	}


	@IsTest
	public static void getHistoryRecords_ExecutesSuccessfully() {
		Session_Object__c session = [SELECT Id FROM Session_Object__c];
		String historyRecordsString = HistoryCMPController.getHistoryRecords(String.valueOf(session.Id));
		List<HistoryRecordWrapper> historyRecords = (List<HistoryRecordWrapper>) JSON.deserialize(historyRecordsString, List<HistoryRecordWrapper>.class);
		System.assertNotEquals(null, historyRecords);
		System.assertEquals(2, historyRecords.size());
		
		for (HistoryRecordWrapper wr: historyRecords) {
			System.assertNotEquals(null, wr.status);
			System.assertEquals(null, wr.applicant);
		}
	}
}
