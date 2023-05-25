import { LightningElement } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import OBJECT_ACCOUNT from '@salesforce/schema/Account';
import ACCOUNT_NAME from '@salesforce/schema/Account.Name';
import ACCOUNT_TYPE from '@salesforce/schema/Account.Type';
import ACCOUNT_RATING from '@salesforce/schema/Account.Rating';
import ACCOUNT_PHONE from '@salesforce/schema/Account.Phone';

export default class NewRecordForm extends NavigationMixin(LightningElement) {
    objectAPIName = ACCOUNT_NAME;
    formFields = [ACCOUNT_NAME,ACCOUNT_TYPE,ACCOUNT_RATING,ACCOUNT_PHONE];
    recordPageUrl;
    navigateToRecord(event){N
        const data = event.detail;N
        this.showTitle("Congratulations","Account is Created" , "success","dismissable" );
        this[NavigationMixin.Navigate](
            {N
                type : 'standard__recordPage',
                attributes:{
                    "recordId" : data.id,
                    "objectApiName":"Account",
                    "actionName" : "view"
                }
                
            }
        );
    }
    showTitle(event){
        const evtMsg = new ShowToastEvent({
            title : ctitle,
            message : cmessage,
            variant : cvariant,
            mode : cmode
        });
        debugger;
        this.dispatchEvent(evtMsg);
    }
    generateURL(data){
        // Generate a URL to a User record page
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: data.id,
                actionName: 'view',
            },
        }).then((url) => {
            this.recordPageUrl = url;
        });
    }
}