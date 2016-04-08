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


module rf_manager_unit_test;
  import svunit_pkg::svunit_testcase;
  `include "svunit_defines.svh"

  string name = "rf_manager_ut";
  svunit_testcase svunit_ut;

  import reflection::*;
  import some_package::*;


  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask


  `SVUNIT_TESTS_BEGIN

    `SVTEST(get_class_by_name__nonexistent__returns_null)
      rf_class c = rf_manager::get_class_by_name("some_nonexistent_class");
      `FAIL_UNLESS(c == null)
    `SVTEST_END

    `SVTEST(get_class_by_name__existent__returns_handle)
      rf_class c = rf_manager::get_class_by_name("some_class");
      `FAIL_IF(c == null)
    `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
