public with sharing class HistoryCMPController {

	@AuraEnabled(Cacheable=true)
	public static String getHistoryRecords(String sessionId) {
		List<HistoryRecordWrapper> historyRecordWrappers = new List<HistoryRecordWrapper>();
		HistoryCMPControllerProvider provider = new HistoryCMPControllerProvider();
		historyRecordWrappers.addAll(provider.getHistoryRecordsWrapperList(sessionId));
		return JSON.serialize(historyRecordWrappers);
	}
}