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


class rf_class;
  extern function string get_name();
  extern function array_of_rf_variable get_variables();
  extern function rf_variable get_variable_by_name(string name);

  extern function void print(int unsigned indent = 0);


  //----------------------------------------------------------------------------
  // Internal
  //----------------------------------------------------------------------------

  protected vpiHandle classDefn;

  function new(vpiHandle classDefn);
    this.classDefn = classDefn;
  endfunction
endclass



function string rf_class::get_name();
  return vpi_get_str(vpiName, classDefn);
endfunction


function array_of_rf_variable rf_class::get_variables();
  rf_variable vars[$];
  vpiHandle variables_it = vpi_iterate(vpiVariables, classDefn);
  if (variables_it != null)
    while (1) begin
      rf_variable v;
      vpiHandle variable = vpi_scan(variables_it);
      if (variable == null)
        break;
      v = new(variable);
      vars.push_back(v);
    end
  return vars;
endfunction


function rf_variable rf_class::get_variable_by_name(string name);
  vpiHandle variables_it = vpi_iterate(vpiVariables, classDefn);
  while (1) begin
    vpiHandle variable = vpi_scan(variables_it);
    if (variable == null)
      break;
    if (vpi_get_str(vpiName, variable) == name) begin
      rf_variable v = new(variable);
      return v;
    end
  end
endfunction


function void rf_class::print(int unsigned indent = 0);
  rf_variable vars[] = get_variables();
  $display({indent{" "}}, "Class '%s'", get_name());
  foreach (vars[i])
    vars[i].print(indent + 2);
endfunction
