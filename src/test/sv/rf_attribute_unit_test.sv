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


module rf_attribute_unit_test;

  import svunit_pkg::svunit_testcase;
  `include "svunit_defines.svh"

  string name = "rf_attribute_ut";
  svunit_testcase svunit_ut;

  import reflection::*;


  rf_attribute attr_without_val;


  (* attr_without_val *)
  int some_var;


  function void build();
    automatic rf_module m = rf_manager::get_module_by_name("rf_attribute_unit_test");
    automatic rf_variable v = m.get_variable_by_name("some_var");
    attr_without_val = v.get_attributes()[0];

    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask


  `SVUNIT_TESTS_BEGIN

    `SVTEST(get_name__returns_name)
      `FAIL_UNLESS_STR_EQUAL(attr_without_val.get_name(), "attr_without_val")
    `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
