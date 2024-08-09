# Install Docker
sudo pacman -S docker

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Install yay (AUR helper)
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Install Minikube
yay -S minikube

# Install kubectl
sudo pacman -S kubectl

# Start Minikube with Docker driver
minikube start --driver=docker

# Verify Minikube status
minikube status
