#! /bin/bash
# th -ldisplay.start 8000 0.0.0.0 &
# IMAGE_NAME=yellow-red-blue-1925.jpg
IMAGE_NAME=kandinsky-26.png
# IMAGE_NAME=dali-dream.jpg
MODEL=johnson
DESCRIPTION=relu4_2
NORMALIZATION=batch
STYLE_WEIGHT=6
PYRAMID_LOSS=2
PYRAMID_DECAY=0.2
IMAGE_SIZE=378
BATCH=4
GPU_ID=1
CONTENT_LAYERS=relu4_2
STYLE_LAYERS=relu1_2,relu2_2,relu3_2,relu4_2

OUT_DIR=/train/checkpoints/${IMAGE_NAME}_${DESCRIPTION}_${MODEL}_${STYLE_WEIGHT}_${PYRAMID_LOSS}_${PYRAMID_DECAY}_${IMAGE_SIZE}_${1}
mkdir -p ${OUT_DIR}
TRAIN_COMMAND="train.lua -data /dataset/coco -style_image /train/styles/${IMAGE_NAME} -checkpoints_path ${OUT_DIR} -content_layers ${CONTENT_LAYERS} -style_layers ${STYLE_LAYERS} -model ${MODEL} -normalization ${NORMALIZATION} -style_weight ${STYLE_WEIGHT} -pyramid_loss ${PYRAMID_LOSS} -pyramid_decay ${PYRAMID_DECAY} -style_size 0 -image_size ${IMAGE_SIZE} -gpu ${GPU_ID} -backend cunn -batch_size ${BATCH} -learning_rate ${BATCH}e-3"
echo ${TRAIN_COMMAND} > ${OUT_DIR}/command.txt
cp "$(readlink -f $0)" "${OUT_DIR}"
th ${TRAIN_COMMAND} $@

