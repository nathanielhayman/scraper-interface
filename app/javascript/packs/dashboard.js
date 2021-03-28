window.onload=function(){

    var fStars = document.getElementsByClassName('sd-i-starred');
    var eStars = document.getElementsByClassName('sd-i-empty');
    Array.from(fStars).forEach(star => {
        star.addEventListener('click', () => {
            star.style.display = "none"
            document.getElementById(`${star.id.substring(0, star.id.length - 12)}-empty-star`)
            .style.display = "block";
        });
    });
    Array.from(eStars).forEach(star => {
        star.addEventListener('click', () => {
            console.log(star.id);
            star.style.display = "none"
            document.getElementById(`${star.id.substring(0, star.id.length - 11)}-filled-star`)
            .style.display = "block";
        });
    });
}

// fix turbolinks error
var fStars = document.getElementsByClassName('sd-i-starred');
var eStars = document.getElementsByClassName('sd-i-empty');
Array.from(fStars).forEach(star => {
    star.addEventListener('click', () => {
        star.style.display = "none"
        document.getElementById(`${star.id.substring(0, star.id.length - 12)}-empty-star`)
        .style.display = "block";
    });
});
Array.from(eStars).forEach(star => {
    star.addEventListener('click', () => {
        console.log(star.id);
        star.style.display = "none"
        document.getElementById(`${star.id.substring(0, star.id.length - 11)}-filled-star`)
        .style.display = "block";
    });
});