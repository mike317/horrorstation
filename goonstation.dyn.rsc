B%   ���q�h�W    "%  pathoComp.html <!DOCTYPE html> <html> <head> <title>Pathogen Manipulator</title> <meta http-equiv=X-UA-Compatible content="IE=edge,chrome=1"> <meta http-equiv=Content-Type content="text/html; charset=UTF-8"> <script src=http://cdn.goonhub.com/js/jquery.min.js type=text/javascript></script><!--<script src="./json2.min.js" type="text/javascript"></script>--> <script src=http://cdn.goonhub.com/js/pathology_display.js type=text/javascript></script> <script src=http://cdn.goonhub.com/js/pathoui-script.js type=text/javascript></script> <link href=http://cdn.goonhub.com/css/pathoui.css rel=stylesheet type=text/css> </head> <body> <div class=mainContent><!--Displays information about the currently loaded pathogen--> <div id=loadedPathogen> <div class=noborder> <span class=label>DNA Load Status: </span> <div class="annunciator a-green" id=annDNALoad> LOAD </div> <div class="annunciator a-red" id=annDNANoLoad> NO LOAD </div> <div class="annunciator a-yellow" id=annDNASplice> SPLICE </div> <span class=label>Pathogen: </span> <div class="text-field tf-med" id=txtPName>G68P68</div> <div class="text-field tf-med" id=txtPType>(fungus)</div> </div> <div class=noborder> <span class=label>Slot: </span> <div class="text-field tf-narrow" id=txtExpSlot>1</div> <div class="annunciator a-yellow" id=annSlotExp>EXPOSED</div> <div class="annunciator a-green" id=annSlotSample>SAMPLE</div> <div class="button btn-small" id=btnCloseSlot>Close</div> <div class="button btn-small" id=btnEjectSample>Eject</div> </div> <div class=noborder> <span class=label>DNA Seq: </span><br> <div class="text-field tf-long" id=txtPSeq> </div> </div> </div><!--Displays the currently selected page--> <div class=dataDisplay> <div class=dataPage id=dpManip> <h1>DNA Manipulator</h1> <div id=manipHolder> <div class="narrow-border extrapad"> <span class="label lb-long">Status:</span> <div class="annunciator a-green" id=aMutRdy>READY</div> <div class="annunciator a-yellow" id=aMutIrr>RAD</div> <div class="annunciator a-green" id=aMutAck>PASS</div> <span class="label lb-long"></span> <div class="annunciator a-red" id=aMutOpen>EXPOSED</div> <div class="annunciator a-red" id=aMutSample>SAMPLE</div> <div class="annunciator a-red" id=aMutNack>FAIL</div> </div> <table> <tr> <td><span class="label lb-long">Mutativeness:</span></td> <td><div class="button btn-tiny" data-tsk="mut=-1">-</div></td> <td><div class="text-field tf-narrow" id=txtMut></div></td> <td><div class="button btn-tiny" data-tsk="mut=1">+</div></td> </tr> <tr> <td><span class="label lb-long">Mutation Speed:</span></td> <td><div class="button btn-tiny" data-tsk="mts=-1">-</div></td> <td><div class="text-field tf-narrow" id=txtMts></div></td> <td><div class="button btn-tiny" data-tsk="mts=1">+</div></td> </tr> <tr> <td><span class="label lb-long">Advance Speed:</span></td> <td><div class="button btn-tiny" data-tsk="adv=-1">-</div></td> <td><div class="text-field tf-narrow" id=txtAdv></div></td> <td><div class="button btn-tiny" data-tsk="adv=1">+</div></td> </tr> <tr> <td><span class="label lb-long">Maliciousness:</span></td> <td><div class="button btn-tiny" data-tsk="mal=-1">-</div></td> <td><div class="text-field tf-narrow" id=txtMal></div></td> <td><div class="button btn-tiny" data-tsk="mal=1">+</div></td> </tr> <tr> <td><span class="label lb-long">Suppression Threshold:</span></td> <td><div class="button btn-tiny" data-tsk="sth=-1">-</div></td> <td><div class="text-field tf-narrow" id=txtSth></div></td> <td><div class="button btn-tiny" data-tsk="sth=1">+</div></td> </tr> </table> </div> </div> <div class=dataPage id=dpSplice1> <h1>Select splice target</h1> <span class="label lb-slong">The loaded DNA will be modified during this session.</span> <div class="noborder splice-selection"> <div class="noborder slot-holder" id=spliceSlots> </div> <div class="narrow-border button-holder" id=spliceButtons> <div class="annunciator a-red" id=annSpliceStatExp>EXPOSED</div> <div class="annunciator a-green" id=annSpliceStatSource>SOURCE</div> <div class="annunciator a-green" id=annSpliceStatTarget>TARGET</div> <hr> <div class=button id=btnSpliceBegin>Begin<br>Splice</div> <div class=button id=btnSpliceCancel>Cancel<br>Splice</div> </div> </div> </div> <div class=dataPage id=dpSplice2> <h1>Splicing Session</h1> <div class="noborder splice-selection"><!--DATA HOLDER--> <div class=noborder id=spliceData> <div class="extrapad button-holder prediction-holder"> <span class="label lb-long">Predictive Effectiveness:</span> <div class="text-field tf-med txtPredEffect"></div> <div class="button btn-med display-known">Sequences</div> </div> <div class="extrapad splice-sequence" id=spliceTargetField> <span class="label lb-long">Target sequence:</span> <div class="text-field tf-long" id=txtSpliceTarget></div> <div class="button btn-small btn-seq-off" dir=-1>-</div> <div class="button btn-small btn-seq-off" dir=1>+</div> <span class=label>Status:</span> <div class="annunciator a-red" id=annSpliceTargetEmpty>EMPTY</div> </div> <div class="button-holder extrapad splice-controls" id=spliceActions> <span class="label lb-elong">Splice actions:</span> <div class="button btn-small" dir=-1>Before</div> <div class="button btn-small" dir=1>After</div> <div class="button btn-small" dir=0>Remove</div> </div> <div class="extrapad splice-sequence" id=spliceSourceField> <span class="label lb-long">Source sequence:</span> <div class="text-field tf-long" id=txtSpliceSource></div> <div class="button btn-small btn-seq-off" dir=-1>-</div> <div class="button btn-small btn-seq-off" dir=1>+</div> <span class=label>Status:</span> <div class="annunciator a-red" id=annSpliceSourceEmpty>EMPTY</div> </div> </div><!--FINALIZING BUTTONS--> <div class="button-holder extrapad" id=spliceFinalButtons> <span class="label lb-med">Splice status:</span> <div class="annunciator a-green" id=annSpliceSuccess>SUCCESS</div> <div class="annunciator a-red" id=annSpliceFail>FAIL</div> <span class=label>Prediction:</span> <div class="annunciator a-green" id=annPredSuccess>SUCCESS</div> <div class="annunciator a-yellow" id=annPredUnk>UNKNOWN</div> <div class="annunciator a-red" id=annPredFail>FAIL</div> <hr> <div class=button id=btnSpliceFinish>Finish Splicing</div> </div> </div> </div> <div class=dataPage id=dpTester> <h1>DNA Stability Analyzer</h1> <div class=noborder id=analyzerHolder><!--SHOWING PREDICTIVE EFFECTIVENESS--> <div class="narrow-border extrapad button-holder" id=predictionHolder> <span class="label lb-long">Predictive Effectiveness:</span> <div class="text-field tf-med txtPredEffect"></div> <div class="button btn-med display-known">Sequences</div> </div><!--HOLDING BOTH ANALYSIS BUFFERS (current / previous) --> <div class="noborder extramargin"> <div class="narrow-border analysis-buffer extrapad" id=currAnalysis> <span class="label lb-long block">Current analysis:</span> <div class="text-field tf-enarrow" id=currAnalysis0></div> <div class="text-field tf-enarrow" id=currAnalysis1></div> <div class="text-field tf-enarrow" id=currAnalysis2></div> <div class="text-field tf-enarrow" id=currAnalysis3></div> <div class="text-field tf-enarrow" id=currAnalysis4></div> <div class="button btn-tinyish" id=btnClrAnalysisCurr>CLR</div> </div> <div class="narrow-border analysis-buffer extrapad" id=prevAnalysis> <span class="label lb-long block">Previous analysis:</span> <div class="text-field tf-enarrow" id=prevAnalysis0></div> <div class="text-field tf-enarrow" id=prevAnalysis1></div> <div class="text-field tf-enarrow" id=prevAnalysis2></div> <div class="text-field tf-enarrow" id=prevAnalysis3></div> <div class="text-field tf-enarrow" id=prevAnalysis4></div> </div> </div> <div class="noborder extramargin"> <div class="extrapad button-holder" id=analyzeComponents> </div> <div class="narrow-border extrapad" id=analyzeResults> <span class=label>Stable:</span> <div class="annunciator a-green" id=annStableYes>YES</div> <div class="annunciator a-red" id=annStableNo>NO</div> <span class=label>Transient:</span> <div class="annunciator a-green" id=annTransYes>YES</div> <div class="annunciator a-red" id=annTransNo>NO</div> <hr> <span class=label>Error:</span> <div class="annunciator a-red" id=annErrBuffer>BUFFER</div> <div class="annunciator a-red" id=annErrNack>NACK</div> <span class=label></span> <div class="annunciator a-yellow" id=annErrSample>SAMPLE</div> <div class="annunciator a-yellow" id=annErrData>T. DATA</div> </div> </div> <div class="button btn-long" id=btnAnalysisLoad>Load Sample &amp; Clear Buffer</div> <div class="button btn-long" id=btnAnalysisDoTest>Test DNA</div> </div> </div> <div class=dataPage id=dpLoadSave> <h1>Load / Save DNA</h1> <div class="noborder slot-holder" id=dnaSlotHolder> </div> </div> <div class=dataPage id=dpWelcome> <h1>Welcome to the Path-o-matic 2000</h1> <span>The leading market solution for pathology research.</span> <span>This device is capable of the following:</span> <ul> <li>DNA Sequence Verification</li> <li>DNA Sequence Splicing</li> <li>DNA Trait Segment Manipulation</li> <li>Predictive Stability Analysis</li> <li>Pathogen Sample Identification</li> </ul> </div> </div><!--The main menu, used for scrolling through the pages--> <div id=mainMenu> <div class=button id=btnRetMain>Main Screen</div> <div class=button id=btnManip>Manipulate</div> <div class=button id=btnSplice>Splice</div> <div class=button id=btnTester>DNA Analyzer</div> <div class=button id=btnLoadSave>Load / Save DNA</div> <div class="annunciator a-yellow" id=annSynch>SYNCH</div> </div> </div> </body> </html>(   �%q��h�W    
  tooltip.html <!DOCTYPE html> <html> <head> <title>Tooltip</title> <meta http-equiv=X-UA-Compatible content="IE=edge,chrome=1"> <meta http-equiv=Content-Type content="text/html; charset=UTF-8"> <link rel=stylesheet type=text/css href=http://cdn.goonhub.com/css/tooltip.css> </head> <body> <div id=wrap class=wrap> <div id=content class=content></div> </div> <script type=text/javascript src=http://cdn.goonhub.com/js/jquery.min.js></script> <script type=text/javascript src=http://cdn.goonhub.com/js/tooltip.js></script> </body> </html>-   6�խ�h�W    	  create_object.html <!DOCTYPE html> <html> <head> <title>Create Object</title> <link rel=stylesheet type=text/css href=http://cdn.goonhub.com/css/style.css> </head> <body id=createobj> <form name=spawner action="byond://?src=/* ref src */" method=get> <input type=hidden name=src value="/* ref src */"> <input type=hidden name=action value=object_list> Type <input type=text name=filter style=width:280px onkeydown=submitFirst(event)><input type=button name=search value=Search onclick=updateSearch() style=width:70px><br> Offset: <input type=text name=offset value=x,y,z style=width:250px> A <input type=radio name=offset_type value=absolute> R <input type=radio name=offset_type value=relative checked><br> Direction: S<input type=radio name=one_direction value=2 checked> SE<input type=radio name=one_direction value=6> E<input type=radio name=one_direction value=4> NE<input type=radio name=one_direction value=5> N<input type=radio name=one_direction value=1> NW<input type=radio name=one_direction value=9> W<input type=radio name=one_direction value=8> SW<input type=radio name=one_direction value=10><br> Number: <input type=text name=object_count value=1 style=width:330px> <br><br> <div id=selector_hs> <select name=type id=object_list multiple size=20> </select> </div> <br> <input type=submit value=spawn> </form> <script language=JavaScript>var old_search = "";
		var object_list = document.spawner.object_list;
		var object_list_container = document.getElementById('selector_hs');
		var object_paths = null /* object types */;
		var objects = object_paths == null ? new Array() : object_paths.split(";");
		
		document.spawner.filter.focus();
		populateList(objects);
		
		function populateList(from_list)
		{
			var newOpts = '';
			var i;
			for (i in from_list)
			{
				newOpts += '<option value="' + from_list[i] + '">'
					+ from_list[i] + '</option>';
			}
			object_list_container.innerHTML = '<select name="type" id="object_list" multiple size="20">' + 
			newOpts + '</select>';
		}
		
		function updateSearch()
		{
			if (old_search == document.spawner.filter.value)
			{
				return false;
			}
			
			old_search = document.spawner.filter.value;
			
			
			var filtered = new Array();
			var i;
			for (i in objects)
			{
				if(objects[i].search(old_search) < 0)
				{
					continue;
				}
				
				filtered.push(objects[i]);
			}
			
			populateList(filtered);
			
			if (object_list.options.length)
				object_list.options[0].selected = 'true';
			
			return true;
		}
		
		function submitFirst(event)
		{
			if (event.keyCode == 13 || event.which == 13)
			{
				if (updateSearch())
				{
					if (event.stopPropagation) event.stopPropagation();
					else event.cancelBubble = true;

					if (event.preventDefault) event.preventDefault();
					else event.returnValue = false;
				}
			}
		}</script> </body> </html>�   �?E9�h�W    �  browserOutput.html <!DOCTYPE html> <html> <head> <title>Chat</title> <meta http-equiv=X-UA-Compatible content="IE=edge,chrome=1"> <meta http-equiv=Content-Type content="text/html; charset=UTF-8"> <link rel=stylesheet type=text/css href=http://cdn.goonhub.com/css/font-awesome.css> <link rel=stylesheet type=text/css href=http://cdn.goonhub.com/css/browserOutput.css> <script type=text/javascript src=http://cdn.goonhub.com/js/jquery.min.js></script> <script type=text/javascript src=http://cdn.goonhub.com/js/json2.min.js></script> </head> <body> <div id=loading> <i class="icon-spinner icon-2x"></i> <div> Loading...<br><br> If this takes longer than 30 seconds, it will automatically reload a maximum of 5 times.<br> If it STILL doesn't work, please post a report here: <a href="http://forum.ss13.co/viewforum.php?f=7">http://forum.ss13.co/viewforum.php?f=7</a> </div> </div> <div id=messages> </div> <div id=userBar style="display: none"> <div id=ping> <i class=icon-circle id=pingDot></i> <span class=ms id=pingMs>--ms</span> </div> <div id=options> <a href=# class=toggle id=toggleOptions title=Options><i class=icon-cog></i></a> <div class=sub id=subOptions> <a href=# class=decreaseFont id=decreaseFont><span>Decrease font size</span> <i class=icon-font>-</i></a> <a href=# class=increaseFont id=increaseFont><span>Increase font size</span> <i class=icon-font>+</i></a> <a href=# class=chooseFont id=chooseFont>Change font <i class=icon-font></i></a> <a href=# class=togglePing id=togglePing><span>Toggle ping display</span> <i class=icon-circle></i></a> <a href=# class=highlightTerm id=highlightTerm><span>Highlight string</span> <i class=icon-tag></i></a> <a href=# class=saveLog id=saveLog><span>Save chat log</span> <i class=icon-save></i></a> <a href=# class=clearMessages id=clearMessages><span>Clear all messages</span> <i class=icon-eraser></i></a> </div> </div> </div> <script type=text/javascript src=http://cdn.goonhub.com/js/browserOutput.js></script> </body> </html>�   |8��h�W    �  changelog.html <style type=text/css>.postcard {display: block; margin: 10px auto; width: 300px;}
	h1 {font-size: 2.5em; padding: 0 10px; margin: 0; color: #115FD5;}
	h1 a {display: block; float: right;}
	.links {list-style-type: none; margin: 15px 5px; padding: 0; border: 1px solid #ccc; color: #333;}
	.links li {float: left; width: 50%; text-align: center; background: #f9f9f9; padding: 10px 0; position: relative;}
	.links li span {position: absolute; top: 0; right: 0; bottom: 0; width: 1px; background: #ccc;}

	.log {list-style-type: none; padding: 0; background: #f9f9f9; margin: 20px 5px; border: 1px solid #ccc; font-size: 1em; color: #333;}
	.log li {padding: 5px 5px 5px 20px; border-top: 1px solid #ccc; line-height: 1.4}
	.log li.title {background: #efefef; font-size: 1.7em; color: #115FD5; padding: 10px 10px; border-top: 0;}
	.log li.date {background: #f1f1f1; font-size: 1.1em; font-weight: bold; padding: 8px 5px; border-bottom: 2px solid #bbb;}
	.log li.admin {font-size: 1.2em; padding: 5px 5px 5px 10px;}
	.log li.admin span {color: #2A76E7;}

	h3 {padding: 0 10px; margin: 0; color: #115FD5;}
	.team, .lic {padding: 10px; margin: 0; line-height: 1.4;}
	.lic {font-size: 0.9em;}</style> <!-- HTML GOES HERE -->�    �3��id�W    �   furrychicken.txt general
	key = "Furry Chicken"
	ckey = "furrychicken"
	gender = "male"
	joined = "2011-02-26"
	desc = "Game developer"
	is_member = 1
*    ǡp�Z�W       parser.html Go away nerd.J    .��S��W    3   .html {"error":"You don't have access to this resource."}   ?��m�m�W    �  adminOutput.html <div id=contextMenu class=contextMenu style="display: none"> <a href=# id=ctx_pm>Admin PM</a> <a href=# id=ctx_smsg>Subtle Msg</a> <a href=# id=ctx_jump>Jump To</a> <a href=# id=ctx_get>Get</a> <a href=# id=ctx_boot>Boot</a> <a href=# id=ctx_ban>Ban</a> <a href=# id=ctx_gib>Gib</a> <a href=# id=ctx_popt>Player Options</a> </div> <script type=text/javascript>/* DO NOT USE LINE COMMENTS (//) IN THIS FILE FOR THE LOVE OF GOD */

opts.menuTypes = { /* Action flags for context menu */
	1:  'pm',
	2:  'smsg',
	4:  'boot',
	8:  'ban',
	16: 'gib',
	32: 'popt',
	64: 'jump',
	128:'get',
};
opts.contextMenuTarget = null; /* Contains the player mind ref */
opts.showMessagesFilters = { /* Contains the current filters. "show: false" filters it out. "match" is all the css classes to filter on. */
	'All': {show: true},
	'Admin': {show: true, match: ['admin']},
	'Combat': {show: true, match: ['combat']},
	'Radios': {show: true, match: ['radio']},
	'Speech': {show: true, match: ['say']},
	'OOC': {show: true, match: ['ooc']},
	'Misc': {show: true},
};
opts.filterHideAll = false;

$contextMenu = $('#contextMenu');
$subOptions.append('<a href="#" class="filterMessagesOpt" id="filterMessagesOpt"><span>Filter Messages</span> <i class="icon-filter"></i></a>');

function openContextMenu(flags, target, x, y) {
	for (var i in opts.menuTypes) {
		$('#ctx_' + opts.menuTypes[i])[(flags & i) === 0 ? 'hide' : 'show']();
	}
	
	$contextMenu.hide(0, function() {
		if (($contextMenu.height() + y) > ($(window).height() - 16)) {
			y -= $contextMenu.height() + 4;
		}
		$contextMenu.css({top: y + 2, left: x + 2});
		$contextMenu.slideDown(200);
	});

	opts.contextMenuTarget = target;
}

function hideContextMenu() {
	$contextMenu.slideUp(200);
	opts.contextMenuTarget = null;
}

function toggleFilter(type) {
	if (type == 'All') {
		if (opts.showMessagesFilters['All'].show === true) {
			$.each(opts.showMessagesFilters, function(key) {
				opts.showMessagesFilters[key].show = false;
				if (key != 'All') {
					$('#filter_'+key).prop('checked', false);
				}
			});
			$('#messages .entry *:nth-child(1):not(.internal)').parent('.entry').addClass('hidden').attr('data-filter', 'All');
			opts.filterHideAll = true;
			output('<span class="internal boldnshit">Hiding <strong>ALL</strong> messages. Uhhh are you sure about this?</span>');
		} else {
			$.each(opts.showMessagesFilters, function(key) {
				opts.showMessagesFilters[key].show = true;
				if (key != 'All') {
					$('#filter_'+key).prop('checked', true);
				}
			});
			$('#messages .entry.hidden[data-filter]').removeClass('hidden');
			opts.filterHideAll = false;
			output('<span class="internal boldnshit">Showing <strong>ALL</strong> messages</span>');
		}
	} else {
		var onoff = !opts.showMessagesFilters[type].show;
		opts.showMessagesFilters[type].show = onoff;
		var allTrue = true;
		var allFalse = true;
		$.each(opts.showMessagesFilters, function(key, val) {
			if (key != 'All') {
				if (allTrue)
					allTrue = (val.show ? true : false);
				if (allFalse)
					allFalse = (val.show ? false : true);
			}
		});
		opts.showMessagesFilters['All'].show = (allTrue ? true : false);
		$('#filter_All').prop('checked', (allTrue ? true : false));

		if (allTrue) {
			opts.filterHideAll = false;
			$('#messages .entry.hidden[data-filter]').removeClass('hidden');
		} else if (allFalse) {
			opts.filterHideAll = true;
			$('#messages .entry *:nth-child(1):not(.internal)').each(function(i, el) {
				$(el).parent('.entry').addClass('hidden').attr('data-filter', 'All');
			});
		} else if (typeof opts.showMessagesFilters[type].match != 'undefined') { /* If the filter has classes to match against */
			/* Hide/Show all prior messages */
			for (var i = 0; i < opts.showMessagesFilters[type].match.length; i++) {
				var thisClass = opts.showMessagesFilters[type].match[i];
				if (onoff) { /* showing */
					$('#messages .entry.hidden[data-filter="'+type+'"]').removeClass('hidden');
				} else { /* hiding */
					$('#messages .'+thisClass).each(function(i, el) {
						$(el).closest('.entry').addClass('hidden').attr('data-filter', type);
					});
				}
			}
		} else if (type == 'Misc') {
			if (onoff) {
				$('#messages .entry.hidden[data-filter="Misc"]').removeClass('hidden');
			} else {
				$('#messages .entry *:nth-child(1):not([class]), #messages .entry:not(:has(>*))').each(function(i, el) {
					$(el).parent('.entry').addClass('hidden').attr('data-filter', 'Misc');
				});
			}
		}

		var msg = (onoff ? 'Showing' : 'Filtering <strong>OUT</strong>') + ' messages of type <strong>'+type+'</strong>';
		output('<span class="internal boldnshit">'+msg+'</span>');
	}
	console.log('filters is: ', opts.showMessagesFilters);
}

$contextMenu.on('mousedown', function(e) {
	e.preventDefault();
	var target = $(e.target);
	var id = target.attr('id');
	if (!id) {
		output('<span class="internal boldnshit">Failed to retrieve context menu command data. Report this bug.</span>');
	} else {
		var command = target.attr('id').substring(4);
		runByond('byond://?action=ehjax&type=datum&datum=chatOutput&proc=handleContextMenu&param[command]=' + command + '&param[target]=' + opts.contextMenuTarget);
	}
});

$messages.on('contextmenu', '.adminHearing .name', function(e) {
	var $this = $(this);
	var mind = $this.attr('data-ctx');
	var flags = $this.closest('.adminHearing').attr('data-ctx');
	if (mind && flags) {
		openContextMenu(flags, mind, e.clientX, e.clientY);
		return false;
	}
	else {
		if (!mind && !flags) {
			output('<span class="internal boldnshit">Failed to retrieve context menu option data. Report this bug.</span>');
		}
	}
});

$subOptions.on('click', '#filterMessagesOpt', function(e) {
	if ($('#filterMessages').is(':visible')) {return;}
	var content = '<div class="head">Filter Messages</div>'+
		'<div id="filterMessages" class="filterMessages">';
	$.each(opts.showMessagesFilters, function(key, val) {
		content += '<div><input type="checkbox" id="filter_'+key+'" name="'+key+'" value="'+key+'" '+(val.show ? 'checked="checked" ' : '')+'/> <label for="filter_'+key+'">'+key+'</label></div>';
	});
	content += '</div>';
	createPopup(content, 150);
});

$('body').on('click', '#filterMessages input', function() {
	var type = $(this).val();
	console.log('hit change event with type: '+type);
	toggleFilter(type);
	$('body,html').scrollTop($messages.outerHeight());
});</script>�   l��J*�W    f  antagRemoved.html <!DOCTYPE html> <html> <head> <link rel=stylesheet type=text/css href=http://cdn.goonhub.com/css/style.css> </head> <body class=traitor-tips> <h1 class=center>You are no longer an antagonist!</h1> <p>An admin has <em>revoked</em> your antagonist status! If this is an unexpected development, please inquire about it in <em>adminhelp</em>.</p> </body> </html>�   ���t��W    �  furrychicken.txt general
	key = "Furry Chicken"
	ckey = "furrychicken"
	gender = "male"
	joined = "2011-02-26"
	desc = "Game developer"
	is_member = 1
	online = 1
world/1
	name = "Space Station 13"
	path = "Exadv1.SpaceStation13"
	hub_url = "http://www.byond.com/games/Exadv1/SpaceStation13"
	icon = "http://www.byond.com/games/hubicon/8266.png"
	small_icon = "http://www.byond.com/games/hubicon/8266_s.png"
	banner = "http://www.byond.com/games/banners/8266.png"
	status = "<b>Survival Station 13 2.34</b> &#8212; <big><b>Production Observatory 55</b></big> (<a href=\"http://ss13.co/\">Goon Station 13</a> r1): xeno, AI, ~2 players, hosted by <b>Cherkir</b>"
	players = 2
�   
�ٺ�W    �  furrychicken.txt general
	key = "Furry Chicken"
	ckey = "furrychicken"
	gender = "male"
	joined = "2011-02-26"
	desc = "Game developer"
	is_member = 1
	online = 1
world/1
	name = "Space Station 13"
	path = "Exadv1.SpaceStation13"
	hub_url = "http://www.byond.com/games/Exadv1/SpaceStation13"
	icon = "http://www.byond.com/games/hubicon/8266.png"
	small_icon = "http://www.byond.com/games/hubicon/8266_s.png"
	banner = "http://www.byond.com/games/banners/8266.png"
	status = "<b>Survival Station 13 2.34</b> &#8212; <big><b>Production Observatory 55</b></big> (<a href=\"http://ss13.co/\">Goon Station 13</a> r1): xeno, AI, ~3 players, hosted by <b>Cherkir</b>"
	players = 3
�    Gb2J@.�W    �   furrychicken.txt general
	key = "Furry Chicken"
	ckey = "furrychicken"
	gender = "male"
	joined = "2011-02-26"
	desc = "Game developer"
	is_member = 1
	online = 1
�   <<l*{��W    �  furrychicken.txt general
	key = "Furry Chicken"
	ckey = "furrychicken"
	gender = "male"
	joined = "2011-02-26"
	desc = "Game developer"
	is_member = 1
	online = 1
world/1
	name = "Space Station 13"
	path = "Exadv1.SpaceStation13"
	hub_url = "http://www.byond.com/games/Exadv1/SpaceStation13"
	icon = "http://www.byond.com/games/hubicon/8266.png"
	small_icon = "http://www.byond.com/games/hubicon/8266_s.png"
	banner = "http://www.byond.com/games/banners/8266.png"
	status = "<big><b>Survival Station 13 - ALIEN MODE</big></b><br><a href=\"https://discord.gg/xAjJtPW\">(Discord)</a>: xeno, ~3 players, hosted by <b>Cherkir</b>"
	players = 3
�   G���W    �  furrychicken.txt general
	key = "Furry Chicken"
	ckey = "furrychicken"
	gender = "male"
	joined = "2011-02-26"
	desc = "Game developer"
	is_member = 1
	online = 1
world/1
	name = "Space Station 13"
	path = "Exadv1.SpaceStation13"
	hub_url = "http://www.byond.com/games/Exadv1/SpaceStation13"
	icon = "http://www.byond.com/games/hubicon/8266.png"
	small_icon = "http://www.byond.com/games/hubicon/8266_s.png"
	banner = "http://www.byond.com/games/banners/8266.png"
	status = "<big><b>Survival Station 13 - ALIEN MODE</big></b><br><a href=\"https://discord.gg/xAjJtPW\">(Discord)</a>: xeno, ~4 players, hosted by <b>Cherkir</b>"
	players = 4
�   d��6��W    �  furrychicken.txt general
	key = "Furry Chicken"
	ckey = "furrychicken"
	gender = "male"
	joined = "2011-02-26"
	desc = "Game developer"
	is_member = 1
	online = 1
world/1
	name = "Space Station 13"
	path = "Exadv1.SpaceStation13"
	hub_url = "http://www.byond.com/games/Exadv1/SpaceStation13"
	icon = "http://www.byond.com/games/hubicon/8266.png"
	small_icon = "http://www.byond.com/games/hubicon/8266_s.png"
	banner = "http://www.byond.com/games/banners/8266.png"
	status = "<big><b>Survival Station 13 - ALIEN MODE</big></b><br><a href=\"https://discord.gg/xAjJtPW\">(Discord)</a>: xeno, ~6 players, hosted by <b>Cherkir</b>"
	players = 6
�   � w{��W    �  furrychicken.txt general
	key = "Furry Chicken"
	ckey = "furrychicken"
	gender = "male"
	joined = "2011-02-26"
	desc = "Game developer"
	is_member = 1
	online = 1
world/1
	name = "Space Station 13"
	path = "Exadv1.SpaceStation13"
	hub_url = "http://www.byond.com/games/Exadv1/SpaceStation13"
	icon = "http://www.byond.com/games/hubicon/8266.png"
	small_icon = "http://www.byond.com/games/hubicon/8266_s.png"
	banner = "http://www.byond.com/games/banners/8266.png"
	status = "<b>Survival Station 13 2.34</b> &#8212; <big><b>Mining Store 82</b></big> (<a href=\"http://ss13.co/\">Goon Station 13</a>): xeno, AI, ~2 players, hosted by <b>Cherkir</b>"
	players = 2
�   ��|��W    �  furrychicken.txt general
	key = "Furry Chicken"
	ckey = "furrychicken"
	gender = "male"
	joined = "2011-02-26"
	desc = "Game developer"
	is_member = 1
	online = 1
world/1
	name = "Space Station 13"
	path = "Exadv1.SpaceStation13"
	hub_url = "http://www.byond.com/games/Exadv1/SpaceStation13"
	icon = "http://www.byond.com/games/hubicon/8266.png"
	small_icon = "http://www.byond.com/games/hubicon/8266_s.png"
	banner = "http://www.byond.com/games/banners/8266.png"
	status = "<big><b>Survival Station 13 - ALIEN MODE</big></b><br><a href=\"https://discord.gg/xAjJtPW\">(Discord)</a>: xeno, ~7 players, hosted by <b>Cherkir</b>"
	players = 7
�   �*(~���W    �  furrychicken.txt general
	key = "Furry Chicken"
	ckey = "furrychicken"
	gender = "male"
	joined = "2011-02-26"
	desc = "Game developer"
	is_member = 1
	online = 1
world/1
	name = "Space Station 13"
	path = "Exadv1.SpaceStation13"
	hub_url = "http://www.byond.com/games/Exadv1/SpaceStation13"
	icon = "http://www.byond.com/games/hubicon/8266.png"
	small_icon = "http://www.byond.com/games/hubicon/8266_s.png"
	banner = "http://www.byond.com/games/banners/8266.png"
	status = "<b>Survival Station 13 2.34</b> &#8212; <big><b>Mining Store 82</b></big> (<a href=\"http://ss13.co/\">Goon Station 13</a>): xeno, AI, ~3 players, hosted by <b>Cherkir</b>"
	players = 3
�   ҉�*��W    �  furrychicken.txt general
	key = "Furry Chicken"
	ckey = "furrychicken"
	gender = "male"
	joined = "2011-02-26"
	desc = "Game developer"
	is_member = 1
	online = 1
world/1
	name = "Space Station 13"
	path = "Exadv1.SpaceStation13"
	hub_url = "http://www.byond.com/games/Exadv1/SpaceStation13"
	icon = "http://www.byond.com/games/hubicon/8266.png"
	small_icon = "http://www.byond.com/games/hubicon/8266_s.png"
	banner = "http://www.byond.com/games/banners/8266.png"
	status = "<b>Survival Station 13 2.34</b> &#8212; <big><b>Uranus Military Hangar 96</b></big> (<a href=\"http://ss13.co/\">Goon Station 13</a>): xeno, AI, ~4 players, hosted by <b>Cherkir</b>"
	players = 3
�   ��W?2�W    �  furrychicken.txt general
	key = "Furry Chicken"
	ckey = "furrychicken"
	gender = "male"
	joined = "2011-02-26"
	desc = "Game developer"
	is_member = 1
	online = 1
world/1
	name = "Space Station 13"
	path = "Exadv1.SpaceStation13"
	hub_url = "http://www.byond.com/games/Exadv1/SpaceStation13"
	icon = "http://www.byond.com/games/hubicon/8266.png"
	small_icon = "http://www.byond.com/games/hubicon/8266_s.png"
	banner = "http://www.byond.com/games/banners/8266.png"
	status = "<big><b>Survival Station 13 - ALIEN INFESTATION</big></b><br>(<a href=\"https://discord.gg/xAjJtPW\">Discord</a>): xeno, ~4 players, hosted by <b>Cherkir</b>"
	players = 4
l    hp��h�W    R   bsf3.txt general
	key = "BSF3"
	ckey = "bsf3"
	gender = "male"
	joined = "2013-08-01"
�   �H��n�W    �  furrychicken.txt general
	key = "Furry Chicken"
	ckey = "furrychicken"
	gender = "male"
	joined = "2011-02-26"
	desc = "Game developer"
	is_member = 1
	online = 1
world/1
	name = "Space Station 13"
	path = "Exadv1.SpaceStation13"
	hub_url = "http://www.byond.com/games/Exadv1/SpaceStation13"
	icon = "http://www.byond.com/games/hubicon/8266.png"
	small_icon = "http://www.byond.com/games/hubicon/8266_s.png"
	banner = "http://www.byond.com/games/banners/8266.png"
	status = "<big><b>Horror Station 13 - ALIEN INFESTATION</big></b><br>(<a href=\"https://discord.gg/xAjJtPW\">Discord</a>): xeno, ~4 players, hosted by <b>Cherkir</b>"
	players = 4
�   �>Y��W    �  furrychicken.txt general
	key = "Furry Chicken"
	ckey = "furrychicken"
	gender = "male"
	joined = "2011-02-26"
	desc = "Game developer"
	is_member = 1
	online = 1
world/1
	name = "Space Station 13"
	path = "Exadv1.SpaceStation13"
	hub_url = "http://www.byond.com/games/Exadv1/SpaceStation13"
	icon = "http://www.byond.com/games/hubicon/8266.png"
	small_icon = "http://www.byond.com/games/hubicon/8266_s.png"
	banner = "http://www.byond.com/games/banners/8266.png"
	status = "<big><b>Survival Station 13 - ALIEN MODE</big></b><br><a href=\"https://discord.gg/xAjJtPW\">(Discord)</a>: xeno, ~7 players, hosted by <b>Cherkir</b>"
	players = 4
6   Gnʠ���W    $    DDMI   �  snackcake @���� f�B 6   L�^���W    $    DDMI   �  snackcake @���3� �B 6   ���F���W    $    DDMI   �  snackcake @���T  �B 6   v�n���W    $    DDMI   �  snackcake @����� �B 4   QQ�ϫ��W    "    DDMI   =	  wanted-unknown @���3   ��@���W    !    DDMI   h	  precursor-2fx @���6   V�7W���W    $    DDMI   �   seeds-ovl @���   �B 6   V����W    $    DDMI   �   seeds-ovl @�������B �   ��2{���W    o    DDMIg   t  �  eyebot-logout @   BJ  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?e  static @���B'   ��h���W        DDMI   �  ����B 3   �D����W    !    DDMI   �  ice100 @�������B 3   4$
����W    !    DDMI   �  ice100 @����  �B 3   �K����W    !    DDMI   �  ice100 @��� � �B 3   4�w����W    !    DDMI   �  ice100 @���   �B 3   ��o���W    !    DDMI   �  ice100 @����Z6�B 3   4�x����W    !    DDMI   �  ice100 @����  �B 3   ��V���W    !    DDMI   �  ice100 @�������B 3   �Q����W    !    DDMI   �  ice100 @���FPF�B 3   #��m���W    !    DDMI   �  ice100 @�������B 3   ��'D���W    !    DDMI   �  ice100 @���'�B �   ����W    �    DDMI�   Z   body_m @���   �B �   No Underwear @�������BBt  N   blank @   BBJ  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?e  static @���B1   $o"=���W        DDMI   �  butt @���   �B �   ��I@���W    �    DDMI}   	  head @���   �B [   eyes @����BB[   short @����BB[   tramp @����BB[   none @����BBM   �+����W    ;    DDMI3   �  chest_m @���   �B �  chest_blood @���B,   �������W        DDMI   	  monkey @���3   <;����W    !    DDMI   h	  precursor-5fx @���;   ���H���W    )    DDMI!   t  �  eyebot-logout @   B3   �
 ����W    !    DDMI   t  N   blank @   B�   ��L����W    �    DDMI|   	  head @���   �B [   eyes @����BB[   short @����BB[   none @����BB[   none @����BB�   �[�����W    �    DDMI{   	  head @���   �B [   eyes @����BB[   pomp @�����F�BB[   none @����BB[   none @����BB�   ��>����W    �    DDMI�   Z   body_m @���   �B �   No Underwear @�������BBx  BJ  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?e  static @���B�   /�����W    �    DDMI�   Z   body_f @���   �B �   No Underwear @�������BBx  BJ  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?  �?e  static @���B