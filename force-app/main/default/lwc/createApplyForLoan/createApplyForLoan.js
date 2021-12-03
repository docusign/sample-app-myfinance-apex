import {api, LightningElement, track} from 'lwc';

import LOAN from '@salesforce/schema/Loan__c';
import saveLoan from '@salesforce/apex/MyFinanceController.saveLoan';
import {signingIt} from 'c/signService';

export default class CreateApplyForLoan extends LightningElement {
    @track spinner = false;
    @track loanRecord = LOAN;

    @api buttonLabel;
    @api templateId;
    @api description;
    @api sessionId;

    connectedCallback() {
        this.sessionId = localStorage.getItem('sessionId');
    }

    firstNameChange(event) {
        this.loanRecord.FirstName__c = event.target.value;
    }

    lastNameChange(event) {
        this.loanRecord.LastName__c = event.target.value;
    }

    emailChange(event) {
        this.loanRecord.Email__c = event.target.value;
    }

    phoneChange(event) {
        this.loanRecord.Phone_Number__c = event.target.value;
    }

    amountChange(event) {
        this.loanRecord.Desire_Loan_Amount__c = event.target.value;
    }

    termsChange(event) {
        this.loanRecord.Payment_Terms__c = event.target.value;
    }

    get currencyOptions() {
        return [
            {label: 'USD', value: 'USD'},
            {label: 'EUR', value: 'EUR'}
        ];
    }

    saveRecord() {
        this.spinner = true;
        this.loanRecord.Session_Object__c = this.sessionId;
        saveLoan({'recordToInsert': this.loanRecord}).then((res) => {
            if (res) {
                signingIt(this.templateId, this.description, res);
            }
        })
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
}
