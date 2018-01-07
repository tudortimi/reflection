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


/**
 * Encapsulates code to get the variables of an element
 */
class variable_introspection;

  local const vpiHandle element;


  function new(vpiHandle element);
    this.element = element;
  endfunction


  function array_of_rf_variable get_all();
    rf_variable vars[$];
    vpiHandle variables_it = vpi_iterate(vpiVariables, element);
    if (variables_it != null)
      forever begin
        rf_variable v;
        vpiHandle variable = vpi_scan(variables_it);
        if (variable == null)
          break;
        v = new(variable, element);
        vars.push_back(v);
      end
    return vars;
  endfunction


  function rf_variable get_by_name(string name);
    vpiHandle variables_it = vpi_iterate(vpiVariables, element);
    if (variables_it != null)
      forever begin
        vpiHandle variable = vpi_scan(variables_it);
        if (variable == null)
          break;
        if (vpi_get_str(vpiName, variable) == name) begin
          rf_variable v = new(variable, element);
          return v;
        end
      end
    $error("Variable '%s' not found", name);
  endfunction

endclass
