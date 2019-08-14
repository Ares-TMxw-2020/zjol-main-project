function imageBrowse(jsObject,index) {
    zjxw.imageBrowse(index);
}

function imageABrowse(jsObject,index) {
    zjxw.imageABrowse(index);
}

function applyNightTheme() {
    var ui_mode_link = document.getElementById("ui_mode_link");
    ui_mode_link.setAttribute("href", "file:///android_asset/css/night.css");
}

function applyDayTheme() {
    var ui_mode_link = document.getElementById("ui_mode_link");
    ui_mode_link.setAttribute("href", "file:///android_asset/css/day.css");
}
 function replaceImage(index,url){
       var imgs = document.getElementsByTagName("img"),arr=[];
       for(var i = 0; i < imgs.length; i++) {
         if (imgs[i].parentNode.tagName !== 'A') {
            arr.push(imgs[i]);
         }
        }
        if(arr.length > 0){
            var a = arr[index];
            a.setAttribute("src",url);
        }
  }

 function replaceAImage(index,url){
       var imgs = document.getElementsByTagName("img"),arr=[];
       for(var i = 0; i < imgs.length; i++) {
         if (imgs[i].parentNode.tagName === 'A') {
            arr.push(imgs[i]);
         }
        }
        if(arr.length > 0){
            var a = arr[index];
            a.setAttribute("src",url);
        }
  }

 function musicPause(){
     var audio = document.getElementsByTagName("audio");
     for(var i = 0; i < audio.length; i++) {
         var a = document.getElementsByTagName("audio")[i];
         a.pause();
     }
 }
