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


class rf_function extends rf_method;
  extern function string get_return_type();


  //----------------------------------------------------------------------------
  // Internal
  //----------------------------------------------------------------------------

  function new(vpiHandle method);
    super.new(method);
  endfunction
endclass



function string rf_function::get_return_type();
  vpiHandle r = vpi_handle(vpiReturn, method);
  rf_variable v;
  if (r == null)
    return "void";
  v = new(r);
  return v.get_type();
endfunction
