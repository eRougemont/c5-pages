// to read texts

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
