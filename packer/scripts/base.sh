sudo adduser --system atlasdemo
sudo service tomcat7 stop
sudo -u atlasdemo export MAVEN_HOME=/usr/share/maven3

cd /home/atlasdemo
sudo -u atlasdemo git clone https://github.com/banuprakashurs/AtlasDemo.git

cd AtlasDemo/HelloAtlas
sudo -u atlasdemo mvn clean install

sudo cp 'target/HelloAtlas.war' /var/lib/tomcat7/webapps

sudo service tomcat7 start
