require "my_opencv"
require "tree"

SQ_BLANK	= 0
SQ_X		= 1
SQ_O		= 2

function sleep(n)
  local t = os.clock()
    while os.clock() - t <= n do
    -- nothing
  end
end

function checkGameOver(b)
	return (b[1] == b[2] and b[1] == b[3] and b[1] ~= SQ_BLANK) or
	   (b[4] == b[5] and b[4] == b[6] and b[4] ~= SQ_BLANK) or
	   (b[7] == b[8] and b[7] == b[9] and b[7] ~= SQ_BLANK) or
	   (b[1] == b[4] and b[1] == b[7] and b[1] ~= SQ_BLANK) or
	   (b[2] == b[5] and b[2] == b[8] and b[2] ~= SQ_BLANK) or
	   (b[3] == b[6] and b[3] == b[9] and b[3] ~= SQ_BLANK) or
	   (b[1] == b[5] and b[1] == b[9] and b[1] ~= SQ_BLANK) or
	   (b[3] == b[5] and b[3] == b[7] and b[3] ~= SQ_BLANK)
end

function findMove(b)
	for i, s in ipairs(b) do
		if s == SQ_BLANK then return i end
	end
end

-- Initial setup: Find the board, get a table of coordinates, and sort them
os.execute("scrot board.png")
coords = detectAndDisplay("board.png", "single_square.xml")

table.sort(coords,
	function(a, b)
		local ay = math.floor(a[2]/100)
		local by = math.floor(b[2]/100)
		return ay < by or ay == by and a[1] < b[1]
	end
)

--for i, t in ipairs(coords) do
--    print ("X: " .. t[1] .. " Y: " .. t[2])
--end

-- Make opening click
doClick(coords[5][1], coords[5][2])

-- Main game loop:
while true do

	sleep(1); -- Wait for tictactoe-ng to make its move, then take a screenshot of the new board
	os.execute("scrot board.png")

	-- Get a table with the current board contents
	board = {}
	for i, t in ipairs(coords) do
		table.insert(board, checkSquare("board.png", t[1], t[2]))
	end

	-- Check if the game is over, if so break out of game loop
	if checkGameOver(board) then break end

	-- Otherwise, find a square to move to
	--square = findMove(board)
	square = getMove(board)

	-- And click there
	doClick(coords[square][1], coords[square][2])

end
