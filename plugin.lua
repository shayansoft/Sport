cbqkey = {{{text="1",callback_data="1"},{text="2",callback_data="2"},{text="3",callback_data="3"},{text="4",callback_data="4"},{text="5",callback_data="5"}}}

function getdate(o)
	return o
end

function run(msg)
	about_key = {{{text="Website",url="http://Umbrella.shayan-soft.ir"},{text="Master Channel",url="https://telegram.me/UmbrellaTeam"}},{{text="Master Robot",url="https://telegram.me/UmbreIIaBot"},{text="Instagram",url="https://instagram.com/UmbrellaTeam"}},{{text="Messanger",url="https://telegram.me/shayansoftBot"},{text="Admin",url="https://telegram.me/shayan_soft"}}}
	about_txt = "*Sport3 Robot* v"..bot_version.."\n\n`رباتی برای علاقمندان به فوتبال، محصولی از آمبرلا پروجکت...`\n\nبرنامه نویس: [مهندس شایان احمدی](https://instagram.com/shayan_soft)\nمشاور: [هیرش فرجی](https://instagram.com/heresh9)\nطراح لوگو: لیلا احمدی\nبا سپاس فراوان از آقای شکیب هدایتی و وبسایت ورزش3"	
	help_user = about_txt
	help_admin = "_Admin Commands:_\n\n".."   *Block a user:*\n".."     `/block {telegram id}`\n\n".."   *Unblock a user:*\n".."     `/unblock {telegram id}`\n\n".."   *Block list:*\n".."     /blocklist\n\n".."   *Send message to all users:*\n".."     `/sendtoall {message}`\n\n".."   *All users list:*\n".."     /users\n\n"
	start_txt = "به ربات اسپرت3 خوش آمدید\n\n`این ربات با مرجع ورزش3 اطلاعات را ارائه مینماید و قادر است اطلاعات کامل لیگای مهم جهان همچنین اخبار مرتبط با فوتبال را در اختیارتان قرار دهد.`"
	keyboard = {{"نتایج آنلاین بازیها"},{"اخبار فوتبال"},{"اطلاعات لیگها"},{"سایر پلتفرما","درباره ما"}}
	------------------------------------------------------------------------------------
	blocks = load_data("../blocks.json")
	users = load_data("users.json")
	userid = tostring(msg.from.id)
	
	if msg.text == "/start" then
		if users[userid] then
			users[userid].action = 0
			save_data("users.json", users)
			return send_key(msg.from.id, '`منوی اصلی:`', keyboard)
		else
			users[userid] = {}
			users[userid].action = 0
			users[userid].news = true
			save_data("users.json", users)
			return send_key(msg.from.id, start_txt, keyboard)
		end
	elseif msg.text:lower() == "about" or msg.text:lower() == "/about" or msg.text == "درباره ما" then
		return send_inline(msg.from.id, about_txt, about_key)
	elseif msg.text:lower() == "help" or msg.text:lower() == "/help" or msg.text == "راهنما" then
		if msg.from.id == sudo_id then
			return send_msg(msg.from.id, help_admin, true)
		else
			return send_msg(msg.from.id, help_user, true)
		end
	elseif not users[userid] then
		users[userid] = {}
		users[userid].action = 0
		users[userid].news = true
		save_data("users.json", users)
		return send_key(msg.from.id, start_txt, keyboard)
	end

	if msg.text:find('/sendtoall') and msg.from.id == sudo_id then
		local usertarget = msg.text:input()
		if usertarget then
			i=0
			for k,v in pairs(users) do
				i=i+1
				send_msg(k, usertarget, true)
			end
			return send_msg(sudo_id, "`پیام شما به "..i.." نفر ارسال شد`", true)
		else
			return send_msg(sudo_id, "*/sendtoall test*\n`/sendtoall [message]`", true)
		end
	elseif msg.text == "/users" and msg.from.id == sudo_id then
		local list = ""
		i=0
		for k,v in pairs(users) do
			i=i+1
			list = list..i.."- "..k.."\n"
		end
		return send_msg(sudo_id, "لیست اعضا:\n\n"..list, false)
	elseif msg.text == "/blocklist" and msg.from.id == sudo_id then
		local list = ""
		i=0
		for k,v in pairs(blocks) do
			if v then
				i=i+1
				list = list..i.."- "..k.."\n"
			end
		end
		return send_msg(sudo_id, "بلاک لیست:\n\n"..list, false)
	elseif msg.text:find('/block') and msg.from.id == sudo_id then
		local usertarget = msg.text:input()
		if usertarget then
			if tonumber(usertarget) == sudo_id or tonumber(usertarget) == bot.id then
				return send_msg(sudo_id, "`نمیتوانید خودتان را بلاک کنید`", true)
			end
			if blocks[tostring(usertarget)] then
				return send_msg(sudo_id, "`شخص مورد نظر بلاک است`", true)
			end
			blocks[tostring(usertarget)] = true
			save_data("../blocks.json", blocks)
			send_msg(tonumber(usertarget), "`شما بلاک شدید!`", true)
			return send_msg(sudo_id, "`شخص مورد نظر بلاک شد`", true)
		else
			return send_msg(sudo_id, "`بعد از این دستور آی دی شخص مورد نظر را با درج یک فاصله وارد کنید`", true)
		end
	elseif msg.text:find('/unblock') and msg.from.id == sudo_id then
		local usertarget = msg.text:input()
		if usertarget then
			if blocks[tostring(usertarget)] then
				blocks[tostring(usertarget)] = false
				save_data("../blocks.json", blocks)
				send_msg(tonumber(usertarget), "`شما آنبلاک شدید!`", true)
				return send_msg(sudo_id, "`شخص مورد نظر آنبلاک شد`", true)
			end
			return send_msg(sudo_id, "`شخص مورد نظر بلاک نیست`", true)
		else
			return send_msg(sudo_id, "`بعد از این دستور آی دی شخص مورد نظر را با درج یک فاصله وارد کنید`", true)
		end
	end
	
	if msg.text == "" or msg.text == false or msg.text == nil or msg.text == " " then
		return send_msg(msg.from.id, "`فقط متن وارد کنید`", true)
	end
	
	if msg.text == "منوی اصلی" then
		users[userid].action = 0
		save_data("users.json", users)
		return send_key(msg.from.id, "`منوی اصلی:`", keyboard)
	elseif msg.text == "اطلاعات لیگها" then
		users[userid].action = 1
		save_data("users.json", users)
		return send_key(msg.from.id, "`برای مشاهده ی اطلاعات هر لیگ، نام آن را انتخاب کنید`", {{"منوی اصلی"},{"ليگ برتر ايران","دسته يک ايران"},{"لیگ فوتسال ایران","بوندسليگا - آلمان"},{"لالیگا - اسپانیا","سری آ - ایتالیا"},{"لیگ جزیره - انگلیس","لوشامپیون - فرانسه"},{"لیگ برتر هلند","لیگ برتر روسیه"},{"گروه A مقدماتی آسیا","گروه B مقدماتی آسیا"}}, true)
	elseif msg.text == "اخبار فوتبال" then
		local res,dat = http.request('http://api.varzesh3.com/v0.2/news/live/1360000')
		if dat ~= 200 then return send_msg(msg.from.id, "`سرور خارج از سرویس میباشد لطفا بعدا تلاش کنید.`", true) end
		res = json.decode(res)
		list = "### 1-5 خبر آخر فوتبال ###"
		for i=1,5 do
			if res[i].Lead then
				if string.len(res[i].Lead) > 10 then
					newstext = ":\n<code>"..res[i].Lead.."</code>"
				else
					newstext = ""
				end
			else
				newstext = ""
			end
			dandt = res[i].LastUpdate:gsub("T","   ") --getdate(res[i].Timestamp)
			list = list.."\n<code>----------------------------------</code>\n"..i.."- <b>"..dandt.."</b>\n"..res[i].Title..newstext.."\n<a href='"..res[i].Url.."'>ادامه خبر</a>"
		end
		return send_inlines(msg.from.id, list, cbqkey)
	elseif msg.text == "سایر پلتفرما" then
		return send_msg(msg.from.id, "`به زودی...`", true)
	elseif msg.text == "نتایج آنلاین بازیها" then
		local res,dat = http.request('http://umbrella.shayan-soft.ir/sport3/livegames.php')
		if dat ~= 200 then return send_msg(msg.from.id, "`سرور خارج از سرویس میباشد لطفا بعدا تلاش کنید.`", true) end
		res = json.decode(res)
		list = "### نتایج آنلاین بازی ها ###\n`----------------------------------`\n"
		for i=1,#res do
			for m,n in pairs(res[i]) do
				game = ''
				for k,v in pairs(n) do
					game = game..k..' | '..v.."\n"
				end
				list = list..m..':\n`'..game..'----------------------------------`\n'
			end
		end
		return send_msg(msg.from.id, list, true)
	else
		if users[userid].action == 0 then
			return send_key(msg.from.id, "`فقط یکی از موارد کیبرد را انتخاب کنید:`", keyboard)
		end
	end
	
	if users[userid].action == 1 then
		if msg.text =="ليگ برتر ايران" then league="900931"
		elseif msg.text =="دسته يک ايران" then league="900971"
		elseif msg.text =="لیگ فوتسال ایران" then league="900977"
		elseif msg.text =="بوندسليگا - آلمان" then league="900959"
		elseif msg.text =="لالیگا - اسپانیا" then league="900958"
		elseif msg.text =="سری آ - ایتالیا" then league="900960"
		elseif msg.text =="لیگ جزیره - انگلیس" then league="900957"
		elseif msg.text =="لوشامپیون - فرانسه" then league="900961"
		elseif msg.text =="لیگ برتر هلند" then league="900962"
		elseif msg.text =="لیگ برتر روسیه" then league="900978"
		elseif msg.text =="گروه A مقدماتی آسیا" then league="900922"
		elseif msg.text =="گروه B مقدماتی آسیا" then league="900923"
		else
			return send_msg(msg.from.id, "`فقط یکی از موارد کیبرد را انتخاب کنید`", true)
		end
		local res,dat = http.request('http://api.varzesh3.com/v1.0.live/leaguestat/table/live/'..league)
		if dat ~= 200 then return send_msg(msg.from.id, "`سرور خارج از سرویس میباشد لطفا بعدا تلاش کنید.`", true) end
		res = json.decode(res)
		list = {{"برگشت","منوی اصلی"}}
		for i=1,#res do
			table.insert(list, {res[i].Team})
			x=i
		end
		users[userid].action = 2
		users[userid].teams = res
		save_data("users.json", users)
		return send_key(msg.from.id, "لیست تیمهای "..msg.text.." ("..x..")\n`برای مشاهده ی اطلاعات هر باشگاه، نام آن را انتخاب کنید`", list, true)
	elseif users[userid].action == 2 then
		if msg.text == "برگشت" then
			users[userid].action = 1
			save_data("users.json", users)
			return send_key(msg.from.id, "`برای مشاهده ی اطلاعات هر لیگ، نام آن را انتخاب کنید`", {{"منوی اصلی"},{"ليگ برتر ايران","دسته يک ايران"},{"لیگ فوتسال ایران","بوندسليگا - آلمان"},{"لالیگا - اسپانیا","سری آ - ایتالیا"},{"لیگ جزیره - انگلیس","لوشامپیون - فرانسه"},{"لیگ برتر هلند","لیگ برتر روسیه"},{"گروه A مقدماتی آسیا","گروه B مقدماتی آسیا"}}, true)
		end
		res = users[userid].teams
		for i=1,#res do
			if msg.text == res[i].Team then
				text = "`نام تیم:` "..res[i].Team.."\n\n"
					.."`امتیاز:` *"..res[i].Points.."*\n"
					.."`بازیها:` *"..res[i].Played.."*\n"
					.."نتایج:\n"
					.."`   پیروزی:` *"..res[i].Victories.."*"
					.."`   تساوی:` *"..res[i].Draws.."*"
					.."`   باخت:` *"..res[i].Defeats.."*\n"
					.."گلها:\n"
					.."`   زده:` *"..res[i].Made.."*"
					.."`   خورده:` *"..res[i].Let.."*"
					.."`   تفاضل:` *"..res[i].Diff.."*\n"
					.."[‌ ]("..res[i].FlagHQ..")" -- [@Sport3_Bot](telegram.me/Sport3_Bot)
				return send_msg(msg.from.id, text, true)
			end
		end
		return send_msg(msg.from.id, "`فقط یکی از موارد کیبرد را انتخاب کنید`", true)
	end
end

function cbinline(msg)
	bb = tonumber(msg.data)*5
	aa = bb-4
	local res,dat = http.request('http://api.varzesh3.com/v0.2/news/live/1360000')
	if dat ~= 200 then return send_msg(msg.from.id, "`سرور خارج از سرویس میباشد لطفا بعدا تلاش کنید.`", true) end
	res = json.decode(res)
	list = "### "..aa.."-"..bb.." خبر آخر فوتبال ###"
	for i=aa,bb do
		if res[i].Lead then
			if string.len(res[i].Lead) > 10 then
				newstext = ":\n<code>"..res[i].Lead.."</code>"
			else
				newstext = ""
			end
		else
			newstext = ""
		end
		dandt = res[i].LastUpdate:gsub("T","   ") --getdate(res[i].Timestamp)
		list = list.."\n<code>----------------------------------</code>\n"..i.."- <b>"..dandt.."</b>\n"..res[i].Title..newstext.."\n<a href='"..res[i].Url.."'>ادامه خبر</a>"
	end
	--return edit_msg(msg.id, list, cbqkey)
	return send_inlines(msg.from.id, list, cbqkey)
end

return {launch = run, cbinline = cbinline}