({
	echoEvent : function(component, event, helper) {
        let _input = component.find("dataInput").get("v.value");
        let data = {sample : _input};
        alert("DATA : "+JSON.stringify(data));
        let appEvent = $A.get("e.c:AppEventExample");  
        debugger;
        appEvent.setParams({
            sampleDataAttribute : data
        });
        appEvent.fire();
	}
})