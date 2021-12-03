import {LightningElement, api} from 'lwc';
import myFinanceIcons from '@salesforce/resourceUrl/MyFinanceIcons';
import createSessionObject from "@salesforce/apex/EmbeddedSigningController.createSession";

export default class ActionCmp extends LightningElement {
    @api mainIconName;
    @api mainText;
    @api backgroundColor;
    @api checkListItemsString;
    @api checkListHeader;
    @api buttonText;
    @api pageName;

    mainIconPath;
    backgroundCss;
    checkIcon = myFinanceIcons + '/check.png';
    checkList;
    pageUrl;

    connectedCallback() {
        if (this.mainIconName) {
            this.mainIconPath = myFinanceIcons + '/' + this.mainIconName + '.png';
        }

        if (this.backgroundColor) {
            this.backgroundCss = 'background:' + this.backgroundColor;
        }

        if (this.checkListItemsString) {
            this.checkList = this.checkListItemsString.split(';');
        }

        if (this.pageName){
            this.pageUrl='/myfinance/s/'+this.pageName;
        }

    }

    onClickCreateSessionObject(){
        const sessionId = localStorage.getItem('sessionId');
        if(sessionId == null){
            createSessionObject({})
            .then((recordId) => {
                localStorage.setItem('sessionId', recordId);
            })
            .catch((error) => {
              
            })
        }
    }
}