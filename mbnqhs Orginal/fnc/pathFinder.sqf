// Written by mbnq for DayZ Shadow of Chernarus Elite server
// www.mbnq.pl
// mbnq00@gmail.com
//
// Hunter Seeker aka Survivor Simulation (Little Girl)
// path finder

sleep 5;

private [
	"_IsEnemyNear",
	"_groupWeight",
	"_casualties",
	"_injured",
	"_wpPos",
	"_inPlace",
	"_checkpoint",
	"_fnc_selectRandom",
	"_fnc_checkpoint",
	"_marker",
	"_markertemp"
	];

_fnc_selectRandom = {
    _this select (floor random (count _this))
};

// places being used as checkpoints for random bot patrol
fnc_checkpoint = {
 _checkpoint =  [
			 [7302.31,8035.76,0],
			 [4454.24,10729.6,0],
			 [5743.77,9886.94,0],
			 [4000.64,8501.05,0],
			 [4085.07,9212.66,0],
			 [7302.31,8035.76,0],
			 [4454.24,10729.6,0],
			 [5743.77,9886.94,0],
			 [4190.55,6605.76,0],
			 [4000.64,8501.05,0],
			 [4085.07,9212.66,0],
			 [7302.31,8035.76,0],
			 [4454.24,10729.6,0],
			 [5743.77,9886.94,0],
			 [4000.64,8501.05,0],
			 [4085.07,9212.66,0]
		] call _fnc_selectRandom;
};

waitUntil {sleep 0.1; ((count units HS_group) > 0)};

_groupWeight 	= (count units HS_group);
_hasWaypoint 	= false;
_radius		= 2500;
_wpPos		= (getPos (leader HS_group));


while {(count units HS_group) > 0} do {

// checks
 _IsEnemyNear 	= { (!isNull(_x findNearestEnemy _x)) } forEach units HS_group; 
 _casualties 	= (count units HS_group) < _groupWeight;
 _injured	= { (getDammage _x) > 0.2 } forEach units HS_group;
 _hasWaypoint	= ((count waypoints HS_group) > 1);
 if (count ((waypoints HS_group) select (currentWaypoint HS_group)) > 0) then {_wpPos = getWPPos ((waypoints HS_group) select (currentWaypoint HS_group))};
 _inPlace	= ((leader HS_group) distance _wpPos < 20);

 sleep 0.1;
 if (!_IsEnemyNear && !_casualties && !_injured) then {
	// idle state
	HS_group setBehaviour "AWARE";
	HS_group setCombatMode "YELLOW";
	HS_group enableIRLasers true;
	{ _x setUnitPos "AUTO"; } forEach units HS_group;
 } else {
	// combate state
	HS_group setBehaviour "COMBAT";
	HS_group setCombatMode "RED";
	HS_group enableIRLasers true;
	{ _x setUnitPos "Middle"; } forEach units HS_group;
 };

 sleep 0.1;
 if (_inPlace) then {
	// hint "czyszcze WP";
	while {(count (waypoints (HS_group))) > 0} do { deleteWaypoint ((waypoints (HS_group)) select 0); };
 };

 sleep 0.1;
 if (!_hasWaypoint) then {
	call fnc_checkpoint;
	_checkpoint = [(_checkpoint select 0) + ceil(random _radius)* cos ceil(random 360) + ceil(random _radius)* cos ceil(random 360),(_checkpoint select 1) + ceil(random _radius)* cos ceil(random 360) + ceil(random _radius)* cos ceil(random 360),0];
	HS_group addWaypoint [_checkpoint, 0];
	[HS_group,0] setWaypointCompletionRadius 50;
	// hint format["przydzielono nowy waypoint %1",_checkpoint];
	diag_log format["[MBNQHS]: Going from %1 to %2",(mapGridPosition (getPos (leader HS_group))),(mapGridPosition _checkpoint)];

	if (HS_inEditor) then {
			_marker = {
				_markertemp = createMarkerLocal [format["%1%2", floor(random 1024),floor(random 1024)], _checkpoint];
				_markertemp setMarkerShapeLocal "ELLIPSE";
				_markertemp setMarkerTypeLocal "mil_circle";
				_markertemp setMarkerSizeLocal [55, 55];
				_markertemp setMarkerBrushLocal "SolidBorder";
				_markertemp setMarkerAlphaLocal 1;
			}; deleteMarkerLocal _markertemp; call _marker;
	};
  	sleep 1;
 };

// hint format["%1 %2",_inPlace,_hasWaypoint];
sleep 5;
};
