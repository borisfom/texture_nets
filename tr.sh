#! /bin/bash
th -ldisplay.start 8000 0.0.0.0 &
IMAGE_NAME=coco.jpg
# IMAGE_NAME=monet_adain.png
# IMAGE_NAME=dali-dream.jpg
MODEL=johnson
DESCRIPTION=relu4_2
NORMALIZATION=batch
STYLE_WEIGHT=30
PYRAMID_LOSS=3
PYRAMID_DECAY=0.2
IMAGE_SIZE=512
GPU_ID=1
CONTENT_LAYERS=relu4_2
STYLE_LAYERS=relu1_1,relu2_1,relu3_1,relu4_1
OUT_DIR=/train/checkpoints/${IMAGE_NAME}_${DESCRIPTION}_${MODEL}_${STYLE_WEIGHT}_${PYRAMID_LOSS}_${PYRAMID_DECAY}_${IMAGE_SIZE}_${1}
mkdir -p ${OUT_DIR}
TRAIN_COMMAND="train.lua -data /dataset/coco -style_image /train/styles/${IMAGE_NAME} -checkpoints_path ${OUT_DIR} -content_layers ${CONTENT_LAYERS} -style_layers ${STYLE_LAYERS} -model ${MODEL} -normalization ${NORMALIZATION} -style_weight ${STYLE_WEIGHT} -pyramid_loss ${PYRAMID_LOSS} -pyramid_decay ${PYRAMID_DECAY} -style_size 0 -image_size ${IMAGE_SIZE} -gpu ${GPU_ID}"
echo ${TRAIN_COMMAND} > ${OUT_DIR}/command.txt
cp "$(readlink -f $0)" "${OUT_DIR}"
pushd /texture_nets
th ${TRAIN_COMMAND} $@

