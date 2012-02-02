$('window').resize(function(){
  // resize_elements()
})
    
$('a#save').live('click', function(){
  var tex = get_tex();
  $('input[name="tex"]').val(tex)
  $('form').submit();
})

$('#embed').live('click', function(){
  $('#embed-popup').toggle();
})

$(document).live('keyup', function(){
  render_tex();
})

function get_tex(){
  return window.editor.getSession().getValue()
}

function set_tex(tex) {
  window.ace_session.setValue(tex);
}

function render_tex() {
  var tex = get_tex();
  $('#output').html(tex)
  var math = document.getElementById("output");
  MathJax.Hub.Queue(["Typeset",MathJax.Hub,math]);
}
