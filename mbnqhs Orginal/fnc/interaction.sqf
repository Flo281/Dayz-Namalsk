// Written by mbnq for DayZ Shadow of Chernarus Elite server
// www.mbnq.pl
// mbnq00@gmail.com
//
// Hunter Seeker aka Survivor Simulation (Little Girl)
// interaction module

private [
	"_IsEnemyNear",
	"_inVehicle",
	"_IsVehicleNear",
	"_vehicle2ST",
	"_debug",
	"_knowsAbout",
	"_iknowthisvehicle",
	"_vehiclehasfuel",
	"_isTentNear",
	"_nearestTent",
	"_tempVeh"
	];

_debug = false;
_knowsAbout = [];

waitUntil {sleep 0.1; ((count units HS_group) > 0)};

while {(count units HS_group) > 0} do {
 // checks
 _IsEnemyNear 	= { (!isNull(_x findNearestEnemy _x)) } forEach units HS_group;
 _inVehicle 	= { vehicle _x != _x } forEach units HS_group;
 _IsVehicleNear = { (!isNull(getPos _x nearestObject "LandVehicle")) } forEach units HS_group;
 _isTentNear	= { (!isNull(getPos _x nearestObject "Land_A_tent")) } forEach units HS_group;

 if (_debug) then {hint format["EnemyNear %1 InVeh %2 VehNear %3 knowsabout %4 iktv %5",_IsEnemyNear,_inVehicle,_IsVehicleNear,_knowsAbout,_iknowthisvehicle]};

 // i found a tent
 sleep 0.1;

 if ( _isTentNear && !_inVehicle ) then {

  _nearestTent = nearestObject [getPos (leader HS_group), "Land_A_tent"];
  _iknowthisvehicle = (_nearestTent in _knowsAbout);

   if ( !_iknowthisvehicle && (getDammage _nearestTent) < 0.1 && ( ((getPos (leader HS_group)) distance _nearestTent < 35) ) ) then {

		{_x allowDammage false} forEach (units HS_group);
		sleep 1;
		_tempVeh = "Grenade" createVehicle (getPos _nearestTent);
		sleep 0.1;
		_tempVeh = "Grenade" createVehicle (getPos _nearestTent);
		sleep 1;
		{_x allowDammage true} forEach (units HS_group);

  		_knowsAbout = _knowsAbout + [_nearestTent];
		diag_log format["[MBNQHS]: Found a tent at %1",(mapGridPosition (getPos (leader HS_group)))];
   };

 };


 // i found a vehicle
 sleep 0.1;

 if ( _IsVehicleNear && !_inVehicle ) then {

  _vehicle2ST = nearestObject [getPos (leader HS_group), "landvehicle"];
  _iknowthisvehicle = (_vehicle2ST in _knowsAbout);
  _vehiclehasfuel = ((fuel _vehicle2ST) > 0);

  if ( (!_iknowthisvehicle) && !_inVehicle ) then {

	if ( (canMove _vehicle2ST) && (count crew _vehicle2ST == 0) && _vehiclehasfuel )then {

				if (_debug) then {hint "taking vehicle"};
				{_x assignAsCargo _vehicle2ST} foreach units HS_group; 
				(leader HS_group) assignAsDriver _vehicle2ST;
				[units HS_group] orderGetIn true;
  				_knowsAbout = _knowsAbout + [_vehicle2ST];
				diag_log format["[MBNQHS]: Found ready to use vehicle at %1",(mapGridPosition (getPos (leader HS_group)))];
				sleep 10;
	};

	if ( (!(canMove _vehicle2ST)) or !_vehiclehasfuel ) then {
		
	   if (((getPos (leader HS_group)) distance _vehicle2ST) < 45) then {
		
		// {_x doFire _vehicle2ST} forEach (units HS_group);

		{_x allowDammage false} forEach (units HS_group);
		sleep 1;
		_tempVeh = "Grenade" createVehicle (getPos _vehicle2ST);
		sleep 1;
		{_x allowDammage true} forEach (units HS_group);

	   };

  		_knowsAbout = _knowsAbout + [_vehicle2ST];
		diag_log format["[MBNQHS]: Found broken vehicle at %1",(mapGridPosition (getPos (leader HS_group)))];

	};

  };

 };


 sleep 0.1;
 if ( _inVehicle ) then {

  	if ( (!(canMove (vehicle (leader HS_group)) )) or ((fuel (vehicle (leader HS_group))) < 0.001 ) or _isTentNear ) then {
		{ unassignVehicle _x } forEach crew _vehicle2ST;
		{ _x leaveVehicle (vehicle _x) } forEach units HS_group;
		diag_log format["[MBNQHS]: Leaving vehicle at %1",(mapGridPosition (getPos (leader HS_group)))];
	};


	if ((speed(vehicle (leader HS_group))) < 2) then {
		sleep 30;
			if !(isEngineOn (vehicle (leader HS_group))) then {
			{ _x leaveVehicle (vehicle _x) } forEach units HS_group;
			diag_log format["[MBNQHS]: Leaving vehicle at %1, engine not running",(mapGridPosition (getPos (leader HS_group)))];
	};
	};

	if (_IsEnemyNear) then {
		{ unassignVehicle _x } forEach crew _vehicle2ST;
		{ _x leaveVehicle (vehicle _x) } forEach units HS_group;
  		_knowsAbout = _knowsAbout - [(vehicle (leader HS_group))];
		diag_log format["[MBNQHS]: Engaging enemy with vehicle at %1",(mapGridPosition (getPos (leader HS_group)))];
	};

 };

sleep 5;
};