# data collection from serial port, Python alternative
# 2019-11-14 -> 2020-11-13 Naoki F., AIT
# New BSD License is applied. See COPYING file for details.

import sys
import time
import serial
PORT = 'COM5' # modify the port according to environment
BLOCK_SIZE = 4096

# Check Arguments
if len(sys.argv) != 3:
    print('Usage: python serial_read.py FILE_NAME data_size', file=sys.stderr)
    sys.exit(1)

file_name = sys.argv[1]
data_size = int(sys.argv[2])
prog_size = data_size // 50

# Open Serial Port and Output File
try:
    ser = serial.Serial(PORT, 3000000, timeout=1)
except Exception as e:
    print(f'!! failed to open serial port ({e}). stop.', file=sys.stderr)
    sys.exit(1)

try:
    out = open(file_name, mode='wb')
except Exception as e:
    print(f'!! failed to open output file ({e}). stop.', file=sys.stderr)
    sys.exit(1)

# Read
total = 0
start = None
while total < data_size:
    data = ser.read(BLOCK_SIZE)
    if len(data) == 0:
        continue
    out.write(data)
    if total // prog_size != (total + len(data)) // prog_size:
        print('#', file=sys.stdout, end='')
        sys.stdout.flush()
    total += len(data)
    if start is None and total >= data_size // 2:
        start = time.time()

elapsed = time.time() - start
ser.close()
out.close()
print()
print('Elapsed Time(s): {:.3f}'.format(elapsed * 2))
if elapsed != 0:
    print('Transfer Rate (kbit/s): {:.3f}'.format(total / elapsed / 250))
