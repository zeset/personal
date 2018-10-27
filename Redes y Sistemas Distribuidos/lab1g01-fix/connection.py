# encoding: utf-8
# Copyright 2014 Carlos Bederián
# $Id: connection.py 455 2011-05-01 00:32:09Z carlos $

import socket
import os
from constants import *


class Request(object):

    def __init__(self, command, size):
        self.command = command
        self.size = size


class Connection(object):
    """
    Conexión punto a punto entre el servidor y un cliente.
    Se encarga de satisfacer los pedidos del cliente hasta
    que termina la conexión
    """

    def __init__(self, socket, directory):
        self.client_socket = socket
        self.directory = directory
        self.current_state = CODE_OK
        self.connected = True
        self.client_is_here = True

    def error_notify(self):
        """
        Desde aqui se notifica al servidor de los errores
        generados por el funcionamiento o la interacción con el cliente.
        """

        if self.client_is_here and not fatal_status(self.current_state):
            self.respond("")
            self.current_state = CODE_OK
        elif self.client_is_here:
            self.respond("")
            self.quit()
        else:
            return

    def respond(self, response):
        """
        Aqui es donde se manejan las respuestas al cliente.
        """
        answer = response
        try:
            status = str(self.current_state) + " " \
                                    + error_messages[self.current_state] \
                                    + EOL

            if (self.current_state != CODE_OK):
                while status:
                    sent = self.client_socket.send(status)
                    assert sent > 0
                    status = status[sent:]

                sent = 0

            while answer:
                sent = self.client_socket.send(answer)
                assert sent > 0
                answer = answer[sent:]

        except socket.error:
            self.current_state = INTERNAL_ERROR
            self.error_notify()

    def check_int(self, n):
        try:
            int(n)
            return True
        except ValueError:
            return False

    def quit(self):
        """
        Esta función caduca la sesión del cliente
        """

        self.client_is_here = False
        self.connected = False

    def react(self, arguments):
        """
        Aqui es donde los pedidos se manejan y se utilizan para
        determinar que metodo lanzar a ejecución
        """

        if len(arguments) > 1:
            wish = arguments[0]
            data = arguments[1:]
        else:
            wish = arguments[0]
            data = ""

        if wish == "get_file_listing":
            if (data != ""):
                self.current_state = BAD_REQUEST
                self.error_notify()
            else:
                self.get_file_listing()
        elif wish == "get_metadata":
            if (len(data) != 1):
                self.current_state = BAD_REQUEST
                self.error_notify()
            else:
                self.get_metadata(data)
        elif wish == "get_slice":
            if (len(data) != 3):
                self.current_state = INVALID_ARGUMENTS
                self.error_notify()
            elif (self.check_int(data[0]) == int):
                self.current_state = INVALID_ARGUMENTS
                self.error_notify()
            else:
                data[1] = int(data[1])
                data[2] = int(data[2])
                self.get_slice(data)
        elif wish == "quit":
            self.quit()
        else:
            self.current_state = INVALID_COMMAND
            self.error_notify()

    def get_file_listing(self):
        """
        Esta función responde al cliente con el listado
        de archivos en el directorio
        """
        response = ""
        try:
            files = os.listdir(self.directory)
            for file in files:
                response = response + file + EOL
            self.respond(response)
        except OSError:
            self.current_state = INTERNAL_ERROR
            self.error_notify()

    def get_metadata(self, data):
        """
        Esta función responde al cliente con el tamaño de
        un archivo
        """
        file = data[0]
        try:
            files = os.listdir(self.directory)
            if file in files:
                try:
                    self.respond(str(self.current_state) + " " +
                                 error_messages[self.current_state] +
                                 EOL)
                    self.respond(str(os.path.getsize(
                                    os.path.join(self.directory, file))) + EOL)
                except OSError:
                    self.current_state = INTERNAL_ERROR
                    self.error_notify()
            else:
                self.current_state = FILE_NOT_FOUND
                self.error_notify()
        except OSError:
            self.current_state = INTERNAL_ERROR
            self.error_notify()

    def get_slice(self, data):
        """
        Esta función responde al cliente con una porcion del
        archivo filename de tamaño size, comenzando desde offset.
        """

        if not ("" in data):

            filename, offset, size = data

            files = os.listdir(self.directory)
            if filename not in files:
                self.current_state = FILE_NOT_FOUND
                self.error_notify()
            else:
                if (not self.check_int(offset)) or (not self.check_int(size)):
                    self.current_state = INVALID_ARGUMENTS
                    self.error_notify()
                else:
                    offset = int(offset)
                    size = int(size)

                    size_of_file = os.path.getsize(
                        os.path.join(self.directory, filename))

                    if (offset >= size_of_file) or \
                            ((offset + size) > size_of_file) or not \
                            size_of_file:
                            self.current_state = BAD_OFFSET
                            self.error_notify()
                    else:
                        try:
                            file = open(os.path.join(self.directory, filename),
                                        "r")
                            file.seek(offset)

                            self.respond(str(self.current_state) + " " +
                                         error_messages[self.current_state] +
                                         EOL)

                            while size and (self.connected):
                                if BUFFER > size:
                                    file_slice = file.read(size)
                                    size = 0
                                else:
                                    file_slice = file.read(BUFFER)
                                    size -= BUFFER

                                file_slice = str(len(file_slice)) + " " + \
                                    file_slice

                                if self.connected:
                                    self.respond(file_slice + EOL)

                            self.respond(str(CODE_OK) + " " + EOL)

                        except OSError:
                            self.current_state = INTERNAL_ERROR
                            self.error_notify()
                            return
        else:
            self.current_state = BAD_REQUEST
            self.error_notify()
        return

    def check_eol(self, request_command):
        if ('\n' in request_command) or ('\r' in request_command):
            return False
        else:
            return True

    def check_valid_char(self, request):
        b = True
        for i in request:
            if i not in VALID_CHARS:
                b = False
        return b

    def handle(self):
        """
        Constituye el loop principal del servidor. Es iniciado al
        comenzar una sesión
        """

        socket_buffer = ""
        remaining = ""
        while self.connected and self.client_is_here:
            if not remaining:
                self.partial_request = self.client_socket.recv(BUFFER)
                socket_buffer = socket_buffer + self.partial_request

            if not socket_buffer:
                self.quit()

            if socket_buffer.count(EOL) > 0:

                request_command, socket_buffer = socket_buffer.split(EOL, 1)
                request_size = len(request_command)

                if request_size > 0:

                    if not self.check_eol(request_command):
                        self.current_state = BAD_EOL
                        self.error_notify()
                    elif not self.check_valid_char(request_command):
                        self.current_state = BAD_REQUEST
                        self.error_notify()
                    else:
                        arguments = request_command.split(BLANK)
                        remaining = socket_buffer
                        self.react(arguments)

        self.client_socket.close()