
# start from a debian image with Java 7 and git preinstalled
FROM  java:7

# install packages 
RUN echo '***** Update packages *****'                                                                          \
    && apt-get -y update                                                                                        \
                                                                                                                \
    && echo '***** Install packages REQUIRED for creating this image *****'                                     \
    && apt-get -y install curl makepasswd gcc make                                                              \
                                                                                                                \
    && echo '***** Install packages required by YesWorkflow *****'                                              \
    && apt-get -y install graphviz                                                                              \
                                                                                                                \
    && echo '***** Install packages NOT required to run yesworkflow *****'                                      \
    && apt-get -y install sudo apt-utils man less file tree vim emacs                                            
                  
# create an unprivileged user
RUN echo '***** Create the yw user *****'                                                                       \
    && useradd yw --gid sudo                                                                                    \
                 --shell /bin/bash                                                                              \
                 --create-home                                                                                  \
                 --password `echo yeswf | makepasswd --crypt-md5 --clearfrom - | cut -b11-`

# perform remaining commands as the user and within the user's home directory
USER  yw
WORKDIR  /home/yw

# set up user's run-time environment

RUN echo '***** Download yw-prototypes executable jar, expand examples, and create alias *****'                 \
    && mkdir ~/bin                                                                                              \
    && curl -o ~/bin/yw.jar https://opensource.ncsa.illinois.edu/bamboo/browse/KURATOR-YW-260/artifact/JOB1/executable-jar/yesworkflow-0.2-SNAPSHOT-jar-with-dependencies.jar \
    && cd /home/yw; jar -xvvf ~/bin/yw.jar examples                                                             \
    && echo "alias yw='java -jar ~/bin/yw.jar'"  >> ~/.bash_aliases

RUN echo '***** Download and build XSB 3.6 *****'                                                               \
    && svn checkout svn://svn.code.sf.net/p/xsb/src/trunk/XSB xsb-3.6                                           \
    && cd xsb-3.6/build                                                                                         \
    && ./configure                                                                                              \
    && ./makexsb                                                                                                \
    && cd                                                                                                       \
    && echo 'export PATH="/home/yw/xsb-3.6/bin:$PATH"' >> .bashrc
    
# start an interactive bash login shell when the image is run
CMD  /bin/bash -il
