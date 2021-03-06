
local function res_block()
  -- Convolutions  
  local conv_block = nn.Sequential()
  
  conv_block:add(pad(1, 1, 1, 1))
  conv_block:add(nn.SpatialConvolution(128, 128, 3, 3, 1, 1, 0, 0))
  conv_block:add(normalization(128))
  conv_block:add(nn.ReLU(true))

  conv_block:add(pad(1, 1, 1, 1))
  conv_block:add(nn.SpatialConvolution(128, 128, 3, 3, 1, 1, 0, 0))
  conv_block:add(normalization(128))

  local concat = nn.ConcatTable():add(nn.Identity()):add(conv_block)
  
  -- Sum
  local res_block = nn.Sequential()
  res_block:add(concat)
  res_block:add(nn.CAddTable())
  return res_block
end


local model = nn.Sequential()

if params.mode == 'texture' then
  model:add(nn.NoiseFill(3))
end

model:add(pad(4, 4, 4, 4))
model:add(nn.SpatialConvolution(3, 32, 9, 9, 1, 1, 0, 0))
model:add(normalization(32))
model:add(nn.ReLU(true))

model:add(pad(1, 1, 1, 1))
model:add(nn.SpatialConvolution(32, 64,  3, 3, 2, 2, 0, 0))
model:add(normalization(64))
model:add(nn.ReLU(true))

model:add(pad(1, 1, 1, 1))
model:add(nn.SpatialConvolution(64, 128, 3, 3, 2, 2, 0, 0))
model:add(normalization(128))
model:add(nn.ReLU(true))

model:add(res_block())
model:add(res_block())
model:add(res_block())
model:add(res_block())
model:add(res_block())

model:add(nn.SpatialFullConvolution(128, 64, 3, 3, 2, 2, 1, 1, 1, 1))
model:add(normalization(64))
model:add(nn.ReLU(true))

model:add(nn.SpatialFullConvolution(64, 32, 3, 3, 2, 2, 1, 1, 1, 1))
model:add(normalization(32))
model:add(nn.ReLU(true))

model:add(pad(1, 1, 1, 1))
model:add(nn.SpatialConvolution(32, 3, 3, 3, 1, 1, 0, 0))

return model:add(nn.TVLoss(params.tv_weight))