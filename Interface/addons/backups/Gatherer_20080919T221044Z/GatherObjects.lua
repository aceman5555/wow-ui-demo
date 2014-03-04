--[[
	Gatherer Addon for World of Warcraft(tm).
	Version: 2.99.0.0498 (eagle)
	Revision: $Id: GatherObjects.lua 496 2007-02-26 01:59:10Z esamynn $

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit licence to use this AddOn with these facilities
		since that is it's designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]
Gatherer_RegisterRevision("$URL: http://norganna.org/svn/gatherer/trunk/GatherObjects.lua $", "$Rev: 496 $")

Gatherer = {
	Api = {},
	Categories = {},
	Comm = {},
	Command = {},
	Convert = {},
	Config = {},
	Constants = {},
	DropRates = {},
	Event = {},
	Interface = {},
	Locale = {},
	MapNotes = {},
	MiniNotes = {},
	Nodes = {},
	SpecialCases = {},
	Storage = {},
	Tooltip = {},
	Util = {},
	Var = {},
	ZoneTokens = {},
}

