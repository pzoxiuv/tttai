require "my_opencv"

os.execute("scrot board.png")
coords = detectAndDisplay("board.png", "single_square.xml")

table.sort(coords,
	function(a, b)
		local ay = math.floor(a[2]/100)
		local by = math.floor(b[2]/100)
		return ay < by or ay == by and a[1] < b[1]
	end
)

for i, t in ipairs(coords) do
    print ("X: " .. t[1] .. " Y: " .. t[2])
end

doClick(coords[5][1], coords[5][2])
