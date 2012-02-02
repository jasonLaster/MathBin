$('window').resize(function(){
  resize_elements()
})
    
$('input[type="submit"]').live('click', function(){
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

function resize_elements(){
  var height = $(window).height() - 15 -30
  var width = $(window).width()/2-1
  $('#output').css('height', height)
  $('table td').css('width', width)
}
