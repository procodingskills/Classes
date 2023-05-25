import { LightningElement } from 'lwc';

export default class ChildSearchType extends LightningElement {
    searchAction(event){
        // custom events
        const eventName = "inputupdated";
        let data = {searchKey : event.detail.value};
        let dispatchdetails = new CustomEvent(eventName, {detail : data});
        this.dispatchEvent(dispatchdetails);
    }
}