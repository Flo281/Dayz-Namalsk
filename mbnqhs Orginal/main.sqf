// Written by mbnq for DayZ Shadow of Chernarus Elite server
// www.mbnq.pl
// mbnq00@gmail.com
//
// Hunter Seeker aka Survivor Simulation (Little Girl)

if (!isServer) exitWith {};
diag_log "[MBNQHS]: Hunter Seeker script waiting...";
sleep 120;
diag_log "[MBNQAOS]: Hunter Seeker script starting";

private [
	"_debug",
	"_spawnPos",
	"_unit",
	"_fnc_selectRandom"
	];

_fnc_selectRandom = {
    _this select (floor random (count _this))
};

// ======================================= Local CFG =======================================
_debug 		= false;

// locations where bots are being spawned at server restart
_spawnPos	=  	[
			 [260,[4478.24,11228.2,0]],
			 [352,[6735.84,11333.3,0]],
			 [272,[4974.26,6543.74,0.047]],		 
			] call _fnc_selectRandom;

// ======================================= Local CFG =======================================
// ====================================== Global CFG  ======================================
HS_inEditor = false;	

if (HS_inEditor) then {HS_unitSetup = "mbnqhs\fnc\unitSetup.sqf"} else {HS_unitSetup = "\z\addons\dayz_server\mbnqhs\fnc\unitSetup.sqf"};
if (HS_inEditor) then {HS_mbnqAI = "mbnqhs\fnc\mbnqAI.sqf"} else {HS_mbnqAI = "\z\addons\dayz_server\mbnqhs\fnc\mbnqAI.sqf"};
if (HS_inEditor) then {HS_pathfinder = "mbnqhs\fnc\pathFinder.sqf"} else {HS_pathfinder = "\z\addons\dayz_server\mbnqhs\fnc\pathFinder.sqf"};
if (HS_inEditor) then {HS_monitor = "mbnqhs\fnc\monitor.sqf"} else {HS_monitor = "\z\addons\dayz_server\mbnqhs\fnc\monitor.sqf"};
if (HS_inEditor) then {HS_interaction = "mbnqhs\fnc\interaction.sqf"} else {HS_interaction = "\z\addons\dayz_server\mbnqhs\fnc\interaction.sqf"};
if (HS_inEditor) then {HS_killed = "mbnqhs\fnc\unitkilled.sqf"} else {HS_killed = "\z\addons\dayz_server\mbnqhs\fnc\unitkilled.sqf"};

HS_group = createGroup east;

// ====================================== Global CFG  ======================================


HS_group setFormation "VEE";
for "_i" from 0 to 1 do {
	// characters being used by bots
	_unit = ["Survivor2_DZ","Survivor2_DZ"] call _fnc_selectRandom;
	_unit createunit [_spawnPos, HS_group, "ffx0 = [this] execVM HS_unitSetup;", 0.9, "corporal"];
}; 

diag_log format["[MBNQHS]: Group spawned at %1",(mapGridPosition _spawnPos)];

[] execVM HS_pathfinder;
[] execVM HS_interaction;
if (_debug) then {[] execVM HS_monitor};