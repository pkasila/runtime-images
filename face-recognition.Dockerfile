# Use Python 3.11 slim as the base image (matches YQL SystemPython3_11)
FROM python:3.11-slim

# Set environment variables to prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 1. Install system dependencies
# - build-essential & cmake: Required to compile dlib
# - libgl1 & libglib2.0-0: Required for OpenCV
# - wget & bzip2: Required to download and extract the model
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    wget \
    bzip2 \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Python libraries
# We use opencv-python-headless for smaller size and server compatibility
RUN pip install --no-cache-dir \
    numpy \
    opencv-python-headless \
    dlib

# 3. Download and prepare the Model Weights
WORKDIR /models
RUN wget http://dlib.net/files/shape_predictor_68_face_landmarks.dat.bz2 \
    && bzip2 -d shape_predictor_68_face_landmarks.dat.bz2

# 4. Set environment variable for the model path
ENV FACE_MODEL_PATH="/models/shape_predictor_68_face_landmarks.dat"

# Reset working directory
WORKDIR /