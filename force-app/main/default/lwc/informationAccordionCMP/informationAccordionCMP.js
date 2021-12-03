import {api, LightningElement} from 'lwc';

export default class InformationAccordionCmp extends LightningElement {
    @api
    sectionHeader;
    @api
    htmlText;
}