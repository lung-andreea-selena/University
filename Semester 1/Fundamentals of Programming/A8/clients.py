class Clients:
    def __init__(self, client_id, name):
        self._client_id = client_id
        self._name = name

    def getter_client_id(self):
        return self._client_id

    def getter_name(self):
        return self._name

    def setter_client_id(self, value):
        self._client_id = value

    def setter_name(self, value):
        self._name = value

    def __str__(self):
        return str(self._client_id) + ' | ' + str(self._name)
