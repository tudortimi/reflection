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


module rf_method_unit_test;
  import svunit_pkg::svunit_testcase;
  `include "svunit_defines.svh"

  string name = "rf_method_ut";
  svunit_testcase svunit_ut;

  import reflection::*;
  import some_package::*;

  rf_method st;
  rf_method sf;
  rf_method sfwa;

  // TODO Currently, only objects declared in modules are tested/supported.
  some_class c;


  function void build();
    automatic rf_package p = rf_manager::get_package_by_name("some_package");
    automatic rf_class c = p.get_class_by_name("some_class");
    svunit_ut = new(name);
    st = c.get_method_by_name("some_task");
    sf = c.get_method_by_name("some_function");
    sfwa = c.get_method_by_name("some_function_with_args");
  endfunction


  task setup();
    svunit_ut.setup();
    c = new();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask


  `SVUNIT_TESTS_BEGIN

    `SVTEST(get_name__task__returns_name)
      `FAIL_UNLESS_STR_EQUAL(st.get_name(), "some_task")
    `SVTEST_END

    `SVTEST(get_name__function__returns_name)
      `FAIL_UNLESS_STR_EQUAL(sf.get_name(), "some_function")
    `SVTEST_END

    `SVTEST(get_kind__task__returns_task)
      `FAIL_UNLESS(st.get_kind() == TASK)
    `SVTEST_END

    `SVTEST(get_kind__function__returns_function)
      `FAIL_UNLESS(sf.get_kind() == FUNCTION)
    `SVTEST_END


    `SVTEST(get_io_declarations__returns_3_entries)
      rf_io_declaration io_decls[] = sfwa.get_io_declarations();
      `FAIL_UNLESS(io_decls.size() == 3)
    `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
