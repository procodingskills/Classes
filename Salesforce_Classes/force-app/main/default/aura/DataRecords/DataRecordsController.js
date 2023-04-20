({
    dataBind : function(component, event, helper) {
        let firstName = component.getReference("v.firstName");
        component.set("v.lastName",firstName);

    },
    valueAssign : function(component, event, helper) {
        let firstName = component.get("v.firstName");
        //component.set("v.lastName",firstName);
        component.find("firstName").set("v.value",firstName);
        component.find("firstName").set("v.label","Value Assigned");
    },
    validateMe : function(component, event, helper){
        let selectedItem = event.currentTarget;
        let valueOfSelected = selectedItem.dataset.value;
        alert("Selected Value :"+valueOfSelected);
    },
    dataHandling : function(component, event, helper){
      let details = event.detail;
      console.log("Details : "+JSON.stringify(details));  
      console.log("Value : "+JSON.stringify(details.value));  
    }
})
