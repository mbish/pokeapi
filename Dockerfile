from ubuntu:22.04

RUN apt-get update
RUN apt-get install -y curl lsb-release
RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc
RUN curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | tee /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17 python3 mssql-tools unixodbc-dev virtualenv python3-pip
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

RUN mkdir /src
ADD requirements.txt /src

WORKDIR /src

RUN pip install -r requirements.txt
RUN pip install mssql-django
COPY ./fixed-checks.py /usr/local/lib/python3.10/dist-packages/corsheaders/checks.py
ADD . /src
CMD python3 manage.py migrate
