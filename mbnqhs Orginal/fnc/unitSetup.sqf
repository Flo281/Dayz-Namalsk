// Written by mbnq for DayZ Shadow of Chernarus Elite server
// www.mbnq.pl
// mbnq00@gmail.com
//
// Hunter Seeker aka Survivor Simulation (Little Girl)
// unit setup

sleep 2;

private [
	"_debug",
	"_unit",
	"_weapon",
	"_fnc_selectRandom",
	"_mag"
	];

_unit = _this select 0;

_fnc_selectRandom = {
    _this select (floor random (count _this))
};

// ======================================= Local CFG =======================================

_weapon = [
		"Sa58V_EP1",
		"Sa58P_EP1",
		"Sa58V_CCO_EP1",
		"AK_74_GL_kobra",
		"Sa58V_RCO_EP1",
		"AKS_74_pso",
		"huntingrifle",
		"AK_47_M",
		"SVD_CAMO_DZ",
		"BAF_L85A2_RIS_Holo",
		"M40A3",
		"M4A1_AIM_SD_camo",
		"M240_DZ",
		"M4A1_RCO_GL",
		"G36A_camo",
		"FN_FAL",
		"G36C_camo",
		"Mk_48_DZ",
		"M4A1_HWS_GL_SD_CAMO",
		"SVD_DZ",
		"DMR_DZ",
		"AKS_74_U",
		"RPK_74",
		"AK_74_GL",
		"M14_EP1",
		"M16A2GL",
		"Sa58P_EP1",
		"M240_DZ"
	  ] call _fnc_selectRandom;

_backpack = [
		"DZ_ALICE_Pack_EP1",
		"DZ_Assault_Pack_EP1"
	    ] call _fnc_selectRandom;

_mag = (getArray (configFile >> "cfgWeapons" >> _weapon >> "magazines")) select 0;

// ======================================= Local CFG =======================================

	sleep 1;

	removeAllItems _unit;
	removeAllWeapons _unit;

	{
		_unit removeMagazine _x
	} forEach magazines _unit;

	_unit enableAI "TARGET";
	_unit enableAI "AUTOTARGET";
	_unit enableAI "MOVE";
	_unit enableAI "ANIM";
	_unit enableAI "FSM";

	{_unit setskill _x} forEach [
		["aimingAccuracy",1.00],
		["aimingShake",1.00],
		["aimingSpeed",1.00],
		["endurance",1.00],
		["spotDistance",1.00],
		["spotTime",1.00],
		["courage",1.00],
		["reloadSpeed",1.00],
		["commanding",1.00],
		["general",1.00]
	];

	sleep 1;

	_unit addWeapon "NVGoggles";
	_unit addWeapon _weapon;

	for "_i" from 0 to 4 do {
		_unit addMagazine _mag;
	};

	_unit addEventHandler ["Killed",{ [(_this select 0), (_this select 1)] ExecVM HS_killed; }];
	[_unit,[0,0,0]] execVM HS_mbnqAI;


_debug = nil;
_unit = nil;
_weapon = nil;
_fnc_selectRandom = nil;
_mag = nil;