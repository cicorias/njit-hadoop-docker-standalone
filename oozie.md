    1  oozie
    2  hadoop
    3  pwd
    4  cd ~
    5  ll
    6  ls -alt
    7  wget http://ftp.wayne.edu/apache/oozie/5.1.0/oozie-5.1.0.tar.gz
    8  tar -xzf oozie-5.1.0.tar.gz
    9  ll
   10  cd oozie-5.1.0
   11  ll
   12  ./bin/mkdistro.sh
   13  pig
   14  cd ..
   15  wget http://us.mirrors.quenda.co/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
   16  tar xzf apache-maven-3.6.3-bin.tar.gz
   17  cd apache-maven-3.6.3
   18  ll
   19  cd bin
   20  export PATH=$(pwd):$PATH
   21  cd ../...
   22  ll
   23  cd ..
   24  ll
   25  cd apache-maven-3.6.3
   26  ll
   27  cd ..
   28  ll
   29  cd oozie-5.1.0
   30  ll
   31  cd bin
   32  ll
   33  cd ..
   34  ./bin/mkdistro.sh
   35  history
