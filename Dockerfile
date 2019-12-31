
# start from a debian image with Java 7 and git preinstalled
FROM  openjdk:8

# install packages 
RUN echo '***** Update packages *****'                                                                          \
    && apt-get -y update                                                                                        \
                                                                                                                \
    && echo '***** Install packages REQUIRED for creating this image *****'                                     \
    && apt-get -y install apt-utils curl makepasswd gcc make                                                    \
                                                                                                                \
    && echo '***** Install packages required by YesWorkflow *****'                                              \
    && apt-get -y install graphviz                                                                              \
                                                                                                                \
    && echo '***** Install packages NOT required to run yesworkflow *****'                                      \
    && apt-get -y install sudo man less file tree                                            
                  
# create an unprivileged user
RUN echo '***** Create the yw user *****' \
    && useradd yw --gid sudo \
                 --shell /bin/bash \
                 --create-home \
    && echo "yw ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/yw \
    && chmod 0440 /etc/sudoers.d/yw

# perform remaining commands as the user and within the user's home directory
ENV HOME /home/yw
USER  yw
WORKDIR $HOME

# specify name, version, and location of YW jar to be used
ENV YW_RELEASES https://github.com/yesworkflow-org/yw-prototypes/releases
ENV YW_VERSION 0.2.1.2
ENV YW_JAR $HOME/bin/yesworkflow-${YW_VERSION}.jar

RUN echo '***** Download yw-prototypes executable jar and create alias *****' \
    && mkdir $HOME/bin  \
    && wget -O $YW_JAR ${YW_RELEASES}/download/v${YW_VERSION}/yesworkflow-${YW_VERSION}-jar-with-dependencies.jar \
    && echo "alias yw='java -jar $YW_JAR'"  >> $HOME/.bash_aliases

RUN echo '***** Download and build XSB 3.8 *****'                                                               \
    && svn checkout svn://svn.code.sf.net/p/xsb/src/trunk/XSB xsb-3.8                                  \
    && cd xsb-3.8/build                                                                                \
    && ./configure                                                                                     \
    && ./makexsb                                                        \
    && cd                                                                                                       \
    && echo 'export PATH="/home/yw/xsb-3.8/bin:$PATH"' >> .bashrc
    
# start an interactive bash login shell when the image is run
CMD  /bin/bash -il
