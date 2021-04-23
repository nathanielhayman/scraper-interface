function initializeComponents() {
    var fStars = document.getElementsByClassName('sd-i-starred');
    var eStars = document.getElementsByClassName('sd-i-empty');
    Array.from(fStars).forEach(star => {
        var short = star.id.substring(0, star.id.length - 12);
        star.addEventListener('click', () => {
            star.style.display = "none"
            document.getElementById(`${short}-empty-star`)
            .style.display = "block";
            $.ajax({
                url: `/tasks/star/${short}`,
                type: 'post',
                data: {starred: false},
                success: () => {
                    
                },
                error: () => {
                    throw("Unable to contact server!");
                }
            });
        });
    });
    Array.from(eStars).forEach(star => {
        var short = star.id.substring(0, star.id.length - 11);
        star.addEventListener('click', () => {
            star.style.display = "none"
            document.getElementById(`${short}-filled-star`)
            .style.display = "block";
            $.ajax({
                url: `/tasks/star/${short}`,
                type: 'post',
                data: {starred: true},
                success: () => {
                    
                },
                error: () => {
                    throw("Unable to contact server!");
                }
            });
        });
    });
    var containers = document.getElementsByClassName("sd-card-container");
    Array.from(containers).forEach(container => {
        var clock = container.getElementsByClassName("task-clock")[0];
        var short = container.getElementsByClassName("task-short-report")[0].id;
        $.ajax({
            url: `/tasks/api/${short}`,
            type: 'get',
            success: (tsk) => {
                updateClock(tsk, clock);
                console.log(tsk);
            },
            error: () => {
                throw("Unable to contact server!");
            }
        });
    });
}

function updateClock(tsk, clock) {
    var txt = clock.getElementsByTagName('b')[0];
    var nextExec = new Date(tsk.time);
    setInterval(() => { 
        var now = new Date();
        if (now.getHours() > nextExec.getHours())  {
            nextExec.setDate(now.getDate()+1);
        }
        if(now.getDate() > nextExec.getDate()) {
            nextExec.setDate(now.getDate());
        }
        var diff = nextExec - now;
        var seconds = diff / 1000;
        var hours = parseInt( seconds / 3600 );
        var minutes = parseInt( seconds / 60 );
        minutes = parseInt(minutes % 60);
        seconds = parseInt(seconds % 60);
        txt.innerHTML = `${hours ? hours + ":" : ""}${minutes < 10 ? "0" + minutes + ":" : minutes + ":"}${seconds < 10 ? "0" + seconds : seconds}`; 
    }, 1000);
    //setInterval(() => {
    //    
    //});
}

window.onload=function() {
    initializeComponents();
}

// fix turbolinks error
initializeComponents();