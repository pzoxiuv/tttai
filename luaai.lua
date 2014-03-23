require "my_opencv"

function sleep(n)
  local t = os.clock()
    while os.clock() - t <= n do
    -- nothing
  end
end

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

sleep(1); -- wait for tictactoe-ng to make its move

os.execute("scrot board.png")

board = {}
for i, t in ipairs(coords) do
	table.insert(board, checkSquare("board.png", t[1], t[2]))
end

for i, v in ipairs(board) do
	print(v)
end
