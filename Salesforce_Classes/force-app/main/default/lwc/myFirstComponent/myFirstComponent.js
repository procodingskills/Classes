import { LightningElement,api ,wire } from 'lwc';
import userDetails from '@salesforce/apex/LWCComponentController.userNames'
export default class MyFirstComponent extends LightningElement {
    firstNameValue = "My First Name Default";
    @api
    title;
    userEmail;
    // Imperative calling apex
    retriveUserDetails(event){
        let _params = {
            email : this.template.querySelector("lightning-input[data-my-id=email]").value
        }
        // invoke server action
        userDetails(_params)
        .then(result => {
            let dataResult = result.length;
            alert("Total records found : "+dataResult);
        })
        .catch(error => {
            alert("Some Error Occured :"+error);
        })
    }
  
    @wire(userDetails,{email : '$userEmail'})
    wireUserDetails({error,data}){
        if(error){
            alert("In error Lock : "+JSON.stringify(error));
        }
        else if(data){
            alert("Records found : "+data.length);
        }
    }
    generateFullName() {
        if (this.inputValidations()) {
            let firstName = this.template.querySelector("lightning-input[data-my-id=firstName]").value;
            let lastName = this.template.querySelector("lightning-input[data-my-id=lastName]").value;
           this.userEmail = this.template.querySelector("lightning-input[data-my-id=email]").value;
            let fullName = this.firstNameValue + " " + lastName;
            let templateInputs = this.template.querySelectorAll("lightning-input");
            templateInputs.forEach(function (item, index) {
                if (item.label === "Full Name") {
                    item.value = fullName;
                }
            });
        }
    }

    inputValidations() {
        const isInputs = [...this.template.querySelectorAll("lightning-input")]
            .reduce((ValidSoFar, inputField) => {
                inputField.reportValidity();
                return ValidSoFar && inputField.checkValidity();
            }, true);
            return isInputs;
           
    }
    handleFirstName(event){
        //this.firstNameValue = event.detail.value;
    }
}