$(document).ready(function() {
	var code = '';
	var card = false;
	var insert = false;
	var inside = false;
	var taking = false;
	var Balance = 0;
	var Password = 0;

	var clickSound = new Howl({
		src: ['assets/sounds/click.ogg'],
		volume: 0.35,
	});

	var insertSound = new Howl({
		src: ['assets/sounds/insert.ogg?v=4'],
		volume: 0.3,
	});

	var moneySound = new Howl({
		src: ['assets/sounds/money.ogg?v=2'],
		volume: 0.5,
	});

	var errorSound = new Howl({
		src: ['assets/sounds/error.ogg?v=2'],
		volume: 0.5,
	});

	window.addEventListener('message', function(event) {
		if (event.data.action == 'open') {
			if (!taking) {
				$('body').show();
				$('#header p').text("$" + event.data.bank["Balance"]);
			}
			Balance = event.data.bank["Balance"];
			Password = event.data.bank["Password"];
		} else if (event.data.action == 'close') {
			$('body').hide();
		} else if (event.data.action == 'correct') {
			$('#code').hide();
			$('#display').show();
			$('#display #take').show();
		}
	});

	$('#cardflash').click(function() {
		if (!card) {
			$('#card').addClass('card-anim');
			card = true;
			setTimeout(function() {
				$('#card').hide();
				insertSound.play();
				$('#cardflash').hide();
				$('#welcome').attr('src', 'assets/images/welcome_code.png');
			}, 1000);
		}
	});


	$('#code-button').click(function() {
		if (card && !inside) {
			$('#code').show();
		}
	});

	$("#b-cancel").click(function() {
		if (card && inside) {
			clickSound.play();
			resetAll();
			$('body').hide();
			$.post(`http://atm/Close`);
		}
	});

	$('.take-money').click(function() {
		if (card && inside) {
			clickSound.play();
			var value = $(this).attr('data-amount');
			if (insert) {
				$.post(`http://atm/Deposit`, value, (Balance) => {
					$('#header p').text(`$${Balance}`);
				})
			} else {
				if (!taking) {
					if (Balance > 0 && Balance > value) {
						taking = true;
						$('#display #insert').hide();
						$('#display #take').hide();
						$('#display').hide();
						$('#loading').show();
						moneySound.play();
						setTimeout(function() {
							$('#money').show();
							$('#receipt').show();
							setTimeout(function() {
								$('#money').attr('src', 'assets/images/money.gif');
								$('#money').hide();
								$('#receipt').attr('src', 'assets/images/receipt.gif');
								$('#receipt').hide();
								$('#loading').hide();
								$('#display').show();
								if (insert && inside) {
									$('#display #insert').show();
								} else if (!insert && inside) {
									$('#display #take').show();
								} else {
									$('#header').hide();
								}
								taking = false;
								if (inside) {
									$.post(`http://atm/Withdraw`, value, (Balance) => {
										$('#header p').text(`$${Balance}`);
									})
								}
							}, 3800);
						}, 5600);
					}
				}
			}
		}
	});

	$("body").on("click", "#insert-money", function() {
		clickSound.play();
		if (!insert) {
			insert = true;
			$('#display #take').hide();
			$('#display #insert').show();
		} else {
			insert = false;
			$('#display #insert').hide();
			$('#display #take').show();
		}
	});

	$('#cancel').click(function() {
		clickSound.play();
		resetAll();
	});

	$('#wrong').click(function() {
		clickSound.play();
		$('#code h1').text('');
		code = '';
	});

	$('#done').click(function() {
		clickSound.play();
		if (code.length == 4) {
			$('#code').hide();
			$('#welcome').hide();
			$('#error').hide();
			if (code == Password) {
				$('#loading').show();
				setTimeout(function() {
					$('#loading').hide();
					$('#display').show();
					$('#display #take').show();
					$('#header').show();
					inside = true;
				}, 1000);
			} else {
				$('#code h1').text('');
				code = '';
				$('#error').show();
				errorSound.play();
				setTimeout(function() {
					errorSound.stop();
					$('#error').hide();
					$('#welcome').show();
				}, 3000);
			}
		}
	});

	$('#small li').click(function() {
		clickSound.play();
		var txt = $('#code h1').text();
		if (txt.length != 4) {
			$('#code h1').text(txt + '*');
			code = code + $(this).text();
		}
	});

	function resetAll() {
		clickSound.stop();
		errorSound.stop();
		moneySound.stop();
		insertSound.stop();
		$('#error').hide();
		$('#card').show();
		inside = false;
		insert = false;
		card = false;
		transaction = false;
		code = '';
		$('#header').hide();
		$('#code').hide();
		$('#display').hide();
		$('#cardflash').show();
		$('#card').removeClass('card-anim');
		$('#card').css('height', '12.5%');
		$('#welcome img').attr('src', 'assets/images/welcome.png');
		$('#code').hide();
		$("#insert").hide();
		$('#code h1').text('');
		$('#display').hide();
		$('#display #take').hide();
		$('#display #insert').hide();
		$('#loading').hide();
		$('#paper').hide();
		$('#welcome').show();
	}

	// Escape key event + reset the page
	$(document).keyup(function(e) {
		if (e.keyCode == 27) {
			resetAll();
			window.location.href = 'index.html';
			$('body').hide();
			$.post(`http://atm/Close`);
		}
	});
});