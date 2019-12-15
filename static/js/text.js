// to read texts

var lastScrollY = 0;
var noterefs = document.querySelectorAll('a.noteref');
var cont = document.querySelector('div.cont');
var noteBot = document.createElement("div");
noteBot.id = "notebot";
noteBot.style.display = "none";
cont.appendChild(noteBot);

function scrollPage()
{
  var up = false;
  var scrollY = window.pageYOffset || document.documentElement.scrollTop;
  if (scrollY < lastScrollY) up = true;
  lastScrollY = (scrollY <= 0) ? 0 : scrollY; // phone scroll coul be negative
  var count = 0;
  for (var i = 0, len = noterefs.length; i < len; i++) {
    var ref = noterefs[i];
    var id = ref.hash;
    if (id[0] = '#') id = id.substring(1);
    idCopy = id+"Copy";
    var noteCopy = document.getElementById(idCopy);
    if (isVisible(ref)) {
      count++;
      if (noteCopy) continue;
      var note = document.getElementById(id);
      if (!note) continue; // no note ? bad
      noteCopy = note.cloneNode(true);
      noteCopy.id = idCopy;
      if (up) noteBot.insertBefore(noteCopy, noteBot.firstChild); // prepend not for MS
      else noteBot.appendChild(noteCopy);
    }
    else {
      if (!noteCopy) continue;
      noteCopy.parentNode.removeChild(noteCopy);
    }
  }
  if(!count) noteBot.style.display = "none";
  else noteBot.style.display = "";
}

function isVisible(elem)
{
  var bounding = elem.getBoundingClientRect();
  return (
    bounding.top >= 0 &&
    bounding.left >= 0 &&
    bounding.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
    bounding.right <= (window.innerWidth || document.documentElement.clientWidth)
  );
};

// scrol after anchor clicked
function scrollAnchor()
{
  let id = location.hash;
  if (!id) return;
  if (id[0] == "#") id = id.substring(1);
  if (!document.getElementById(id)) return;
  // Quand l'interface sera stabilisée,
  // on saura quoi et de combien dérouler
  // (table des matières longues)
  // window.scrollBy(0, -100);
}

window.addEventListener('load', scrollAnchor);
window.addEventListener('hashchange', scrollAnchor);
window.addEventListener('scroll', scrollPage);
