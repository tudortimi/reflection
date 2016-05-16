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


virtual class rf_object_instance_base;
  protected vpiHandle class_obj;

  function vpiHandle get_class_obj();
    return class_obj;
  endfunction
endclass



class rf_object_instance #(type T = int) extends rf_object_instance_base;
  static function rf_object_instance #(T) get(T object);
    vpiHandle frame = vpi_handle(vpiFrame, null);
    vpiHandle origin = vpi_handle(vpiOrigin, frame);
    vpiHandle arg_it = vpi_iterate(vpiArgument, origin);

    if (object == null) begin
      $warning("'null' object passed.");
      return null;
    end

    while (1) begin
      vpiHandle arg = vpi_scan(arg_it);
      vpiHandle obj;

      if (arg == null)
        $fatal(0, "Internal error");

      obj = vpi_handle(vpiClassObj, arg);
      if (obj == null)
        $fatal(0, { "Internal error. Make sure that you have visibility",
          " by disabling simulator optimizations where appropriate." });

      get = new(obj);
      return get;
    end
  endfunction


  protected function new(vpiHandle class_obj);
    this.class_obj = class_obj;
  endfunction
endclass
