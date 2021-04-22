function cascadeChangeMethods(on) {
    var methods;
    if (on) { 
        var methods = document.getElementsByClassName('t-activity-bar-s');
    } else { 
        var methods = document.getElementsByClassName('t-activity-bar-r');
    }
    console.log(methods);
    Array.from(methods).forEach(method => {
        setTimeout(() => {
            if (on) {
                method.classList.add("t-activity-bar-r");
                method.classList.remove("t-activity-bar-s");
            } else {
                method.classList.add("t-activity-bar-s");
                method.classList.remove("t-activity-bar-r");
            }
        }, 100);
    });
}

function initializeComponents() {
    var element = document.getElementById("console-output");
    var short = $('.task-short-report').attr('id');
    element.scrollTop = element.scrollHeight ;
    var toggles = document.getElementsByClassName('toggle');
    var running = document.getElementsByClassName('running-confirm')[0];
    var stopped = document.getElementsByClassName('stopped-confirm')[0];
    Array.from(toggles).forEach(toggle => {
        toggle.addEventListener('click', () => {
            if (toggle.id.includes("toggled")) {
                running.style.display = "none";
                stopped.style.display = "block";
                toggle.id = `${toggle.id.replace("-toggled", "")}`;
                cascadeChangeMethods(false);
                $.ajax({
                    url: `/tasks/toggle/${short}`,
                    type: 'post',
                    data: {short: short, status: "Stopped"},
                    success: () => {
                        $('input').val("");
                    },
                    error: () => {
                        throw("Unable to contact server!");
                    }
                });
            } else {
                running.style.display = "block";
                stopped.style.display = "none";
                toggle.id = `${toggle.id}-toggled`;
                cascadeChangeMethods(true);
                $.ajax({
                    url: `/tasks/toggle/${short}`,
                    type: 'post',
                    data: {short: short, status: "Running"},
                    success: () => {
                        $('input').val("");
                    },
                    error: () => {
                        throw("Unable to contact server!");
                    }
                });
            }
        });
    });
    $('form').on("submit", () => {
        $.ajax({
            url: `/tasks/api/${short}`,
            type: 'get',
            success: (tsk) => {
                $('input').val("");
                location.reload();
                console.log(tsk);
            },
            error: () => {
                throw("Unable to contact server!");
            }
        });
    });
}

window.onload=function(){
    initializeComponents();
}

// fix turbolinks error
initializeComponents();