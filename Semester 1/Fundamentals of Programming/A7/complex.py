class ComplexNumbers:
    def __init__(self, real, imaginary):
        self._real = real
        self._imaginary = imaginary

    def getter_real(self):
        return self._real

    def setter_real(self, value):
        self._real = value

    def getter_imaginary(self):
        return self._imaginary

    def setter_imaginary(self, value):
        self._imaginary = value

    def __str__(self):
        if self._imaginary == 0:
            return self._real
        elif self._imaginary > 0:
            return str(self._real) + '+' + str(self._imaginary) + 'i'
        else:
            return str(self._real) + str(self._imaginary) + 'i'
