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


typedef class variable_introspection;



class rf_variable;

  extern function string get_name();
  extern function string get_type();


  // TODO Move to 'rf_class_variable' class

  extern function bit is_static();

  extern function bit is_const();

  extern function bit is_rand();
  extern function rand_type_e get_rand_type();


  extern function array_of_rf_attribute get_attributes();

  /**
   * Gets the value of this variable in the supplied object instance. If the instance is null,
   * the variable must static.
   */
  extern function rf_value_base get(rf_object_instance_base object = null);

  /**
   * Sets the value of this variable in the supplied object instance to the given value.
   */
  extern function void set(rf_object_instance_base object, rf_value_base value);

  extern function void print(int unsigned indent = 0);


  //----------------------------------------------------------------------------
  // Internal
  //----------------------------------------------------------------------------

  local const vpiHandle variable;
  local const vpiHandle parent;


  function new(vpiHandle variable, vpiHandle parent = null);
    this.variable = variable;
    this.parent = parent;
  endfunction


  local function bit are_attributes_supported();
    case (vpi_get(vpiType, variable))
      vpiStringVar:
        return 0;
    endcase

    return 1;
  endfunction


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


  // TODO Split class variables into own class
  local function vpiHandle get_static_var();
    rf_class c = new(parent);
    variable_introspection var_intro = new(c.get_typespec());
    rf_variable var_ = var_intro.get_by_name(this.get_name());
    return var_.variable;
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


  local function rf_value_base get_value_string(vpiHandle var_);
    rf_value #(string) ret = new();
    ret.set(vpi_get_value_string(var_));
    return ret;
  endfunction


  local function void set_value_string(vpiHandle var_, rf_value_base value);
    rf_value #(string) val;
    if (!$cast(val, value))
      $fatal(0, "Internal error");
    vpi_put_value_string(var_, val.get());
  endfunction


  local function rf_value_base get_value_string_array(vpiHandle var_);
    typedef string string_arr[];
    string the_array[];
    rf_value #(string_arr) ret = new();

    vpiHandle member_it = vpi_iterate(vpiReg, var_);
    check_array_starts_at_index_0(var_);
    forever begin
      vpiHandle member = vpi_scan(member_it);
      if (member == null)
        break;

      the_array = {the_array, vpi_get_value_string(member)};
    end

    ret.set(the_array);
    return ret;
  endfunction


  local function void check_array_starts_at_index_0(vpiHandle array_handle);
    vpiHandle left_range = vpi_handle(vpiLeftRange, array_handle);
    if (vpi_get_value_int(left_range) != 0)
        $fatal(0, "Only arrays starting at index '0' are supported.");
  endfunction

endclass


function string rf_variable::get_name();
  return vpi_get_str(vpiName, variable);
endfunction


function string rf_variable::get_type();
  vpiHandle typespec = vpi_handle(vpiTypespec, variable);

  if (vpi_get_str(vpiName, typespec) != "")
    return vpi_get_str(vpiName, typespec);

  case (vpi_get(vpiType, typespec))
    vpiIntTypespec : return "int";
  endcase

  $fatal(0, "Type of '%s' not supported", get_name());
  return "";
endfunction


function bit rf_variable::is_static();
  return vpi_get(vpiAutomatic, variable) == 0;
endfunction


function bit rf_variable::is_const();
  return vpi_get(vpiConstantVariable, variable);
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


function array_of_rf_attribute rf_variable::get_attributes();
  rf_attribute attrs[$];
  vpiHandle attrs_it;

  if (!are_attributes_supported()) begin
    $warning(
        "This tool doesn't support attributes variables of type '%s'",
        vpi_get_str(vpiType, variable));
    return attrs;
  end

  attrs_it = vpi_iterate(vpiAttribute, variable);
  if (attrs_it != null)
    forever begin
      rf_attribute v;
      vpiHandle attr = vpi_scan(attrs_it);
      if (attr == null)
        break;
      v = new(attr);
      attrs.push_back(v);
    end
  return attrs;
endfunction


function rf_value_base rf_variable::get(rf_object_instance_base object = null);
  vpiHandle var_;

  if (object == null && !is_static()) begin
`ifdef INCA
    $stacktrace;
`endif
    $fatal(0, "'null' instance passed for dynamic variable");
  end

  if (object != null)
    var_ = get_var(object);
  else
    var_ = get_static_var();

  case (vpi_get_str(vpiType, var_))
    "vpiIntVar" : return get_value_int(var_);
    "vpiStringVar" : return get_value_string(var_);
    "vpiRegArray" : return get_value_string_array(var_);
    default : $fatal(0, "Type '%s' not implemented", vpi_get_str(vpiType,
      var_));
  endcase
endfunction


function void rf_variable::set(rf_object_instance_base object, rf_value_base value);
  vpiHandle var_ = get_var(object);
  case (vpi_get_str(vpiType, var_))
    "vpiIntVar" : set_value_int(var_, value);
    "vpiStringVar" : set_value_string(var_, value);
    default : $fatal(0, "Type '%s' not implemented", vpi_get_str(vpiType,
      var_));
  endcase
endfunction


function void rf_variable::print(int unsigned indent = 0);
  rand_type_e r = get_rand_type();
  $display({indent{" "}}, "Variable '%s'", get_name());
  $display({indent{" "}}, "  Rand type = %s", r.name());
endfunction
