import argparse
import logging
import os
import sys
import json
from typing import Dict
from typing import List

def main(argv):
  logging.getLogger().setLevel(logging.INFO)

  parser = argparse.ArgumentParser(
    description='Custom build step for Plante Web Admin')
  parser.add_argument('--plante-strings-dir', default='submodules/plante/lib/l10n')
  parser.add_argument('--web-admin-strings-dir', default='lib/l10n')
  parser.add_argument('--out-strings-dir', default='lib/l10n/generated')
  options = parser.parse_args()

  plante_strings_dir = options.plante_strings_dir
  plante_strs = os.listdir(plante_strings_dir)
  plante_strs = map(lambda file: os.path.join(plante_strings_dir, file), plante_strs)
  
  web_strings_dir = options.web_admin_strings_dir
  web_strs = os.listdir(web_strings_dir)
  web_strs = map(lambda file: os.path.join(web_strings_dir, file), web_strs)

  combined_strs_files_dict: Dict[str, Dict[str, str]] = {}

  update_combined_strs_files_dict(combined_strs_files_dict, plante_strs)
  update_combined_strs_files_dict(combined_strs_files_dict, web_strs)

  for file_name, combined_strs in combined_strs_files_dict.items():
    path = os.path.join(options.out_strings_dir, file_name)
    with open(path, 'w', encoding='utf-8') as f:
      f.write(json.dumps(combined_strs, ensure_ascii=False, indent=2))

def update_combined_strs_files_dict(the_dict: Dict[str, Dict[str, str]], strs_files: List[str]):
  for str_file in strs_files:
    if not str_file.endswith('.arb'):
      continue
    content: Dict[str, str] = {}
    file_name: str
    with open(str_file, 'r', encoding='utf-8') as f:
      content = json.load(f)
      file_name = os.path.basename(f.name)
    if file_name not in the_dict:
      the_dict[file_name] = {}
    the_dict[file_name].update(content)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))
