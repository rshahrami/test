FROM python:3.10.8 as base

ENV PYTHONUNBUFFERED 1
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install wheel
RUN pip install -r requirements.txt


FROM python:3.10.8-slim-buster

ENV PYTHONUNBUFFERED 1

WORKDIR /app

RUN apt-get update && \
    apt-get install -y libpq-dev && \
    apt-get install -y unixodbc-dev


COPY --from=base /opt/venv /opt/venv
COPY test.py .
ENV PATH="/opt/venv/bin:$PATH"

CMD ["python", "test.py"]
# RUN python manage.py collectstatic --no-input

# CMD gunicorn --bind :8080 --worker-class gevent config.wsgi:application --timeout 300