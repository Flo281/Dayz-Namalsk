/*
        Created exclusively for ArmA2:OA - DayZMod.
        Please request permission to use/alter/distribute from project leader (R4Z0R49)
*/
private ["_wreck","_maxlocalspawned","_maxControlledZombies","_iPos","_nearByZed","_nearByPlayer","_rnd","_positions","_zombieChance","_unitTypes","_min","_max","_num","_clean","_obj","_type","_config","_canLoot","_originalPos","_fastRun","_enabled","_i","_Pos"];
_obj = 			_this select 0;
_wreck = false;
if (count _this > 1) then {
	_wreck = 			_this select 1;
};

_type = 		typeOf _obj;
_config = 		missionConfigFile >> "CfgLootNamalsk" >> "Buildings" >> _type;
_canLoot = 		isClass (_config);
_originalPos = 	getPosATL _obj;

_maxlocalspawned = round(dayz_spawnZombies);
//Lets check if we need to divide the amount of zeds
if (r_player_divideinvehicle > 0) then {
	_maxlocalspawned = round(dayz_spawnZombies / r_player_divideinvehicle);
};

_maxControlledZombies = round(dayz_maxLocalZombies);
_enabled = false;



if (_canLoot ) then {
	//Get zombie class
	_unitTypes = 	getArray (_config >> "zombieClass");
	_min = 			getNumber (_config >> "maxRoaming");
	_max = 			getNumber (_config >> "minRoaming");
	_zombieChance =	getNumber (_config >> "zombieChance");

	//Add Internal Zombies
	if (_zombieChance > 0) then {
		_positions = getArray (_config >> "zedPos");
		{
			//_Pos = [_x select 0, _x select 1, 0];
			_Pos = _x;
			_rnd = random 1.2;
			if (_rnd < _zombieChance) then {
				_iPos = _obj modelToWorld _Pos;
				_nearByZed = {alive _x} count (_iPos nearEntities ["zZombie_Base", 4]) > 0;
				_nearByPlayer = ({isPlayer _x} count (_iPos nearEntities ["CAManBase",10])) > 0;
				//diag_log ("BUILDING: " + _type + " / " + str(_nearByZed) + " / " + str(_nearByPlayer));
				if ((_maxlocalspawned < _maxControlledZombies) and (dayz_CurrentNearByZombies < dayz_maxNearByZombies) and (dayz_currentGlobalZombies < dayz_maxGlobalZeds)) then {
					if (!_nearByPlayer and !_nearByZed) then {
						[_iPos,true,_unitTypes,false] call zombie_generate;
					};
				};
			};
		} forEach _positions;
	};

//Add bloodsuckers
if (_type == "Land_bspawn" && dzn_ns_bloodsucker && ((random 400) < dzn_ns_bloodsucker_den)) then {
	private["_content", "_originalPos"];
	_rnd = random 1;
	if (_rnd < 0.18562) then {
		_content = "this addMagazine 'mut_heart'";
		} else {
			_content = "";
		};
		_originalPos = getPos _obj;
		"ns_bloodsucker" createUnit [[(_originalPos select 0) + (random 60), (_originalPos select 1) - (random 60), 0], group sefik, _content, 1, "CORPORAL"];
	};
	
	//Walking Zombies
	_num = (round(random _max)) max _min; // + round(_max / 3);
	//diag_log ("Class: " + _type + " / Zombies: " + str(_unitTypes) + " / Walking: " + str(_num));
	
	for "_i" from 0 to _num do
	{
		//_iPos = _obj modelToWorld _originalPos;
		if ((_maxlocalspawned < _maxControlledZombies) and (dayz_CurrentNearByZombies < dayz_maxNearByZombies) and (dayz_currentGlobalZombies < dayz_maxGlobalZeds)) then {
			[_originalPos,false,_unitTypes,_wreck] call zombie_generate;
		};
	};
};

//diag_log ("2 end");