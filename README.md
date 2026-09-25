# gcube-ai-suite v1

Reusable gcube container including:
- ComfyUI
- ComfyUI-Manager
- JupyterLab
- rclone / Wasabi support
- ffmpeg
- Git/Python tooling

## Important security rule

Never put real Wasabi keys inside the image or Git repository.

Pass these as gcube workload environment variables:
- WASABI_ACCESS_KEY_ID
- WASABI_SECRET_ACCESS_KEY
- WASABI_BUCKET (default: gabrielimani-gcube)
- WASABI_REGION (default: us-east-1)
- WASABI_ENDPOINT (default: s3.wasabisys.com)
- JUPYTER_TOKEN
- SYNC_INTERVAL (default: 300 seconds)

## gcube workload settings

Recommended exposed HTTP port: 8888

JupyterLab:
- normal gcube service URL

ComfyUI:
- append `/proxy/8188/` to the Jupyter URL

## Persistence design

gcube local disk = fast temporary workspace.

Wasabi = permanent storage for:
- comfyui/user
- comfyui/input
- comfyui/output
- models (optional, pulled on demand)

Large model weights are not baked into the image by default.

## Helper commands

Pull models from Wasabi:
    wasabi-pull-models

Push local models to Wasabi:
    wasabi-push-models

Run one backup now:
    wasabi-sync-once

## Build and publish

Use the included GitHub Actions workflow.

Resulting image:
    ghcr.io/<YOUR_GITHUB_USERNAME>/gcube-ai-suite:latest

In gcube choose Registry Type: GitHub.
