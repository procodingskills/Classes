({
    addNewConatct : function(component, event, helper) {
        debugger;
        let currentCount = component.get("v.noOfContacts");
        if(currentCount=== undefined || currentCount === null || currentCount.length === 0){
            currentCount.push(1);
        }
        else{
            currentCount.push(currentCount.length + 1);
        }
        component.set("v.noOfContacts",currentCount);
    },
    submitFormValidation : function(component , event , helper){
        debugger;
        let contactCmp = component.find("rec");
        let isValid = true;
        for(let i =0 ; i<contactCmp.length ; i++){
            let returnValu = contactCmp[i].childValidations();
            if(isValid){
                isValid = returnValu;
            }
        }
        if(isValid){
            alert("Form got valid data : do server actions");
        }
        else{
            alert("Form Validation Errors review them");
        }
    }
})