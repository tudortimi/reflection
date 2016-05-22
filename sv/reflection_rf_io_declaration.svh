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


class rf_io_declaration;
  extern function string get_name();
  extern function string get_type();
  extern function io_direction_e get_direction();

  extern function void print(int unsigned indent = 0);

  //----------------------------------------------------------------------------
  // Internal
  //----------------------------------------------------------------------------

  local vpiHandle io_declaration;

  function new(vpiHandle io_declaration);
    this.io_declaration = io_declaration;
  endfunction
endclass



function string rf_io_declaration::get_name();
  return vpi_get_str(vpiName, io_declaration);
endfunction


function string rf_io_declaration::get_type();
  rf_variable v = new(vpi_handle(vpiExpr, io_declaration));
  return v.get_type();
endfunction


function io_direction_e rf_io_declaration::get_direction();
  case (vpi_get(vpiDirection, io_declaration))
    vpiInput : return INPUT;
    vpiOutput : return OUTPUT;
    vpiInout : return INOUT;
    default : $fatal(0, "Direction %s not supported", vpi_get_str(vpiDirection,
      io_declaration));
  endcase
endfunction


function void rf_io_declaration::print(int unsigned indent = 0);
  io_direction_e direction = get_direction();
  $display({indent{" "}}, "IO Declaration '%s'", get_name());
  $display({indent{" "}}, "  Direction = %s", direction.name());
  $display({indent{" "}}, "  Type = %s", get_type());
endfunction
