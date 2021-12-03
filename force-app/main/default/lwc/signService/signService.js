import sendEnvelope from "@salesforce/apex/EmbeddedSigningController.sendEnvelope";
import getEmbeddedSigningUrl from "@salesforce/apex/EmbeddedSigningController.getEmbedSigningUrl";
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export const signingIt = (templateId, description, recordId) => {
    sendEnvelope({'template': templateId, 'description': description, 'recordId': recordId})
        .then((envelopeId) => {
            getEmbeddedSigningUrl({
                envId: envelopeId,
                url: "https://docusignsamplefinance-developer-edition.na156.force.com/myfinance/s/"
            }).then((signingUrl) => {
                window.location.href = signingUrl;
            })
        })
        .catch((error) => {
            console.log(error);
            dispatchEvent(
                new ShowToastEvent({
                    title: error.title,
                    message: error.message,
                    variant: 'error',
                    mode: 'sticky',
                })
            );
        })
};