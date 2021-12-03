import {api, LightningElement, track} from 'lwc';
import saveWireTransfer from '@salesforce/apex/MyFinanceController.saveWireTransfer';

import WIRE_TRANSFER from '@salesforce/schema/Wire_Transfer__c';
import {signingIt} from 'c/signService';

export default class CreateWireTransfer extends LightningElement {
    @track spinner = false;
    @track wireTransferRecord = WIRE_TRANSFER;

    @api buttonLabel;
    @api templateId;
    @api description;
    @api sessionId;

    connectedCallback() {
        this.sessionId = localStorage.getItem('sessionId');
    }

    senderFirstNameChange(event) {
        this.wireTransferRecord.FirstName__c = event.target.value;
    }

    senderLastNameChange(event) {
        this.wireTransferRecord.LastName__c = event.target.value;
    }

    senderAccountNumberChange(event) {
        this.wireTransferRecord.Account_Number__c = event.target.value;
    }

    amountOfTransferChange(event) {
        this.wireTransferRecord.Amount_of_Transfer__c = event.target.value;
    }

    dateChange(event) {
        this.wireTransferRecord.Date__c = event.target.value;
    }

    recieverFirstNameChange(event) {
        this.wireTransferRecord.Reciever_FirstName__c = event.target.value;
    }

    recieverLastNameChange(event) {
        this.wireTransferRecord.Receiver_LastName__c = event.target.value;
    }

    bankNameChange(event) {
        this.wireTransferRecord.Bank_Name__c = event.target.value;
    }

    recieverAccountNumberChange(event) {
        this.wireTransferRecord.Reciever_Account_Number__c = event.target.value;
    }

    routingNumberChange(event) {
        this.wireTransferRecord.Routing_Number__c = event.target.value;
    }

    get currencyOptions() {
        return [
            {label: 'USD', value: 'USD'},
            {label: 'EUR', value: 'EUR'}
        ];
    }

    handleSaveClick() {
        let allValid = [
            ...this.template.querySelectorAll('lightning-input'),
            ...this.template.querySelectorAll('lightning-combobox')
        ]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        if (allValid) {
            this.saveRecord();
        }
    }

    saveRecord() {
        this.spinner = true;
        this.wireTransferRecord.Session_Object__c = this.sessionId;
        saveWireTransfer({'recordToInsert': this.wireTransferRecord}).then((res) => {
            if (res) {
                signingIt(this.templateId, this.description, res);
            }
        })
    }
}