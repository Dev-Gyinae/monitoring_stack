#!/bin/bash
export INSTALL_K3S_CHANNEL=stable
export INSTALL_K3S_EXEC="--disable=traefik --disable=servicelb --disable=metrics-server"
export K3S_KUBECONFIG_MODE="644"
export INSTALL_K3S_NAME="k3s"
