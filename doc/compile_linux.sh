#!/bin/bash
#This script downloads and compiles gro (as well as its dependencies ccl and chipmunk)
#Will generate 3 folders gro, ccl and chipmunk in current folder
#necessary packets are installed assuming you have apt-get as paket manager:
sudo apt-get install build-essential bison flex git qtbase5-dev git qt5-default libreadline-dev
git clone https://github.com/2t7/gro		#clone gro repo (from 2t7!). If you clone from klavinslab look at sed-Line below
git clone https://github.com/klavinslab/ccl	#clone ccl rep
wget https://chipmunk-physics.net/release/Chipmunk-5.x/Chipmunk-5.3.5.tgz --no-check-certificate	#download chipmunk
tar -xvf Chipmunk-5.3.5.tgz		#unpack chipmunk
mv Chipmunk-5.3.5 chipmunk 		#rename chipmunk folder
cp gro/useful/chipmunk.pro ./chipmunk/	#copy project file from gro/useful (needed for qmake)
cd ccl					#change to folder ccl
git checkout linux-compile		#checkout branch linux-compile (did work without though for me)
qmake					#generate a Makefile
make					#compile ccl
cd ../chipmunk				#change to chipmunk folder
qmake					#generate Makefile
make					#compile chipmunk
cd ../gro				#change to gro folder
#sed -i 's|chdir("../../..");|//chdir("../../..");|' gui.cpp	#Fixes path if you use this script but clone from klavinslab
qmake 					#generate Makefile
make					#compile gro
#---------------------------------------
#generate startup script for gro ( Get path and locale right, both can lead to problems)
cat > gro.sh << 'EOF'
#!/bin/bash
pushd `dirname $0` > /dev/null  #https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
BASEDIR=`pwd`                   #directory where this script resides (expecting gro binary and mlibs here)
popd > /dev/null                
cd $BASEDIR     		#gro needs working directory to to be where gro binary is located
LC_ALL=C ./gro 			#start gro from here
EOF
chmod +x ./gro.sh			#make script executable	

