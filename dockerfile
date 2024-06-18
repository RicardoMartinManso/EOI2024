FROM python:3.10
RUN useradd user
RUN pip install dice
WORKDIR /app/
COPY ./main.py /app/
USER user
CMD [ "python", "/app/main.py" ]
