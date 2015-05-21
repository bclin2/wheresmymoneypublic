var ready = function(){
  Model.sumResults();
  Model.createMap();
  View.initMap();
  View.StartListeners();
}

$(document).ready(function() {
	ready()
})

$(document).on("page:load", function(){
	ready()
});

var Model = {
	createMap: function(stateResultsCount){
			var mapResults = new Datamap({
				 scope: 'usa',
				 element: document.getElementById('map_container'),
				 geographyConfig: {
			 		 borderColor: '#FDFDFD',
			 	   highlightBorderColor: 'yellow',
			 	   highlightFillColor: '#337AB7',
				   highlightBorderWidth: 0
				 },

				 fills: {
				 	'High': '#F26C4F',
				 	'Middle': '#FFF467',
				 	'Low': '#82CA9D',
				  defaultFill: '#e0e0e0'
				},
				data: Model.countCurrentStateResults(),
				});
				mapResults.labels();
		},

	sum: 0,

	sumResults: function() {
		var model = this;
		$(".state_container").each(function(index, value) {
			model.sum += $(this).children('.results').length;
		})
	},

	countCurrentStateResults: function() {
		var statesResults = {}
		var low_results = this.sum / 6
		var medium_results = this.sum / 3
		$(".state_container").each(function(index, value) {
			numberOfResults = $(this).children('.results').length;
			statesResults[this.id] = {}
			statesResults[this.id]["numberOfHits"] = numberOfResults	;
			if (numberOfResults < low_results) {
				statesResults[this.id]["fillKey"] = "Low"
			}
			else if (numberOfResults > low_results && numberOfResults < medium_results){
			 statesResults[this.id]["fillKey"] = "Medium"
			}
			else {
				statesResults[this.id]["fillKey"] = "High"
			}
		 });
		return statesResults
	}
}


var View = {
	StartListeners: function(){
	$('.user_claim_button').on('click', function(event) {
		stateCodeArr = []
		$(this).parent().siblings('.user_choices').children().each(function(key, value){
			stateCodeArr.push($(value).data().state)
		});
	  $.ajax({
	    url: '/emailer/email',
	    type: 'post',
	    data:  {state_code: stateCodeArr}
	  }).done(function(response) {
	  	if (response.contacts){
	  		window.location.href = "http://localhost:3000/user/"+response.user_id+"/contacts"
	  	}
	  	else {
		  	window.location.href = "http://localhost:3000/user/thankyou";
	  	}
	  });
	});

  	$('.datamaps-subunit').on('click', function() {
  	  $("#" + $(this).attr('class').split(" ")[1] ).toggle("fast")
  	});

  	$(".user_check_box").on('click', function(){
  		checkedItem = $(this).parents('.results')
			stateName = $(this).parents('.state_container').attr('id')
  		checkedItemClone = checkedItem.clone()
			checkedItemClone.data( "state", stateName )
		$(".user_choices").append(checkedItemClone)
  	})

	// function sendFriendEmails() {
	  $('.friends').on('click', function(event) {
	    $.ajax({
	      url: '/user/sendmail',
	      type: 'POST',
	    }).done(function(response) {
	      console.log("ajax success")
	    });
	  });

  	$(".user_claim_button").on("click", function(){
  		View.notMeListener();
  	})
	},
	notMeListener: function(){
	 $('.not_me').on('click', function(){
	   $(this).parent().parent().remove()
	 // if ($(this).parent().parent().siblings().length < 2){
	   // $(this).parents(".row").remove()
	 })
	},

	initMap: function(){
		$("#map_container").children().eq(0).css("overflow","visible")
		$(".state_container").css("display", "none")
	},
}
