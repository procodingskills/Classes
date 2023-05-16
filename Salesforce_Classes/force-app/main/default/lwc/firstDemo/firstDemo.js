import { LightningElement} from 'lwc';

export default class FirstDemo extends LightningElement {
   
    firstName;
    lastName;
    middleName;
    fullName;

    updateFirstName(event){
        this.firstName = event.target.value;
    }
    generateFullName(event){
        debugger;
       let fName =  this.template.querySelector("lightning-input[data-my-id=firstName]").value;
       let lName =  this.template.querySelector(".nameclass[data-my-id=lastName]").value;
       let mName = this.template.querySelector("lightning-input[data-my-id=middleName]").value;
       this.firstName = fName;
       this.lastName = lName;
       this.middleName = mName;
       const eSpace = " ";
       debugger;
       this.fullName = this.firstName + eSpace + this.middleName + eSpace + this.lastName;

    }

    generateFullNameBulk(event){
        let inputs = this.template.querySelectorAll("lightning-input");
        const eSpace = " ";
        this.fullName = inputs[0].value +eSpace+ inputs[1].value + eSpace + inputs[2].value;
    }
}