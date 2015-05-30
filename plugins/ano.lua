-- ano.lolcalhost.org Random pics plugin
-- Based on giphy

do

local BASE_URL = 'http://ano.lolcathost.org/'
local PICS_BASE = 'http://ano.lolcathost.org/pics/'

local function get_image(response)
  -- vardump(response)
  local image = json:decode(string.gsub(response,'\n',''))
  -- if #image == 0 then return nil end -- No images
  -- local i = math.random(#images)
  -- local image =  images[i] -- A random one

vardump(image)

  if image.pic.id then
    return PICS_BASE .. image.pic.id
  end

  return nil
end

local function get_random_top()
  local url = BASE_URL.."/json/pic.json?method=random"
  local response, code = http.request(url)
  if code ~= 200 then return nil end
  return get_image(response)
end

local function search(text)
  text = URL.escape(text)
  -- searchStr := fmt.Sprintf("{ \"method\" : \"searchRelated\", \"tags\" : [%v], \"limit\" : 10 }",
  local url = BASE_URL.."/json/tag.json?method=searchRelated&limit=10&tags="..text..""
  local response, code = http.request(url)
  if code ~= 200 then return nil end
  return get_image(response)
end

local function run(msg, matches)
  local pic_url = nil

  -- If no search data, a random random PIC will be sent
  if matches[1] == "!ano" then
    pic_url = get_random_top()
  else
    pic_url = search(matches[1])
  end

  if not pic_url then
    return "Error: PIC not found"
  end

  local receiver = get_receiver(msg)
  print("PIC URL"..pic_url)

  send_photo_from_url(receiver, pic_url)
end

return {
  description = "Pics from ano.lolcalhost.org",
  usage = {
    "!ano (term): Search and sends random pic from ano.lolcalhost.org"
    },
  patterns = {
    "^!ano$",
    "^!ano (.*)"
  },
  run = run
}

end
