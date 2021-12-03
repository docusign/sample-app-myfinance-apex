@IsTest
global class EmbeddedSigningControllerMock implements HttpCalloutMock {

	global HttpResponse respond(HttpRequest request) {
		HttpResponse response = new HttpResponse();
		response.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		response.setBody('{"access_token":"SESSION_ID_REMOVED",' +
						 '"instance_url":"https://docusignsamplefinance-dev-ed.my.salesforce.com",' +
						 '"id":"https://login.salesforce.com/id/00D5Y0000024lzXUAQ/0055Y00000G6CrFQAV",' +
						 '"token_type":"Bearer",' +
						 '"issued_at":"1629205891129",' +
						 '"signature":"zKNO+cVEvAgiQoDhwLsDeVjtfyQFfBTTkILucdpz00c="}');
		response.setStatusCode(200);
		return response;
	}
}