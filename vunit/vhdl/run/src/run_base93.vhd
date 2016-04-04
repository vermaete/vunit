-- Run base package provides fundamental run functionality.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- Copyright (c) 2014-2016, Lars Asplund lars.anders.asplund@gmail.com

package body run_base_pkg is
  shared variable default_runner : runner_t;

  procedure runner_init(active_python_runner : boolean) is
  begin
    default_runner.state.active_python_runner := active_python_runner;

    for i in default_runner.state.test_case_names'range loop
      if default_runner.state.test_case_names(i) /= null then
        deallocate(default_runner.state.test_case_names(i));
      end if;
    end loop;

    default_runner.state.n_test_cases := unknown_num_of_test_cases_c;
    default_runner.state.active_test_case_index := 1;
    default_runner.state.test_suite_completed := false;
    default_runner.state.test_suite_iteration := 0;

    for i in default_runner.state.run_test_cases'range loop
      if default_runner.state.run_test_cases(i) /= null then
        deallocate(default_runner.state.run_test_cases(i));
      end if;
    end loop;

    if default_runner.state.running_test_case_v /= null then
      deallocate(default_runner.state.running_test_case_v);
    end if;

    default_runner.state.n_run_test_cases := 0;
    default_runner.state.has_run_since_last_loop_check := true;
    default_runner.state.run_all := true;
    default_runner.state.test_case_iteration := 0;
    default_runner.state.test_case_exit_after_error := false;
    default_runner.state.test_suite_exit_after_error := false;
    default_runner.state.runner_cfg := new string'(runner_cfg_default);
  end;

  impure function has_active_python_runner return boolean is
  begin
    return default_runner.state.active_python_runner;
  end function;

  procedure exit_simulation is
  begin
    default_runner.state.exit_simulation := true;
  end;

  procedure set_exit_error_status (
    constant exit_without_errors : in boolean) is
  begin
    default_runner.state.exit_without_errors := exit_without_errors;
  end;

  impure function exit_without_errors
    return boolean is
  begin
    return default_runner.state.exit_without_errors;
  end;

  procedure lock_entry (
    constant phase : in runner_phase_t) is
  begin
    default_runner.state.locks(phase).n_entry_locks := default_runner.state.locks(phase).n_entry_locks + 1;
  end;

  procedure unlock_entry (
    constant phase : in runner_phase_t) is
  begin
    default_runner.state.locks(phase).n_entry_locks := default_runner.state.locks(phase).n_entry_locks - 1;
  end;

  impure function entry_is_locked (
    constant phase : in runner_phase_t)
    return boolean is
  begin
    return default_runner.state.locks(phase).n_entry_locks > 0;
  end;

  procedure lock_exit (
    constant phase : in runner_phase_t) is
  begin
    default_runner.state.locks(phase).n_exit_locks := default_runner.state.locks(phase).n_exit_locks + 1;
  end;

  procedure unlock_exit (
    constant phase : in runner_phase_t) is
  begin
    default_runner.state.locks(phase).n_exit_locks := default_runner.state.locks(phase).n_exit_locks - 1;
  end;

  impure function exit_is_locked (
    constant phase : in runner_phase_t)
    return boolean is
  begin
    return default_runner.state.locks(phase).n_exit_locks > 0;
  end;

  procedure set_phase (
    constant new_phase  : in runner_phase_t) is
  begin
    default_runner.state.runner_phase := new_phase;
  end;

  impure function get_phase
    return runner_phase_t is
  begin
    return default_runner.state.runner_phase;
  end;

  procedure set_test_case_name (
    constant index : in positive;
    constant new_name  : in string) is
  begin
    if default_runner.state.test_case_names(index) /= null then
      deallocate(default_runner.state.test_case_names(index));
    end if;
    write(default_runner.state.test_case_names(index), new_name);
  end;

  impure function get_test_case_name (
    constant index : positive)
    return string  is
  begin
    if default_runner.state.test_case_names(index) /= null then
      return default_runner.state.test_case_names(index).all;
    else
      return "";
    end if;
  end;

  procedure set_num_of_test_cases (
    constant new_value : in integer) is
  begin
    default_runner.state.n_test_cases := new_value;
  end;

  procedure inc_num_of_test_cases is
  begin
    default_runner.state.n_test_cases := default_runner.state.n_test_cases + 1;
  end;

  impure function get_num_of_test_cases
    return integer is
  begin
    return default_runner.state.n_test_cases;
  end;

  impure function get_active_test_case_index
    return integer is
  begin
    return default_runner.state.active_test_case_index;
  end;

  procedure inc_active_test_case_index is
  begin
    default_runner.state.active_test_case_index := default_runner.state.active_test_case_index + 1;
  end;

  procedure set_test_suite_completed is
  begin
    default_runner.state.test_suite_completed := true;
  end;

  impure function get_test_suite_completed
    return boolean is
  begin
    return default_runner.state.test_suite_completed;
  end;

  impure function get_test_suite_iteration
    return natural is
  begin
    return default_runner.state.test_suite_iteration;
  end;

  procedure inc_test_suite_iteration is
  begin
    default_runner.state.test_suite_iteration := default_runner.state.test_suite_iteration + 1;
  end;

  procedure set_run_test_case (
    constant index : in positive;
    constant new_name  : in string) is
  begin
    if default_runner.state.run_test_cases(index) /= null then
      deallocate(default_runner.state.run_test_cases(index));
    end if;
    write(default_runner.state.run_test_cases(index), new_name);
  end;

  impure function get_run_test_case (
    constant index : positive)
    return string is
  begin
    if default_runner.state.run_test_cases(index) /= null then
      return default_runner.state.run_test_cases(index).all;
    else
      return "";
    end if;
  end;

  procedure set_running_test_case (
    constant new_name  : in string) is
  begin
    if default_runner.state.running_test_case_v /= null then
      deallocate(default_runner.state.running_test_case_v);
    end if;
    write(default_runner.state.running_test_case_v, new_name);
  end;

  impure function get_running_test_case
    return string is
  begin
    if default_runner.state.running_test_case_v /= null then
      return default_runner.state.running_test_case_v.all;
    else
      return "";
    end if;
  end;

  impure function get_num_of_run_test_cases
    return natural is
  begin
    return default_runner.state.n_run_test_cases;
  end;

  procedure inc_num_of_run_test_cases is
  begin
    default_runner.state.n_run_test_cases := default_runner.state.n_run_test_cases + 1;
  end;

  procedure set_has_run_since_last_loop_check is
  begin
    default_runner.state.has_run_since_last_loop_check := true;
  end;

  procedure clear_has_run_since_last_loop_check is
  begin
    default_runner.state.has_run_since_last_loop_check := false;
  end;

  impure function get_has_run_since_last_loop_check
    return boolean is
  begin
    return default_runner.state.has_run_since_last_loop_check;
  end;

  procedure set_run_all is
  begin
    default_runner.state.run_all := true;
  end;

  procedure set_run_all (
    constant new_value : in boolean) is
  begin
    default_runner.state.run_all := new_value;
  end;

  impure function get_run_all
    return boolean is
  begin
    return default_runner.state.run_all;
  end;

  impure function get_test_case_iteration
    return natural is
  begin
    return default_runner.state.test_case_iteration;
  end;

  procedure inc_test_case_iteration is
  begin
    default_runner.state.test_case_iteration := default_runner.state.test_case_iteration + 1;
  end;

  procedure init_test_case_iteration is
  begin
    default_runner.state.test_case_iteration := 0;
  end;

  procedure set_test_case_exit_after_error is
  begin
    default_runner.state.test_case_exit_after_error := true;
  end;

  procedure clear_test_case_exit_after_error is
  begin
    default_runner.state.test_case_exit_after_error := false;
  end;

  impure function get_test_case_exit_after_error
    return boolean is
  begin
    return default_runner.state.test_case_exit_after_error;
  end;

  procedure set_test_suite_exit_after_error is
  begin
    default_runner.state.test_suite_exit_after_error := true;
  end;

  procedure clear_test_suite_exit_after_error is
  begin
    default_runner.state.test_suite_exit_after_error := false;
  end;

  impure function get_test_suite_exit_after_error
    return boolean is
  begin
    return default_runner.state.test_suite_exit_after_error;
  end;

  procedure set_cfg (
    constant new_value : in string) is
  begin
      if default_runner.state.runner_cfg /= null then
        deallocate(default_runner.state.runner_cfg);
      end if;
    default_runner.state.runner_cfg := new string'(new_value);
  end;

  impure function get_cfg
    return string is
  begin
    return default_runner.state.runner_cfg.all;
  end;

end package body run_base_pkg;
