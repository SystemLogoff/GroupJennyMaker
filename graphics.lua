j = {}

ImageNames = love.filesystem.getDirectoryItems( "j" )

for i = 1, #ImageNames do
	local path = "j/" .. ImageNames[i]
	j[i] = love.graphics.newImage(path)
	print(path)
end

im = {}

ImageNames = love.filesystem.getDirectoryItems( "i" )

for i = 1, #ImageNames do
	local path = "i/" .. ImageNames[i]
	im[i] = love.graphics.newImage(path)
	print(path)
end
