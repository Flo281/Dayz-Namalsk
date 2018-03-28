// Written by mbnq for DayZ Shadow of Chernarus Elite server
// www.mbnq.pl
// mbnq00@gmail.com
//
// Hunter Seeker aka Survivor Simulation (Little Girl)
// monitor

if (HS_inEditor) then {

 [] spawn {
	private [
		"_markertemp",
		"_marker"
		];

	_marker = {
		_markertemp = createMarkerLocal [format["%1%2", floor(random 1024),floor(random 1024)], (getPos (leader HS_group))];
		_markertemp setMarkerShapeLocal "ELLIPSE";
		_markertemp setMarkerTypeLocal "mil_circle";
		_markertemp setMarkerSizeLocal [30, 30];
		_markertemp setMarkerBrushLocal "SolidBorder";
		_markertemp setMarkerAlphaLocal 1;
		_markertemp setMarkerColorLocal "ColorGreen";
	}; call _marker;

	while {HS_inEditor} do {
		_markertemp setMarkerPosLocal (getPos (leader HS_group));
		sleep 0.1;
	};
 };

 [] spawn {
    while {HS_inEditor} do {

	private [
		"_markerpath",
		"_markertemppath"
	];

	_markerpath = {
		_markertemppath = createMarkerLocal [format["%1%2", floor(random 2048),floor(random 2048)], (getPos (leader HS_group))];
		_markertemppath setMarkerShapeLocal "ELLIPSE";
		_markertemppath setMarkerTypeLocal "mil_circle";
		_markertemppath setMarkerSizeLocal [2, 2];
		// _markertemppath setMarkerBrushLocal "SolidBorder";
		_markertemppath setMarkerAlphaLocal 1;
		_markertemppath setMarkerColorLocal "ColorBlack";
	};
	
	// player attachTo [(vehicle(leader HS_group)),[0,0,5]]; 
	if ( (player distance (leader HS_group)) > 30 ) then {player setPos (getPos (vehicle(leader HS_group)))};
	call _markerpath;
	sleep 2;
    };
 };

};