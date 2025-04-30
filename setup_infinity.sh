#!/bin/bash

echo "📦 Mengupdate dan menginstal dependencies sistem..."
sudo apt-get update && sudo apt-get install -y \
    g++ make git ocl-icd-opencl-dev libopencl-clang-dev \
    curl python3 python3-pip clinfo nano

echo "🐍 Menginstal dependencies Python..."
pip3 install pybind11 safe-pysha3 ecdsa web3 coincurve websocket-client websockets python-dotenv

echo "🔽 Mengkloning repository infinity..."
git clone https://github.com/obisumila/infinity.git
cd infinity || { echo "Gagal masuk ke direktori infinity"; exit 1; }

echo "🔧 Membuat proyek..."
make clean && make

echo "🖥️ (Opsional) Mengatur OpenCL ICD untuk NVIDIA..."
sudo mkdir -p /etc/OpenCL/vendors
echo "libnvidia-opencl.so.1" | sudo tee /etc/OpenCL/vendors/nvidia.icd

echo "🧪 Menjalankan tes OpenCL..."
python3 test_opencl_kernel.py

echo "📝 Menyalin dan mengedit file konfigurasi .env..."
cp .env.example .env
echo "Silakan edit file .env untuk memasukkan alamat miner dan detail RPC:"
nano .env

echo "🚀 Menjalankan miner..."
python3 mine_infinity.py
