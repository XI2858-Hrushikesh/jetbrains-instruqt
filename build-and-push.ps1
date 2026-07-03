# build-and-push.ps1
# Run this once after you have created a Docker Hub account.
#
# Usage:
#   1. Replace hrushikeshkanade below with your actual Docker Hub username
#   2. Open PowerShell in this directory
#   3. Run: .\build-and-push.ps1

$DOCKERHUB_USERNAME = "hrushikeshkanade"
$IMAGE_NAME         = "jetbrains-instruqt"
$TAG                = "latest"
$FULL_IMAGE         = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${TAG}"

Write-Host "==> Building image: $FULL_IMAGE" -ForegroundColor Cyan
docker build -t $FULL_IMAGE .

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker build failed." -ForegroundColor Red
    exit 1
}

Write-Host "==> Logging in to Docker Hub..." -ForegroundColor Cyan
docker login

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker login failed." -ForegroundColor Red
    exit 1
}

Write-Host "==> Pushing image: $FULL_IMAGE" -ForegroundColor Cyan
docker push $FULL_IMAGE

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker push failed." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "SUCCESS: Image pushed to Docker Hub." -ForegroundColor Green
Write-Host "Update config.yml image field to: $FULL_IMAGE" -ForegroundColor Yellow
