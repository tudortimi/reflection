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


class rf_attribute;

  extern function string get_name();

  extern function void print(int unsigned indent = 0);


  //----------------------------------------------------------------------------
  // Internal
  //----------------------------------------------------------------------------

  protected vpiHandle attribute;

  function new(vpiHandle attribute);
    this.attribute = attribute;
  endfunction

endclass



function string rf_attribute::get_name();
  return vpi_get_str(vpiName, attribute);
endfunction


function void rf_attribute::print(int unsigned indent = 0);
endfunction
