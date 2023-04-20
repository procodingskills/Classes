({
    invokeEventPublisherHelper : function(component,event,helper) {
        let sValue = event.getSource().get("v.value");
        // we need to publish an event
        let publishEvent = component.getEvent("cmpEvent");
        publishEvent.setParams({
            searchValue : sValue
        });
        publishEvent.fire();
    }
})
