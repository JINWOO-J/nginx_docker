import time


# Main Class
class Tailer(object):
    def __init__(self, file=None, end=False, lines=0, *args, **kwargs):
        self.args = args
        self.kwargs = kwargs

        self.isRunning = False
        self.newlines = ['\n', '\r', '\r\n']
        self.file = file

        if end: self.seek_end()

    # File 셋팅
    def setFile(self, file):
        self.file = file

    # File의 offset 위치 설정
    def seek(self, offset, whence=0):
        self.file.seek(offset, whence)

    # File의 offset을 맨 앞으로 이동
    def seek_first(self):
        self.seek(0, 1)

    # File의 offset을 맨 뒤로 이동
    def seek_end(self):
        self.seek(0, 2)

    # Follow
    def follow(self, delay=1.0):
        self.isRunning = True

        tailling = True

        while self.isRunning:
            # File의 현재 offset 위치
            pivot = self.file.tell()

            # File의 현재 offset 위치의 line 가져오기.
            # offset이 변경됨.
            line = self.file.readline()

            if line:
                # EOF가 개행문자가 아닌 경우, 다음 문자부터 출력
                if tailling and line in self.newlines:
                    tailling = False
                    continue

                # Line 끝에 개행문자 제거
                if line[-1] in self.newlines:
                    line = line[:-1]
                    if line[-1:] == '\r\n' and '\r\n' in self.newlines:
                        line = line[:-1]

                tailling = False
                yield line

            else:
                tailling = True

                # File의 offset을 이전 위치로 변경
                self.file.seek(pivot)

                time.sleep(delay)

    def stop(self):
        self.isRunning = False
        self.file.close()


def follow(file, delay=1.0, **kwargs):
    tailer = Tailer(file, end=True, **kwargs)
    return (tailer.follow(delay), tailer.stop)
