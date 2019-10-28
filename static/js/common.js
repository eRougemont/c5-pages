/**
 * For dev only, so that no technologies assumptions are yet made
 */
function clientSideInclude(id, url) {
  var req = false;
  // W3C browsers
  if (window.XMLHttpRequest) {
    try {
      req = new XMLHttpRequest();
    } catch (e) {
      req = false;
    }
  } // still old IE around ?
  else if (window.ActiveXObject) {
    try {
      req = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
      try {
        req = new ActiveXObject("Microsoft.XMLHTTP");
      } catch (e) {
        req = false;
      }
    }
  }
  var element = document.getElementById(id);
  if (!element) return; // bad id
  if (!req) return; // old browser
  // Synchronous request, wait till we have it all
  req.open('GET', url, false);
  req.send(null);
  element.innerHTML = req.responseText;
}
clientSideInclude("top", "inc/tete.html");
clientSideInclude("bottom", "inc/pied.html");
