# r_simcards
SIM system for npwd phone by requestrip

## Helpful Info
* Easy to use.
* Easy to setup.

## Requirements
* Required:
    * [npwd](https://github.com/project-error/npwd)
    * [ox_lib](https://github.com/overextended/ox_lib)
    * [ox_inventory](https://github.com/overextended/ox_inventory)
    * [oxmysql](https://github.com/overextended/oxmysql)

## Download & Installation
1. Download & Extract the .zip or Open the .zip.
2. Import the included SQL file to your database.
3. Add "sim_card" item to your ox_inventory
```
['sim_card'] = {
	label = 'Sim Card',
	weight = 10,
	stack = false,
	close = true,
	description = nil,
	consume = 0,
	client = {
		remove = function()
			exports['r_simcards']:checkSim()
		end,
		add = function()
			exports['r_simcards']:checkSim()
		end,
	},
	server = {
		export = 'r_simcards.sim_card',
		metadata = {
            number = nil,
			ssn = nil
        }
	},
},
```
4. Edit the `config.lua` if you'd like to.
5. Add `ensure r_simcards` to your `server.cfg`.

## Known Bugs/Issues
* None for now
