public without sharing class EmbeddedSigningController {
	@AuraEnabled
	public static String sendEnvelope(String template, String description, Id recordId) {
		String sObjectName = recordId.getSObjectType().getDescribe().getName();
		if(sObjectName == 'Loan__c'){
			return getloanEnvelope(template,description,recordId);
		}else if(sObjectName == 'Wire_Transfer__c'){
			return getwireTransferEnvelope(template,description,recordId);
		}
		return '';
	}

	private static String getloanEnvelope(String template, String description, Id recordId){
		Loan__c l = [SELECT 
						FirstName__c,
						LastName__c,
						Email__c,
						Phone_Number__c,
						Desire_Loan_Amount__c,
						Currency__c,
						Payment_Terms__c 
						FROM Loan__c 
						WHERE Id =: recordId];
		dfsle.Envelope dsEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
			new dfsle.Entity(recordId))
			.withDocuments(new List<dfsle.Document>{
					dfsle.Document.fromTemplate(dfsle.UUID.parse(template), description)
			})
			.withRecipients(new List<dfsle.Recipient>{
				dfsle.Recipient.newEmbeddedSigner().withTabs(new List<dfsle.Tab>{
					generateTab(l.FirstName__c, 200,210),
					generateTab(l.LastName__c, 200 ,235),
					generateTab(l.Email__c, 200,265),
					generateTab(l.Phone_Number__c, 200,295),
					generateTab(String.Valueof(l.Desire_Loan_Amount__c), 200,380),
					generateTab(String.ValueOf(l.Payment_Terms__c.format()), 200,405),
					createSignTab(200,430)
				})
			});
		dsEnvelope = dfsle.EnvelopeService.sendEnvelope(
				dsEnvelope,
				true
		);
		return String.valueOf(dsEnvelope.docuSignId);
	}

	private static String getWireTransferEnvelope(String template, String description, Id recordId){
		Wire_Transfer__c w = [SELECT 
								FirstName__c,
								LastName__c,
								Account_Number__c,
								Amount_of_Transfer__c,
								Date__c,
								Reciever_FirstName__c,
								Receiver_LastName__c,
								Bank_Name__c,
								Reciever_Account_Number__c,
								Routing_Number__c 
								FROM Wire_Transfer__c 
								WHERE Id =: recordId];
		dfsle.Envelope dsEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
			new dfsle.Entity(recordId))
			.withDocuments(new List<dfsle.Document>{
					dfsle.Document.fromTemplate(dfsle.UUID.parse(template), description)
			})
			.withRecipients(new List<dfsle.Recipient>{
				dfsle.Recipient.newEmbeddedSigner().withTabs(new List<dfsle.Tab>{
					generateTab(w.FirstName__c, 200,230),
					generateTab(w.LastName__c, 200 ,255),
					generateTab(w.Account_Number__c, 200,280),
					generateTab(String.Valueof(w.Amount_of_Transfer__c), 200,310),
					generateTab(String.ValueOf(w.Date__c.format()), 200,345),
					generateTab(w.Reciever_FirstName__c, 200 ,445),
					generateTab(w.Receiver_LastName__c, 200 ,475),
					generateTab(w.Bank_Name__c, 200 ,505),
					generateTab(String.ValueOf(w.Reciever_Account_Number__c), 200 ,530),
					generateTab(String.ValueOf(w.Routing_Number__c), 200 ,555),
					createSignTab(200, 550)
				})
			});
		dsEnvelope = dfsle.EnvelopeService.sendEnvelope(
				dsEnvelope,
				true
		);
		return String.valueOf(dsEnvelope.docuSignId);
	}

	private static dfsle.Tab generateTab(final String value, final Integer X_position, final Integer Y_position) {
		dfsle.Tab myTextTab = new dfsle.TextTab()
				.withValue(value)
				.withPosition(new dfsle.Tab.Position(
						1,
						1,
						X_position,
						Y_position,
						100,
						null));
		return myTextTab;
	}

	private static dfsle.Tab createSignTab(final Integer X_position, final Integer Y_position){
		dfsle.Tab mySignHereTab = new dfsle.SignHereTab()
			.withScale(0.5) 
			.withRequired(true) 
			.withAnchor(new dfsle.Tab.Anchor(
			'signature', 
			false, 
			false, 
			'right', 
			true, 
			true, 
			'pixels', 
			X_position, 
			Y_position));
			return mySignHereTab;
	}

	@AuraEnabled
	public static String getEmbedSigningUrl(String envId, String url) {
		Url embeddedSigningUrl = dfsle.SigningService.getEmbeddedSigningUrl(
			dfsle.UUID.parse(envId), new URL(url)
		);
		return String.valueOf(embeddedSigningUrl.toExternalForm());
	}

	@AuraEnabled
	public static Id createSession() {
		addDocuSignPermissionSetIfNotExists(UserInfo.getUserId());
		Session_Object__c sess = new Session_Object__c();
		insert sess;
		return sess.Id;
	}

	public static void addDocuSignPermissionSetIfNotExists(Id userId) {
		if (userId != null) {
			List<PermissionSetAssignment> pSets = [
					SELECT 
						Id, 
						PermissionSetId,
						PermissionSet.Name,
						PermissionSet.ProfileId,
						PermissionSet.Profile.Name,
						AssigneeId,
						Assignee.Name
					FROM PermissionSetAssignment
					WHERE
					PermissionSet.Name LIKE '%Sender%'
					AND AssigneeId = :userId
			];
			if (pSets.isEmpty()) {
				HttpResponse authorizationResponse = authorize();
				if (authorizationResponse.getStatusCode() == 200) {
					createAssigmentRestCallout(authorizationResponse.getBody(),userId);
				}
			}
		}
	}

	public static HttpResponse authorize() {
		RESTSetting__mdt authorizationEndpointSettings = [
				SELECT 
						DeveloperName,
						setEndpoint__c,
						setMethod__c,
						setHeaderType__c,
						setHeaderApp__c,
						grant_type__c,
						client_id__c,
						client_secret__c,
						username__c,
						password__c
				FROM RESTSetting__mdt
				WHERE DeveloperName = 'DocuSignAuthorizationEndpointSettings'
				LIMIT 1
		];
	
		HttpResponse authorizationResponse = sendAuthorizationRequest(authorizationEndpointSettings);
		return authorizationResponse;
	}

	public static HttpResponse sendAuthorizationRequest(RESTSetting__mdt authorizationEndpointSettings) {
		HttpRequest request = new HttpRequest();
		request.setEndpoint(authorizationEndpointSettings.setEndpoint__c);
		request.setMethod(authorizationEndpointSettings.setMethod__c);
		request.setHeader(authorizationEndpointSettings.setHeaderType__c, authorizationEndpointSettings.setHeaderApp__c);
		request.setBody(getBodyForAuthorizationRequest(authorizationEndpointSettings));
		HttpResponse authorizationResponse = new Http().send(request);
		return authorizationResponse;
	}
	
	private static String getBodyForAuthorizationRequest(RESTSetting__mdt authorizationEndpointSettings) {
		return 'grant_type=' + authorizationEndpointSettings.grant_type__c +
				+'&client_id=' + authorizationEndpointSettings.client_id__c +
				+'&client_secret=' + authorizationEndpointSettings.client_secret__c +
				+'&username=' + authorizationEndpointSettings.username__c +
				+'&password=' + authorizationEndpointSettings.password__c;
	}
	
	public static void createAssigmentRestCallout(String body, String userId) {
		Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(body);
		String token = (String) results.get('access_token');
		String instanceURL = (String) results.get('instance_url');
		HttpRequest request = new HttpRequest();
		String bodyRequest = '{"userId":"' + userId + '"}';
		request.setEndpoint(instanceURL + '/services/apexrest/createAssigment');
		request.setMethod('POST');
		request.setBody(bodyRequest);
		request.setHeader('Authorization', 'Bearer ' + token);
		request.setHeader('Content-Type', 'application/json');
		new Http().send(request);
	}
}
