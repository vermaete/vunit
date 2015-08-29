# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2015, Lars Asplund lars.anders.asplund@gmail.com

"""
Functions to add builtin VHDL code to a project for compilation
"""


from os.path import join, abspath, dirname, basename
from glob import glob

VHDL_PATH = abspath(join(dirname(__file__), "..", "vhdl"))


def add_builtins(library, vhdl_standard, mock_lang=False, mock_log=False):
    """
    Add vunit builtin libraries
    """
    def get_builtins_vhdl_all(mock_lang):
        """Return built-in VHDL files present under all VHDL versions"""
        files = []

        if mock_lang:
            files += [join("test", "common", "vhdl", "lang", "lang_mock.vhd")]
            files += [join("test", "common", "vhdl", "lang", "lang_mock_types.vhd")]
            files += [join("test", "common", "common", "test_type_methods_api.vhd")]
        else:
            files += [join("src", "common", "vhdl", "lang", "lang.vhd")]

        files += [join("src", "common", "vhdl", "lib", "std", "textio.vhd"),
                  join("src", "common", "string_ops", "string_ops.vhd"),
                  join("src", "common", "check", "check.vhd"),
                  join("src", "common", "check", "check_api.vhd"),
                  join("src", "common", "check", "check_base_api.vhd"),
                  join("src", "common", "check", "check_types.vhd"),
                  join("src", "common", "run", "stop_api.vhd"),
                  join("src", "common", "run", "run.vhd"),
                  join("src", "common", "run", "run_api.vhd"),
                  join("src", "common", "run", "run_types.vhd"),
                  join("src", "common", "run", "run_base_api.vhd")]

        files += [join("src", "common", "logging", "log_api.vhd"),
                  join("src", "common", "logging", "log_formatting.vhd"),
                  join("src", "common", "logging", "log.vhd"),
                  join("src", "common", "logging", "log_types.vhd")]

        files += [join("src", "common", "dictionary", "dictionary.vhd")]

        files += [join("src", "common", "path", "path.vhd")]

        return files

    def get_builtins_vhdl_93(mock_lang, mock_log):
        """Return built-in VHDL files unique fro VHDL 93"""
        files = []

        if mock_lang:
            files += [join("test", "93", "common", "test_type_methods.vhd")]
            files += [join("test", "93", "common", "test_types.vhd")]
            files += [join("test", "93", "vhdl", "lang", "lang_mock_special_types.vhd")]

        if mock_log:
            files += [join("test", "93", "logging", "log_base_mock.vhd"),
                      join("src", "93", "logging", "log_special_types.vhd"),
                      join("test", "common", "logging", "log_base_api_mock.vhd")]
        else:
            files += [join("src", "93", "logging", "log_base.vhd"),
                      join("src", "93", "logging", "log_special_types.vhd"),
                      join("src", "common", "logging", "log_base_api.vhd")]

        files += [join("src", "93", "check", "check_base.vhd"),
                  join("src", "93", "check", "check_special_types.vhd"),
                  join("src", "93", "run", "run_base.vhd"),
                  join("src", "93", "run", "run_special_types.vhd")]

        return files

    def get_builtins_vhdl_not_93(mock_lang, mock_log):
        """Return built-in VHDL files present both in VHDL 2002 and 2008"""
        files = []

        if mock_lang:
            files += [join("test", "200x", "common", "test_type_methods.vhd")]
            files += [join("test", "200x", "common", "test_types.vhd")]
            files += [join("test", "200x", "vhdl", "lang", "lang_mock_special_types.vhd")]

        if mock_log:
            files += [join("test", "common", "common", "test_type_methods_api.vhd")]
            files += [join("test", "200x", "common", "test_type_methods.vhd")]
            files += [join("test", "200x", "common", "test_types.vhd")]
            files += [join("src", "200x", "logging", "log_base.vhd"),
                      join("test", "200x", "logging", "log_special_types_mock.vhd"),
                      join("src", "common", "logging", "log_base_api.vhd")]
        else:
            files += [join("src", "200x", "logging", "log_base.vhd"),
                      join("src", "200x", "logging", "log_special_types.vhd"),
                      join("src", "common", "logging", "log_base_api.vhd")]

        files += [join("src", "200x", "check", "check_base.vhd"),
                  join("src", "200x", "check", "check_special_types.vhd"),
                  join("src", "200x", "run", "run_base.vhd"),
                  join("src", "200x", "run", "run_special_types.vhd")]

        return files

    def get_builtins_vhdl_2008():
        """Return built-in VHDL files present only in 2008"""
        files = []

        files += [join("src", "2008", "vunit_context.vhd")]
        files += [join("src", "2008", "run", "stop.vhd")]

        return files

    def get_builtins_vhdl_not_2008():
        """Return built-in VHDL files present both in VHDL 93 and 2002"""
        files = []

        files += [join("src", "93_2002", "run", "stop.vhd")]

        return files

    files = get_builtins_vhdl_all(mock_lang)

    if vhdl_standard == '93':
        files += get_builtins_vhdl_93(mock_lang, mock_log)
        files += get_builtins_vhdl_not_2008()
    elif vhdl_standard == '2002':
        files += get_builtins_vhdl_not_93(mock_lang, mock_log)
        files += get_builtins_vhdl_not_2008()
    elif vhdl_standard == '2008':
        files += get_builtins_vhdl_not_93(mock_lang, mock_log)
        files += get_builtins_vhdl_2008()

    for file_name in files:
        library.add_source_files(join(VHDL_PATH, file_name))


def add_array_util(library, vhdl_standard):
    """
    Add array_pkg utility library
    """
    if vhdl_standard != '2008':
        raise RuntimeError("Array utility only supports vhdl 2008")

    library.add_source_files(join(VHDL_PATH, "src", "2008", "array", "array_pkg.vhd"))


def add_osvvm(library):
    """
    Add osvvm library
    """
    for file_name in glob(join(VHDL_PATH, "src", "2008", "osvvm", "*.vhd")):
        if basename(file_name) != 'AlertLogPkg_body_BVUL.vhd':
            library.add_source_files(file_name, preprocessors=[])


def add_com(library, vhdl_standard, use_debug_codecs=False):
    """
    Add com library
    """
    if vhdl_standard != '2008':
        raise RuntimeError("Communication package only supports vhdl 2008")

    library.add_source_files(join(VHDL_PATH, "src", "2008", "com", "com.vhd"))
    library.add_source_files(join(VHDL_PATH, "src", "2008", "com", "com_api.vhd"))
    library.add_source_files(join(VHDL_PATH, "src", "2008", "com", "com_types.vhd"))
    library.add_source_files(join(VHDL_PATH, "src", "2008", "com", "com_codec_api.vhd"))
    library.add_source_files(join(VHDL_PATH, "src", "2008", "com", "com_context.vhd"))
    library.add_source_files(join(VHDL_PATH, "src", "2008", "com", "com_string.vhd"))
    library.add_source_files(join(VHDL_PATH, "src", "2008", "com", "com_debug_codec_builder.vhd"))
    library.add_source_files(join(VHDL_PATH, "src", "2008", "com", "com_std_codec_builder.vhd"))

    if use_debug_codecs:
        library.add_source_files(join(VHDL_PATH, "src", "2008", "com", "com_codec_debug.vhd"))
    else:
        library.add_source_files(join(VHDL_PATH, "src", "2008", "com", "com_codec.vhd"))
