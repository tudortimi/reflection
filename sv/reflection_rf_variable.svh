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


class rf_variable;
  extern function string get_name();
  extern function bit is_rand();
  extern function rand_type_e get_rand_type();

  extern function void print(int unsigned indent = 0);


  //----------------------------------------------------------------------------
  // Internal
  //----------------------------------------------------------------------------

  protected vpiHandle variable;

  function new(vpiHandle variable);
    this.variable = variable;
  endfunction
endclass


function string rf_variable::get_name();
  return vpi_get_str(vpiName, variable);
endfunction

function bit rf_variable::is_rand();
  return get_rand_type() != NOT_RAND;
endfunction

function rand_type_e rf_variable::get_rand_type();
  PLI_INT32 rand_type = vpi_get(vpiRandType, variable);
  case (rand_type)
    vpiNotRand : return NOT_RAND;
    vpiRand : return RAND;
    vpiRandC : return RANDC;
    default : $fatal(0, "Internal error");
  endcase
endfunction

function void rf_variable::print(int unsigned indent = 0);
  rand_type_e r = get_rand_type();
  $display({indent{" "}}, "Variable '%s'", get_name());
  $display({indent{" "}}, "  Rand type = %s", r.name());
endfunction
