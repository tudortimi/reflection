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


class rf_package;
  extern function string get_name();
  extern function int get_time_unit();
  extern function int get_time_precision();

  extern function array_of_rf_class get_classes();
  extern function rf_class get_class_by_name(string name);

  extern function void print(int unsigned indent = 0);


  //----------------------------------------------------------------------------
  // Internal
  //----------------------------------------------------------------------------

  protected vpiHandle package_;

  function new(vpiHandle package_);
    this.package_ = package_;
  endfunction
endclass



function string rf_package::get_name();
  return vpi_get_str(vpiName, package_);
endfunction


function int rf_package::get_time_unit();
  return vpi_get(vpiTimeUnit, package_);
endfunction


function int rf_package::get_time_precision();
  return vpi_get(vpiTimePrecision, package_);
endfunction


function array_of_rf_class rf_package::get_classes();
  rf_class classes[$];
  vpiHandle classdefn_it = vpi_iterate(vpiClassDefn, package_);

  while (1) begin
    rf_class c;
    vpiHandle classdefn = vpi_scan(classdefn_it);
    if (classdefn == null)
      break;

    c = new(classdefn);
    classes.push_back(c);
  end
  return classes;
endfunction


function rf_class rf_package::get_class_by_name(string name);
  vpiHandle classdefn_it = vpi_iterate(vpiClassDefn, package_);

  while (1) begin
    vpiHandle classdefn = vpi_scan(classdefn_it);
    if (classdefn == null)
      break;
    if (vpi_get_str(vpiName, classdefn) == name) begin
      rf_class v = new(classdefn);
      return v;
    end
  end
endfunction


function void rf_package::print(int unsigned indent = 0);
  rf_class classes[] = get_classes();
  $display({indent{" "}}, "Package '%s'", get_name());
  $display({indent{" "}}, "  time unit = '%0d'", get_time_unit());
  $display({indent{" "}}, "  time precision = '%0d'", get_time_precision());
  foreach (classes[i])
    classes[i].print(indent + 2);
endfunction
