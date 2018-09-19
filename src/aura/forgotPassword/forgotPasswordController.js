({
    handleForgotPassword: function (component, event, helper) {
    	console.log('Hello from controller');
        helper.handleForgotPassword(component, event, helper);
    },
    onKeyUp: function(component, event, hyelper){
    //checks for "enter" key
        if (event.getParam('keyCode')===13) {
            helper.handleForgotPassword(component, event, hyelper);
        }
    },
    
    setExpId: function (component, event, helper) {
        var expId = event.getParam('expid');
        if (expId) {
            component.set("v.expid", expId);
        }
        helper.setBrandingCookie(component, event, helper);
    },

    initialize: function(component, event, helper) {
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap}).fire();        
    }
})