import random
import numpy as np

def codec_to_columns(codec):
  ''' Convert a categorical codec value to column values
  '''
  mapping = {'"flv"':   [1, 0, 0, 0],
             '"mpeg4"': [0, 1, 0, 0],
             '"h264"':  [0, 0, 1, 0],
             '"vp8"':   [0, 0, 0, 1]}
  return mapping[codec]


def read_and_copy(filename, out_file):
  ''' Read content from a file and convert to list of values
      Also copy the content to out_file
  '''
  records = []
  in_file = open(filename, 'r')
  in_file.readline()
  for line in in_file:
    tokens = line.split()
    record = [float(tokens[1])] +\
              codec_to_columns(tokens[2]) +\
              [float(x) for x in tokens[3:14]] +\
              codec_to_columns(tokens[15]) +\
              [float(x) for x in tokens[16:]]
    records.append(record)
    out_file.write(record_to_line(record))
  in_file.close()
  return records


def record_to_line(values):
  ''' Convert a record to a line
  '''
  strs = [str(x) for x in values]
  return ','.join(strs) + '\n'


def gen_new_record(records):
  ''' Generate a new record.
  '''
  record = records[random.randint(0, len(records) - 1)]
  new_record = list(record)
  for i in range(len(new_record)):
    if 1<= i <= 3 or 16 <= i <= 18:
      continue
    new_record[i] = np.random.normal()
  return new_record


def main():
  ''' Main function
  '''
  target_line_count = 900000000
  out_file = open('scaled_transcoding_mesurment.csv', 'w')
  records = read_and_copy('transcoding_mesurment.tsv', out_file)
  for _ in range(len(records), target_line_count+1):
    new_record = gen_new_record(records)
    out_file.write(record_to_line(new_record))
  out_file.close()


if __name__ == '__main__':
  main()
