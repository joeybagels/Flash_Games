/* ©COPYRIGHT 2009 MARVEL ENTERTAINMENT

	This is the ad harness javascript code. 
	
	Tested on: 
	
		Mac Safari, Firefox
		Windows Firefox, IE6, IE7, IE8
	
*/

function showAd() {
	//alert('showing ad');
	myDiv = eval('document.getElementById("marvel_game")');
    
    myDiv.style.top = "2000px";
	myDiv.style.zIndex = "100";

    myDiv = eval('document.getElementById("marvel_game_ad")');
	
	myDiv.style.top = "0px";
	myDiv.style.zIndex = "200";
	myDiv.style.display = "inline";
}

function showGame() {
	//alert('showing game');
	myDiv = eval('document.getElementById("marvel_game_ad")');
    
    myDiv.style.top = "2000px";
    myDiv.style.zIndex = "100";
	myDiv.style.display = "none";
	
	myDiv = eval('document.getElementById("marvel_game")');
    
    myDiv.style.top = "0px";
    myDiv.style.zIndex = "200";
}

function clearAd()
{
	loadAd('blank.html');
	return;
}

function swapZ()
{
	div1 = eval('document.getElementById("marvel_game_ad")');
	div2 = eval('document.getElementById("marvel_game")');
	
	var savedZ = div2.style.zIndex;
	
	div1.style.zIndex = div2.style.zIndex;
	div2.style.zIndex = savedZ;
}

function loadAd(url)
{
	var iframe = document.getElementById('adFrame');
	iframe.src = url;
	
}
