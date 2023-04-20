document.onkeydown = function(e) {
  if (e.key === 'Enter') {
    if (e.target.nodeName !== "TEXTAREA")
    return false;
  }
}
