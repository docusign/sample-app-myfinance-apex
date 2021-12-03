import {LightningElement} from 'lwc';
import getHistoryRecords from '@salesforce/apex/HistoryCMPController.getHistoryRecords';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

const columns = [
    {label: 'Subject', fieldName: 'subject'},
    {label: 'Applicant', fieldName: 'applicant'},
    {label: 'Last Updated', fieldName: 'lastUpdated'},
    {label: 'Status', fieldName: 'status'}
];

export default class HistoryCmp extends LightningElement {
    data;
    columns = columns;

    async connectedCallback() {
        const sessionId = localStorage.getItem('sessionId');
        if (sessionId != null) {
            getHistoryRecords({sessionId: sessionId})
                .then(records => {
                    this.data = JSON.parse(records).sort((a, b) => (a.lastUpdated > b.lastUpdated) ? 1 : -1);
                })
                .catch(error => {
                    console.log(error)
                    this.showToast('Error', error.message, 'error', 'sticky');
                });
        }
    }

    showToast(title, message, variant, mode) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode,
        });
        this.dispatchEvent(event);
    }

    restartSession() {
        localStorage.clear();
    }
}