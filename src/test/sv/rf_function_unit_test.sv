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


module rf_function_unit_test;
  import svunit_pkg::svunit_testcase;
  `include "svunit_defines.svh"

  string name = "rf_function_ut";
  svunit_testcase svunit_ut;

  import reflection::*;

  rf_function svf;
  rf_function sif;

  // TODO Currently, only objects declared in modules are tested/supported.
  typedef class some_class;
  some_class c = new();


  function void build();
    automatic rf_module m = rf_manager::get_module_by_name(
      "rf_function_unit_test");
    automatic rf_class c = m.get_class_by_name("some_class");
    svunit_ut = new(name);
    svf = c.get_function_by_name("some_void_function");
    sif = c.get_function_by_name("some_int_function");
  endfunction


  task setup();
    svunit_ut.setup();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask


  `SVUNIT_TESTS_BEGIN

    `SVTEST(get_return_type__void__returns_void)
      `FAIL_UNLESS_STR_EQUAL(svf.get_return_type(), "void")
    `SVTEST_END

    `SVTEST(get_return_type__int__returns_int)
      `FAIL_UNLESS_STR_EQUAL(sif.get_return_type(), "int")
    `SVTEST_END

  `SVUNIT_TESTS_END


  class some_class;
    function void some_void_function();
    endfunction

    function int some_int_function();
    endfunction
  endclass
endmodule
