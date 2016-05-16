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

  extern function rf_value_base get(rf_object_instance_base object);
  extern function void set(rf_object_instance_base object, rf_value_base value);

  extern function void print(int unsigned indent = 0);


  //----------------------------------------------------------------------------
  // Internal
  //----------------------------------------------------------------------------

  protected vpiHandle variable;


  local function vpiHandle get_var(rf_object_instance_base object);
    vpiHandle class_obj = object.get_class_obj();
    vpiHandle var_it = vpi_iterate(vpiVariables, class_obj);

    while (1) begin
      vpiHandle var_ = vpi_scan(var_it);
      if (var_ == null)
        $fatal(0, "Internal error");

      if (vpi_get_str(vpiName, var_) == get_name())
        return var_;
    end
  endfunction


  local function rf_value_base get_value_int(vpiHandle var_);
    rf_value #(int) ret = new();
    ret.set(vpi_get_value_int(var_));
    return ret;
  endfunction

  local function void set_value_int(vpiHandle var_, rf_value_base value);
    rf_value #(int) val;
    if (!$cast(val, value))
      $fatal(0, "Internal error");
    vpi_put_value_int(var_, val.get());
  endfunction


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

function rf_value_base rf_variable::get(rf_object_instance_base object);
  vpiHandle var_ = get_var(object);
  case (vpi_get_str(vpiType, var_))
    "vpiIntVar" : return get_value_int(var_);
    default : $fatal(0, "Type '%s' not implemented", vpi_get_str(vpiType,
      var_));
  endcase
endfunction

function void rf_variable::set(rf_object_instance_base object, rf_value_base value);
  vpiHandle var_ = get_var(object);
  case (vpi_get_str(vpiType, var_))
    "vpiIntVar" : set_value_int(var_, value);
    default : $fatal(0, "Type '%s' not implemented", vpi_get_str(vpiType,
      var_));
  endcase
endfunction


function void rf_variable::print(int unsigned indent = 0);
  rand_type_e r = get_rand_type();
  $display({indent{" "}}, "Variable '%s'", get_name());
  $display({indent{" "}}, "  Rand type = %s", r.name());
endfunction
