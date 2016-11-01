function string:split(sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

function send_inline(chat_id, text, keyboard, mark)
	local response = {}
	response.inline_keyboard = keyboard
	local responseString = json.encode(response)
	if mark then
		sended = send_api.."/sendMessage?chat_id="..chat_id.."&text="..url.escape(text).."&disable_web_page_preview=true&reply_markup="..url.escape(responseString)
	else
		sended = send_api.."/sendMessage?chat_id="..chat_id.."&text="..url.escape(text).."&parse_mode=Markdown&disable_web_page_preview=true&reply_markup="..url.escape(responseString)
	end
	return send_req(sended)
end

function send_inlines(chat_id, text, keyboard, mark)
	local response = {}
	response.inline_keyboard = keyboard
	local responseString = json.encode(response)
	if mark then
		sended = send_api.."/sendMessage?chat_id="..chat_id.."&text="..url.escape(text).."&disable_web_page_preview=true&reply_markup="..url.escape(responseString)
	else
		sended = send_api.."/sendMessage?chat_id="..chat_id.."&text="..url.escape(text).."&parse_mode=HTML&disable_web_page_preview=true&reply_markup="..url.escape(responseString)
	end
	return send_req(sended)
end

function edit_msg(id, text, keyboard)
	local response = {}
	response.inline_keyboard = keyboard
	local responseString = json.encode(response)
	sended = send_api..'/editMessageText?inline_message_id='..id..'&parse_mode=Markdown&disable_web_page_preview=true&text='..url.escape(text)..'&reply_markup='..url.escape(responseString)
	return send_req(sended)
end

function requrl(requrls)
	return io.popen('curl -s "'..requrls..'"'):read("*all") --url.escape()
end