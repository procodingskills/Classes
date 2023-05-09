({
    validateInputs : function(component, event, helper) {
        let inputs = component.find("input");
        let allValidInput = inputs.reduce(function(validSoFar,inputCmp){
            if(inputCmp.get("v.label") === "email"){
                inputCmp.set("v.messageWhenTypeMismatch","Email is not correct");
            }
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        },true);

        // making server / return / another event opertyion only after this validation
        if(allValidInput){
           return true;
        }
        else{
            return false;
        }
    }
})