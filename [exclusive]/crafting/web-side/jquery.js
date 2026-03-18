var Name = "";
var selectType = "";
/* --------------------------------------------------- */
$(document).ready(function(){
	window.addEventListener("message",function(event){
		switch(event.data.Action){
			case "Open":
				Name = event.data.name;
				selectType = event.data.type;
				$(".inventory").css("display","flex");
				Request();
			break;

			case "Close":
				$(".inventory").css("display","none");
				$(".ui-tooltip").hide();
			break;

			case "Request":
				Request();
			break;
		}
	});

	document.onkeyup = data => {
		if (data["key"] === "Escape"){
			$.post("http://crafting/close");
			$(".invRight").html("");
			$(".invLeft").html("");
		}
		$('.craftSearch').on('input', function() {
			var searchValue = $(this).val().toLowerCase();
			$('.invRight .craftContainer').each(function() {
				var container = $(this);
				var hasMatch = false;
				container.find('.craftItem .nameItem').each(function() {
					var itemName = $(this).text().toLowerCase();
					if(itemName.includes(searchValue)) {
						hasMatch = true;
						return false; // sai do loop .each interno
					}
				});
				if(hasMatch) {
					container.show();
				} else {
					container.hide();
				}
			});
		});
	}
});
/* --------------------------------------------------- */
const updateDrag = () => {
	
	$(".populated").draggable({
		helper: "clone",
		start: function(event, ui) {
			if (ui.helper.parent()[0].className === "craftContainer" && selectType === "Recycler") return false;
		},
		drag: function(event, ui) {
			let amount = $(".amount").val();
			let itemAmount = parseInt(ui.helper.data("amount"));
			if (event.shiftKey)
				amount = itemAmount;
			else if($(".amount").val() == "" | parseInt($(".amount").val()) <= 0)
				amount = 1;
			else
			amount = itemAmount;
		  	ui.helper.children(".top").children(".itemAmount").html(ParseFormat(amount) + "x");
			ui.helper.children(".top").children(".itemWeight").html((amount*parseFloat(ui.helper.data("peso"))).toFixed(2));
		}
	});

	$('.empty').droppable({
		hoverClass: 'hoverControl',
		drop: function(event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const shiftPressed = event.shiftKey;
			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined) return;
			const tInv = $(this).parent()[0].className;

			itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
			const target = $(this).data('slot');

			if (itemData.key === undefined || target === undefined) return;

			let itemAmount = parseInt(ui.draggable.data("amount"));
			let amount = $(".amount").val();
			if (shiftPressed)
				amount = itemAmount;
			else if($(".amount").val() == "" | parseInt($(".amount").val()) <= 0)
				amount = 1;
			else
				amount = parseInt($(".amount").val());
		
			if(amount > itemAmount && origin === "invLeft")
				amount = itemAmount;

			$(".populated, .empty, .use, .send, .deliver").off("draggable droppable");

			if (origin === "invLeft" && tInv === "invLeft"){
				let clone1 = ui.draggable.clone();
				let slot2 = $(this).data("slot"); 
				let added = Math.min(amount, parseInt(ui.draggable.data("stack")));		
				if (added <= parseInt(ui.draggable.data("amount"))) {
	
					ui.draggable.data("amount",parseInt(ui.draggable.data("amount")) - parseInt(added));
					ui.draggable.children(".top").children(".itemAmount").html(ParseFormat(ui.draggable.data("amount")) + "x");
					ui.draggable.children(".top").children(".itemWeight").html((parseInt(ui.draggable.data("amount"))*parseFloat(ui.draggable.data("peso"))).toFixed(2));
					
					clone1.data("amount",parseInt(added));
					$(this).replaceWith(clone1);
					$(clone1).data("slot",slot2);
					$(clone1).children(".top").children(".itemAmount").html(ParseFormat(clone1.data("amount")) + "x");
					$(clone1).children(".top").children(".itemWeight").html((parseInt(clone1.data("amount"))*parseFloat(ui.draggable.data("peso"))).toFixed(2));
					
					if (parseInt(ui.draggable.data("amount")) == 0){
						ui.draggable.replaceWith(`<div class="item empty" data-slot="${ui.draggable.data("slot")}"></div>`);
					}
				}
				$.post("http://crafting/Update",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			} else if (origin === "craftContainer" && tInv === "invLeft" && selectType === "Craft"){
				$.post("http://crafting/Trade",JSON.stringify({
					name: Name,
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			} else if (origin === "invLeft" && tInv === "craftContainer" && selectType === "Recycler"){
				$.post("http://crafting/Trade",JSON.stringify({
					name: Name,
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			}

			$(".amount").val("");

			updateDrag();
		}
	});

	$('.populated').droppable({
		hoverClass: 'hoverControl',
		drop: function(event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const shiftPressed = event.shiftKey;
			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined) return;
			const tInv = $(this).parent()[0].className;
			
			itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
			const target = $(this).data('slot');

			if (itemData.key === undefined || target === undefined) return;

			let amount = $(".amount").val();
			let itemAmount = parseInt(ui.draggable.data("amount"));
			if (shiftPressed)
				amount = itemAmount;
			else if($(".amount").val() == "" | parseInt($(".amount").val()) <= 0)
				amount = 1;
			else
				amount = parseInt($(".amount").val());

			if(amount > itemAmount && origin === "invLeft")
				amount = itemAmount;

			$(".populated, .empty, .use, .send, .deliver").off("draggable droppable");
			

			if (origin === "invLeft" && tInv === "invLeft"){
				if (ui.draggable.data("item-key") == $(this).data("item-key")){
					let added = Math.min(amount, parseInt($(this).data("stack")) - parseInt($(this).data("amount")));
					if (added <= parseInt(ui.draggable.data("amount"))) {
						
						ui.draggable.data("amount",parseInt(ui.draggable.data("amount")) - parseInt(added));
						ui.draggable.children(".top").children(".itemAmount").html(ParseFormat(ui.draggable.data("amount")) + "x");
						ui.draggable.children(".top").children(".itemWeight").html((parseInt(ui.draggable.data("amount"))*parseFloat(ui.draggable.data("peso"))).toFixed(2));
						
						$(this).data("amount",parseInt($(this).data("amount")) + parseInt(added));
						$(this).children(".top").children(".itemAmount").html(ParseFormat($(this).data("amount")) + "x");
						$(this).children(".top").children(".itemWeight").html((parseInt($(this).data("amount"))*parseFloat(ui.draggable.data("peso"))).toFixed(2));
	
						if (parseInt(ui.draggable.data("amount")) == 0){
							ui.draggable.replaceWith(`<div class="item empty" data-slot="${ui.draggable.data("slot")}"></div>`);
						}
					}
				} else {	
					let clone1 = ui.draggable.clone();
					let clone2 = $(this).clone();
	
					let slot1 = ui.draggable.data("slot");
					let slot2 = $(this).data("slot");
	
					ui.draggable.replaceWith(clone2);
					$(this).replaceWith(clone1);
	
					$(clone1).data("slot",slot2);
					$(clone2).data("slot",slot1);
				}
				$.post("http://crafting/Update",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			} else if (origin === "craftContainer" && tInv === "invLeft" && selectType === "Craft"){
				$.post("http://crafting/Trade",JSON.stringify({
					name: Name,
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			} else if (origin === "invLeft" && tInv === "craftContainer" && selectType === "Recycler"){
				$.post("http://crafting/Trade",JSON.stringify({
					name: Name,
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));

				$(".amount").val("");
			}

			$(".amount").val("");

			updateDrag();
		}
	});

	$(".use").droppable({
		hoverClass: "hoverControl",
		drop: function(event,ui){
			if (ui.draggable.parent()[0] == undefined) return;

			const shiftPressed = event.shiftKey;
			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined || origin === "craftContainer") return;
			itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };

			if (itemData.key === undefined) return;

			let amount = $(".amount").val();
			if (shiftPressed) amount = ui.draggable.data("amount");

			$.post("http://inventory/Use",JSON.stringify({
				slot: itemData.slot,
				amount: parseInt(amount)
			}));

			$(".amount").val("");
		}
	});

	$(".send").droppable({
		hoverClass: "hoverControl",
		drop: function(event,ui){
			if (ui.draggable.parent()[0] == undefined) return;

			const shiftPressed = event.shiftKey;
			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined || origin === "craftContainer") return;
			const itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };

			if (itemData.key === undefined) return;

			let amount = $(".amount").val();
			if (shiftPressed) amount = ui.draggable.data("amount");

			$.post("http://inventory/Send",JSON.stringify({
				slot: itemData.slot,
				amount: parseInt(amount)
			}));

			$(".amount").val("");
		}
	});

	$(".populated").on("auxclick",e => {
		if (e["which"] === 3){
			const item = e["target"];
			const shiftPressed = event.shiftKey;
			const origin = $(item).parent()[0].className;
			if (origin === undefined || origin === "craftContainer") return;

			itemData = { key: $(item).data("item-key"), slot: $(item).data("slot") };

			if (itemData.key === undefined) return;

			let amount = $(".amount").val();
			if (shiftPressed) amount = $(item).data("amount");

			$.post("http://inventory/Use",JSON.stringify({
				slot: itemData.slot,
				amount: parseInt(amount)
			}));
		}
	});

	$(".populated").tooltip({
		create: function(event,ui){
			$(this).tooltip({
				content: $(this).attr("data-description"),
				position: { my: "center top + 10", at: "center bottom", collision: "flipfit" },
				show: { duration: 10 },
				hide: { duration: 10 }
			});
		}
	});
}
/* --------------------------------------------------- */
const ParseFormat = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--){
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}
/* --------------------------------------------------- */
const colorPicker = (percent) => {
	var colorPercent = "#00f8b9";

	if (percent >= 100)
		colorPercent = "rgba(255,255,255,0)";

	if (percent >= 51 && percent <= 75)
		colorPercent = "#fcc458";

	if (percent >= 26 && percent <= 50)
		colorPercent = "#fc8a58";

	if (percent <= 25)
		colorPercent = "#fc5858";

	return colorPercent;
}

const Request = () => {
	$.post("http://crafting/Request",JSON.stringify({ name: Name }),(data) => {

		$("#weightTextLeft").html(`<i class="fa-solid fa-dumbbell"> ${(data["invPeso"]).toFixed(2)} / ${(data["invMaxpeso"]).toFixed(2)}</i>`);
		$("#weightBarLeft").html(`<div id="weightContent" style="width: ${data["invPeso"] / data["invMaxpeso"] * 100}%"></div>`);

		$(".invLeft").html("");
		$(".invRight").html("");

		if (data["invMaxpeso"] > 100)
			data["invMaxpeso"] = 100;

		for (let x = 1; x <= 25; x++){
			const slot = x.toString();

			if (data.Inventory[slot] !== undefined){
				const v = data.Inventory[slot];
				var maxDurability = 3600 * (v["days"] || 1);
				var newDurability = (maxDurability - (v["durability"] || 0)) / maxDurability;
				var actualPercent = newDurability * 100;

				if (v["charges"] !== undefined)
					actualPercent = v["charges"];

				if (actualPercent <= 1)
					actualPercent = 1;

				const item = `<div class="item populated" title="" style="background-image: url('nui://revolt/config/inventory/${v["index"]}.png'); background-position: center; background-repeat: no-repeat;" data-amount="${v["amount"]}" data-item-key="${v["key"]}" data-slot="${slot}" data-peso="${v["peso"]}" data-description="${v["desc"]}">
					<div class="nameItem">${v["name"]}</div>
					<div class="top">
						<div class="itemAmount">${ParseFormat(v["amount"])}x</div>
						<div class="itemWeight">${(v["peso"] * v["amount"]).toFixed(2)}</div>
					</div>
					<div class="durability" style="width: ${actualPercent == 1 ? "100":actualPercent}%; background: ${actualPercent == 1 ? "#fc5858":colorPicker(actualPercent)};"></div>
					
				</div>`;

				$(".invLeft").append(item);
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;
				$(".invLeft").append(item);
			}
		}
		
		for (let x = 1; x <= data.craftSlots; x++){
			const slot = x.toString();
			if (data.Crafting[slot] !== undefined){
				const v = data.Crafting[slot];

				let requirementHtml = '';
				let requirements = v.required;
				for (let xx = 0; xx < requirements.length; xx++) {
					let requiredClasses = 'requirementName';
					if (requirements[xx].name.length > 15) {
						requiredClasses += ' requirementSmall';
					}
					requirementHtml +=
					"<img id='requirementImage' src='http://"+data["Endpoint"]+"/inventory/" +
					requirements[xx].index +
					".png' /><span class='" + requiredClasses +"'>" +
					requirements[xx].name +
					':</span> ' +
					requirements[xx].amount +
					'<br>';
				}
				
				const item = `<div class='craftContainer'>
					<div class="craftItem populated" title="" style="background-image: url('nui://revolt/config/inventory/${v["index"]}.png'); background-position: center; background-repeat: no-repeat;" data-amount="${v["amount"]}" data-item-key="${v["key"]}" data-slot="${slot}" data-price="${v["price"]}" data-peso="${v["peso"]}" data-description="${v["desc"]}" data-slot="${slot}">
						<div class="nameItem">${v["name"]}</div>
						<div class="top">
							<div class="itemAmount">${v["display"] || ParseFormat(v["amount"])+"x"}</div>
							<div class="itemWeight">${(v["peso"]).toFixed(2)}</div>
						</div>
						<div class="durability" style="width: 100%; background: rgba(255,255,255,0);"></div>
					</div>
					<div class='requirements'>${requirementHtml}</div>
				</div>`;

				$(".invRight").append(item);
			}
		}
		updateDrag();
	});
}