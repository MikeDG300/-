FROM astra:175
COPY ./Python_Hello_World /Python_Hello_World
EXPOSE 5000
CMD ["python", "/Python_Hello_World"]
