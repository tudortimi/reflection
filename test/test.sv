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


module test;
  import reflection::*;
  import some_package::*;

  initial begin
    automatic rf_package rf_some_package = rf_manager::get_package_by_name(
      "some_package");
    automatic rf_class rf_some_class = rf_some_package.get_class_by_name(
      "some_class");
    automatic rf_variable rf_some_field = rf_some_class.get_variable_by_name(
      "some_field");
    automatic rf_variable rf_some_rand_field = rf_some_class.get_variable_by_name(
      "some_rand_field");

    rf_some_field.print();
    $display("");

    rf_some_rand_field.print();
    $display("");

    rf_some_class.print();
    $display("");

    rf_some_package.print();
  end
endmodule
