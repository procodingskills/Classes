({
	HandleAppEvent : function(component, event, helper) {
        alert("I am good");
        debugger;
			let eventData = event.getParam("sampleDataAttribute");
        component.find("dataId").set("v.value",eventData.sample);
        
	}
})