/**
 * For dev only, so that no technologies assumptions are yet made
 */
function clientSideInclude(id, url, up) {
  var cont = document.getElementById(id);
  if (!cont) return; // bad id
  var xhr = new XMLHttpRequest();
  xhr.open("GET", url);
  xhr.send(null);
  xhr.responseType = 'text';
  xhr.onload = function() {
    let html = xhr.response;
    cont.innerHTML = html;
    var els = cont.querySelectorAll('a, img')
    for (var i = 0, len = els.length; i < len; i++) {
      let el = els[i];
      let url;
      let attName;
      if (el.href) attName = "href";
      else if (el.src) attName = "src";
      else continue;
      let link = el.getAttribute(attName);
      if (link.startsWith('/') || link.startsWith('http')) continue;
      el.setAttribute(attName, up+link);
    }
  };
}

var url = window.location;
var path = window.location.pathname;
const ancestors = 1;
let depth = path.split("/").length - 2 - ancestors;
let up = "../".repeat(depth);
console.log(up);

clientSideInclude("top", up+"inc/tete.html", up);
clientSideInclude("bottom", up+"inc/pied.html", up);
