--[[
	Enchantrix Addon for World of Warcraft(tm).
	Version: 5.19.5445 (QuiescentQuoll)
	Revision: $Id: EnxObjects.lua 3576 2008-10-10 03:07:13Z aesir $
	URL: http://enchantrix.org/

	Enchantrix namespace.

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
		You have an implicit license to use this AddOn with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]
Enchantrix_RegisterRevision("$URL: http://svn.norganna.org/auctioneer/branches/5.19/Enchantrix/EnxObjects.lua $", "$Rev: 3576 $")

-- Enchantrix namespace
Enchantrix = {
	Command = {},
	Config = {},
	Constants = {},
	Container = {},
	Locale = {},
	State = {},
	Storage = {},
	Tooltip = {},
	Util = {},
}