// Copyright 2016 Tudor Timisescu (verificationgentleman.com)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


module rf_class_unit_test;
  import svunit_pkg::svunit_testcase;
  `include "svunit_defines.svh"

  string name = "rf_class_ut";
  svunit_testcase svunit_ut;

  import reflection::*;

  rf_class rfc;


  function void build();
    automatic rf_module m = rf_manager::get_module_by_name(
      "rf_class_unit_test");
    svunit_ut = new(name);
    rfc = m.get_class_by_name("some_class");
  endfunction


  task setup();
    svunit_ut.setup();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask


  `SVUNIT_TESTS_BEGIN

    `SVTEST(get_name__returns_name)
      `FAIL_UNLESS_STR_EQUAL(rfc.get_name(), "some_class")
    `SVTEST_END


    `SVTEST(get_variables__returns_2_entries)
      rf_variable vars[] = rfc.get_variables();
      `FAIL_UNLESS(vars.size() == 2)
    `SVTEST_END

    `SVTEST(get_variable_by_name__nonexistent__returns_null)
      rf_variable v = rfc.get_variable_by_name("some_nonexistent_variable");
      `FAIL_UNLESS(v == null)
    `SVTEST_END

    `SVTEST(get_variable_by_name__existent__returns_handle)
      rf_variable v = rfc.get_variable_by_name("some_variable");
      `FAIL_IF(v == null)
    `SVTEST_END


    `SVTEST(get_methods__returns_5_entries)
      rf_method methods[] = rfc.get_methods();
      `FAIL_UNLESS(methods.size() == 5)
    `SVTEST_END

    `SVTEST(get_method_by_name__nonexistent__returns_null)
      rf_method m = rfc.get_method_by_name("some_nonexistent_method");
      `FAIL_UNLESS(m == null)
    `SVTEST_END

    `SVTEST(get_method_by_name__existent_task__returns_handle)
      rf_method m = rfc.get_method_by_name("some_task");
      `FAIL_IF(m == null)
    `SVTEST_END

    `SVTEST(get_method_by_name__existent_function__returns_handle)
      rf_method m = rfc.get_method_by_name("some_function");
      `FAIL_IF(m == null)
    `SVTEST_END


    `SVTEST(get_tasks__returns_2_entries)
      rf_task tasks[] = rfc.get_tasks();
      `FAIL_UNLESS(tasks.size() == 2)
    `SVTEST_END

    `SVTEST(get_task_by_name__existent_task__returns_handle)
      rf_task t = rfc.get_task_by_name("some_task");
      `FAIL_IF(t == null)
    `SVTEST_END


    `SVTEST(get_functions__returns_3_entries)
      rf_function functions[] = rfc.get_functions();
      `FAIL_UNLESS(functions.size() == 3)
    `SVTEST_END

    `SVTEST(get_function_by_name__existent_function__returns_handle)
      rf_function f = rfc.get_function_by_name("some_function");
      `FAIL_IF(f == null)
    `SVTEST_END

  `SVUNIT_TESTS_END


  class some_class;
    int some_variable;
    int some_other_variable;

    task some_task();
    endtask

    task some_other_task();
    endtask

    function void some_function();
    endfunction

    function void some_other_function();
    endfunction

    function void yet_another_function();
    endfunction
  endclass
endmodule
