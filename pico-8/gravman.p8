pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--gravman
--brennan rodriguez
objects = {} -- the objects in the world
cam = {} -- variables to track the camera
cam.x_offset = 0
cam.y_offset = 201


function make_object(name,sprite,x,y)

obj = {}
obj.name = name
obj.spr = sprite
obj.x = x
obj.y = y
obj.gravity = 0
obj.speed = 0
add(objects,obj)

return obj
end

function _init()
local playerobj = make_object("player",1,cam.x_offset,cam.y_offset + 64)
playerobj.gravity = 2
playerobj.speed = 2

end


function _update()


--player logic
tp = getplayer()

	if(btnp(4) or btnp(5)) then
		tp.gravity *= -1
	end
	if(btnp(0)) then
		tp.x -= 1
	end
	if(btnp(1)) then
		tp.x += 1
	end
	tp.spr = 1
	if(will_player_collide_vertically() == false) then
		moveplayer(0, getplayer().gravity)
		cam.y_offset += getplayer().gravity
		tp.spr = 2
	end
	if(is_player_crashed() == false) then
		moveplayer(getplayer().speed, 0)
		cam.x_offset += getplayer().speed
	else
		local lineholder = 0--nothing yet
	end

	camera(cam.x_offset,cam.y_offset)
end


function render_object(obj)
spr(obj.spr,obj.x,obj.y)

end


function _draw()
cls()
circfill(20,20,10,1)
foreach(objects, render_object)
map(0,0,0,0,127,63)
end



-->8
--player functions
function getplayer()
local playerfound = false
	for i = 1, count(objects)
	do
		if(objects[i].name == "player") then
		playerfound = true
		return objects[i],i
		end

	end

end

function updateplayer(player)
	local playerindex = -1

	for i = 1, count(objects)
	do
		if(objects[i].name == player) then
		playerindex = i
		end
	end
	if(playerindex != -1) then
	local tableplayer = objects(playerindex)
	tableplayer = player
	end

end


function getplayercell()
local tp = getplayer()
local celx = flr(tp.x / 8)
local cely = flr(tp.y / 8)
return celx, cely
end

function moveplayer(x,y)
	local tempplayer = getplayer()
if (x != 0)	tempplayer.x += x

if (y != 0)	tempplayer.y += y
updateplayer(tempplayer)
end


function will_player_collide_vertically()
local tp,pindex = getplayer()
local coldet = false
local gm = abs(tp.gravity) / tp.gravity --either a -1 or 1
	for	i = 1, abs(tp.gravity)
		do
		if((check_collision_tile(tp.x,i * gm - gm + tp.y))--checks bottom left corner + gravity to see if it will collide
		or
		(check_collision_tile(tp.x,i * gm + tp.y - 8))--top left
		or
		(check_collision_tile(tp.x + 7,i * gm - gm + tp.y))--bottom right
		or
		(check_collision_tile(tp.x + 7,i * gm  + tp.y - 8)))--top right
		then coldet = true
		end
	end
	if(coldet) then
		return true
	else
		return false
	end

end

--finds if a player has collided with a wall horizontally
function is_player_crashed()
	local tp,pindex = getplayer()
	local coldet = false
	local sm = abs(tp.speed) / tp.speed --either a -1 or 1
		for	i = 1, abs(tp.speed)
			do
			if((check_collision_tile(tp.x,tp.y))--checks bottom left corner + gravity to see if it will collide
			or
			(check_collision_tile(tp.x,tp.y - 8))--top left
			or
			(check_collision_tile(tp.x + 8 ,tp.y))--bottom right
			or
			(check_collision_tile(tp.x + 8,tp.y - 8)))--top right
			then coldet = true
			end
		end
		if(coldet) then
			return true
		else
			return false
		end


end
-->8
--enviroment functions
--gets a tile from a position x,y
function get_tile(x,y)
	local celx = flr(x / 8)
	local cely = flr(y / 8) + 1
return celx, cely
end


--checks if location(x,y) will collide with another object
--returns that objects index, or -1 if you're safe
function check_collision(x,y)
	local wasfound = false
	for i = 1, count(objects)
	do
		if(objects[i].name == "player") then local argx = 0
		elseif(
		(y > objects[i].y -8 and y <= objects[i].y)
		and
		(x >= objects[i].x and x < objects[i].x + 8)
		)then
			wasfound = true
			return i
		end
	end

	if(wasfound != true) then
	return -1
	end
end

function check_collision_tile(x,y)
local xcell, ycell = get_tile(x,y)
	if(mget(xcell, ycell) == 32) then
		return true
	else
		return false
	end
end



-->8
--debug functions

function get_objnames()
	local returnstring = {"names: "}
	for i = 1, count(objects)
		do
		local stringtoadd = objects[i].name .. " "
		add(returnstring, stringtoadd)
		end
--returnstring = table.concat(returnstring)
		return returnstring

end
__gfx__
000000006cccccc66888888600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007005555555d5555555d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000555555dd555555dd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000555555dd555555dd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007005555555d5555555d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000006cccccc66888888600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d555556c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d555566c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d555666c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d556666c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d566666c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d666666c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cdddddd8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dcdddd8d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddcdd8dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddc8ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddc8ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddcdd8dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dcdddd8d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cdddddd8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000002020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000002020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000002020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000002020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00044400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00044400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00511100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00511100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00511100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00110100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000001111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000011111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000011111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000001111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__map__
2020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000002020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000002020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000002020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000002020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010f00000e7400e7300e7100e7400c7200e7400c7200e740107401073010710107400e720107401172010740137400e7300e71013740107201074010720137401274012730127101274012720127401272012740
000f00001c0601c0501c0401c0301c0201c0101d0601d0501d0401d0301d0201d0101d0601d0401d0301d00021060210502104021030210202101023060230502304020060200502004020060200400000020050
__music__
02 01424344

