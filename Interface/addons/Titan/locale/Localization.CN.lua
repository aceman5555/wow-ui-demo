﻿local L = LibStub("AceLocale-3.0"):NewLocale("Titan","zhCN")
if not L then return end

L["TITAN_PANEL"] = "Titan Panel";
local TITAN_PANEL = "Titan Panel";
L["TITAN_DEBUG"] = "<Titan>";
L["TITAN_PRINT"] = "Titan";
     
L["TITAN_NA"] = "N/A";
L["TITAN_SECONDS"] = "秒";
L["TITAN_MINUTES"] = "分";
L["TITAN_HOURS"] = "小时";
L["TITAN_DAYS"] = "天";
L["TITAN_SECONDS_ABBR"] = "秒";
L["TITAN_MINUTES_ABBR"] = "分";
L["TITAN_HOURS_ABBR"] = "小时";
L["TITAN_DAYS_ABBR"] = "天";
L["TITAN_MILLISECOND"] = "毫秒";
L["TITAN_KILOBYTES_PER_SECOND"] = "KB/s";
L["TITAN_KILOBITS_PER_SECOND"] = "kb/s"
L["TITAN_MEGABYTE"] = "MB";
L["TITAN_NONE"] = "无";
L["TITAN_USE_COMMA"] = "千位分隔符使用逗号";
L["TITAN_USE_PERIOD"] = "使用点";

L["TITAN_PANEL_ERROR_PROF_DELCURRENT"] = "无法删除你的当前配置.";
local TITAN_PANEL_WARNING = GREEN_FONT_COLOR_CODE.."警告 : "..FONT_COLOR_CODE_CLOSE
local TITAN_PANEL_RELOAD_TEXT = "如果你想继续这个操作, 按 '接受' (会重载界面), 否则请按 '取消' ."
L["TITAN_PANEL_RESET_WARNING"] = TITAN_PANEL_WARNING
	.."这会重置面板的位置和"..TITAN_PANEL.." 设置信息为默认值，并重建配置文件. "
	..TITAN_PANEL_RELOAD_TEXT
L["TITAN_PANEL_RELOAD"] = TITAN_PANEL_WARNING
	.."这会重新加载"..TITAN_PANEL..". "
	..TITAN_PANEL_RELOAD_TEXT
L["TITAN_PANEL_ATTEMPTS"] = TITAN_PANEL.."注册请求" --？？
L["TITAN_PANEL_ATTEMPTS_SHORT"] = "其他插件注册请求" --？？
L["TITAN_PANEL_ATTEMPTS_DESC"] = "下列插件扩展要注册在"..TITAN_PANEL.."下.\n"
	.."如有相关问题请发送给其插件作者."
L["TITAN_PANEL_ATTEMPTS_TYPE"] = "类型" --？？
L["TITAN_PANEL_ATTEMPTS_CATEGORY"] = "类别"
L["TITAN_PANEL_ATTEMPTS_BUTTON"] = "按钮名称"
L["TITAN_PANEL_ATTEMPTS_STATUS"] = "状态"
L["TITAN_PANEL_ATTEMPTS_ISSUE"] = "信息"
L["TITAN_PANEL_ATTEMPTS_NOTES"] = "说明"
L["TITAN_PANEL_ATTEMPTS_TABLE"] = "表单"
L["TITAN_PANEL_EXTRAS"] = TITAN_PANEL.." 附加"
L["TITAN_PANEL_EXTRAS_SHORT"] = "附加"
L["TITAN_PANEL_EXTRAS_DESC"] = "这些是有设置数据但没有加载的扩展组件.\n"
	.."可以安全的删除."
L["TITAN_PANEL_EXTRAS_DELETE_BUTTON"] = "删除设置数据"
L["TITAN_PANEL_EXTRAS_DELETE_MSG"] = "设置数据已经被删除."
L["TITAN_PANEL_CHARS"] = "角色"
L["TITAN_PANEL_CHARS_DESC"] = "这些是有设置数据的角色."
L["TITAN_PANEL_REGISTER_START"] = "正在注册 "..TITAN_PANEL.." 扩展组件..."
L["TITAN_PANEL_REGISTER_END"] = "注册完成."
     
-- slash command help
L["TITAN_PANEL_SLASH_RESET_0"] = LIGHTYELLOW_FONT_COLOR_CODE.."使用命令: |cffffffff/titan {reset | reset tipfont/tipalpha/panelscale/spacing}";
L["TITAN_PANEL_SLASH_RESET_1"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset: |cffffffffResets "..TITAN_PANEL.."重置为默认设置.";
L["TITAN_PANEL_SLASH_RESET_2"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset tipfont: |cffffffffResets "..TITAN_PANEL.." 重置提示文字字体缩放为默认值.";
L["TITAN_PANEL_SLASH_RESET_3"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset tipalpha: |cffffffffResets "..TITAN_PANEL.." 重置提示文字透明度为默认值.";
L["TITAN_PANEL_SLASH_RESET_4"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset panelscale: |cffffffffResets "..TITAN_PANEL.." 重置面板缩放为默认值.";
L["TITAN_PANEL_SLASH_RESET_5"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset spacing: |cffffffffResets "..TITAN_PANEL.." 重置按钮间距为默认值.";
L["TITAN_PANEL_SLASH_GUI_0"] = LIGHTYELLOW_FONT_COLOR_CODE.."使用命令: |cffffffff/titan {gui control/trans/skin}";
L["TITAN_PANEL_SLASH_GUI_1"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."gui control: |cffffffff打开 "..TITAN_PANEL.." 控制面板.";
L["TITAN_PANEL_SLASH_GUI_2"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."gui trans: |cffffffff打开透明度控制面板.";
L["TITAN_PANEL_SLASH_GUI_3"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."gui skin: |cffffffff打开皮肤控制面板.";
L["TITAN_PANEL_SLASH_PROFILE_0"] = LIGHTYELLOW_FONT_COLOR_CODE.."使用命令: |cffffffff/titan {profile use <profile>}";
L["TITAN_PANEL_SLASH_PROFILE_1"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."profile use <名字> <服务器>: |cffffffff使用此服务器下的此角色的配置设置.";
L["TITAN_PANEL_SLASH_PROFILE_2"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."<名字>: |cffffffff可以是角色名也可以是配置文件名."
L["TITAN_PANEL_SLASH_PROFILE_3"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."<服务器>: |cffffffff可以是服务器名也可以是 Titan配置模板名."
L["TITAN_PANEL_SLASH_HELP_0"] = LIGHTYELLOW_FONT_COLOR_CODE.."使用命令: |cffffffff/titan {help | help <主题>}";
L["TITAN_PANEL_SLASH_HELP_1"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."<主题>: reset/gui/profile/help ";
L["TITAN_PANEL_SLASH_ALL_0"] = LIGHTYELLOW_FONT_COLOR_CODE.."使用命令: |cffffffff/titan <topic>";
L["TITAN_PANEL_SLASH_ALL_1"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."<主题>: |cffffffffreset/gui/profile/help ";
     
-- slash command responses
L["TITAN_PANEL_SLASH_RESP1"] = LIGHTYELLOW_FONT_COLOR_CODE..TITAN_PANEL.."Titan Panel 提示文字缩放已重置.";
L["TITAN_PANEL_SLASH_RESP2"] = LIGHTYELLOW_FONT_COLOR_CODE..TITAN_PANEL.."Titan Panel 提示窗口的透明度已重置.";
L["TITAN_PANEL_SLASH_RESP3"] = LIGHTYELLOW_FONT_COLOR_CODE..TITAN_PANEL.."Titan Panel 缩放已重置.";
L["TITAN_PANEL_SLASH_RESP4"] = LIGHTYELLOW_FONT_COLOR_CODE..TITAN_PANEL.."Titan Panel 按钮间距已重置.";
     
-- global profile locale
L["TITAN_PANEL_GLOBAL"] = "全局";     
L["TITAN_PANEL_GLOBAL_PROFILE"] = "全局陪置";     
L["TITAN_PANEL_GLOBAL_USE"] = "使用全局配置";     
L["TITAN_PANEL_GLOBAL_USE_AS"] = "设为全局配置";     
L["TITAN_PANEL_GLOBAL_USE_DESC"] = "为所有角色使用全局配置";     
L["TITAN_PANEL_GLOBAL_RESET_PART"] = "重置选项";     
L["TITAN_PANEL_GLOBAL_ERR_1"] = "当一个全局配置文件在使用中时你可以无法加载";  
     
-- general panel locale
L["TITAN_PANEL_VERSION_INFO"] = "版本|cffffd700 |cffff8c00"..TITAN_PANEL.." 开发团队出品"; 
L["TITAN_PANEL_MENU_TITLE"] = TITAN_PANEL;
L["TITAN_PANEL_MENU_HIDE"] = "隐藏";
L["TITAN_PANEL_MENU_IN_COMBAT_LOCKDOWN"] = "(战斗中)";
L["TITAN_PANEL_MENU_RELOADUI"] = "(将重载界面)";
L["TITAN_PANEL_MENU_SHOW_COLORED_TEXT"] = "显示彩色文本";
L["TITAN_PANEL_MENU_SHOW_ICON"] = "显示图标";
L["TITAN_PANEL_MENU_SHOW_LABEL_TEXT"] = "显示名称";
L["TITAN_PANEL_MENU_AUTOHIDE"] = "自动隐藏";
L["TITAN_PANEL_MENU_CENTER_TEXT"] = "文字居中";
L["TITAN_PANEL_MENU_DISPLAY_BAR"] = "显示Titan条";
L["TITAN_PANEL_MENU_DISABLE_PUSH"] = "禁用自动适应屏幕";
L["TITAN_PANEL_MENU_DISABLE_MINIMAP_PUSH"] = "禁用微缩地图自动出现";
L["TITAN_PANEL_MENU_DISABLE_LOGS"] = "自动记录";
L["TITAN_PANEL_MENU_DISABLE_BAGS"] = "自动背包调整";
L["TITAN_PANEL_MENU_DISABLE_TICKET"] = "自动调整标签框体";
L["TITAN_PANEL_MENU_PROFILES"] = "配置";
L["TITAN_PANEL_MENU_PROFILE"] = "配置";
L["TITAN_PANEL_MENU_PROFILE_CUSTOM"] = "个人";
L["TITAN_PANEL_MENU_PROFILE_DELETED"] = " 已删除.";
L["TITAN_PANEL_MENU_PROFILE_SERVERS"] = "服务器";
L["TITAN_PANEL_MENU_PROFILE_CHARS"] = "角色";
L["TITAN_PANEL_MENU_PROFILE_RELOADUI"] = "按下 '确定' 界面将重载来保存你的个人配置.";
L["TITAN_PANEL_MENU_PROFILE_SAVE_CUSTOM_TITLE"] = "为你的配置文件输入一个名称:\n(20字符限制，不能有空格)";
L["TITAN_PANEL_MENU_PROFILE_SAVE_PENDING"] = "现有设置已经被保存为配置文件: ";
L["TITAN_PANEL_MENU_PROFILE_ALREADY_EXISTS"] = "配置文件名称已存在. 你确定要覆盖它? 按 '接受' 确定, 按 '取消' 取消.";
L["TITAN_PANEL_MENU_MANAGE_SETTINGS"] = "加载配置";
L["TITAN_PANEL_MENU_LOAD_SETTINGS"] = "载入";
L["TITAN_PANEL_MENU_DELETE_SETTINGS"] = "删除";
L["TITAN_PANEL_MENU_SAVE_SETTINGS"] = "保存";
L["TITAN_PANEL_MENU_CONFIGURATION"] = "配置设置";
L["TITAN_PANEL_OPTIONS"] = "选项";
L["TITAN_PANEL_MENU_TOP"] = "顶端面板条"
L["TITAN_PANEL_MENU_TOP2"] = "顶端面板条2"
L["TITAN_PANEL_MENU_BOTTOM"] = "底端面板条"
L["TITAN_PANEL_MENU_BOTTOM2"] = "底端面板条2"
L["TITAN_PANEL_MENU_OPTIONS"] = TITAN_PANEL.." 提示文字和框架";
L["TITAN_PANEL_MENU_OPTIONS_SHORT"] = "提示文字和框架";
L["TITAN_PANEL_MENU_TOP_BARS"] = "顶端面板条"
L["TITAN_PANEL_MENU_BOTTOM_BARS"] = "底端面板条"
L["TITAN_PANEL_MENU_OPTIONS_BARS"] = "面板条"
L["TITAN_PANEL_MENU_OPTIONS_MAIN_BARS"] = TITAN_PANEL.." 顶端面板条";
L["TITAN_PANEL_MENU_OPTIONS_AUX_BARS"] = TITAN_PANEL.." 底端面板条";
L["TITAN_PANEL_MENU_OPTIONS_TOOLTIPS"] = "提示文字";
L["TITAN_PANEL_MENU_OPTIONS_FRAMES"] = "框架";
L["TITAN_PANEL_MENU_PLUGINS"] = "扩展组件";
L["TITAN_PANEL_MENU_LOCK_BUTTONS"] = "锁定按钮";
L["TITAN_PANEL_MENU_VERSION_SHOWN"] = "显示扩展组件版本";
L["TITAN_PANEL_MENU_LDB_SIDE"] = "右侧插件"; --？？
L["TITAN_PANEL_MENU_LDB_FORCE_LAUNCHER"] = "强制LDB启动器到右侧";
L["TITAN_PANEL_MENU_CATEGORIES"] = {"扩展组件","综合","战斗","信息","用户界面","专业技能"}
L["TITAN_PANEL_MENU_TOOLTIPS_SHOWN"] = "显示提示文字";
L["TITAN_PANEL_MENU_TOOLTIPS_SHOWN_IN_COMBAT"] = "在战斗中隐藏提示文字";
L["TITAN_PANEL_MENU_AUTOHIDE_IN_COMBAT"] = "在战斗中锁定自动隐藏的面板条";
L["TITAN_PANEL_MENU_RESET"] = "重置 "..TITAN_PANEL.." 为默认";
L["TITAN_PANEL_MENU_TEXTURE_SETTINGS"] = "皮肤";     
L["TITAN_PANEL_MENU_LSM_FONTS"] = "面板字体"
L["TITAN_PANEL_MENU_ENABLED"] = "启用";
L["TITAN_PANEL_MENU_DISABLED"] = "禁用";
L["TITAN_PANEL_SHIFT_LEFT"] = "向左移动"; 
L["TITAN_PANEL_SHIFT_RIGHT"] = "向右移动";
L["TITAN_PANEL_MENU_SHOW_PLUGIN_TEXT"] = "显示扩展组件文本";
L["TITAN_PANEL_MENU_BAR_ALWAYS"] = "总是显示"; --？？
L["TITAN_PANEL_MENU_POSITION"] = "位置";
L["TITAN_PANEL_MENU_BAR"] = "面板条";
L["TITAN_PANEL_MENU_DISPLAY_ON_BAR"] = "选择扩展组件显示在哪个面板条上";
L["TITAN_PANEL_MENU_SHOW"] = "显示扩展组件";
L["TITAN_PANEL_MENU_PLUGIN_RESET"] = "刷新扩展组件";
L["TITAN_PANEL_MENU_PLUGIN_RESET_DESC"] = "刷新扩展组件的文本和位置";
   
-- localization strings for AceConfigDialog-3.0     
L["TITAN_ABOUT_VERSION"] = "版本";
L["TITAN_ABOUT_AUTHOR"] = "作者";
L["TITAN_ABOUT_CREDITS"] = "贡献者";
L["TITAN_ABOUT_CATEGORY"] = "类别";
L["TITAN_ABOUT_EMAIL"] = "Email";
L["TITAN_ABOUT_WEB"] = "网址";
L["TITAN_ABOUT_LICENSE"] = "许可证";
L["TITAN_PANEL_CONFIG_MAIN_LABEL"] = "信息条插件. 在屏幕顶部或底部增加一个信息面板，允许用户添加显示所需信息或者快速载入其他插件.";			 
L["TITAN_TRANS_MENU_TEXT"] = TITAN_PANEL.." 透明度";
L["TITAN_TRANS_MENU_TEXT_SHORT"] = "透明度";
L["TITAN_TRANS_MENU_DESC"] = "为 "..TITAN_PANEL.." 面板条和提示文字调整透明度.";		
L["TITAN_TRANS_MAIN_CONTROL_TITLE"] = "主面板条";
L["TITAN_TRANS_AUX_CONTROL_TITLE"] = "辅面板条";
L["TITAN_TRANS_CONTROL_TITLE_TOOLTIP"] = "提示文字";		 
L["TITAN_TRANS_TOOLTIP_DESC"] = "为扩展组件和其提示文字调整透明度.";
L["TITAN_UISCALE_MENU_TEXT"] = TITAN_PANEL.." 缩放和字体";
L["TITAN_UISCALE_MENU_TEXT_SHORT"] = "缩放和字体";
L["TITAN_UISCALE_CONTROL_TITLE_UI"] = "用户界面缩放";
L["TITAN_UISCALE_CONTROL_TITLE_PANEL"] = TITAN_PANEL.." 缩放";
L["TITAN_UISCALE_CONTROL_TITLE_BUTTON"] = "按钮间距";
L["TITAN_UISCALE_CONTROL_TITLE_ICON"] = "图标间距";
L["TITAN_UISCALE_CONTROL_TOOLTIP_TOOLTIPFONT"] = "提示文字缩放";
L["TITAN_UISCALE_TOOLTIP_DISABLE_TEXT"] = "禁用提示文字缩放";		 
L["TITAN_UISCALE_MENU_DESC"] = "控制 "..TITAN_PANEL.."的界面.";
L["TITAN_UISCALE_SLIDER_DESC"] = "设置你整体用户界面的缩放.";
L["TITAN_UISCALE_PANEL_SLIDER_DESC"] = "控制 "..TITAN_PANEL.." 的各个按钮图标的缩放.";
L["TITAN_UISCALE_BUTTON_SLIDER_DESC"] = "调整左侧的扩展组件间距.";
L["TITAN_UISCALE_ICON_SLIDER_DESC"] = "调整右侧的扩展组件间距.";
L["TITAN_UISCALE_TOOLTIP_SLIDER_DESC"] = "调整各个扩展组件提示文字的缩放.";
L["TITAN_UISCALE_DISABLE_TOOLTIP_DESC"] = "禁用"..TITAN_PANEL.." 提示文字缩放.";

L["TITAN_SKINS_TITLE"] = TITAN_PANEL.." 皮肤";
L["TITAN_SKINS_OPTIONS_CUSTOM"] = "皮肤 - 自定义";
L["TITAN_SKINS_TITLE_CUSTOM"] = TITAN_PANEL.." 自定义皮肤";
L["TITAN_SKINS_MAIN_DESC"] = "所有自定义皮肤都放在以下文件夹中: \n"
			.."..\\AddOns\\Titan\\Artwork\\Custom\\<Skin Folder>\\ ".."\n"
			.."\n"..TITAN_PANEL.."自定义皮肤寸放在各自账号的插件配置文件夹.";
L["TITAN_SKINS_LIST_TITLE"] = "皮肤列表";
L["TITAN_SKINS_SET_DESC"] = "给"..TITAN_PANEL.."信息条选择一个皮肤.";
L["TITAN_SKINS_SET_HEADER"] = "设置面板皮肤";
L["TITAN_SKINS_RESET_HEADER"] = "重置"..TITAN_PANEL.." 皮肤";
L["TITAN_SKINS_NEW_HEADER"] = "添加新皮肤";
L["TITAN_SKINS_NAME_TITLE"] = "皮肤名称";
L["TITAN_SKINS_NAME_DESC"] = "为新皮肤输入一个名称.";
L["TITAN_SKINS_PATH_TITLE"] = "皮肤路径";
L["TITAN_SKINS_PATH_DESC"] = "输入皮肤的准确路径, 如范例所示.";
L["TITAN_SKINS_ADD_HEADER"] = "添加皮肤";
L["TITAN_SKINS_ADD_DESC"] = "添加一个新皮肤到面板可用皮肤列表.";
L["TITAN_SKINS_REMOVE_HEADER"] = "删除皮肤";
L["TITAN_SKINS_REMOVE_DESC"] = "从面板可用皮肤列表删除一个皮肤.";
L["TITAN_SKINS_REMOVE_BUTTON"] = "删除";
L["TITAN_SKINS_REMOVE_BUTTON_DESC"] = "从面板可用皮肤列表删除一个皮肤.";
L["TITAN_SKINS_REMOVE_NOTES"] = "你需要从"
..TITAN_PANEL.." 安装目录操作，来彻底删除你不需要的皮肤. 插件无法添加或删除文件."
L["TITAN_SKINS_RESET_DEFAULTS_TITLE"] = "恢复默认";
L["TITAN_SKINS_RESET_DEFAULTS_DESC"] = "恢复皮肤列表至默认值.";
L["TITAN_PANEL_MENU_LSM_FONTS_DESC"] = "选择Titan条上各个模块的字体样式.";
L["TITAN_PANEL_MENU_FONT_SIZE"] = "字体大小";
	L["TITAN_PANEL_MENU_FONT_SIZE_DESC"] = "设置面板上的字体大小.";
	L["TITAN_PANEL_MENU_FRAME_STRATA"] = "面板框架层叠";
	L["TITAN_PANEL_MENU_FRAME_STRATA_DESC"] = "设置"..TITAN_PANEL.."的框架是否显示在最前.";
	-- /end localization strings for AceConfigDialog-3.0

L["TITAN_PANEL_MENU_ADV"] = "高级";
L["TITAN_PANEL_MENU_ADV_DESC"] = "当你遇到页面框架出错时更改计时器.".."\n"; --？？
L["TITAN_PANEL_MENU_ADV_PEW"] = "登陆界面"; --？？
L["TITAN_PANEL_MENU_ADV_PEW_DESC"] = "当你登陆登出游戏或者进出副本时遇到页面框架出错时更改设定值(通常是增大).";
L["TITAN_PANEL_MENU_ADV_VEHICLE"] = "坐骑";
L["TITAN_PANEL_MENU_ADV_VEHICLE_DESC"] = "当你上下坐骑遇到页面框架出错时更改设定值(通常是增大).";
    
L["TITAN_AUTOHIDE_TOOLTIP"] = "控制"..TITAN_PANEL.."自动隐藏 开/关";
     
L["TITAN_BAG_FORMAT"] = "%d/%d";
L["TITAN_BAG_BUTTON_LABEL"] = "背包: ";
L["TITAN_BAG_TOOLTIP"] = "背包状态";
L["TITAN_BAG_TOOLTIP_HINTS"] = "提示: 左键点击打开所有背包.";
L["TITAN_BAG_MENU_TEXT"] = "背包监视";
L["TITAN_BAG_USED_SLOTS"] = "已用空间";
L["TITAN_BAG_FREE_SLOTS"] = "剩余空间";
L["TITAN_BAG_BACKPACK"] = "背包";
L["TITAN_BAG_MENU_SHOW_USED_SLOTS"] = "显示已用空间";
L["TITAN_BAG_MENU_SHOW_AVAILABLE_SLOTS"] = "显示可用空间";
L["TITAN_BAG_MENU_SHOW_DETAILED"] = "显示详细的提示信息";
L["TITAN_BAG_MENU_IGNORE_SLOTS"] = "忽略容器";
L["TITAN_BAG_MENU_IGNORE_PROF_BAGS_SLOTS"] = "忽略专业技能包";
L["TITAN_BAG_PROF_BAG_NAMES"] = {
-- Enchanting
"魔化魔纹布包", "魔化符文布包", "附魔师之袋", "大附魔袋", "魔焰背包", 
"神秘背包", "异界之袋", "“马车——限定款”附魔之夜手提包",
-- Engineering
"重工具箱", "魔铁工具箱", "泰坦神铁工具箱", "氪金工具箱", "源质工具箱", "“马车——狂人”高科技背包",
-- Herbalism
"草药袋", "塞纳里奥草药包", "塞纳留斯之袋", "麦卡的草药包", "翡翠包", "海加尔远征背囊",
"“马车——拥抱绿野”草药手提袋",
-- Inscription
"皇家铭文师背包", "无尽口袋", "“马车——珊德拉”学徒手提包",
-- Jewelcrafting
"宝石袋", "珠宝袋", "“马车——限定款”宝石镶嵌挎包",
-- Leatherworking
"制皮匠的背包", "大皮袋", "猎户的旅行背包", "“马车——米亚”真皮背包",
-- Mining
"矿物包", "加固矿工袋", "猛犸皮矿石包", "三重加固的矿工袋", "“马车——克莉斯汀娜”珍藏金属背包",
-- Fishing
"捕鱼大师的工具箱",
-- Cooking
"便携式冷柜",
};
     
L["TITAN_CLOCK_TOOLTIP"] = "时钟";     
L["TITAN_CLOCK_TOOLTIP_VALUE"] = "与服务器的时差: ";
L["TITAN_CLOCK_TOOLTIP_LOCAL_TIME"] = "本地时间: ";
L["TITAN_CLOCK_TOOLTIP_SERVER_TIME"] = "服务器时间: ";
L["TITAN_CLOCK_TOOLTIP_SERVER_ADJUSTED_TIME"] = "修正服务器时间: ";
L["TITAN_CLOCK_TOOLTIP_HINT1"] = "提示: 左键单击来修正时间"
L["TITAN_CLOCK_TOOLTIP_HINT2"] = "(仅服务器时间) 24小时模式.";
L["TITAN_CLOCK_TOOLTIP_HINT3"] = "Shift+左键单击 打开/关闭日历.";
L["TITAN_CLOCK_CONTROL_TOOLTIP"] = "服务器时差: ";
L["TITAN_CLOCK_CONTROL_TITLE"] = "时差";
L["TITAN_CLOCK_CONTROL_HIGH"] = "+12";
L["TITAN_CLOCK_CONTROL_LOW"] = "-12";
L["TITAN_CLOCK_CHECKBUTTON"] = "24小时制";
L["TITAN_CLOCK_CHECKBUTTON_TOOLTIP"] = "切换 12/24 小时制显示";
L["TITAN_CLOCK_MENU_TEXT"] = "时钟";
L["TITAN_CLOCK_MENU_LOCAL_TIME"] = "显示本地时间";
L["TITAN_CLOCK_MENU_SERVER_TIME"] = "显示服务器时间";
L["TITAN_CLOCK_MENU_SERVER_ADJUSTED_TIME"] = "显示修正后的服务器时间";
L["TITAN_CLOCK_MENU_DISPLAY_ON_RIGHT_SIDE"] = "在最右侧显示";
L["TITAN_CLOCK_MENU_HIDE_GAMETIME"] = "隐藏 时间/日历 按钮";
L["TITAN_CLOCK_MENU_HIDE_MAPTIME"] = "隐藏时间按钮";
L["TITAN_CLOCK_MENU_HIDE_CALENDAR"] = "隐藏日历按钮";
     
L["TITAN_COORDS_FORMAT"] = "(%.d, %.d)";
L["TITAN_COORDS_FORMAT2"] = "(%.1f, %.1f)";
L["TITAN_COORDS_FORMAT3"] = "(%.2f, %.2f)";
L["TITAN_COORDS_FORMAT_LABEL"] = "(xx , yy)";
L["TITAN_COORDS_FORMAT2_LABEL"] = "(xx.x , yy.y)";
L["TITAN_COORDS_FORMAT3_LABEL"] = "(xx.xx , yy.yy)";
L["TITAN_COORDS_FORMAT_COORD_LABEL"] = "坐标格式";
L["TITAN_COORDS_BUTTON_LABEL"] = "位置: ";
L["TITAN_COORDS_TOOLTIP"] = "所在位置信息";
L["TITAN_COORDS_TOOLTIP_HINTS_1"] = "提示: Shift + 左键单击添加所在位置";
L["TITAN_COORDS_TOOLTIP_HINTS_2"] = "信息到聊天窗口.";
L["TITAN_COORDS_TOOLTIP_ZONE"] = "区域: ";
L["TITAN_COORDS_TOOLTIP_SUBZONE"] = "具体地点: ";
L["TITAN_COORDS_TOOLTIP_PVPINFO"] = "PVP 信息: ";
L["TITAN_COORDS_TOOLTIP_HOMELOCATION"] = "炉石位置";
L["TITAN_COORDS_TOOLTIP_INN"] = "旅店: ";
L["TITAN_COORDS_MENU_TEXT"] = "坐标";
L["TITAN_COORDS_MENU_SHOW_ZONE_ON_PANEL_TEXT"] = "显示区域信息";
L["TITAN_COORDS_MENU_SHOW_COORDS_ON_MAP_TEXT"] = "在世界地图上显示坐标";
L["TITAN_COORDS_MAP_CURSOR_COORDS_TEXT"] = "鼠标位置(X,Y): %s";
L["TITAN_COORDS_MAP_PLAYER_COORDS_TEXT"] = "玩家位置(X,Y): %s";
L["TITAN_COORDS_NO_COORDS"] = "无坐标";
L["TITAN_COORDS_MENU_SHOW_LOC_ON_MINIMAP_TEXT"] = "在小地图显示位置";
L["TITAN_COORDS_MENU_UPDATE_WORLD_MAP"] = "当切换地区时更新世界地图";
     
L["TITAN_FPS_FORMAT"] = "%.1f";
L["TITAN_FPS_BUTTON_LABEL"] = "FPS: ";
L["TITAN_FPS_MENU_TEXT"] = "FPS";
L["TITAN_FPS_TOOLTIP_CURRENT_FPS"] = "当前FPS: ";
L["TITAN_FPS_TOOLTIP_AVG_FPS"] = "平均 FPS: ";
L["TITAN_FPS_TOOLTIP_MIN_FPS"] = "最低 FPS: ";
L["TITAN_FPS_TOOLTIP_MAX_FPS"] = "最高 FPS: ";
L["TITAN_FPS_TOOLTIP"] = "每秒画面帧数";
     
L["TITAN_LATENCY_FORMAT"] = "%d".."ms";
L["TITAN_LATENCY_BANDWIDTH_FORMAT"] = "%.3f ".."KB/s";
L["TITAN_LATENCY_BUTTON_LABEL"] = "延迟: ";
L["TITAN_LATENCY_TOOLTIP"] = "网络状况信息";
L["TITAN_LATENCY_TOOLTIP_LATENCY_HOME"] = "游戏延迟 (本地): ";
L["TITAN_LATENCY_TOOLTIP_LATENCY_WORLD"] = "游戏延迟 (世界): ";
L["TITAN_LATENCY_TOOLTIP_BANDWIDTH_IN"] = "接收带宽: ";
L["TITAN_LATENCY_TOOLTIP_BANDWIDTH_OUT"] = "发送带宽: ";
L["TITAN_LATENCY_MENU_TEXT"] = "延迟";
     
L["TITAN_LOOTTYPE_BUTTON_LABEL"] = "分配: ";
L["TITAN_LOOTTYPE_FREE_FOR_ALL"] = "自由拾取";
L["TITAN_LOOTTYPE_ROUND_ROBIN"] = "轮流拾取";
L["TITAN_LOOTTYPE_MASTER_LOOTER"] = "队长分配";
L["TITAN_LOOTTYPE_GROUP_LOOT"] = "队伍分配";
L["TITAN_LOOTTYPE_NEED_BEFORE_GREED"] = "需求优先";
L["TITAN_LOOTTYPE_TOOLTIP"] = "分配方式";
L["TITAN_LOOTTYPE_MENU_TEXT"] = "分配方式";
L["TITAN_LOOTTYPE_RANDOM_ROLL_LABEL"] = "Roll点";
L["TITAN_LOOTTYPE_TOOLTIP_HINT1"] = "左键单击将Roll点.";
L["TITAN_LOOTTYPE_TOOLTIP_HINT2"] = "右键点击选择Roll点类型.";
L["TITAN_LOOTTYPE_DUNGEONDIFF_LABEL"] = "五人副本难度";
L["TITAN_LOOTTYPE_DUNGEONDIFF_LABEL2"] = "团队副本难度";
	L["TITAN_LOOTTYPE_SHOWDUNGEONDIFF_LABEL"] = "显示副本难度";
	L["TITAN_LOOTTYPE_SETDUNGEONDIFF_LABEL"] = "设置五人副本难度";
	L["TITAN_LOOTTYPE_SETRAIDDIFF_LABEL"] = "设置团队副本难度";
	L["TITAN_LOOTTYPE_AUTODIFF_LABEL"] = "自动设定(基于队伍类型)";
     
L["TITAN_MEMORY_FORMAT"] = "%.3f".."MB";
L["TITAN_MEMORY_FORMAT_KB"] = "%d".."KB";
L["TITAN_MEMORY_RATE_FORMAT"] = "%.3f".."KB/s";
L["TITAN_MEMORY_BUTTON_LABEL"] = "内存: ";
L["TITAN_MEMORY_TOOLTIP"] = "内存使用";
L["TITAN_MEMORY_TOOLTIP_CURRENT_MEMORY"] = "当前: ";
L["TITAN_MEMORY_TOOLTIP_INITIAL_MEMORY"] = "起始: ";
L["TITAN_MEMORY_TOOLTIP_INCREASING_RATE"] = "增长率: ";
L["TITAN_MEMORY_KBMB_LABEL"] = "KB/MB";     
     
L["TITAN_MONEY_FORMAT"] = "%d".."g"..", %02d".."s"..", %02d".."c";
     
L["TITAN_PERFORMANCE_TOOLTIP"] = "性能信息";
L["TITAN_PERFORMANCE_MENU_TEXT"] = "性能";
L["TITAN_PERFORMANCE_ADDONS"] = "插件使用";
L["TITAN_PERFORMANCE_ADDON_MEM_USAGE_LABEL"] = "插件的内存使用";
L["TITAN_PERFORMANCE_ADDON_MEM_FORMAT_LABEL"] = "插件内存占用形式";
L["TITAN_PERFORMANCE_ADDON_CPU_USAGE_LABEL"] = "插件CPU使用";
L["TITAN_PERFORMANCE_ADDON_NAME_LABEL"] = "名称:";
L["TITAN_PERFORMANCE_ADDON_USAGE_LABEL"] = "使用";
L["TITAN_PERFORMANCE_ADDON_RATE_LABEL"] = "百分比";
L["TITAN_PERFORMANCE_ADDON_TOTAL_MEM_USAGE_LABEL"] = "插件使用内存总量:";
L["TITAN_PERFORMANCE_ADDON_TOTAL_CPU_USAGE_LABEL"] = "CPU使用总量:";
L["TITAN_PERFORMANCE_MENU_SHOW_FPS"] = "显示 FPS";
L["TITAN_PERFORMANCE_MENU_SHOW_LATENCY"] = "显示本地延迟";
L["TITAN_PERFORMANCE_MENU_SHOW_LATENCY_WORLD"] = "显示世界延迟";
L["TITAN_PERFORMANCE_MENU_SHOW_MEMORY"] = "显示内存使用";
L["TITAN_PERFORMANCE_MENU_SHOW_ADDONS"] = "显示插件内存使用量";
L["TITAN_PERFORMANCE_MENU_SHOW_ADDON_RATE"] = "显示插件内存使用率";
L["TITAN_PERFORMANCE_MENU_CPUPROF_LABEL"] = "CPU 使用图形显示模式";
L["TITAN_PERFORMANCE_MENU_CPUPROF_LABEL_ON"] = "启用CPU图形显示 ";
L["TITAN_PERFORMANCE_MENU_CPUPROF_LABEL_OFF"] = "禁用CPU图形显示 ";
L["TITAN_PERFORMANCE_CONTROL_TOOLTIP"] = "监视的插件: ";
L["TITAN_PERFORMANCE_CONTROL_TITLE"] = "被监视的插件";
L["TITAN_PERFORMANCE_CONTROL_HIGH"] = "40";
L["TITAN_PERFORMANCE_CONTROL_LOW"] = "1";
L["TITAN_PERFORMANCE_TOOLTIP_HINT"] = "左键点击回收内存.";
		     
L["TITAN_XP_FORMAT"] = "%s";
L["TITAN_XP_PERCENT_FORMAT"] = "(%.1f%%)";
L["TITAN_XP_BUTTON_LABEL_XPHR_LEVEL"] = "经验/小时 当前等级: ";
L["TITAN_XP_BUTTON_LABEL_XPHR_SESSION"] = "经验/小时 本次连接: ";
L["TITAN_XP_BUTTON_LABEL_TOLEVEL_TIME_LEVEL"] = "升级所需时间: ";
L["TITAN_XP_LEVEL_COMPLETE"] = "升级: ";
L["TITAN_XP_TOTAL_RESTED"] = "剩余: ";
L["TITAN_XP_XPTOLEVELUP"] = "升级所需经验: ";
L["TITAN_XP_TOOLTIP"] = "经验相关信息";
L["TITAN_XP_TOOLTIP_TOTAL_TIME"] = "总共游戏时间: ";
L["TITAN_XP_TOOLTIP_LEVEL_TIME"] = "当前等级的游戏时间: ";
L["TITAN_XP_TOOLTIP_SESSION_TIME"] = "本次连接游戏时间: ";
L["TITAN_XP_TOOLTIP_TOTAL_XP"] = "当前级别总经验: ";
L["TITAN_XP_TOOLTIP_LEVEL_XP"] = "当前等级所获经验: ";
L["TITAN_XP_TOOLTIP_TOLEVEL_XP"] = "升级所需经验: ";
L["TITAN_XP_TOOLTIP_SESSION_XP"] = "本次连接所获经验: ";
L["TITAN_XP_TOOLTIP_XPHR_LEVEL"] = "经验/小时 当前级别: ";
L["TITAN_XP_TOOLTIP_XPHR_SESSION"] = "经验/小时 本次连接: ";     
L["TITAN_XP_TOOLTIP_TOLEVEL_LEVEL"] = "升级时间 (按等级效率): ";
L["TITAN_XP_TOOLTIP_TOLEVEL_SESSION"] = "升级时间 (按连接效率): ";
L["TITAN_XP_MENU_TEXT"] = "经验";
L["TITAN_XP_MENU_SHOW_XPHR_THIS_LEVEL"] = "显示当前级别 经验/小时";
L["TITAN_XP_MENU_SHOW_XPHR_THIS_SESSION"] = "显示本次连接 经验/小时";
L["TITAN_XP_MENU_SHOW_RESTED_TOLEVELUP"] = "更多信息显示";
L["TITAN_XP_MENU_SIMPLE_BUTTON_TITLE"] = "按钮";
L["TITAN_XP_MENU_SIMPLE_BUTTON_RESTED"] = "显示双倍的经验值";
L["TITAN_XP_MENU_SIMPLE_BUTTON_TOLEVELUP"] = "显示升级所需经验";
L["TITAN_XP_MENU_SIMPLE_BUTTON_KILLS"] = "显示升级所需的预估击杀数";
L["TITAN_XP_MENU_RESET_SESSION"] = "重置连接时间";
L["TITAN_XP_MENU_REFRESH_PLAYED"] = "刷新计时器";
L["TITAN_XP_UPDATE_PENDING"] = "更新中...";
L["TITAN_XP_KILLS_LABEL"] = "升级所需击杀数 (基于最后一个的经验 %s): ";
L["TITAN_XP_KILLS_LABEL_SHORT"] = "预估击杀数: ";
L["TITAN_XP_BUTTON_LABEL_SESSION_TIME"] = "连接时间: ";
L["TITAN_XP_MENU_SHOW_SESSION_TIME"] = "显示连接时间";
L["TITAN_XP_GAIN_PATTERN"] = "(.*)死亡，你获得(%d+)点经验。";
L["TITAN_XP_XPGAINS_LABEL_SHORT"] = "预估获得经验: ";
L["TITAN_XP_XPGAINS_LABEL"] = "升级所需杀怪数 (基于最后杀怪所获%s点经验): ";
L["TITAN_XP_MENU_SIMPLE_BUTTON_XPGAIN"] = "显示升级所需(基于最后一次所获经验)";
     
     --Titan Repair
   L["REPAIR_LOCALE"] = {
          menu = "修理",
          tooltip = "耐久度信息",
          button = "耐久度: ",
          normal = "修理费用 (正常): ",
          friendly = "修理费用 (友善): ",
          honored = "修理费用 (尊敬): ",
          revered = "修理费用 (崇敬): ",
          exalted = "修理费用 (崇拜): ",
          buttonNormal = "显示正常费用",
          buttonFriendly = "显示(声望友善)费用 (5%折扣)",
          buttonHonored = "显示(声望尊敬)费用 (10%折扣)",
          buttonRevered = "显示(声望崇敬)费用 (15%折扣)",
          buttonExalted = "显示(声望崇拜)费用 (20%折扣)",
          percentage = "显示为百分比",
          itemnames = "显示物品名称",
          mostdamaged = "耐久度最低的",
          showdurabilityframe = "显示耐久度面板",
          undamaged = "显示未掉耐久度的物品",
          discount = "折扣",
          nothing = "没有需要修理的物品",
          confirmation = "你确定要修理所有装备吗 ?",
          badmerchant = "这个商人不能修理，现在将显示正常费用",
          popup = "显示维修框",
          showinventory = "统计背包中的需修理物品",
          WholeScanInProgress = "更新中...",
          AutoReplabel = "自动修理",
          AutoRepitemlabel = "自动修理所有物品",
          ShowRepairCost = "显示修理费用",
		      ignoreThrown = "忽略投掷武器",
		  		ShowItems = "显示物品",
		  		ShowDiscounts = "显示折扣",
		  		ShowCosts = "显示花费",
		  		Items = "物品",
		  		Discounts = "折扣",
		  		Costs = "花费",
				CostTotal = "总花费",
				CostBag = "背包内花费",
				CostEquip = "身上装备花费",
 				TooltipOptions = "提示文字",
    };
     
L["TITAN_REPAIR"] = "Titan 修理"
L["TITAN_REPAIR_GBANK_TOTAL"] = "公会银行总资金 :"
L["TITAN_REPAIR_GBANK_WITHDRAW"] = "公会银行允许的费用 :"
L["TITAN_REPAIR_GBANK_USEFUNDS"] = "使用公会银行资金"
L["TITAN_REPAIR_GBANK_NOMONEY"] = "公会银行余额不足或者你超过了允许的使用量."
L["TITAN_REPAIR_GBANK_NORIGHTS"] = "你没有公会或你没有权限使用公会资金来修理."
L["TITAN_REPAIR_CANNOT_AFFORD"] = "现在，至少，你没钱来修理."
L["TITAN_REPAIR_REPORT_COST_MENU"] = "报告修理费到聊天频道"
L["TITAN_REPAIR_REPORT_COST_CHAT"] = "修理花费 "
     
L["TITAN_PLUGINS_MENU_TITLE"] = "扩展模块"; 

L["TITAN_GOLD_TOOLTIPTEXT"] = "统计所持有金币信息";
L["TITAN_GOLD_ITEMNAME"] = "金币助手";
L["TITAN_GOLD_CLEAR_DATA_TEXT"] = "清除已存数据";
L["TITAN_GOLD_RESET_SESS_TEXT"] = "重置现有周期";
L["TITAN_GOLD_DB_CLEARED"] = "Titan金币查看助手 - 数据已清除.";
L["TITAN_GOLD_SESSION_RESET"] = "Titan金币查看助手 - 周期已重置.";
L["TITAN_GOLD_MENU_TEXT"] = "金币助手";
L["TITAN_GOLD_TOOLTIP"] = "金币信息";
L["TITAN_GOLD_TOGGLE_PLAYER_TEXT"] = "显示玩家金币";
L["TITAN_GOLD_TOGGLE_ALL_TEXT"] = "显示所有角色金币";
L["TITAN_GOLD_SESS_EARNED"] = "这个周期所赚金币";
L["TITAN_GOLD_PERHOUR_EARNED"] = "每小时所赚金币";
L["TITAN_GOLD_SESS_LOST"] = "这个周期所花费金币";
L["TITAN_GOLD_PERHOUR_LOST"] = "每小时花费金币";
L["TITAN_GOLD_STATS_TITLE"] = "周期统计";
L["TITAN_GOLD_TTL_GOLD"] = "总金币";
L["TITAN_GOLD_START_GOLD"] = "起始金币数";
L["TITAN_GOLD_TOGGLE_SORT_GOLD"] = "按金币数排列";
L["TITAN_GOLD_TOGGLE_SORT_NAME"] = "按角色名排列";
L["TITAN_GOLD_TOGGLE_GPH_SHOW"] = "显示每小时金币进出";
L["TITAN_GOLD_TOGGLE_GPH_HIDE"] = "隐藏每小时金币进出";
L["TITAN_GOLD_GOLD"] = "g";
L["TITAN_GOLD_SILVER"] = "s";
L["TITAN_GOLD_COPPER"] = "c";
L["TITAN_GOLD_STATUS_PLAYER_SHOW"] = "显示";
L["TITAN_GOLD_STATUS_PLAYER_HIDE"] = "隐藏";
L["TITAN_GOLD_DELETE_PLAYER"] = "删除这个角色";
L["TITAN_GOLD_SHOW_PLAYER"] = "Show toon";
L["TITAN_GOLD_FACTION_PLAYER_ALLY"] = "联盟";
L["TITAN_GOLD_FACTION_PLAYER_HORDE"] = "部落";
L["TITAN_GOLD_CLEAR_DATA_WARNING"] = GREEN_FONT_COLOR_CODE.."警告: "
..FONT_COLOR_CODE_CLOSE.."这会清楚你的Titan金币统计数据库. "
.."如果你想继续操作请按 '接受', 否则请按 '取消'.";
L["TITAN_GOLD_COIN_NONE"] = "不现实标签";
L["TITAN_GOLD_COIN_LABELS"] = "显示标签文字";
L["TITAN_GOLD_COIN_ICONS"] = "显示标签图标";
L["TITAN_GOLD_ONLY"] = "只显示金";
L["TITAN_GOLD_COLORS"] = "显示金币颜色";

L["TITAN_VOLUME_TOOLTIP"] = "音量信息";
L["TITAN_VOLUME_MASTER_TOOLTIP_VALUE"] = "主音量: ";
L["TITAN_VOLUME_SOUND_TOOLTIP_VALUE"] = "音效音量: ";
L["TITAN_VOLUME_AMBIENCE_TOOLTIP_VALUE"] = "环境音量: ";
L["TITAN_VOLUME_MUSIC_TOOLTIP_VALUE"] = "音乐音量: ";
L["TITAN_VOLUME_MICROPHONE_TOOLTIP_VALUE"] = "麦克风音量: ";
L["TITAN_VOLUME_SPEAKER_TOOLTIP_VALUE"] = "扬声器音量: ";
L["TITAN_VOLUME_TOOLTIP_HINT1"] = "提示: 用鼠标左键来调节"
L["TITAN_VOLUME_TOOLTIP_HINT2"] = "音量.";
L["TITAN_VOLUME_CONTROL_TOOLTIP"] = "音量控制: ";
L["TITAN_VOLUME_CONTROL_TITLE"] = "音量控制";
L["TITAN_VOLUME_MASTER_CONTROL_TITLE"] = "主音量";
L["TITAN_VOLUME_SOUND_CONTROL_TITLE"] = "音效音量";
L["TITAN_VOLUME_AMBIENCE_CONTROL_TITLE"] = "环境音量";
L["TITAN_VOLUME_MUSIC_CONTROL_TITLE"] = "音乐";
L["TITAN_VOLUME_MICROPHONE_CONTROL_TITLE"] = "麦克风";
L["TITAN_VOLUME_SPEAKER_CONTROL_TITLE"] = "扬声器";
L["TITAN_VOLUME_CONTROL_HIGH"] = "高";
L["TITAN_VOLUME_CONTROL_LOW"] = "低";
L["TITAN_VOLUME_MENU_TEXT"] = "音量控制";
L["TITAN_VOLUME_MENU_AUDIO_OPTIONS_LABEL"] = "显示 声音控制" ;
L["TITAN_VOLUME_MENU_OVERRIDE_BLIZZ_SETTINGS"] = "替换默认声音控制";

-- Version : Simplified Chinese
-- Translated by Yeachan
-- Email:yeachan@live.com
