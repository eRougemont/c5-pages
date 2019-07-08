var livres = document.getElementById("livres");
function sort(select) {
  if (!select) return select;
  var key = select.options[select.selectedIndex].value;
  if (key == "key1") Sortable.sort(livres, key);
  else Sortable.sort(livres, key);
}
function view(select) {
  if (!select) return select;
  var key = select.options[select.selectedIndex].value;
  if (key == 'thumbs') {
    livres.className = livres.className.replace(/ +thumbs */, "")+" thumbs";
  }
  else {
    livres.className = livres.className.replace(/ +thumbs */, "");
  }
}
