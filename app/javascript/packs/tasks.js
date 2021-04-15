function initializeComponents() {
    var toggles = document.getElementsByClassName('toggle');
    console.log(toggles);
    console.log("a");
    Array.from(toggles).forEach(toggle => {
        toggle.addEventListener('click', () => {
            if (toggle.id.includes("toggled")) {
                toggle.childNodes[1].style.right = "";
                toggle.id = `${toggle.id.replace("-toggled", "")}`;
            } else {
                toggle.childNodes[1].style.right = 0;
                toggle.id = `${toggle.id}-toggled`;
            }
        })
    })
    var clocks = document.getElementsByClassName('t-clock');
    Array.from(clocks).forEach(clock => {
        var txt = clock.getElementsByTagName('b')[0];
        var input_str = clock.innerText.slice(clock.innerText.indexOf("—")+1, -1);
        var mod = input_str.slice(0, input_str.lastIndexOf(":")+3);
        var hms = mod.split(":").map(x => +x);
        var p = input_str.slice(input_str.lastIndexOf(":")+4, input_str.indexOf("M")+1);
        console.log(p, hms);
        if (p == "PM") hms[0] += 12;
        var today = new Date();
        var nextExec = new Date(today.getFullYear(), today.getMonth(), today.getDate(), hms[0], hms[1], hms[2]);
        setInterval(() => { 
            var now = new Date();
            var diff = nextExec - now;
            //console.log(`${nextExec} - ${now} = ${diff}`);
            var seconds = diff / 1000;
            var hours = parseInt( seconds / 3600 );
            var minutes = parseInt( seconds / 60 );
            minutes = parseInt(minutes % 60);
            seconds = parseInt(seconds % 60);
            txt.innerHTML = `${hours ? hours + ":" : ""}${minutes < 10 ? "0" + minutes + ":" : minutes + ":"}${seconds < 10 ? "0" + seconds : seconds}`; 
        }, 1000);
    });
}

window.onload=function(){
    initializeComponents();
}

// fix turbolinks error
initializeComponents();