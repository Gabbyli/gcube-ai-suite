FROM ghcr.io/data-alliance/edu-genai-sd:latest

USER root

ENV DEBIAN_FRONTEND=noninteractive \
    COMFYUI_DIR=/opt/ComfyUI \
    WORKSPACE_DIR=/workspace \
    COMFYUI_PORT=8188 \
    JUPYTER_PORT=8888 \
    WASABI_REMOTE=wasabi \
    WASABI_BUCKET=gabrielimani-gcube \
    WASABI_REGION=us-east-1 \
    WASABI_ENDPOINT=s3.wasabisys.com \
    SYNC_INTERVAL=300

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      git curl ca-certificates unzip ffmpeg rsync tini && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://rclone.org/install.sh | bash

RUN git clone --depth=1 https://github.com/Comfy-Org/ComfyUI.git ${COMFYUI_DIR} && \
    pip install --no-cache-dir -r ${COMFYUI_DIR}/requirements.txt

RUN git clone --depth=1 https://github.com/Comfy-Org/ComfyUI-Manager.git \
      ${COMFYUI_DIR}/custom_nodes/ComfyUI-Manager && \
    if [ -f ${COMFYUI_DIR}/custom_nodes/ComfyUI-Manager/requirements.txt ]; then \
      pip install --no-cache-dir -r ${COMFYUI_DIR}/custom_nodes/ComfyUI-Manager/requirements.txt; \
    fi

RUN pip install --no-cache-dir jupyter-server-proxy

COPY scripts/ /usr/local/bin/
RUN chmod +x /usr/local/bin/gcube-start \
    /usr/local/bin/wasabi-sync-once \
    /usr/local/bin/wasabi-pull-models \
    /usr/local/bin/wasabi-push-models

WORKDIR /workspace

EXPOSE 8888 8188

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/local/bin/gcube-start"]
