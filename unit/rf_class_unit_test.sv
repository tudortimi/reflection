// Copyright 2016-2018 Tudor Timisescu (verificationgentleman.com)
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
  rf_class rfoc;


  function void build();
    automatic rf_module m = rf_manager::get_module_by_name(
      "rf_class_unit_test");
    svunit_ut = new(name);
    rfc = m.get_class_by_name("some_class");
    rfoc = m.get_class_by_name("some_other_class");
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


    //`SVTEST(get_attributes__returns_2_entries)
    //  rf_attribute attributes[] = rfc.get_attributes();
    //  `FAIL_UNLESS(attributes.size() == 2)
    //`SVTEST_END


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


    `SVTEST(get_base_class__root_class__returns_null)
      `FAIL_UNLESS(rfc.get_base_class() == null)
    `SVTEST_END

    `SVTEST(get_base_class__derived_class__returns_handle)
      rf_class bc = rfoc.get_base_class();
      `FAIL_IF(bc == null)
      `FAIL_UNLESS_STR_EQUAL(bc.get_name(), "some_class")
    `SVTEST_END


    // Not implemented in VPI layer yet

    //`SVTEST(get_derived_classes__leaf_class__returns_empty_array)
    //  rf_class dcs[] = rfoc.get_subclasses();
    //  `FAIL_UNLESS(dcs.size() == 0)
    //`SVTEST_END
    //
    //`SVTEST(get_derived_classes__class_with_subclasses__returns_empty_array)
    //  rf_class dcs[] = rfc.get_subclasses();
    //  rf_class find_res[$];
    //  `FAIL_UNLESS(dcs.size() == 2)
    //  find_res = dcs.find() with ( item.get_name() == "some_other_class" );
    //  `FAIL_UNLESS(find_res.size() == 1);
    //  find_res = dcs.find() with ( item.get_name() == "yet_another_class" );
    //  `FAIL_UNLESS(find_res.size() == 1);
    //`SVTEST_END

  `SVUNIT_TESTS_END


  (* attr1 *)
  (* attr2 *)
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


  class some_other_class extends some_class;
  endclass

  class yet_another_class extends some_class;
  endclass
endmodule
