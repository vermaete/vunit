# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2015, Lars Asplund lars.anders.asplund@gmail.com

from os.path import join, dirname
from vunit import VUnit

root = dirname(__file__)
test_path = join(root, "..", "..")

ui = VUnit.from_argv()
lib = ui.add_library("lib")
lib.add_source_files(join(root, "*.vhd"))
lib.add_source_files(join(test_path, "common", "common", "test_type_methods_api.vhd"))

if ui.vhdl_standard in ('2002', '2008'):
    lib.add_source_files(join(test_path, "200x", "common", "test_types.vhd"))
    lib.add_source_files(join(test_path, "200x", "common", "test_type_methods.vhd"))
elif ui.vhdl_standard == '93':
    lib.add_source_files(join(test_path, "93", "common", "test_types.vhd"))
    lib.add_source_files(join(test_path, "93", "common", "test_type_methods.vhd"))

ui.main()
