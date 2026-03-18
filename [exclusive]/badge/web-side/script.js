window.onload = function(e){
	window.addEventListener("message",function(event){
		var eventData = event.data;
		if (eventData.show) {
			$('.container-badge').fadeIn(500).delay(2500).fadeOut(500);
			$('.profile-image-holder').html(`
				<img src="${eventData.infos.picture}" alt="profile">
			`);
			$('#rank').text(eventData.infos.rank);
			$('#name').text(eventData.infos.name);
			$('#callsign').text("#"+eventData.infos.callsign);
		} else {
			$(".container-badge").fadeOut();
		}
	});
}