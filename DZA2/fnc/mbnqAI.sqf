// Written by mbnq for DayZ Shadow of Chernarus Elite server
// www.mbnq.pl
// mbnq00@gmail.com

sleep (random 2);
if (HS_inEditor) then {} else {if (!isServer) exitWith {};};
// if (HS_inEditor) then {} else {if ((random 1) < 0.20) exitWith {diag_log format ["[MBNQAI]: Skipped for %1",_this select 0]};};	// chance for not loading script for unit

private [
	"_unit",
	"_basePos",
	"_refreshRate",
	"_debug",
	"_hasBase",
	"_inVehicle",
	"_isWounded",
	"_isBadlyWounded",
	"_isStatusRed",
	"_canWalk",
	"_hasCover",
	"_IsEnemyNear",
	"_IsVehicleNear",
	"_healChance",
	"_findCoverChance",
	"_magazines",
	"_magazine",
	"_IsAway",
	"_smokeChance",
	"_awaydist",
	"_tempVeh",
	"_smokesAmount",
	"_enemy",
	"_stealVehChance",
	"_vehicle2ST",
	"_MilBasePos",
	"_AtMilBase",

	"_inForest",
	"_CampInForest",
	"_OnKnees",
	"_grenadesAmount",
	"_grenadeChance",
	"_enemyInVeh",
	"_posCheck1",
	"_posCheck2",
	"_camping",
	"_disableFnc"
	];



// ======================================= CFG =======================================

_debug = false;
_disableFnc = true;
_awaydist = 0;		// DISABLED, HS
_refreshRate = 4;
_healChance = 0.10;
_smokeChance = 0.75;
_smokesAmount = round(random 2);
_grenadeChance = 0.50;
_grenadesAmount = round(random 1);
_findCoverChance = 0;	// DISABLED, HS
_stealVehChance = 0;	// DISABLED, HS
_CampInForest = 0;	// DISABLED, HS
_MilBasePos = [0,0,0];	// DISABLED, HS

// ======================================= CFG =======================================

_unit = _this select 0;
_basePos = _this select 1;
diag_log format ["[MBNQAI]: Running for HS %1",_unit,_basePos];

if (isNil ("_basePos")) then {_hasBase = false} else {_hasBase = true};

// main loop
while {alive _unit} do 
{
 // checks
 _inVehicle = ( vehicle _unit != _unit );
 _isWounded = ( getDammage _unit > 0.1 );
 _isBadlyWounded = ( getDammage _unit > 0.4 );
 _isStatusRed = ( getDammage _unit > 0.6 );
 _canWalk = ( canStand _unit );
 _IsEnemyNear = (!isNull(_unit findNearestEnemy _unit));
 _IsVehicleNear = (!isNull(getPos _unit nearestObject "LandVehicle"));
 _hasCover = ( !( (surfaceType position _unit) in ["#CRGrit1","#CRTarnac","#CRConcrete"] ) );	// temp solution
 _IsAway = (_unit distance _basePos > _awaydist);
 _AtMilBase = ( _unit distance _MilBasePos < 50 );
 _inForest = ( (surfaceType position _unit) in ["#CRForest1","#CRForest2"] );
 _OnKnees = ( (unitPos _unit) in ["Middle"] );
 if (isNil ("_posCheck2")) then {_camping = false} else {_camping = ( _posCheck1 distance _posCheck2 < 2 )};

if (_debug) then {hint format["HasBase:%1 InVeh: %2 IsWounded: %3 IsBadlyWounded: %4 IsStatusRed: %5 CanWalk: %6 HasCover: %7 IsTargetNear: %8 IsAway %9 Smokes: %10 Vehicle Near: %11 InForest: %12 OnKnees: %13 Grenades: %14 Camper: %15",_hasBase,_inVehicle,_isWounded,_isBadlyWounded,_isStatusRed,_canWalk,_hasCover,_IsEnemyNear,_IsAway,_smokesAmount,_IsVehicleNear,_inForest,_OnKnees,_grenadesAmount,_camping]}; 


// functions
// ***
_posCheck1 = getPos _unit;
if (!_inVehicle) then {

// scatter
sleep 0.1;
 if ( _Camping && !_inVehicle ) then {
	if ( !_IsEnemyNear && ((random 1) < 0.25) ) then {

		if (_debug) then {hint "camped, changing pos"};
		_unit commandMove [((getPos _unit) select 0) + ceil(random 50)* cos ceil(random 360) + ceil(random 50)* cos ceil(random 360),((getPos _unit) select 1) + ceil(random 50)* cos ceil(random 360) + ceil(random 50)* cos ceil(random 360),0];
		_unit setUnitPos "Middle";
		sleep 15;
		_unit setUnitPos "AUTO";

	};
 };

//add mags
sleep 0.1;
 if ( ((random 1) < 0.50) && (primaryweapon _unit != "") ) then {
	_weapon = primaryweapon _unit;
	_magazines = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
	_magazine = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines") select 0;
	_mags = magazines _unit;

	if (!({_x in _magazines} count _mags > 1)) then {
		if (_debug) then {hint format["Addmag. Mags %4 Type %3",_weapon,_magazine,_mags,{_x in _magazines} count _mags]};
		_unit addMagazine _magazine;
	};
 };

// get cover --- DISABLED FOR HS ---
sleep 0.1;
if (!_hasCover && !_disableFnc) then {
 if ( ((random 1) < _findCoverChance) && !_inVehicle ) then {
	if ( !_hasCover && !isWalking _unit) then {

		if (_debug) then {hint "looking for cover"};

		_unit commandMove [((getPos _unit) select 0) + ceil(random 100)* cos ceil(random 360) + ceil(random 100)* cos ceil(random 360),((getPos _unit) select 1) + ceil(random 100)* cos ceil(random 360) + ceil(random 100)* cos ceil(random 360),0];
		if (_debug) then {hint "changing pos"};
		sleep 15;

	};
 };
};

// enemy detected, stop wp, engage !
sleep 0.1;

if ( _IsEnemyNear && !_inVehicle && ((random 1) < 0.25 ) ) then {
 if ( (_unit findNearestEnemy _unit) distance _unit < 400 ) then {

	_unit lockWP true;
	if (_debug) then {hint "enemy near, ignore WP"};

 } else {

	_unit lockWP false;
	if (_debug) then {hint "no enemy, WP"};

 };
};

// camp in forest if wounded in forest --- DISABLED FOR HS ---
sleep 0.1;
 if ( !_disableFnc ) then {

		// doStop _unit;
		if (_debug) then {hint "wounded, taking cover in forest"};
		_unit setUnitPos "DOWN";
 };

// stay crouch outside forest --- DISABLED FOR HS ---
sleep 0.1;
if ( !_disableFnc ) then {
 if ( !_inForest && !_OnKnees ) then {

		if (_debug) then {hint "not in forest, crouching"};
		_unit setUnitPos "Middle";
 } else {

		_unit setUnitPos "AUTO";
		if (_debug) then {hint "in forest, UnitPos auto"};

 };
};

// heal
sleep 0.1;
 if ( ((random 1) < _healChance) && !_inVehicle ) then {
	if (_isWounded && _hasCover) then {

				if (_debug) then {hint "healing"};

				_unit disableAI "TARGET"; _unit disableAI "AUTOTARGET"; _unit disableAI "MOVE";
				_unit playActionNow "Medic";
				sleep 6;
				_unit setDamage 0;
				_unit enableAI "TARGET"; _unit enableAI "AUTOTARGET"; _unit enableAI "MOVE";
	};
 };

// smoke me
sleep 0.1;
if (_isWounded) then {
 if ( ((random 1) < _smokeChance) && !_inVehicle  && _IsEnemyNear ) then {
	if (_smokesAmount > 0) then {
		if (_debug) then {hint "smoke"};
		_smokesAmount = _smokesAmount - 1;
		_enemy = _unit findNearestEnemy _unit;
		if ( daytime<6 || daytime>22 ) then {
			_tempVeh = "F_40mm_White" createVehicle [(getPos _enemy) select 0, (getPos _enemy) select 1, 150];
		} else {
			if (!_inForest) then {_tempVeh = "SmokeShell" createVehicle (position _unit)};
		};
		diag_log format["[MBNQHS]: Using smoke at %1",(mapGridPosition (position _unit))];
	};
 };
};

// throw grenade
sleep 0.1;
if ( _IsEnemyNear && !_inVehicle ) then {
 if ( ((random 1) < _grenadeChance) && ((_unit findNearestEnemy _unit) distance _unit < 65) ) then {
	if (_grenadesAmount > 0) then {
		if (_debug) then {hint "grenade !"};
		_grenadesAmount = _grenadesAmount - 1;
		_enemy = _unit findNearestEnemy _unit;
		_tempVeh = "Grenade" createVehicle [((getPos _enemy) select 0) + ceil(random 35)* cos ceil(random 360) + ceil(random 35)* cos ceil(random 360) + 5,((getPos _enemy) select 1) + ceil(random 35)* cos ceil(random 360) + ceil(random 35)* cos ceil(random 360) - 5,1];
		diag_log format["[MBNQHS]: Using grenade at %1",(mapGridPosition (position _unit))];
	};
 };
};

// stop enemy vehicle !
sleep 0.1;
if ( _IsEnemyNear && !_inVehicle ) then {
 _enemy = _unit findNearestEnemy _unit;
 _enemyInVeh = ((speed _enemy) > 30);
 if ( (_enemy distance _unit < 80) && _enemyInVeh) then {
	if (_grenadesAmount > 0) then {

		if (_debug) then {hint "stop vehicle, grenade !"};
		_grenadesAmount = _grenadesAmount - 1;
		_tempVeh = "Grenade" createVehicle [((getPos _enemy) select 0) + ceil(random 25)* cos ceil(random 360) + ceil(random 25)* cos ceil(random 360) + 5,((getPos _enemy) select 1) + ceil(random 25)* cos ceil(random 360) + ceil(random 25)* cos ceil(random 360) - 5,1];
		diag_log format["[MBNQHS]: Fighting against player vehicle at %1",(mapGridPosition (position _unit))];
	};
 };
};

// getBack --- DISABLED FOR HS ---
sleep 0.1;
 if ( !_disableFnc ) then {
	if (_IsAway) then {

				if (_debug) then {hint "heading back to base"};

				(group _unit) lockWP true;
				_unit doMove _basePos;
				sleep 10;
	} else {
				(group _unit) lockWP false;
	};
 };

}; 
// ***

// steal vehicle --- DISABLED FOR HS ---
sleep 0.1;
 // !!!
if ( !_disableFnc ) then {
 if ( ((random 1) < _stealVehChance) && _IsVehicleNear && !_inVehicle && !_IsAway) then {

	_vehicle2ST = nearestObject [getPos _unit, "landvehicle"];

	if ( (canMove _vehicle2ST) && (count crew _vehicle2ST == 0) )then {

				if (_debug) then {hint "taking vehicle"};

				_unit assignAsDriver _vehicle2ST;
				[_unit] orderGetIn true;

				sleep 10;
	} else {

				_unit leaveVehicle (vehicle _unit);
				(group _unit) lockWP false;
				[_unit] orderGetIn false;

	};
 };


// Drive vehicle to mil base --- DISABLED FOR HS ---
sleep 0.1;
 if ( ((random 1) < 0.50) && _inVehicle ) then {

	if (!_AtMilBase) then {

				if (_debug) then {hint "driving to junkyard"};

				(group _unit) lockWP true;
				_unit doMove _MilBasePos;
				sleep 30;
	} else {

				if (_debug) then {hint "porzucam pojazd"};

				_unit leaveVehicle (vehicle _unit);
				(group _unit) lockWP false;
				[_unit] orderGetIn false;

	};
 };
}; // !!!

sleep ((random _refreshRate) + 1);
_posCheck2 = getPos _unit;
};

_unit = nil;
_basePos = nil;
_refreshRate = nil;
_debug = nil;
_hasBase = nil;
_inVehicle = nil;
_isWounded = nil;
_isBadlyWounded = nil;
_isStatusRed = nil;
_canWalk = nil;
_hasCover = nil;
_IsEnemyNear = nil;
_IsVehicleNear = nil;
_healChance = nil;
_findCoverChance = nil;
_magazines = nil;
_magazine = nil;
_IsAway = nil;
_smokeChance = nil;
_awaydist = nil;
_tempVeh = nil;
_smokesAmount = nil;
_enemy = nil;
_stealVehChance = nil;
_vehicle2ST = nil;
_MilBasePos = nil;
_AtMilBase = nil;
_inForest = nil;
_CampInForest = nil;
_OnKnees = nil;
_grenadesAmount = nil;
_grenadeChance = nil;
_enemyInVeh = nil;
_posCheck1 = nil;
_posCheck2 = nil;
_camping = nil;
_disableFnc = nil;