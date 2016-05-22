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


class rf_manager;
  extern static function rf_package get_package_by_name(string name);
  extern static function rf_module get_module_by_name(string name);


  //----------------------------------------------------------------------------
  // Internal
  //----------------------------------------------------------------------------

  local static function rf_module search_module(vpiHandle module_, string name);
    vpiHandle module_it = vpi_iterate(vpiModule, module_);
    vpiHandle modules[$];

    if (module_it != null)
      while (1) begin
        vpiHandle module_ = vpi_scan(module_it);
        if (module_ == null)
          break;

        modules.push_back(module_);
        if (vpi_get_str(vpiDefName, module_) == name) begin
          rf_module m = new(module_);
          return m;
        end
      end

    foreach (modules[i]) begin
      rf_module m = search_module(modules[i], name);
      if (m != null)
        return m;
    end
  endfunction
endclass



function rf_package rf_manager::get_package_by_name(string name);
  vpiHandle package_it = vpi_iterate(vpiPackage, null);

  while (1) begin
    vpiHandle package_ = vpi_scan(package_it);
    if (package_ == null)
      break;

    if (vpi_get_str(vpiName, package_) == name) begin
      rf_package p = new(package_);
      return p;
    end
  end
endfunction


function rf_module rf_manager::get_module_by_name(string name);
  return search_module(null, name);
endfunction
