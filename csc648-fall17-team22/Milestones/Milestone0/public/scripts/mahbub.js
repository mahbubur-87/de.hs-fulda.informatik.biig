//const http = require('http');

var me = {
	name: 'Mahbubur Rahman',
	dob: '02-08-1987',
	origin: 'Bangladesh',
	current: 'Germany',	
	contact: {
		address: [
			{
				type: 'Present',	
				houseNo: 'Room No 112',
				street: 'Heinrich-von-Bibra-Platz 3',
				postCode: '36037',
				city: 'Fulda',
				country: 'Germany'
			}
		],
		phone: '+4915211413724',
		email: 'mahbubur.rahman@informatik.hs-fulda.de'
	},
	qualification: {
		academic: [
			{
				degree: 'Master',
				group: 'Science',				
				university: 'Fulda University of Applied Sciences',
				department: 'Applied Computer Science',				
				program: 'Global Software Development',
				duration: '2017 - 2019'
			},
			{
				degree: 'Bachelor',
				group: 'Science',				
				university: 'International Islamic University Chittagong',
				department: 'Computer Science',				
				program: 'Computer Science and Engineering',
				duration: '2005 - 2009'
			}
		],
		professional: [
			{
				company: '',
				contact: {
					address: [
						{
							type: 'Present',	
							houseNo: '',
							street: '',
							postCode: '',
							city: '',
							country: ''
						}
					],
					phone: '',
					fax: '',
					email: ''
				},
				position: '',
				duration: '',
				focusAreas: []
			}
		]
	}
};

var meInHtml = '';

function checkValue (value) {
	if (typeof value  === 'object') {
		if (value.length) {
			generateTableForArray(value);			
		} else {
			generateTableForObject(value);
		}
	} else {
		meInHtml += value.toString();		
	}
}

function generateTableForObject (jsObj) {
	meInHtml += '<table><tbody>';
	
	for (var key in jsObj) {
		meInHtml += ('<tr><td style="border: thin dotted">' + key + '</td><td style="border: thin dotted">');
		checkValue(jsObj[key]);
		meInHtml += '</td></tr>';		
	}

	meInHtml += '</tbody></table>';	
}

function generateTableForArray (jsArr) {
	if (typeof jsArr[0] !== 'object') {			
		meInHtml += jsArr.join(', ');
		return;			
	}
	
	var i, key;

	meInHtml += '<table><tbody>';
	
	meInHtml += '<tr>';

	for (key in jsArr[0]) {
		meInHtml += ('<td style="border: thin dotted">' + key + '</td>');
	}

	meInHtml += '</tr>';
	
	for (i = 0; i < jsArr.length; i++) {
		meInHtml += '<tr>';

		for (key in jsArr[i]) {
			meInHtml += '<td style="border: thin dotted">';
			checkValue(jsArr[i][key]);
			meInHtml += '</td>';
		}

		meInHtml += '</tr>';
	}	

	meInHtml += '</tbody></table>';	
}

function loadMyself () {
	generateTableForObject(me);
	document.getElementById('myself').innerHTML = meInHtml;					
}

/*function getAboutMe () {
	var port = document.getElementById('port').value;
	
	if (!port) {
		alert('Please enter correct port number');
	}

	http.get('127.0.0.1:' + port + '/about-me', function (res) {		
		res.on('error', function (err) {
			console.log('response error: ', err);
		});

		res.setEncoding('UTF-8');

		var jsnMsg = '';

		res.on('data', function (chunk) {
			jsnMsg += chunk;
		});

		res.on('end', function () {
			var jsnObj = JSON.parse(jsnMsg);
			meInHtml = '';
			generateTableForObject(jsnObj);
			document.getElementById('nodeMyself').innerHTML = meInHtml;
		});
	})
	.on('error', function (err) {
		console.log('request error: ', err);
	});
}*/
