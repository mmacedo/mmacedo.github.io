function switchLang(e,me,id) {
  if (me.className.match(/selected/)) {
    return;
  }
  if (!e) e = window.event;
  if (e.preventDefault) {
    e.preventDefault();
  }
  if (!me.onmouseup) {
    me.onmouseup = function(e) {
      if (e && e.preventDefault) {
        e.preventDefault();
      }
    }
  }
  var el1 = document.getElementById(id);
  var el2 = document.getElementById(id+"_alt");
  if (!el1 || !el2) {
    return;
  }
  if (el1.style.display == 'none') {
    el2.style.display = 'none';
    el1.style.display = 'block';
    me.parentNode.childNodes[0].className = "switchLang selected";
    me.parentNode.childNodes[1].className = "switchLang";
  } else {
    el1.style.display = 'none';
    el2.style.display = 'block';
    me.parentNode.childNodes[0].className = "switchLang";
    me.parentNode.childNodes[1].className = "switchLang selected";
  }
}
