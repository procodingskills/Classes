({
    handleEventHelper : function(c, e , h) {
        let sValue = e.getParam("searchValue");
        c.find("outputv").set("v.value",sValue);
    }
})
