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


module rf_variable_unit_test;
  import svunit_pkg::svunit_testcase;
  `include "svunit_defines.svh"

  string name = "rf_variable_ut";
  svunit_testcase svunit_ut;

  import reflection::*;
  import some_package::*;

  rf_variable sv;
  rf_variable srv;
  rf_variable srcv;

  rf_variable siv;

  // TODO Currently, only variables declared in modules are tested/supported.
  some_class c;


  function void build();
    automatic rf_package p = rf_manager::get_package_by_name("some_package");
    automatic rf_class c = p.get_class_by_name("some_class");
    svunit_ut = new(name);
    sv = c.get_variable_by_name("some_variable");
    srv = c.get_variable_by_name("some_rand_variable");
    srcv = c.get_variable_by_name("some_randc_variable");
    siv = c.get_variable_by_name("some_int_var");
  endfunction


  task setup();
    svunit_ut.setup();
    c = new();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask


  `SVUNIT_TESTS_BEGIN

    `SVTEST(get_name__returns_name)
      `FAIL_UNLESS_STR_EQUAL(sv.get_name(), "some_variable")
    `SVTEST_END

    `SVTEST(is_rand__not_rand__returns_0)
      `FAIL_IF(sv.is_rand())
    `SVTEST_END

    `SVTEST(is_rand__rand__returns_1)
      `FAIL_UNLESS(srv.is_rand())
      `FAIL_UNLESS(srcv.is_rand())
    `SVTEST_END

    `SVTEST(get_rand_type__returns_type)
      `FAIL_UNLESS(sv.get_rand_type() == NOT_RAND)
      `FAIL_UNLESS(srv.get_rand_type() == RAND)
      `FAIL_UNLESS(srcv.get_rand_type() == RANDC)
    `SVTEST_END

    `SVTEST(get__int__returns_value)
      rf_value #(int) v;
      c.some_int_var = 5;
      `FAIL_UNLESS($cast(v, siv.get(rf_object_instance #(some_class)::get(c))))
      `FAIL_UNLESS(v.get() == 5)
    `SVTEST_END

    `SVTEST(set__int__modifies_value)
      rf_value #(int) v = new(5);
      siv.set(rf_object_instance #(some_class)::get(c), v);
      `FAIL_UNLESS(c.some_int_var == 5)
    `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
