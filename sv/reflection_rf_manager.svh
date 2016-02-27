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
  extern static function rf_class get_class_by_name(string name);
endclass


function rf_class rf_manager::get_class_by_name(string name);
  vpiHandle package_it = vpi_iterate(vpiPackage, null);

  while (1) begin
    vpiHandle package_ = vpi_scan(package_it);
    vpiHandle classdefn_it;

    if (package_ == null)
      break;
    classdefn_it = vpi_iterate(vpiClassDefn, package_);
    if (classdefn_it == null)
      continue;

    while (1) begin
      vpiHandle classdefn = vpi_scan(classdefn_it);
      if (classdefn == null)
        break;
      if (vpi_get_str(vpiName, classdefn) == name) begin
        rf_class c = new(classdefn);
        return c;
      end
    end
  end
endfunction
