function initializeComponents() {
    console.log("a");
    $("#task_method_action_type").on("change", function(){
        var val = $(this).find("option:selected").attr("value");
        
        switch (val){
            case "save as":
                $("#case-btn").css("display", "none");
                $("#var-title").css("display", "block");
                $("#web-title").css("display", "none");
                $("#path-title").css("display", "none");
                $("#var-container").css("display", "block");
                $("#case-loading").css("display", "none");
                break;
            case "GET":
                $("#case-btn").css("display", "none");
                $("#var-title").css("display", "none");
                $("#web-title").css("display", "block");
                $("#path-title").css("display", "none");
                $("#var-container").css("display", "none");
                $("#case-loading").css("display", "none");
                break;
            default:
                $("#case-loading").css("display", "none");
                $("#case-btn").css("display", "block");
                $("#var-title").css("display", "none");
                $("#web-title").css("display", "none");
                $("#path-title").css("display", "block");
                $("#var-container").css("display", "none");
        }
    });

    $("#case-btn").on("click", () => {
        $("#case-btn").css("display", "none");
        $("#case-loading").css("display", "block");
    })
}

window.onload=function(){
    initializeComponents();
}

// fix turbolinks error
initializeComponents();