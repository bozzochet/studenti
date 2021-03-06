FROM rootproject/root:latest

LABEL maintainer.name="Matteo Duranti"
LABEL maintainer.email="matteo.duranti@infn.it"

ENV LANG=C.UTF-8

COPY packages_custom packages_custom

RUN apt-get update -qq \
 && apt-get -y install $(cat packages_custom) \
 && rm -rf /var/lib/apt/lists/*

# Run the following commands as super user (root):
USER root

# Create a user that does not have root privileges 
ARG username=studente
RUN useradd --create-home --home-dir /home/${username} ${username}
ENV HOME /home/${username}

# Switch to our newly created user
USER ${username}

ADD dot-bashrc ${HOME}/.bashrc
ADD dot-rootlogon ${HOME}/.rootlogon.C

# Our working directory will be in our home directory where we have permissions
#WORKDIR /home/${username}
WORKDIR ${HOME}

RUN ln -s ${HOME}/current_dir/.bash_history ./
RUN ln -s ${HOME}/current_dir/.root_hist ./

# Our (final) working dir is the directory "mounted" from outside the container: docker run --rm -it -v `pwd`:/home/studente/current_dir bozzochet/studenti:latest
WORKDIR ${HOME}/current_dir

CMD ["root", "-b"]
