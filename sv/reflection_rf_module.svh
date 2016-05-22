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


class rf_module;
  extern function string get_name();

  extern function array_of_rf_class get_classes();
  extern function rf_class get_class_by_name(string name);

  extern function void print(int unsigned indent = 0);


  //----------------------------------------------------------------------------
  // Internal
  //----------------------------------------------------------------------------

  protected vpiHandle module_;

  function new(vpiHandle module_);
    this.module_ = module_;
  endfunction
endclass



function string rf_module::get_name();
  return vpi_get_str(vpiName, module_);
endfunction


function array_of_rf_class rf_module::get_classes();
  rf_class classes[$];
  vpiHandle classdefn_it = vpi_iterate(vpiClassDefn, module_);

  if (classdefn_it)
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


function rf_class rf_module::get_class_by_name(string name);
  vpiHandle classdefn_it = vpi_iterate(vpiClassDefn, module_);

  if (classdefn_it != null)
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


function void rf_module::print(int unsigned indent = 0);
  rf_class classes[] = get_classes();
  $display({indent{" "}}, "Module '%s'", get_name());
  foreach (classes[i])
    classes[i].print(indent + 2);
endfunction
