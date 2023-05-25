import { LightningElement , wire } from 'lwc';
import wireApexMethod from '@salesforce/apex/SearchControll.wireMethod';
import explicitApexMethod from '@salesforce/apex/SearchControll.searchRecords';
export default class LwcSearchRecords extends LightningElement {
    searchKeyword; // searchKeyword to handle the searchvalue
    results;
    totalMatchs;
    totalApexMatchs;
    // handle the value change for search
    searchAction(event){
        this.searchKeyword = event.detail.value;
    }

    handleChildEvent(event){
        const eventData = event.detail;
        this.searchKeyword = eventData.searchKey;
    }

    // Wire aruguments should reactive 
    @wire(wireApexMethod , {accountName : '$searchKeyword'} )
    wireResultHandler({error,data}){
       if(data){
            this.results = data;
            this.totalMatchs = data.length;
       } 
       else if(error){
            let errorMessage = JSON.stringify(error);
            alert("ERROR : "+errorMessage);
       }
    }

    apexImperativeCall(){
        const params = {accountName : this.searchKeyword};
        explicitApexMethod(params)
        .then( result => {
            this.results = result;
            this.totalApexMatchs = result.length;
        })
        .catch( error => {
            alert("APEX ERROR : "+JSON.stringify(error));
        });
    }

    /*
        jsMethodName(){
            let params = {};
            apexImportMethodName(params).then(result => {}).catch(error => {});
        }
    */
}