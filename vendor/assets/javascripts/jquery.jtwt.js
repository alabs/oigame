//jtwt.js by Harbor (http://jtwt.hrbor.com)

(function($){

 	$.fn.jtwt = function(options) { 

			//Declare defaults
			var defaults = {
				username : 'harbor',
				query: '',
                count : 4,
                image_size: 48,
                convert_links: true,
                loader_text: 'loading new tweets',
                no_result: 'No recent tweets found'
                
			}

			//Merge default with options
			var options =  $.extend(defaults, options);

			// customized parseTwitterDate. Base by http://stackoverflow.com/users/367154/brady - Special thanks to @mikloshenrich
			var parseTwitterDate = function(tdate) {
    
	    			var system_date = new Date(tdate.replace(/^\w+ (\w+) (\d+) ([\d:]+) \+0000 (\d+)$/, "$1 $2 $4 $3 UTC"));
	    			var user_date = new Date();
	
	    			var diff = Math.floor((user_date - system_date) / 1000);
	    			if (diff <= 1) {return "just now";}
	    			if (diff < 20) {return diff + " seconds ago";}
	    			if (diff < 40) {return "half a minute ago";}
	    			if (diff < 60) {return "less than a minute ago";}
	    			if (diff <= 90) {return "one minute ago";}
	    			if (diff <= 3540) {return Math.round(diff / 60) + " minutes ago";}
	    			if (diff <= 5400) {return "1 hour ago";}
	    			if (diff <= 86400) {return Math.round(diff / 3600) + " hours ago";}
	    			if (diff <= 129600) {return "1 day ago";}
	    			if (diff < 604800) {return Math.round(diff / 86400) + " days ago";}
	    			if (diff <= 777600) {return "1 week ago";}
	    			return "on " + system_date;
    
    		}
    		
    		return this.each(function() {
    		
				var o = options;
                var obj = $(this); 
                var q; 
                
				$(obj).append('<ul class="jtwt"></ul>');	
				$(".jtwt", obj).append('<li class="jtwt_loader jtwt_tweet" style="display:none;">' + o.loader_text + '</li>');	
				$(".jtwt_loader", obj).fadeIn('slow');
		
				//Check if there is a search query given, if not fetch user tweets
				if(o.query) {
					
					q = encodeURIComponent(o.query);
					
				} else {
					
					q = 'from:' + encodeURIComponent(o.username);
					
				}
		
				//get the tweets from the API
				$.getJSON('http://search.twitter.com/search.json?q=' + q + '&callback=?', function(data){ 

					var results = data['results'];
					
					if(results.length) {
						
						//Loop through results and append them to the parent
						for(var i = 0; i < o.count && i < results.length; i++) {
						
							var item = results[i];
							
							jtweet = '<li class="jtwt_tweet">';
		
			                if (o.image_size) {
			                
			                	today = new Date();
			  
				                jtweet += '<div class="jtwt_picture">';
				                jtweet += '<a href="http://twitter.com/' + item.from_user + '">'
				                jtweet += '<img width="' + o.image_size +'" height="' + o.image_size + '" src="' + item.profile_image_url + '" />';
				                jtweet += '</a>';
				                jtweet += '</div>';
			
			                } 
		
			                var tweettext = item.text;
			                var tweetdate = parseTwitterDate(item.created_at);
			                
			                if (o.convert_links) {
		
				                tweettext = tweettext.replace(/(http\:\/\/[A-Za-z0-9\/\.\?\=\-]*)/g,'<a href="$1">$1</a>');
				                tweettext = tweettext.replace(/@([A-Za-z0-9\/_]*)/g,'<a href="http://twitter.com/$1">@$1</a>');
				                tweettext = tweettext.replace(/#([A-Za-z0-9\/\.]*)/g,'<a href="http://twitter.com/search?q=$1">#$1</a>');
	
			                }
		
			                jtweet += '<p class="jtwt_tweet_text">' + tweettext + '</p>';
			                jtweet += '<a href="http://twitter.com/' + item.from_user + '/statuses/' + item.id_str + '" class="jtwt_date">' + tweetdate + '</a>';
			 
			                jtweet += '</li>';   				
			                
			                $(".jtwt", obj).append(jtweet);
	                
		                }   
						
					} else {
						
						//If there are not any tweets, display the "no results" container
						$(".jtwt_loader", obj).fadeOut('fast', function() {
							
							$(".jtwt", obj).append('<li class="jtwt_noresult jtwt_tweet" style="display:none;">' + o.no_result + '</li>');
							$(".jtwt_noresult", obj).fadeIn('slow');
							
						});   
						
						
					}
		
					$(".jtwt_loader", obj).fadeOut('fast');   
           
				});

			});
			
    	}

})(jQuery);