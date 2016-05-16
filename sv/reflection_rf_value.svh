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


virtual class rf_value_base;
endclass


class rf_value #(type T = int) extends rf_value_base;
  local T value;
  local static T def_value;

  function new(T value = def_value);
    this.value = value;
  endfunction

  function T get();
    return value;
  endfunction

  function void set(T value);
    this.value = value;
  endfunction
endclass
