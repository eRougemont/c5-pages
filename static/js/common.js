/**
 * For dev only, so that no technologies assumptions are yet made
 */
function clientSideInclude(id, url) {
  var element = document.getElementById(id);
  if (!element) return; // bad id
  var xhr = new XMLHttpRequest();
  xhr.open("GET", url);
  xhr.send(null);
  xhr.responseType = 'text';
  xhr.onload = function() {
    let html = xhr.response;
    element.innerHTML = html;
    if (!relup) return;
    const links = element.getElementsByTagName('a');
    for (var i = 0, len = links.length; i < len; i++) {
      let a = links[i];
      let href = a.getAttribute("href");
      if (!href) continue;
      if (href.startsWith('/') || href.startsWith('http')) continue;
      a.setAttribute("href", relup+href);
    }
  };
}

var url = window.location;
var path = window.location.pathname;
const ancestors = 1;
let depth = path.split("/").length - 2 - ancestors;
let up = "../".repeat(depth);

clientSideInclude("top", up+"inc/tete.html");
clientSideInclude("bottom", up+"inc/pied.html");
