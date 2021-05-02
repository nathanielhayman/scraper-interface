function initializeComponents() {

    $("#case-btn").on("click", () => {
        $("#case-btn").css("display", "none");
        $("#case-loading").css("display", "block");
        var short = $(".task-short-report").attr('id');
        var path = $("#task_method_action").val();
        var pk = Math.floor(Math.random() * 10000);
        console.log(path);
        $.ajax({
            url: `/tasks/test/${short}`,
            type: 'post',
            data: { pk: pk, path: path },
            success: () => {
                var count = 0;
                var pingServer = setInterval(() => {
                    count ++;
                    $.ajax({
                        url: `/tasks/api/${short}`,
                        type: 'get',
                        success: (tsk) => {
                            console.log(tsk);
                            clearInterval(pingServer);
                        },
                        error: () => {
                            throw("Unable to contact server!");
                        }
                    });
                    if (count > 10) {
                        clearInterval(pingServer);
                    }
                }, 1000);
            },
            error: () => {
                throw("Unable to contact server!");
            }
        });
    })
}

window.onload=function(){
    initializeComponents();
}

// fix turbolinks error
initializeComponents();