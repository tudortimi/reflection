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


virtual class cache_base;
  pure virtual function bit has(vpiHandle handle);
endclass


class single_cache #(type T = int) extends cache_base;
  local T vals[vpiHandle];

  virtual function bit has(vpiHandle handle);
    return vals.exists(handle);
  endfunction


  function T get_val(vpiHandle handle);
    if (!has(handle))
      vals[handle] = new(handle);
    return vals[handle];
  endfunction


  local static single_cache #(T) c;

  static function single_cache #(T) get();
    if (c == null)
      c = new();
    return c;
  endfunction

  local function new();
    // empty
  endfunction
endclass


class cache extends cache_base;
  extern static function cache get();

  extern function bit has(vpiHandle handle);


  local static cache c;

  const single_cache #(rf_package) packages;
  const single_cache #(rf_module) modules;
  const single_cache #(rf_class) classes;

  local cache_base single_caches[$];

  local function new();
    packages = single_cache #(rf_package)::get();
    single_caches.push_back(packages);

    modules = single_cache #(rf_module)::get();
    single_caches.push_back(modules);

    classes = single_cache #(rf_class)::get();
    single_caches.push_back(classes);
  endfunction
endclass



function cache cache::get();
  if (c == null)
    c = new();
  return c;
endfunction


function bit cache::has(vpiHandle handle);
  foreach (single_caches[i])
    if (single_caches[i].has(handle))
      return 1;
  return 0;
endfunction
