login with kali/kali
passwd
logout
ssh-copy-id -i ~/.ssh/raspi_id_rsa blackberryi
ssh blackberryi
sudo apt upgrade && sudo apt update
select yes for wireshark
sudo apt install fish
chsh -s $(which fish)
logout
login
sudo timedatectl set-timezone America/Los_Angeles
git config --global user.email 'you@example.com'
git config --global user.name 'Your Name'
ssh-keygen -t rsa -b 8192 -a 100 -f ~/.ssh/github_id_rsa
echo 'Host *
  IdentitiesOnly yes

Host github.com
  User git
  IdentityFile ~/.ssh/github_id_rsa' >> ~/.ssh/config
mkdir -p ~/.config && cd ~/.config
git clone git@github.com:andrewarchi/config dotfiles
cd dotfiles
./install.fish
sudo apt install neofetch screenfetch
mkdir -p ~/dev/github.com/andrewarchi && cd ~/dev/github.com/andrewarchi
ln -s ~/.config/dotfiles config
startx


git version
  git version 2.27.0
git config --global pull.rebase false

localectl status
locale
locale -a
sudo sed -i.bak -r 's/^#\s*(en_US\.UTF-8 UTF-8)/\1/' /etc/locale.gen
sudo sed -i -r 's/^#\s*(de_DE\.UTF-8 UTF-8)/\1/' /etc/locale.gen
sudo locale-gen
sudo localectl set-locale LANG=en_US.UTF-8


sudo apt-get install golang aptitude
go version
  go version go1.14.4 linux/arm64


hostnamectl set-hostname blackberryi
hostnamectl set-hostname --pretty 'Blackberry i'
echo '127.0.0.1 blackberryi' | sudo tee -a /etc/hosts
sudo sed -i'' -r 's/^(127.0.0.1\s+)kali(\s+localhost)/\1blackberryi\2/' /etc/hosts
