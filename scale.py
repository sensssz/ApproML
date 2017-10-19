''' Used for scaling a training data set.
'''
import random
import sys
import gflags
from gflags import FLAGS
import numpy as np

gflags.DEFINE_string('dataset', None, 'Name of the dataset file.')
gflags.DEFINE_multi_enum('mode', 'linear', ['linear', 'logistic'], 'Type of GLM to use.')
gflags.DEFINE_integer('label_column', 0, 'Column of the labels.')
gflags.DEFINE_integer('feature_column_start', 1, 'Starting column of the features.')

def read_and_copy(filename, out_file):
  ''' Read content from a file and convert to list of values
      Also copy the content to out_file
  '''
  content = []
  in_file = open(filename, 'r')
  for line in in_file:
    parts = line.split(',')
    values = [float(x) for x in parts]
    content.append(values)
    out_file.write(line)
  return content


def values_to_line(values):
  ''' Convert a list of values to a line
  '''
  strs = [str(x) for x in values]
  return ','.join(strs) + '\n'


def gen_new_record(records):
  ''' Generate a new record.
  '''
  record = records[random.randint(0, len(records))]
  new_record = list(record)
  for i in range(FLAGS.feature_column_start, len(new_record)):
    new_record[i] = np.random.normal()
  if FLAGS.mode == 'linear':
    new_record[FLAGS.label_column] += np.random.normal()
  return new_record


def main():
  ''' Main function
  '''
  target_line_count = 900000000
  out_file = open('scaled_' + FLAGS.dataset, 'w')
  records = read_and_copy(FLAGS.dataset, out_file)
  new_records = []
  for _ in range(len(records), target_line_count):
    new_records.append(gen_new_record(records))


if __name__ == '__main__':
  try:
    FLAGS(sys.argv)  # parse flags
  except gflags.FlagsError, e:
    print '%s\\nUsage: %s ARGS\\n%s' % (e, sys.argv[0], FLAGS)
    sys.exit(1)
  main()
