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


module rf_variable_unit_test;
  import svunit_pkg::svunit_testcase;
  `include "svunit_defines.svh"

  string name = "rf_variable_ut";
  svunit_testcase svunit_ut;

  import reflection::*;

  rf_variable sv;
  rf_variable ssv;
  rf_variable scv;

  rf_variable snrv;
  rf_variable srv;
  rf_variable srcv;

  rf_variable siv;

  rf_variable some_var_with_attrs;
  rf_variable some_static_int_var;
  rf_variable some_string_var;
  rf_variable some_string_array_handle;

  // TODO Currently, only variables declared in classes are tested/supported.
  typedef class some_class;
  some_class c;


  function void build();
    automatic rf_module m = rf_manager::get_module_by_name(
      "rf_variable_unit_test");
    automatic rf_class c = m.get_class_by_name("some_class");
    svunit_ut = new(name);
    sv = c.get_variable_by_name("some_variable");
    ssv = c.get_variable_by_name("some_static_variable");
    scv = c.get_variable_by_name("some_const_variable");
    snrv = c.get_variable_by_name("some_not_rand_variable");
    srv = c.get_variable_by_name("some_rand_variable");
    srcv = c.get_variable_by_name("some_randc_variable");
    siv = c.get_variable_by_name("some_int_var");
    some_var_with_attrs = c.get_variable_by_name("some_var_with_attrs");
    some_static_int_var = c.get_variable_by_name("some_static_int_var");
    some_string_var = c.get_variable_by_name("some_string_var");
    some_string_array_handle = c.get_variable_by_name("some_string_array_var");
  endfunction


  task setup();
    svunit_ut.setup();
    c = new();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask


  typedef string string_arr[];


  `SVUNIT_TESTS_BEGIN

    `SVTEST(get_name__returns_name)
      `FAIL_UNLESS_STR_EQUAL(sv.get_name(), "some_variable")
    `SVTEST_END


    `SVTEST(get_type__int__returns_type)
      `FAIL_UNLESS_STR_EQUAL(siv.get_type(), "int")
    `SVTEST_END


    `SVTEST(is_static__returns_correct)
      `FAIL_IF(sv.is_static())
      `FAIL_UNLESS(ssv.is_static())
    `SVTEST_END


    `SVTEST(is_const__returns_correct)
      `FAIL_IF(sv.is_const())
      `FAIL_UNLESS(scv.is_const())
    `SVTEST_END


    `SVTEST(is_rand__not_rand__returns_0)
      `FAIL_IF(snrv.is_rand())
    `SVTEST_END


    `SVTEST(is_rand__rand__returns_1)
      `FAIL_UNLESS(srv.is_rand())
      `FAIL_UNLESS(srcv.is_rand())
    `SVTEST_END


    `SVTEST(get_rand_type__returns_type)
      `FAIL_UNLESS(snrv.get_rand_type() == NOT_RAND)
      `FAIL_UNLESS(srv.get_rand_type() == RAND)
      `FAIL_UNLESS(srcv.get_rand_type() == RANDC)
    `SVTEST_END


    `SVTEST(get_attributes__returns_2_entries)
      rf_attribute attrs[] = some_var_with_attrs.get_attributes();
      `FAIL_UNLESS(attrs.size() == 2)
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


    `SVTEST(get__static_int__returns_value)
      rf_value #(int) val;
      c.some_static_int_var = 5;

      `FAIL_UNLESS($cast(val, some_static_int_var.get()))
      `FAIL_UNLESS(val.get() == 5)
    `SVTEST_END


    `SVTEST(get__string__returns_value)
      rf_value #(string) val;
      c.some_string_var = "a_string";

      `FAIL_UNLESS($cast(val, some_string_var.get(rf_object_instance #(some_class)::get(c))))
      `FAIL_UNLESS_STR_EQUAL(val.get(), "a_string")
    `SVTEST_END


    `SVTEST(set__string__modifies_value)
      rf_value #(string) v = new("another_string");
      some_string_var.set(rf_object_instance #(some_class)::get(c), v);
      `FAIL_UNLESS_STR_EQUAL(c.some_string_var, "another_string")
    `SVTEST_END


    `SVTEST(get__string_array__returns_value)
      rf_value #(string_arr) val;
      c.some_string_array_var = {"a_string", "another_string"};

      `FAIL_UNLESS($cast(val, some_string_array_handle.get(rf_object_instance #(some_class)::get(c))))
      `FAIL_UNLESS(val.get().size() == 2)
      `FAIL_UNLESS_STR_EQUAL(val.get()[0], "a_string")
      `FAIL_UNLESS_STR_EQUAL(val.get()[1], "another_string")
    `SVTEST_END

  `SVUNIT_TESTS_END


  class some_class;

    bit some_variable;
    static bit some_static_variable;
    const bit some_const_variable;

    int some_not_rand_variable;
    rand int some_rand_variable;
    randc int some_randc_variable;

    int some_int_var;

    (* attr0 *)
    (* attr1 *)
    bit some_var_with_attrs;

    static int some_static_int_var;
    string some_string_var;
    string some_string_array_var[];

  endclass

endmodule
