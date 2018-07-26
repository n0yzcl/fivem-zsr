function DistanceBetweenCoords(x1,y1,z1,x2,y2,z2)
	local deltax = x1 - x2
	local deltay = y1 - y2
	local deltaz = z1 - z2

	local dist = math.sqrt((deltax * deltax) + (deltay * deltay) + (deltaz * deltaz))
	return dist
end

function DistanceBetweenCoords2D(x1,y1,x2,y2)
	local deltax = x1 - x2
	local deltay = y1 - y2

	dist = math.sqrt((deltax * deltax) + (deltay * deltay))

	return dist
end

function DrawText3D(x, y, z, text)
    SetDrawOrigin(x, y, z, 0);
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.0, 0.2)
    SetTextColour(19, 232, 46, 240)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
	if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
		return k
	else
		return "[" .. table.val_to_str( k ) .. "]"
	end
end

function table.tostring( tbl )
	local result, done = {}, {}
	for k, v in ipairs( tbl ) do
		table.insert( result, table.val_to_str( v ) )
		done[ k ] = true
	end

	for k, v in pairs( tbl ) do
		if not done[ k ] then
		 	table.insert( result,
			table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
		end
	end
	return "{" .. table.concat( result, "," ) .. "}"
end
