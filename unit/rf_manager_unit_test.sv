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


module rf_manager_unit_test__some_module();
endmodule

package rf_manager_unit_test__some_package;
endpackage



module rf_manager_unit_test;
  import svunit_pkg::svunit_testcase;
  `include "svunit_defines.svh"

  string name = "rf_manager_ut";
  svunit_testcase svunit_ut;

  import reflection::*;
  import rf_manager_unit_test__some_package::*;


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

    `SVTEST(get_package_by_name__nonexistent__returns_null)
      rf_package p = rf_manager::get_package_by_name(
        "some_nonexistent_package");
      `FAIL_UNLESS(p == null)
    `SVTEST_END

    `SVTEST(get_package_by_name__existent__returns_handle)
      rf_package p = rf_manager::get_package_by_name(
        "rf_manager_unit_test__some_package");
      `FAIL_IF(p == null)
    `SVTEST_END

    `SVTEST(get_package_by_name__returns_same_handle)
      rf_package p1 = rf_manager::get_package_by_name(
        "rf_manager_unit_test__some_package");
      rf_package p2 = rf_manager::get_package_by_name(
        "rf_manager_unit_test__some_package");
      `FAIL_IF(p1 != p2)
    `SVTEST_END


    `SVTEST(get_module_by_name__nonexistent__returns_null)
      rf_module m = rf_manager::get_module_by_name(
        "some_nonexistent_module");
      `FAIL_UNLESS(m == null)
    `SVTEST_END

    `SVTEST(get_module_by_name__existent__returns_handle)
      rf_module m = rf_manager::get_module_by_name(
        "rf_manager_unit_test__some_module");
      `FAIL_IF(m == null)
    `SVTEST_END

    `SVTEST(get_module_by_name__returns_same_handle)
      rf_module m1 = rf_manager::get_module_by_name(
        "rf_manager_unit_test__some_module");
      rf_module m2 = rf_manager::get_module_by_name(
        "rf_manager_unit_test__some_module");
      `FAIL_IF(m1 != m2)
    `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
