def test():
    return 121
def CallIndicators(minQty,nb_simbol,symbol,interval,indicateur):
	$('#in_result').load('Curl.php',{symbol:symbol,interval:interval,indicateur:indicateur, def(): //send table
		//console.log($('#in_result').text())
		//console.log(12313453)
		result = $('#in_result').text()
		AfterGetIndicator(minQty,symbol,nb_simbol,indicateur,JSON.parse(result))	
	)
