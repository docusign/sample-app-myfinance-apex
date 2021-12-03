public with sharing class HistoryCMPControllerProvider {

	public List<HistoryRecordWrapper> getHistoryRecordsWrapperList(String sessionId) {
		List<SObject> sObjectList = new List<SObject>();
		sObjectList.addAll(HistoryCMPControllerRepository.getLoan(sessionId));
		sObjectList.addAll(HistoryCMPControllerRepository.getWire(sessionId));
		List<HistoryRecordWrapper> historyRecordWrappers = new List<HistoryRecordWrapper>();
		for (SObject record : sObjectList) {
			String typeOfRecord = String.valueOf(record.getSObjectType());
			HistoryRecordWrapper wrapper = new HistoryRecordWrapper();
			String userName = String.valueOf(record?.get('Full_Name__c'));
			wrapper.applicant = userName;
			wrapper.lastUpdated = Datetime.valueOf(record.get('CreatedDate')).format('MMMMM dd, yyyy hh:mm:ss a');
			final String statusValue = String.valueOf(record?.get('Status__c'));
			wrapper.status = String.isNotBlank(statusValue) ? statusValue : '-';

			if (typeOfRecord.equals('Loan__c')) {
				wrapper.subject = HistoryRecordWrapper.LOAN_APPLICATION;
			}

			if (typeOfRecord.equals('Wire_Transfer__c')) {
				wrapper.subject = HistoryRecordWrapper.TRANSFER_APPLICATION;
			}
			historyRecordWrappers.add(wrapper);
		}
		return historyRecordWrappers;
	}
}