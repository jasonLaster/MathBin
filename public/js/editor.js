



$('window').resize(function(){
  resize_elements()
})
    
$('input[type="submit"]').live('click', function(){
  var tex = get_tex();
  $('input[name="tex"]').val(tex)
  $('form').submit();
})

$(document).live('keyup', function(){
  render_tex();
})

function get_tex(){
  return window.editor.getSession().getValue();
}

function render_tex() {
  var tex = get_tex();
  $('#output').html(tex)
  var math = document.getElementById("output");
  MathJax.Hub.Queue(["Typeset",MathJax.Hub,math]);
}

function resize_elements(){
  $('#input').css('height', $(window).height()-15)
  $('#output').css('height', $(window).height()-15)
  $('table').css('width', $(window).width())
  $('table td').css('width', $(window).width()/2-1)
}
