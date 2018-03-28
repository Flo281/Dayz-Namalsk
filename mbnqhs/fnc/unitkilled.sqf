// Written by mbnq for DayZ Shadow of Chernarus Elite server
// www.mbnq.pl
// mbnq00@gmail.com
//
// Hunter Seeker aka Survivor Simulation (Little Girl)
// unit killed

sleep 1;

private [
	"_debug",
	"_unit",
	"_killer",
	"_weapon",
	"_fnc_selectRandom",
	"_mag",
	"_sidearm",
	"_tempmsg",
	"_tool",
	"_pistolmag",
	"_food",
	"_backpack",
	"_backpackitem",
	"_fnc_randomize",
	"_banditkills",
	"_humanity"
	];

_unit = _this select 0;
_killer = _this select 1;

diag_log format["[MBNQHS]: Group member %1 was killed at %2 by %3",_unit,(mapGridPosition (getPos (leader HS_group))),(name _killer)];

_fnc_selectRandom = {
    _this select (floor random (count _this))
};

// ======================================= Local CFG =======================================

_fnc_randomize = {

_weapon = [
		"AK_74",
		"M14_EP1",
		"huntingrifle",
		"RPK_74",
		"M16A2GL",
		"LeeEnfield",
		"MP5A5",
		"AKS_74_U",
		"AK_47_M",
		"AK_107_kobra",
		"M4A1",
		"M4SPR",
		"BAF_L85A2_RIS_Holo",
		"G36C",
		"Sa58V_CCO_EP1",
		"AK_107_kobra",
		"M240_DZ",
		"AKS_74_pso",
		"M16A2",
		"MP5SD"
] call _fnc_selectRandom;


_backpack = [
		"DZ_Patrol_Pack_EP1",
		"DZ_Assault_Pack_EP1",
		"DZ_CivilBackpack_EP1",
		"DZ_Czech_Vest_Puch",
		"DZ_ALICE_Pack_EP1",
		"DZ_TK_Assault_Pack_EP1",
		"DZ_Backpack_EP1",
		"DZ_British_ACU"

	    ] call _fnc_selectRandom;


_sidearm = [
		"Makarov",
		"glock17_EP1",
		"M9",
		"revolver_EP1",
		"UZI_EP1",
		"Colt1911"

	    ] call _fnc_selectRandom;


_tool = [
		"APSI"
		"ItemWatch",
		"ItemKnife",
		"ItemHatchet",
		"ItemCompass",
		"ItemMap",
		"ItemToolbox",
		"binocular",
		"Binocular_Vector",
		"ItemEtool",
		"ItemRadio",
		"ItemFlashlightRed",
		"ItemMatchbox",
		"ItemFlashlight",
		"ItemCrowbar"

	    ] call _fnc_selectRandom;


_food = [
		"ItemSodaCoke",
		"FoodCanSardines",
		"ItemSodaPepsi",
		"FoodCanBakedBeans",
		"FoodCanFrankBeans",
		"FoodCanPasta",
		"FoodMRE"

	    ] call _fnc_selectRandom;


_backpackitem = [

		"Attachment_M16_ACG",
		"Attachment_Kobra",
		"Attachment_M14_SniperScope",
		"Attachment_M9Silencer",
		"Attachment_M4A1_Aim",
		"Attachment_M4A1_Aim_camo",
		"Attachment_M4A1_AIM_SD_camo",
		"Attachment_Crossbow_CCO",
		"Attachment_MakarovSilencer",
		"ItemSodaCoke",
		"FoodCanSardines",
		"ItemSodaPepsi",
		"FoodCanBakedBeans",
		"FoodCanFrankBeans",
		"FoodCanPasta",
		"FoodMRE",
		"FoodmuttonCooked",
		"FoodchickenCooked",
		"FoodBaconCooked",
		"FoodbaconRaw",
		"FoodchickenRaw",
		"FoodmuttonRaw",
		"FoodCanUnlabeled",
		"FoodPistachio",
		"FoodNutmix",
		"ItemBandage",
		"ItemPainkiller",
		"ItemMorphine",
		"bloodTester",
		"transfusionKit",
		"emptyBloodBag",
		"bloodBagOPOS",
		"bloodBagONEG",
		"bloodBagABPOS",
		"bloodBagABNEG",
		"bloodBagBPOS",
		"bloodBagBNEG",
		"bloodBagAPOS",
		"bloodBagANEG",
		"ItemEpinephrine",
		"ItemAntibacterialWipe",
		"ItemHeatpack",
		"HandRoadFlare",
		"HandChemBlue",
		"HandChemRed",
		"HandChemGreen",
		"SmokeShell",
		"SmokeShellGreen",
		"SmokeShellGreen",
		"FlareGreen_M203",
		"FlareWhite_M203",
		"1Rnd_Smoke_M203",
		"FlareGreen_M203",
		"FlareWhite_M203",
		"1Rnd_Smoke_M203",
		"TrashTinCan",
		"TrashJackDaniels",
		"ItemTrashToiletpaper",
		"ItemSodaEmpty",
		"ItemSodaPepsiEmpty",
		"FoodCanRusPorkEmpty",
		"FoodCanRusPeasEmpty",
		"30Rnd_556x45_Stanag",
		"30Rnd_545x39_AK",
		"FlareWhite_GP25",
		"1Rnd_HE_GP25",
		"1Rnd_SMOKEGREEN_GP25",
		"1Rnd_SMOKE_GP25",
		"FlareGreen_GP25",
		"1Rnd_SMOKEGREEN_GP25",
		"ItemJerrycan",
		"PartWheel",
		"PartEngine",
		"PartFueltank",
		"PartGlass",
		"PartWoodPile",
		"30Rnd_556x45_G36",
		"30Rnd_556x45_StanagSD",
		"30Rnd_545x39_AKSD",
		"30Rnd_762x39_SA58",
		"64Rnd_9x19_SD_Bizon",
		"20Rnd_762x51_FNFAL",
		"20Rnd_762x51_DMR",
		"10Rnd_762x54_SVD",
		"5Rnd_762x51_M24",
		"5Rnd_127x108_KSVK",
		"100Rnd_556x45_BetaCMag",
		"100Rnd_762x51_M240",
		"200Rnd_556x45_M249",
		"100Rnd_762x54_PK",
		"75Rnd_545x39_RPK",
		"Skin_Sniper1_DZ",
		"Skin_Camo1_DZ",
		"ItemBookBible",
		"ItemSandbag",
		"PipeBomb",
		"ItemAntibiotic",
		"ItemTrashRazor",
		"ItemTent",
		"ItemDomeTent"

	    ] call _fnc_selectRandom;

};
call _fnc_randomize;

_mag = (getArray (configFile >> "cfgWeapons" >> _weapon >> "magazines")) select 0;
_pistolmag = (getArray (configFile >> "cfgWeapons" >> _sidearm >> "magazines")) select 0;

// ======================================= Local CFG =======================================

	sleep 1;

	removeAllItems _unit;
	removeAllWeapons _unit;

	{
		_unit removeMagazine _x
	} forEach magazines _unit;

	if (_unit hasWeapon "NVGoggles") then {_unit removeWeapon "NVGoggles"};

	sleep 1;

	_unit addWeapon _weapon;
	_unit addWeapon _sidearm;

	for "_i" from 1 to (round(random 2)) do {
		call _fnc_randomize;
		_unit addWeapon _tool;
	};

	for "_i" from 1 to (round(random 2)) do {
		_unit addMagazine _mag;
	};

	for "_i" from 1 to (round(random 2)) do {
		_unit addMagazine _pistolmag;
	};

	for "_i" from 1 to (round(random 2)) do {
		call _fnc_randomize;
		_unit addMagazine _food;
	};

	_unit addBackpack _backpack;
	clearMagazineCargo unitBackpack _unit;

	for "_i" from 1 to (round(random 14)) do {
		call _fnc_randomize;
		(unitBackpack _unit) addMagazineCargoGlobal [_backpackitem, 1];
	};

if (HS_inEditor) then {} else {
	_tempmsg = format["Hunter seeker was killed by %1 !",(name _killer)];
	[nil,nil,rTitleText,_tempmsg, "PLAIN DOWN",10] call RE;

	// based on code by Vampire
	if (isPlayer _killer) then { 
		_banditkills = _killer getVariable ["banditKills",0];
		_killer setVariable ["banditKills",(_banditkills + 1),true];
		_humanity = _killer getVariable ["humanity",0];
		_killer setVariable ["humanity",(_humanity + 200),true];

		{
			if (((position _x) distance (position _unit)) <= 600) then {
				_x reveal [_killer, 4.0];
			}
		} forEach allUnits;

	};
};

sleep 1;
_debug = nil;
_unit = nil;
_killer = nil;
_weapon = nil;
_fnc_selectRandom = nil;
_mag = nil;
_sidearm = nil;
_tempmsg = nil;
_tool = nil;
_pistolmag = nil;
_food = nil;
_backpack = nil;
_backpackitem = nil;
_fnc_randomize = nil;
_banditkills = nil;
_humanity = nil;