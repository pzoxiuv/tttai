function copyTable(src)
	local dst = {}
	for _, v in ipairs(src) do
		table.insert(dst, v)
	end
	return dst
end

function addChildren(r, j, maxDepth)
	if j >= maxDepth then return r end

	local board = r[1]
	local childList = {}

	for i, v in ipairs(board) do
		if v == 0 then
			newChild = {nil, nil}
			newChild[1] = copyTable(board)
			if j%2 == 0 then newChild[1][i] = 2
			else newChild[1][i] = 1 end
			table.insert(childList, newChild)
		end
	end
	if #childList == 0 then
		r[2] = nil
	else
		r[2] = childList
		for i, t in ipairs(r[2]) do
			r[2][i] = addChildren(t, j+1, maxDepth)
		end
	end

	return r
end

function printTree(r)
	for _, v in ipairs(r[1]) do io.write(v) end
	print()
	if r[2] == nil then return end
	for _, t in ipairs(r[2]) do printTree(t) end
end

function subh(b)
	local mins = 0
	local maxes = 0
	for _, i in ipairs(b) do
		if i == 1 then
			maxes = maxes + 1
		elseif i == 2 then
			mins = mins - 1
		end
	end
	if mins < 0 and maxes > 0 then return 0
	elseif mins < 0 then return mins
	else return maxes end
end

function h(board)
	local sum = 0
	local results = {}
	local sub = {{board[1], board[2], board[3]},
		{board[4], board[5], board[6]},
		{board[7], board[8], board[9]},
		{board[1], board[4], board[7]},
		{board[2], board[5], board[8]},
		{board[3], board[6], board[9]},
		{board[1], board[5], board[9]},
		{board[3], board[5], board[7]}}

	for _, b in ipairs(sub) do
		table.insert(results, subh(b))
	end

	for _, r in ipairs(results) do
		if r == 3 then sum = sum + 10
		elseif r == 2 then sum = sum + 3
		elseif r == 1 then sum = sum + 1
		elseif r == -1 then sum = sum - 1
		elseif r == -2 then sum = sum - 3
		elseif r == -3 then sum = sum - 10 end
	end
	return sum
end

function calcMinimax(r, i)
	local results = {}
	if r[2] ~= nil then
		for _, t in ipairs(r[2]) do
			table.insert(results, calcMinimax(t, i+1))
		end
		if i == 0 then -- special case, if i = 0 return index of max, not max
			for d, v in ipairs(results) do
				if v == math.max(unpack(results)) then return d end
			end
		elseif i%2 == 0 then
			return math.max(unpack(results))
		else
			return math.min(unpack(results))
		end
	else
		return h(r[1])
	end
end

function getMove(board)
	local root = {board, nil}

	root = addChildren(root, 1, 10)
	--printTree(root)
	local newBoard = root[2][calcMinimax(root, 0)][1]
	for i, s in ipairs(newBoard) do
		if s ~= board[i] then return i end
	end
end
