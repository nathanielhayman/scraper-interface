window.onload=function(){
    var fStar = document.querySelector('#sd-i-starred')
    var eStar = document.querySelector('#sd-i-empty')
    eStar.addEventListener('click', (e) => {
        e.preventDefault();
        fStar.style.display = "block";
        eStar.style.display = "none";
    });
    fStar.addEventListener('click', (e) => {
        e.preventDefault();
        eStar.style.display = "block";
        fStar.style.display = "none";
    });
}