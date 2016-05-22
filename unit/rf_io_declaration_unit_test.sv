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


module rf_io_declaration_unit_test;
  import svunit_pkg::svunit_testcase;
  `include "svunit_defines.svh"

  string name = "rf_io_declaration_ut";
  svunit_testcase svunit_ut;

  import reflection::*;
  import some_package::*;

  rf_io_declaration ia;
  rf_io_declaration oa;
  rf_io_declaration ioa;

  // TODO Currently, only objects declared in modules are tested/supported.
  some_class c = new();


  function void build();
    automatic rf_package p = rf_manager::get_package_by_name("some_package");
    automatic rf_class c = p.get_class_by_name("some_class");
    automatic rf_method sfwa = c.get_method_by_name("some_function_with_args");
    svunit_ut = new(name);
    ia = sfwa.get_io_declaration_by_name("input_arg");
    oa = sfwa.get_io_declaration_by_name("output_arg");
    ioa = sfwa.get_io_declaration_by_name("inout_arg");
  endfunction


  task setup();
    svunit_ut.setup();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask


  `SVUNIT_TESTS_BEGIN

    `SVTEST(get_name__returns_name)
      `FAIL_UNLESS_STR_EQUAL(ia.get_name(), "input_arg")
    `SVTEST_END

    `SVTEST(get_direction__input__returns_input)
      `FAIL_UNLESS(ia.get_direction() == INPUT)
    `SVTEST_END

    `SVTEST(get_direction__output__returns_output)
      `FAIL_UNLESS(oa.get_direction() == OUTPUT)
    `SVTEST_END

    `SVTEST(get_direction__inout__returns_input)
      `FAIL_UNLESS(ioa.get_direction() == INOUT)
    `SVTEST_END

    `SVTEST(get_type__returns_type)
      `FAIL_UNLESS_STR_EQUAL(ia.get_type(), "int")
    `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
