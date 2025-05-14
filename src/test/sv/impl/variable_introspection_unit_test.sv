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


module variable_introspection_unit_test;

  import svunit_pkg::svunit_testcase;
  `include "svunit_defines.svh"

  string name = "variable_introspection_ut";
  svunit_testcase svunit_ut;

  import reflection::*;
  import vpi::*;


  variable_introspection var_intr;


  dummy_module dummy_inst();
  string dummy_inst_path = $sformatf("%m.dummy_inst");


  function void build();
    svunit_ut = new(name);
    var_intr = new(vpi_handle_by_name(dummy_inst_path, null));
  endfunction


  task setup();
    svunit_ut.setup();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask


  `SVUNIT_TESTS_BEGIN

    `SVTEST(get_all__returns_2_entries)
      rf_variable vars[] = var_intr.get_all();
      `FAIL_UNLESS(vars.size() == 2)
      `FAIL_UNLESS_STR_EQUAL(vars[0].get_name(), "some_var")
      `FAIL_UNLESS_STR_EQUAL(vars[1].get_name(), "some_other_var")
    `SVTEST_END


    `SVTEST(get_by_name__returnsx)
      rf_variable v = var_intr.get_by_name("some_var");
      `FAIL_UNLESS_STR_EQUAL(v.get_name(), "some_var")
    `SVTEST_END

  `SVUNIT_TESTS_END

endmodule



module dummy_module();
  int some_var;
  int some_other_var;
endmodule
