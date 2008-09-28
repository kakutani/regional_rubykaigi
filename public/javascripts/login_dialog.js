$(function() {
	$("#link_to_login").click(
	  function(e){
		e.preventDefault();
		$("#login_dialog").modal();
	});
});